
WITH lookup AS (
    SELECT 
    v.video_id AS video_id,
    c.channel_id AS channel_id,
    v.video_view_count AS view_count,
    v.video_like_count AS like_count,
    v.video_comment_count AS comment_count,
    c.channel_videos_view_count AS channel_videos_view_count,
    c.channel_video_count AS channel_video_count,
    c.channel_subscriber_count AS channel_subscriber_count,
    NULLIF(count(DISTINCT i.allowed_country), 0) AS num_of_allowed_countries,
    NULLIF(count(DISTINCT i.blocked_country), 0) AS num_of_blocked_countries

FROM 
    {{ ref('stg_videos')}} AS v
LEFT JOIN
    {{ ref('stg_channels')}} AS c ON v.channel_id = c.channel_id
LEFT JOIN
    {{ ref('int_videos_enriched')}} AS i ON v.video_id = i.video_id
    
GROUP BY ALL
)

SELECT
    * EXCLUDE(num_of_allowed_countries,num_of_blocked_countries),
    CASE 
        WHEN num_of_blocked_countries IS NULL THEN COALESCE(num_of_allowed_countries,249)
        WHEN num_of_blocked_countries IS NOT NULL THEN SUBTRACT(249, num_of_blocked_countries)
        ELSE num_of_allowed_countries
    END AS num_of_allowed_countries,

    CASE 
        WHEN num_of_allowed_countries IS NULL AND num_of_blocked_countries IS NULL THEN COALESCE(num_of_blocked_countries,0)
        WHEN num_of_allowed_countries IS NOT NULL THEN SUBTRACT(249, num_of_allowed_countries)
        ELSE num_of_blocked_countries
    END AS num_of_blocked_countries

FROM lookup
