---
nav_order: 1
title: Tag a qube
layout: recipe
adminvm: dom0
qube: work
tag: created-during-installation
---
{% contentfor problem %}
You want to record boolean metadata about a qube. You want this metadata to be available through the Qubes Admin API and SaltStack on adminvm qubes.
{% endcontentfor %}

{% contentfor solution %}
{% include solutions/tag-qube.md adminvm=page.adminvm qube=page.qube tag=page.tag %}
{% endcontentfor %}
