
#  **<img  height="45" src="https://toolradar.com/api/logo-download?slug=dbt&format=png&size=512 " alt="merge-git" align="absmiddle"/> DATA TRANSFORMATION & TESTING**
After the raw_data is set in the cloud warehouse (motherduck), dbt queries (SQL + jinja) are written to transform the raw data into a star schema( one fact and many dimensions tables) for easy querying, analysis and building  dashboards.

## **STEP BREAKDOWN**
By default dbt at initialization (dbt init) formats the working/target folder appriopriately as shown.
I went further to breakdown the models folder into 3 folders.

## [**1. STAGING**](./data_modeling/models/_staging/)

This layer is that which connects with my raw data in my cloud database referred to as source defined in [sources.yml](./data_modeling/models/sources.yml).  
It's the layer that handles renaming, re-casting(changing data type), date reformating, "NULL" handling.

## [**2. INTERMEDIATE**](./data_modeling/models/intermediate/)

This layer is meant to handle complex joins ( grouping seperated items like tags . . . back to their respective videos).

## [**3. MARTS**](./data_modeling/models/marts/)
This contains the ready made models that facilitates querying, can be used for decision making and dashboarding. It's built into a star schema with one fact and 2 dimensions table.

### NOTE:
This 3 models are built into seperate schemas as my cloud warehouse will reveal [see more](./data_modeling/dbt_project.yml)
A test file [schema.yml](./data_modeling/models/schema.yml) was built incorporating all the test for the models.
It didn't require much complexity as my dataset prove to be well structured (free from much errors). 

## Conclusion
This step I believe from the structure and code, is self explanatory.   
Thank you once more for your time and patience getting this far. **I pray this convinces you of my skill and knowledge.** Meanwhile I'm very much open to an interview "Hiring Manager".