
SELECT
    id AS channel_id,
    {{initcap('snippet__title')}} AS channel_title,
    CAST(statistics__view_count AS BIGINT) AS channel_videos_view_count,
    CAST(statistics__subscriber_count AS BIGINT) AS channel_subscriber_count,
    CAST(statistics__video_count AS BIGINT) AS channel_video_count,
    snippet__country AS channel_country_code,
    {{ map_channel_country('snippet__country') }} AS channel_country, -- Mapping YouTube country codes to human-readable country names using the map_channel_country macro
    snippet__default_language AS channel_language_code,
    {{ map_audio_language('snippet__default_language') }} AS channel_language, -- Mapping YouTube language codes to human-readable language names using the map_audio_language macro
    CASE 
        WHEN LENGTH(snippet__description) > 2 THEN snippet__description
        ELSE NULL
    END AS channel_description,
    content_details__related_playlists__uploads AS channel_uploads_playlist_id,
    snippet__published_at AS channel_creation_date,
    TO_TIMESTAMP(CAST(_dlt_load_id AS BIGINT))::TIMESTAMP AS ingestion_date

FROM 
    {{source('raw_data','raw_channels')}}

WHERE id IN (
    SELECT 
    channel_id 
    FROM 
    {{ref('stg_videos')}}
)