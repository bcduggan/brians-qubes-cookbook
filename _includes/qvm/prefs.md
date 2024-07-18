{% capture command -%}
qvm-prefs --verbose --set {{ include.qube }} {{ include.pref }} {{ include.value }}
{%- endcapture %}
Set pref *{{ include.pref }}* on **{{ include.qube }}** to **{{ include.value }}**:

{% include cli.md host=include.adminvm command=command %}
