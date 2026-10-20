{% macro initcap(col) %}
    CASE
        WHEN position(' ' IN {{ col }}) > 0 THEN
            list_aggr(
                list_transform(
                    string_split({{ col }}, ' '),
                    w -> CASE
                            WHEN length(w) > 0
                            THEN upper(substr(w, 1, 1)) || lower(substr(w, 2))
                            ELSE w
                         END
                ),
                'string_agg',
                ' '
            )
        ELSE
            upper(substr({{ col }}, 1, 1)) || lower(substr({{ col }}, 2))
    END
{% endmacro %}
