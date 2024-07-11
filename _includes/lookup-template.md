{% assign template = site.data.qubes[include.qube].template %}
{% capture template-page-name %}
  {%- if template -%}
{{ "create-" | append: template | append: ".md" }}
  {%- endif -%}
{% endcapture %}
{% capture template-page %}
  {%- if template -%}
{{ page.dir | split: "/" | shift | push: template-page-name | join: "/" }}
  {%- endif -%}
{% endcapture %}
