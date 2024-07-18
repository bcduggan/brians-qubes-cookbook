{% capture command -%}
qvm-create --verbose --template {{ include.template }} --class {{ include.class }} --label {{ include.label }} {{ include.qube }}
{%- endcapture %}
Create **{{ include.qube }}** through **{{ include.adminvm }}**:

{% include cli.md host=include.adminvm command=command %}
