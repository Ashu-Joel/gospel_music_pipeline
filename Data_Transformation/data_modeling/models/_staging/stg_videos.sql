
SELECT
    id AS video_id,
    {{initcap('snippet__title')}} AS video_title,
    CAST(statistics__view_count AS BIGINT) AS video_view_count,
    CAST(statistics__like_count AS BIGINT) AS video_like_count,
    CAST(statistics__comment_count AS BIGINT) as video_comment_count,
    -- Converting YouTube ISO 8601 duration to HH:MM:SS
    TRY_CAST(REPLACE(content_details__duration, 'PT', '') AS INTERVAL) AS video_duration, 
    content_details__definition AS video_definition,
    content_details__licensed_content AS is_licensed,
    CAST(content_details__caption AS BOOLEAN) AS has_captions,
    CASE 
        WHEN LENGTH(snippet__description) > 2 THEN snippet__description
        ELSE NULL
    END AS video_description,
    snippet__default_audio_language AS video_audio_language_code,
    {{ map_audio_language('snippet__default_audio_language') }} AS video_audio_language, -- Mapping YouTube audio language codes to human-readable language names using the map_audio_language macro
    snippet__channel_id AS channel_id,
    {{ initcap('snippet__channel_title') }} AS channel_title, -- Converting channel title to title case for consistency
    snippet__published_at AS video_published_date,
    DAYNAME(video_published_date) AS video_published_day,
    _dlt_id AS video_dlt_id,
    TO_TIMESTAMP(CAST(_dlt_load_id AS BIGINT))::TIMESTAMP AT TIME ZONE 'UTC' AS ingestion_date

FROM 
    {{source('raw_data','raw_videos')}}

WHERE video_duration >= INTERVAL '00:01:00' OR video_duration IS NULL