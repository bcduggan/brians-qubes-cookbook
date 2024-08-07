{%- assign tag = "cloned-from-" | append: include.original -%}
qvm-clone --verbose {{ include.original }} {{ include.clone }}
{% include qvm/tag.md adminvm=include.adminvm qube=include.clone tag=tag -%}
