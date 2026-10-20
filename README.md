# <img  height="50" src="https://img.icons8.com/nolan/64/musical.png" alt="musical-notes" align="absmiddle"/> **GOSPEL MUSIC DATA PIPELINE**

## Introduction
An **ELT** pipeline designed to **extract** gospel music data (channels and  videos data) from Youtube , **loads** it to a cloud data warehouse, **transforms** it (e.g renaming columns, redifinig data types, null handling . . .) to **build insightful dashboards**.

##  Working Environment / Tools:
- **<img height="18" src="https://img.icons8.com/color/48/code.png" alt="code" align="absmiddle"/> Code Editor:** <img height="18" src="https://img.icons8.com/color/50/visual-studio-code-2019.png" alt="visual-studio-code-2019" align="absmiddle"/> VS Code (Visual Studio Code Editor)
- **<img height="18" src="https://img.icons8.com/fluency/48/console.png" alt="console" align="absmiddle"/> Terminal**: <img height="18" src="https://img.icons8.com/external-tal-revivo-color-tal-revivo/50/external-ubuntu-is-a-free-and-open-source-linux-distribution-logo-color-tal-revivo.png" alt="external-ubuntu-is-a-free-and-open-source-linux-distribution-logo-color-tal-revivo" align="absmiddle"/> Ubuntu (WSL2)
- **<img height="18" src="https://img.icons8.com/color/48/download--v1.png" alt="download--v1" align="absmiddle"/> Data Extraction Tool (E):** <img height="18" src="https://img.icons8.com/color/48/python--v1.png" alt="python--v1" align="absmiddle"/> Python 
- **<img height="18" src="https://img.icons8.com/fluency/48/upload-to-cloud.png" alt="upload-to-cloud" align="absmiddle"/> Data Ingestion Tool (L):** <img src="https://toolradar.com/api/logo-download?slug=dlt-hub&format=png&size=512" height="15" align ="absmiddle
"/> DLT (Data load Tool)
-  **<img height="18" src="https://img.icons8.com/color/48/database.png" alt="database" align="absmiddle
"/> Cloud Warehouse:** <img src="https://toolradar.com/api/logo-download?slug=motherduck&format=png&size=512" height=15 align="absmiddle
"> Motherduck (Duckdb in the cloud)
- **<img height="18" src="https://img.icons8.com/color/48/settings--v1.png" alt="settings--v1" align="absmiddle
"/> Data Transformation and Testing (T)**: <img  height="12" src="https://toolradar.com/api/logo-download?slug=dbt&format=png&size=512 " alt="merge-git" align="absmiddle"/> DBT (Data Build Tool)
- **<img  height="18" src="https://img.icons8.com/color/48/merge-git.png" alt="merge-git" align="absmiddle
"/> Version Control:** <img height="15" src="https://img.icons8.com/color/48/git.png" alt="git"  align="absmiddle
"/> Git / <img src="https://toolradar.com/api/logo-download?slug=github-desktop&format=png&size=512" alt="github" height=15 align="absmiddle
"> Github 
- **<img height="18" src="https://img.icons8.com/color/48/graph.png" alt="graph" align="absmiddle
"/> Dashboard:** <img height="15" src="https://img.icons8.com/color/48/power-bi-2021.png" alt="power-bi-2021" align="absmiddle
"/>  Power BI (Microsoft Business Intelligence Tool)

## Project Scope
This Project was built primarily to showcase my skills as a Data Engineer. I noticed it is a **rare** niche in public datasets and data bootcamps so i decided to venture in with the hope that it will standout as a true prove of knowledge and skills giving little to no room for doubt.

Meanwhile, it could also be of use to Gospel Music Enthusiast (Ministers, Bloggers, Instrumentalists . . .) to judge the current gospel music field , finding common patterns around top channels, top musics/genres, ... to decide their area of focus or secure green areas.

## Project Breakdown
The project was broken into 3 different parts/steps with their common ground being the cloud data warehouse:

### [**1.  DATA INGESTION LAYER:**](./Extraction_and_Load/) 
Here a python script is written to pull data from youtube's API and loads the data to the cloud with proper pagination setup to respect youtube's limits (e.g At most 50 ids per call from videos.list) and error handling using the python logging module. [see more ...](./Extraction_and_Load/pipeline.py)

[![Cloud Warehouse preview](./Assets/motherduck_warehouse_preview.jpeg)](./Assets/motherduck_warehouse_preview.jpeg)
### [**2.  DATA TRANSFORMATION PROCESS:**](./Data_Transformation/data_modeling/)
After the raw_data is set in the cloud warehouse (motherduck), dbt queries (SQL + jinja) are written to transform the raw data into a star schema( one fact and many dimensions tables) for easy querying, analysis and building  dashboards. [see more ...](./Data_Transformation/data_modeling/) 

[![dbt docs serve](./Assets/dbt_docs_serve.jpeg)](./Assets/dbt_docs_serve.jpeg) 
### [**3. Data Visualization:**](./Data_Transformation/data_modeling/)

Using the motherduck -> power BI connector i imported the data into Power BI and  built intuitive dashboards showcasing knowledge on the current gospel music field i judged will be interesting and useful to the viewers/users. 

[![dashboard view](./Assets/dashboard_preview.png)](./Assets/dashboard_preview.png)

## Disclaimer & Conclusion
 
This Dataset was built by querying youtube's API  search.list with the names of gospel artists scraped from a well known gospel music site  paired with 'gospel songs' it was restricted to 
` "videoCategoryId":"10"` youtube's restriction for music and I explored the dataset. [see more ...](./Extraction_and_Load/pipeline.py)    
But even with all this measures in place, I guess they might still be some exceptions ( videos not belonging to the set).  
Yet, I believe the target niche (gospel music data) remains in much higher volume.  
This is to push back on any claims you might have come to believe about this dataset being purely 'gospel music'.
 

### <p style = "text-align: center">**Thank you for your time and patience.  Enjoy Your tour.😊** </p>