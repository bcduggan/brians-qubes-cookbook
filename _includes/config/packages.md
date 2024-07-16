{%- assign os = site.data.qubes[include.qube].os -%}
{%- assign packages = site.data.recipes[include.recipe].packages[os] -%}
## Install these packages on **{{ include.qube }}**

{% for package in packages %}
- {{ package }}
{% endfor %}
