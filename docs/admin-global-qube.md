---
nav_order: 3
title: Global admin qube
slug: global-admin-qube
layout: recipe
qubes:
  adminvm: dom0
  target:
    app: dom0
  client:
    app: sys-admin
    template: fedora-39-admin
packages:
  client:
    template:
      - qubes-core-admin-client
policies:
  include/admin-global-rwx: |-
    sys-admin  @adminvm                   allow  target=dom0
    sys-admin  @tag:created-by-sys-admin  allow  target=dom0
    sys-admin  sys-admin                  allow  target=dom0
  30-sys-admin: |-
    admin.vm.Create.TemplateVM    *  sys-admin  @adminvm                   allow  target=dom0
    admin.vm.Create.AppVM         *  sys-admin  @adminvm                   allow  target=dom0
    admin.vm.Create.StandaloneVM  *  sys-admin  @adminvm                   allow  target=dom0
    admin.vm.Remove               *  sys-admin  @tag:created-by-sys-admin  allow  target=dom0
    qubes.Filecopy                *  sys-admin  @tag:created-by-sys-admin  allow
    qubes.WaitForSession          *  sys-admin  @tag:created-by-sys-admin  allow
    qubes.VMShell                 *  sys-admin  @tag:created-by-sys-admin  allow
---

{% contentfor problem %}
Wanna buy some stuff?
{% endcontentfor %}

{% contentfor solution %}

## Target qube

**dom** is already present and alreday supports the qrexec RPC services your admin qube will call.

## Client qube

### Template

{% include qvm/clone.md adminvm=page.qubes.adminvm original="fedora-39-xfce" clone=page.qubes.client.template %}
{% include packages.md os="fedora" host=page.qubes.client.template packages=page.packages.client.template %}

### App

Nothing to do here.

## Policies

{% include policies.md adminvm=page.qubes.adminvm policies=page.policies %}

## Use 

Use **qvm** tools to administer qubes on **{{ page.qubes.client.app }}**. For example:

{% include cli.md host=page.qubes.client.app command="qvm-ls --all" %}

{% endcontentfor %}

{% contentfor discussion %}
We just made and admin qube!
{% endcontentfor %}
