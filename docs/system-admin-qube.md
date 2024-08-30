---
nav_order: 50
title: System admin qube
slug: system-admin-qube
layout: recipe
---

{% contentfor problem %}
You want to administer global parameters from a non-**dom0** qube.
{% endcontentfor %}

{% contentfor solution %}
## Provision

Create admin template, **fedora-40-admin**.

{% qubeconsole dom0 %}
$ qvm-clone --verbose fedora-40-xfce fedora-40-admin
{% endqubeconsole %}

Add provenance tag to **fedora-40-admin**.

{% qubeconsole dom0 %}
$ qvm-tags fedora-40-admin add --verbose cloned-from-fedora-40-xfce 
{% endqubeconsole %}

Create **sys-admin** without network access.

{% qubeconsole dom0 %}
$ qvm-create --class AppVM --template fedora-40-admin --label purple --property netvm= sys-admin
{% endqubeconsole %}

## Client

### Template

Install Qubes admin packages on **fedora-40-admin**:

{% qubeconsole fedora-40-admin %}
$ dnf install --assumeyes qubes-core-admin-client
{% endqubeconsole %}

## Policies

Allow **sys-admin** access to all global admin RPCs on all qubes, including **dom0**, through **dom0**.

{% qubepolicy sys-policy include/admin-global-rwx %}
sys-admin  @adminvm  allow  target=dom0
sys-admin  @anyvm    allow  target=dom0
{% endqubepolicy %}

Allow **sys-admin** access to all local admin RPCs on all qubes, including **dom0**, through **dom0**.

{% qubepolicy sys-policy include/admin-local-rwx %}
sys-admin  @adminvm  allow  target=dom0
sys-admin  @anyvm    allow  target=dom0
{% endqubepolicy %}

## Test

Use _qvm_ tools to administer qubes on **{{ page.qubes.client.app }}**:

{% qubeconsole sys-admin %}
$ qvm-ls --all
{% endqubeconsole %}

{% endcontentfor %}

{% contentfor discussion %}
There's no app qube configuration.
{% endcontentfor %}
