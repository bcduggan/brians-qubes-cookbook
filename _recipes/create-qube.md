---
nav_order: 3
title: Create a qube
layout: recipe
adminvm: dom0
qube: acme
class: AppVM
template: fedora-39
label: blue
---
{% contentfor problem %}
You want to create a new qube.
{% endcontentfor %}

{% contentfor solution %}
{% include solutions/create-qube.md adminvm=page.adminvm qube=page.qube template=page.template class=page.class label=page.label %}
{% endcontentfor %}
