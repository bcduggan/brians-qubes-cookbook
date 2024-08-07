{% capture content %}
Create offline qube

```bash
{% include qvm/create.md adminvm=page.qubes.adminvm qube=include.qube template=include.template class=include.class label=include.label -%}
{% include qvm/prefs.md adminvm=page.qubes.adminvm qube=include.qube pref="netvm" value="None" -%}
```
{% endcapture content %}
{% include blockquote.md content=content %}
