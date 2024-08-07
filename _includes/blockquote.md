{% assign quote = "" %}
{% assign depth = include.depth | default: 1 %}
{% for increment in (1..depth) %}
  {% assign quote = quote | append: ">" %}
{% endfor %}
{% comment %}
Split on newline:
{% endcomment %}
{% assign lines = include.content | split: "
" %}
{% for line in lines %}
{{ quote }} {{ line }}
{%- endfor %}
