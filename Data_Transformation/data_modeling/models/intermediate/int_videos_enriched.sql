
SELECT 
    v.* EXCLUDE(video_dlt_id),
    t.value AS tag,
    a.value AS allowed_country,
    b.value AS blocked_country

FROM
    {{ref('stg_videos')}} AS v
LEFT JOIN
    {{source('raw_data','raw_videos__snippet__tags')}} AS t ON v.video_dlt_id = t._dlt_parent_id
LEFT JOIN 
    {{source('raw_data','raw_videos__content_details__region_restriction__allowed')}} AS a ON v.video_dlt_id = a._dlt_parent_id
LEFT JOIN 
    {{source('raw_data','raw_videos__content_details__region_restriction__blocked')}} AS b ON v.video_dlt_id = b._dlt_parent_id
