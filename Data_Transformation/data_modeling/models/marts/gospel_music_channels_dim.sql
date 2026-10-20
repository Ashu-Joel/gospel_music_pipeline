
SELECT 
    channel_id AS "id",
    channel_uploads_playlist_id AS "related_playlist_id",
    channel_title AS "title",
    channel_country AS "country",
    channel_language AS "language",
    channel_description AS "description",
    channel_creation_date AS "creation_date",
    DAYNAME(channel_creation_date) AS "creation_day"

FROM
    {{ ref('stg_channels') }}
