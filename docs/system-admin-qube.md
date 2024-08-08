---
nav_order: 3
title: System admin qube
slug: system-admin-qube
layout: recipe
qubes:
  adminvm: dom0
  target:
    app: dom0
  client:
    app: sys-admin
    template: fedora-39-admin
policies:
  30-sys-admin: |-
---

{% contentfor problem %}
You want to grant system-wide qube administration privileges to a non-**dom0** qube.
{% endcontentfor %}

{% contentfor solution %}
## Provision

Create admin template, **fedora-39-admin**.

{% qubecode dom0 console %}
$ qvm-clone --verbose fedora-39-xfce fedora-39-admin
{% endqubecode %}

Add provenance tag to **fedora-39-admin**.

{% qubecode dom0 console  %}
$ qvm-tags fedora-39-admin add --verbose cloned-from-fedora-39-xfce 
{% endqubecode %}

Create **sys-admin**.

{% qubecode dom0 console  %}
$ qvm-create --class AppVM --template fedora-39-xfce --label purple fedora-39-admin
{% endqubecode %}

Disable network access on **sys-admin**

{% qubecode dom0 console  %}
$ qvm-prefs --verbose --set sys-admin netvm None
{% endqubecode %}
 

## Client

### Template

Install the following packages on **fedora-39-admin**:

- qubes-core-admin-client

{% qubecode fedora-39-admin console %}
$ dnf install --assumeyes qubes-core-admin-client
{% endqubecode %}

## Policies

Allow **sys-policy** to use all global admin RPCs on all qubes, including **dom0**, through **dom0**.

{% qubecode sys-policy policy-include edit_command="$ qubes-policy-editor include/admin-global-rwx" caption="Add to include/admin-global-rwx" %}
sys-admin  @adminvm  allow  target=dom0
sys-admin  @anyvm    allow  target=dom0
{% endqubecode %}

Allow **sys-policy** to use all local admin RPCs on all qubes, including **dom0**, through **dom0**:

{% qubecode sys-policy policy-include edit_command="$ qubes-policy-editor include/admin-local-rwx" caption="Add to include/admin-local-rwx" %}
sys-admin  @adminvm  allow  target=dom0
sys-admin  @anyvm    allow  target=dom0
{% endqubecode %}

## Test

Use _qvm_ tools to administer qubes on **{{ page.qubes.client.app }}**:

{% qubecode sys-admin console %}
$ qvm-ls --all
{% endqubecode %}

{% endcontentfor %}

{% contentfor discussion %}
There's no app qube configuration.
{% endcontentfor %}
