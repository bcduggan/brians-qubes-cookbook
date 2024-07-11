---
title: Create a global admin qube
layout: recipe
adminvm: dom0
qube: sys-admin 
---
{% contentfor problem %}
You want to create a new qube.
{% endcontentfor %}

{% contentfor solution %}
{% include solutions/create-global-admin-qube.md adminvm=page.adminvm qube=page.qube %}
{% endcontentfor %}
