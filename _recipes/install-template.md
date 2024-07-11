---
nav_order: 0
title: Install a template
layout: recipe
adminvm: dom0
template: debian-12-minimal
---
{% contentfor problem %}
You want the **{{ page.template }}** template qube to be available on your system.
{% endcontentfor %}

{% contentfor solution %}
{% include solutions/install-template.md adminvm=page.adminvm template=page.template %}
{% endcontentfor %}
