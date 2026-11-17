
SELECT 
country
FROM
{{ref("gospel_music_channels_dim")}}
WHERE
LENGTH(country) < 3