{% assign quote = "" %}
{% assign depth = include.depth | default: 1 %}

{% for increment in (1..depth) %}
  {% assign quote = quote | append: ">" %}
{% endfor %}
