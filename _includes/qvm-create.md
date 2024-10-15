{%- assign name = include.qube[0] %}
{%- assign props = include.qube[1] %}
{%- assign options = "template class label" | split: " " %}
{%- capture command -%}
  qvm-create --template {{ props.template }} --class {{ props.class }} --label {{ props.label }}
{%- endcapture %}
{%- for prop in props %}
  {%- if options contains prop[0] %}
  {%- else %}
    {%- capture command -%}
      {{ command }} --property {{ prop[0] }}={{ prop[1] }}
    {%- endcapture %}
  {%- endif %}
{%- endfor %}
$ {{ command }} {{ name }}
