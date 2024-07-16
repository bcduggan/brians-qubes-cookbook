---
title: Create a global admin qube
layout: recipe
slug: bootstrap-admin-global-qube
grand_parent: Plans
parent: Bootstrap
adminvm: dom0
qube: sys-admin 
---
{% contentfor problem %}
You want to create a new qube.
{% endcontentfor %}

{% contentfor solution %}
{% include recipe/qube/admin-global.md adminvm=page.adminvm qube=page.qube %}
{% endcontentfor %}
