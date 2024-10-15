---
nav_order: 25
title: Provision qubes
layout: default
slug: provision-qubes
---

# Templates

{% qubeconsole dom0 %}
  {%- for qube in site.data.qubes %}
    {%- if qube[1].fromrepo %}
$ qvm-template install {{ qube[0] }}
    {%- endif %}
  {%- endfor %}
{% endqubeconsole %}

# Template clones

{% qubeconsole dom0 %}
  {%- for qube in site.data.qubes %}
    {%- if qube[1].original %}
$ qvm-clone {{ qube[1].original}} {{ qube[0] }} 
$ qvm-tags {{ qube[0] }} add cloned-from-{{ qube[1].original }}
    {%- endif %}
  {%- endfor %}
{% endqubeconsole %}

# AppVMs

{% qubeconsole dom0 %}
  {%- for qube in site.data.qubes %}
    {%- if qube[1].class == "AppVM" -%}
      {%- unless qube[1].template_for_dispvms -%}
        {% include qvm-create.md qube=qube %}
      {%- endunless %}
    {%- endif %}
  {%- endfor %}
{% endqubeconsole %}

# DispVM templates

{% qubeconsole dom0 %}
  {%- for qube in site.data.qubes %}
    {%- if qube[1].class == "AppVM" -%}
      {%- if qube[1].template_for_dispvms -%}
        {% include qvm-create.md qube=qube %}
      {%- endif %}
    {%- endif %}
  {%- endfor %}
{% endqubeconsole %}

# DispVMs

{% qubeconsole dom0 %}
  {%- for qube in site.data.qubes %}
    {%- if qube[1].class == "DispVM" -%}
      {% include qvm-create.md qube=qube %}
    {%- endif %}
  {%- endfor %}
{% endqubeconsole %}
