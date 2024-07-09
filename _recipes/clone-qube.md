---
title: Clone a qube
layout: recipe
adminvm: dom0
original-qube: debian-12
clone-qube: debian-12-firefox
---
{% contentfor problem %}
You want to customize an existing qube without modifying it.
{% endcontentfor %}

{% contentfor solution %}
{% include solutions/clone-qube.md adminvm=page.adminvm original-qube=page.original-qube clone-qube=page.clone-qube %}
{% endcontentfor %}

{% contentfor discussion %}
The Qubes Admin API automatically adds tags to new qubes in some circumstances. When a local admin qube creates a new qube, the Admin API automatically adds a "created-by-[admin-qube]" tag. This indicates that we can record provenance data about qubes in tags.

Qubes does not automatically add any tags to cloned qubes. But we can add this provenance data manually with this process.

Neither of these methods of tracing provenance can currently self-update if we change the name of the original qube. But neither can tags that track the admin qube that created a qube.
{% endcontentfor %}
