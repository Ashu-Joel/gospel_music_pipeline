{% macro map_audio_language(col) %}
CASE {{col}}
    -- English variants
    WHEN 'en' THEN 'English'
    WHEN 'en-US' THEN 'English (US)'
    WHEN 'en-GB' THEN 'English (GB)'
    WHEN 'en-AU' THEN 'English (Australia)'
    WHEN 'en-CA' THEN 'English (Canada)'
    WHEN 'en-IN' THEN 'English (India)'

    -- Spanish variants
    WHEN 'es' THEN 'Spanish'
    WHEN 'es-419' THEN 'Latin American Spanish'
    WHEN 'es-MX' THEN 'Spanish (Mexico)'
    WHEN 'es-ES' THEN 'Spanish (Spain)'

    -- Major languages
    WHEN 'fr' THEN 'French'
    WHEN 'fr-CA' THEN 'French (Canada)'
    WHEN 'de' THEN 'German'
    WHEN 'pt' THEN 'Portuguese'
    WHEN 'pt-BR' THEN 'Portuguese (Brazil)'
    WHEN 'pt-PT' THEN 'Portuguese (Portugal)'
    WHEN 'it' THEN 'Italian'
    WHEN 'nl' THEN 'Dutch'
    WHEN 'ru' THEN 'Russian'
    WHEN 'ja' THEN 'Japanese'
    WHEN 'ko' THEN 'Korean'
    WHEN 'zh' THEN 'Chinese'
    WHEN 'zh-CN' THEN 'Chinese (Simplified)'
    WHEN 'zh-TW' THEN 'Chinese (Traditional)'

    -- Other common languages
    WHEN 'ar' THEN 'Arabic'
    WHEN 'bn' THEN 'Bengali'
    WHEN 'cs' THEN 'Czech'
    WHEN 'da' THEN 'Danish'
    WHEN 'el' THEN 'Greek'
    WHEN 'he' THEN 'Hebrew'
    WHEN 'hi' THEN 'Hindi'
    WHEN 'hu' THEN 'Hungarian'
    WHEN 'id' THEN 'Indonesian'
    WHEN 'ms' THEN 'Malay'
    WHEN 'ml' THEN 'Malayalam'
    WHEN 'no' THEN 'Norwegian'
    WHEN 'pl' THEN 'Polish'
    WHEN 'ro' THEN 'Romanian'
    WHEN 'sv' THEN 'Swedish'
    WHEN 'th' THEN 'Thai'
    WHEN 'ta' THEN 'Tamil'
    WHEN 'tr' THEN 'Turkish'
    WHEN 'uk' THEN 'Ukrainian'
    WHEN 'vi' THEN 'Vietnamese'

    -- Sign languages
    WHEN 'ase' THEN 'American Sign Language'
    WHEN 'bfi' THEN 'British Sign Language'

    -- Fallback
    ELSE {{col}}
END
{% endmacro %}
