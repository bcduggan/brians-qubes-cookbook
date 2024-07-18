{% case include.os %}
  {% when "fedora" %}
    {% capture command %}dnf install --assumeyes {{ include.packages | join " " }}{% endcapture %}
{% endcase %}
Install these packages on **{{ include.host }}**...
{% for package in include.packages %}
- {{ package }}
{% endfor %}
with:
{% include cli.md host=include.host command=command %}
