
 WITH lookup AS (
    SELECT
    s.video_id AS "id",
    s.video_title AS "title",
    s.video_duration AS "duration",
    s.video_definition AS "definition",
    s.is_licensed,
    s.has_captions,
    s.video_audio_language AS "audio_language",
    LIST(i.tag) AS "tags",
    LIST(DISTINCT i.allowed_country) AS "allowed_countries",
    LIST(DISTINCT i.blocked_country) AS "blocked_countries",
    s.video_description AS "description",
    s.video_published_date AS "published_date",
    s.video_published_day AS "published_day"

FROM
    {{ ref('stg_videos') }} AS s
LEFT JOIN
    {{ ref('int_videos_enriched')}} AS i ON s.video_id = i.video_id

    
GROUP BY ALL
 )

 SELECT 
    * EXCLUDE (allowed_countries, blocked_countries),
    CASE 
        WHEN allowed_countries[1] IS NOT NULL THEN allowed_countries
        ELSE NULL
    END AS allowed_countries,
    CASE 
        WHEN blocked_countries[1] IS NOT NULL THEN blocked_countries
        ELSE NULL
    END AS blocked_countries
 FROM
    lookup
