{% capture command %}qvm-tags {{ include.qube }} add --verbose {{ include.tag }}{% endcapture %}
Tag **{{ include.qube }}** with *{{ include.tag }}* through **{{ include.adminvm }}**:

{% include cli.md host=include.adminvm command=command %}
