# **<img height="50" src="https://img.icons8.com/fluency/48/upload-to-cloud.png" alt="upload-to-cloud" align="absmiddle"/>  DATA EXTRACTION & LOAD**


Here a python script is written to pull data from youtube's API and loads the data to the cloud with proper pagination setup to respect youtube's limits (e.g At most 50 ids per call from videos.list) and error handling using the python logging module.

## **STEP BREAKDOWN**

This step was further broken down into 3 major processes:

## [**1. GOSPEL ARTISTS SCRAPER**](./scrape_gospel_artists.py)
Here, I built a scraper that pulls gospel artists data (name and page) from [CeeNaija](https://www.ceenaija.com/about-us/) and stored them in a csv file [(gospel_artists.csv)](./gospel_artists.csv)

    CeeNaija is a gospel music download blog that is dedicated to providing the best and latest gospel music from Nigeria and around the world. We believe in the power of music to uplift the soul and bring people closer to God, and we are committed to making that power available to as many people as possible.

This was done in the bid to improve on the success rate of my youtube search as touching the goal of this pipeline.


## [**2. THE MAIN PIPELINE**](./pipeline.py)
Here, the terms (gospel musicians names) gotten from the previous step was passed to my search function targetting youtube's search.list API and by setting `"type":"video"` in the params, I received the ids passed to the fuction targeting youtube's video.list API and [see more . . .](./pipeline.py) as shown in the pipeline i used [dlt](https://dlthub.com/docs/intro)

    dlt is an open-source Python library that loads data from various, often messy data sources into well-structured datasets.

## [**3. DATABASE UPDATE**](./update.py)
In case i exceed the 200 daily searches on youtube (but not my entire 10000 quota limit), which implies I can no longer target the youtube search.list to get new rows but i'm still opne to targeting video.list and channel.list, then it's wise not to throw away my remaining free quota but update my database by passing the already stored ids in it as parameter to the functions targeting video.list and channel.list.
This is what this step is designed to do [see more . . .](./update.py) 

## Conclusion
**I really appreciate you for getting this far**. I hope you could explore the links and understand my setup.
I want to assure you that my skills and knowledge are not limited to the toolsets used in this project but these were chosen based on my own judgement of the current data engineering market. So tools like fivetran, Airbyte . . . that could serve this purpose are not strange to me.

I'm also working on an orchestrator tool that could help auitomate this pipeline properly, respecting youtube's API limits and alternating between updating the database or keep running the main pipeline depending on the error code receive. coming soon...

### <p style = "text-align: center">**Thank you for your time and patience.  Enjoy Your tour.😊** </p>