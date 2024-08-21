---
nav_order: 2
title: Policy qube
slug: policy-qube
layout: recipe
---

{% contentfor problem %}
You want to grant RPC policy edit privileges to a non-**dom0** qube.
{% endcontentfor %}

{% contentfor solution %}
## Provision

Create **sys-policy**.

{% qubeconsole dom0 %}
$ qvm-create --verbose --class AppVM --template fedora-39-xfce --label purple sys-policy
{% endqubeconsole %}

Disable **sys-policy** network access.

{% qubeconsole dom0 %}
$ qvm-prefs --verbose --set sys-policy netvm None
{% endqubeconsole %}

Edit **sys-policy** permissions to edit RPC policies.

{% qubeconsole dom0 %}
$ qubes-policy-editor include/admin-policy-rwx
{% endqubeconsole %}

Add this line to _include/admin-policy-rwx_:

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
Use **qubes-policy** tools on **sys-policy** to administer Qrexec policies.
{% endcontentfor %}
