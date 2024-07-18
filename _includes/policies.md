{% for policy in include.policies %}
  {% capture command -%}
    qubes-policy-editor {{ policy[0] }}
  {%- endcapture %}
Edit policy **{{ policy[0] }}** through **{{ include.adminvm }}** with...


  {% include cli.md host=include.adminvm command=command %}



to add:
```
{{ policy[1] }}
```
{% endfor %}
