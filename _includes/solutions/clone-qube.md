{%- assign tag = "cloned-from-" | append: include.original-qube -%}
## Clone **{{ include.original-qube }}** as **{{ include.clone-qube }}**

```bash
{{ include.adminvm }}$ qvm-clone --verbose {{ include.original-qube }} {{ include.clone-qube }}
```

{% include solutions/tag-qube.md adminvm=include.adminvm qube=include.clone-qube tag=tag %}
