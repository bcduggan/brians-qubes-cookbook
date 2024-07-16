{% assign qube = site.data.book.qubes[include.qube] %}
{% assign plan = site.data.book.plan[include.plan] %}
{% for file in plan.policy %}
  {% assign filename = file.name | replace: "%qube%", include.qube %}
Edit __{{ filename }}__:

```bash
qvm-policy-edit {{ filename }}
```

Add these lines:

```
{{ file.content | replace "%qube%", include.qube }}
```
{% endfor %}
