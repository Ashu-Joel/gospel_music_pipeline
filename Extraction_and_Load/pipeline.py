""" PUULS GOSPEL MUSIC DATA FROM THE YOUTUBE API V3 and UPLOADS IT TO MY DATA WAREHOUSE ON MOTHERDUCK"""

import os
import logging
import requests
from datetime import datetime
from time import sleep
import dlt
import csv

os.makedirs("./logs", exist_ok=True)

run_date = datetime.now().strftime("%d-%m-%Y")

logfile = f"logs/pipeline_run on {run_date}"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - [%(levelname)s] -%(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler(logfile)
    ]
)

logger = logging.getLogger(__name__)

BASE_URL = "https://www.googleapis.com/youtube/v3"

session = requests.Session()
MAX_PAGES_PER_TERM = 5   # youtube's own stated max number of pages for a given search term. 
MAX_RETRIES = 3

with open("gospel_artists.csv", "r") as f:
    reader = csv.reader(f)
    SEARCH_TERMS = [row[0] for row in reader]
    
API_KEY = os.environ.get("YOUTUBE_API_KEY")

if not API_KEY:
    raise EnvironmentError("API KEY NOT FOUND")

def search_videos(query):
    """Paginates Youtube for a given search term and retrurns a list of raw search items"""

    search_results = []
    page_count = 0
    next_page_token = None
    num_timeout = 0

    while page_count < MAX_PAGES_PER_TERM:
        
        params = {
            "part":"snippet",
            "type":"video",
            "q":f'"{query}" "christian gospel"',
            "key":API_KEY,
            "maxResults":50,                # youtube's maximum per page
            "videoCategoryId":"10",          # Restricting search results to only music (category 10)
            "safeSearch":"strict"
        }
        
        if next_page_token:
            params["pageToken"] = next_page_token
            
        try:
            response = session.get(url=f"{BASE_URL}/search",params=params, timeout=10)
            response.raise_for_status()
        except requests.exceptions.HTTPError as e:
            logger.error(f"HTTP ERROR at {query} page {page_count + 1}: {e}")
            break
        except requests.exceptions.Timeout:
            if num_timeout < MAX_RETRIES:
                logger.warning(f"Timeout at {query} page {page_count + 1}, Retrying...")
                num_timeout +=1
                sleep(2)
                continue
            else:
                break
        except requests.exceptions.RequestException as e:
            logger.error(f"Request Failed at {query} page {page_count + 1}: {e}")
            break
        
        
        data = response.json()
        items = data.get("items",[])
        search_results.extend(items)
        logging.info(f" Fetched {len(items)} videos for {query} page {page_count + 1}. Total: {len(search_results)} videos ")
        page_count += 1
        next_page_token = data.get("nextPageToken")
        
        if not next_page_token:
            logger.info(f"No more pages for {query} ")
            break
        sleep (2)
        
    return search_results
         

def chunk_list (lst,size=50):
    """ Breaks down a given list into batches of 50 items. 
    Used for cal videos.list and channels.list while staying within youtube's limit which is 50 ids per call
    """
    for i in range (0,len(lst),size):
        yield lst[i:i+size]
        
def get_video_details (video_ids):
    """ Calls Videos.list in batches of up to 50 videoIds """
    results = []
    num_timeout = 0
    
    if not video_ids:
        return None

    for batch in chunk_list(video_ids):
        params ={
            "part":"snippet,statistics,contentDetails",
            "key":API_KEY,
            "id":",".join(batch)
        }
        try:
            response = session.get(url=f"{BASE_URL}/videos",params=params,timeout=10)
            response.raise_for_status()
        except requests.exceptions.Timeout:
            while num_timeout < MAX_RETRIES:
                logger.warning(f"Timeout at {len(batch)} videos, Retrying...")
                num_timeout +=1
                sleep(1)
                continue
        except requests.exceptions.RequestException as e:
            logger.error(f"Request Failed at {len(batch)} videos; {e}")
            break
    
        data = response.json()
        items = data.get("items",[])
        results.extend(items)
        logger.info(f"Fetched {len(items)} video items. Total: {len(results)} results")
        
        sleep (0.5)
    return results

def get_channel_details (channel_ids):
    
    results = []
    num_timeout = 0
    
    if not channel_ids:
        return None

    for batch in chunk_list(channel_ids):
        params ={
            "part":"snippet,statistics,contentDetails",
            "key":API_KEY,
            "id":",".join(batch)
        }
        try:
            response = session.get(url=f"{BASE_URL}/channels",params=params,timeout=10)
            response.raise_for_status()
        except requests.exceptions.Timeout:
            while num_timeout < MAX_RETRIES:
                logger.warning(f"Timeout at {len(batch)} channels, Retrying...")
                num_timeout += 1
                sleep(1)
                continue
        except requests.exceptions.RequestException as e:
            logger.error(f"Request Failed at {len(batch)} channels; {e}")
            break
    
        data = response.json()
        items = data.get("items",[])
        results.extend(items)
        logger.info(f"Fetched {len(items)} channel items. Total: {len(results)} results")
        
        sleep (0.5)
    return results

def run_pipeline ():
    
    logging.info(f"Starting ingestion at {run_date}")
    
    all_search_results = []
    
    for search_term in SEARCH_TERMS[120:130]:
        all_search_results.extend(search_videos(search_term))
    
        
    video_ids = list(items["id"]["videoId"] for items in all_search_results if "videoId" in items.get("id"))
    
    if not video_ids:
        return 
    
    logging.info(f"Discovered {len(video_ids)} unique video ids for {len(SEARCH_TERMS)} search terms")

    videos = get_video_details(video_ids)
    
    channel_ids = list(v["snippet"]["channelId"] for v in videos if "channelId" in v.get("snippet"))
    logging.info(f"Discovered {len(channel_ids)} unique channel ids for {len(video_ids)} videos")
    channels = get_channel_details(channel_ids)
    
    logger.info(f"Loading data into cloud for {run_date}")
    
    pipeline = dlt.pipeline(
        pipeline_name="gospel_music_analysis",
        destination = "motherduck",
        dataset_name = "raw_data"
    )
    
    load_info = pipeline.run([
        dlt.resource(videos, name="raw_videos",write_disposition="merge",primary_key="id"),
        dlt.resource(channels, name="raw_channels",write_disposition="merge",primary_key="id")
    ],
        loader_file_format="parquet"
    )
    
    logging.info(f"dlt load to motherduck completed: {load_info}")
    
     
if __name__ == '__main__':
    run_pipeline()
    