
from pipeline import get_channel_details,get_video_details,logger
import duckdb
import dlt
from datetime import datetime

updated_at = datetime.now().strftime("%d-%m-%Y")


con = duckdb.connect('md:gospel_music_data')

video_ids_table = con.sql('SELECT DISTINCT id FROM raw_data.raw_videos ORDER BY RANDOM() LIMIT 5000').fetchall()
video_ids = [id[0] for id in video_ids_table]

channel_ids_table = con.sql('SELECT DISTINCT snippet__channel_id FROM raw_data.raw_videos ORDER BY RANDOM() LIMIT 5000').fetchall()
channel_ids = [id[0] for id in channel_ids_table]

def run_update():
    
    logger.info(f"Getting videos data for database update...")
    if not video_ids:
        logger.warning("No video_id giving")
        return 
    videos = get_video_details(video_ids)
    
    logger.info(f"Getting channels data for database update...")
    if not channel_ids:
        logger.warning("No channel_id giving")
        return
    channels = get_channel_details(channel_ids)
    

    logger.info(f"Updating Database for {updated_at}")
    
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
    if load_info.has_failed_jobs:
        logger.error(f"Update Failed!!! {load_info}")
    else:
        logger.info(f"Dataset Update Successful: {load_info}")
        
if __name__ == '__main__':
    run_update()