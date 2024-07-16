{%- assign tag = "cloned-from-" | append: include.original -%}
## Clone **{{ include.original }}** as **{{ include.clone }}** through **{{ include.adminvm }}**

```bash
# On {{ include.adminvm }}:
qvm-clone --verbose {{ include.original }} {{ include.clone }}
```

{% include solutions/tag-qube.md adminvm=include.adminvm qube=include.clone tag=tag %}
