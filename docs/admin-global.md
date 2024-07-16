---
title: Global admin qube
slug: global-admin-qube
layout: recipe
admin_qube: dom0
target_qube: dom0
client_qube: sys-admin
---

{% contentfor problem %}
Wanna buy some stuff?
{% endcontentfor %}

{% contentfor solution %}
{% assign client_template = site.data.qubes[page.client_qube].template %}

## Target qube

**dom** is already present and alreday supports the qrexec RPC services your admin qube will call.

## Client qube

### Template

{% include qvm/clone.md adminvm=page.admin_qube original="fedora-39-xfce" clone=client_template %}

### App

{% endcontentfor %}
