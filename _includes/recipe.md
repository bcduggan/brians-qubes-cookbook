{%- capture path -%}
{%- if page.dir -%}
{{ page.colleciton }}/{{ page.dir }}/{{ page.name }}
{%- else -%}
{{ page.collection }}/{{ page.name }}
{%- endif -%}
{%- endcapture -%}
# Problem
{% include {{ path }} recipe=include.recipe section="problem" %}
# Solution
{% include {{ path }} recipe=include.recipe section="solution" %}
# Discussion
{% include {{ path }} recipe=include.recipe section="discussion" %}
