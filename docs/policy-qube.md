---
nav_order: 40
title: Policy qube
slug: policy-qube
layout: recipe
---

{% contentfor problem %}
You want to administer RPC policies from a non-**dom0** qube.
{% endcontentfor %}

{% contentfor solution %}
## Provision

Create **sys-policy**.

{% qubeconsole dom0 %}
$ qvm-create --verbose --class AppVM --template fedora-40-xfce --label purple sys-policy
{% endqubeconsole %}

Disable **sys-policy** network access.

{% qubeconsole dom0 %}
$ qvm-prefs --verbose --set sys-policy netvm None
{% endqubeconsole %}

## Policy

Grant read-only or read-write RPC policy access to **sys-policy**.

### Read-only

Grant read-only RPC policy API access to **sys-policy**.

{% qubepolicy dom0 include/admin-policy-ro %}
sys-policy  @adminvm  allow  target=dom0
{% endqubepolicy %}

### Read-write

Grant read-write RPC policy API access to **sys-policy**.

{% qubepolicy dom0 include/admin-policy-rwx %}
sys-policy  @adminvm  allow  target=dom0
{% endqubepolicy %}

## Test

Use **qubes-policy** tools to administer qubes on **sys-policy**.

{% qubeconsole sys-policy %}
$ qubes-policy --list
{% endqubeconsole %}

{% endcontentfor %}

{% contentfor discussion %}
Qubes OS R4.2 introduced policy administration tools and RPCs in the Admin API. Qubes with access to policy RPCs can use either read-only or read-write functions of the policy administration tools. Together, these functions allow a qube to read and write the contents of **dom0**:*/etc/qubes/policy.d*.

Qubes does not currently include policy backup and restore functionalities. And the built-in policy editor tool can only use text editors installed on **dom0**. **sys-policy** is a good place to implement a custom backup and restore function for policies and to install a text editor of your choice for editing policies with `qubes-policy-editor`.
{% endcontentfor %}
