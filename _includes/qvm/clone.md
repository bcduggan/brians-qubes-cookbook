{%- assign tag = "cloned-from-" | append: include.original -%}
{% capture command %}qvm-clone --verbose {{ include.original }} {{ include.clone }}{% endcapture %}
Clone **{{ include.original }}** as **{{ include.clone }}** through **{{ include.adminvm }}**:

{% include cli.md host=include.adminvm command=command %}

{% include qvm/tag.md adminvm=include.adminvm qube=include.clone tag=tag %}
