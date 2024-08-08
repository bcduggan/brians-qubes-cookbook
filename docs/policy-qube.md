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

{% qubecode dom0 console %}
$ qvm-create --verbose --class AppVM --template fedora-39-xfce --label purple sys-policy
{% endqubecode %}

Disable **sys-policy** network access.

{% qubecode dom0 console %}
$ qvm-prefs --verbose --set sys-policy netvm None
{% endqubecode %}

Edit **sys-policy** permissions to edit RPC policies.

{% qubecode dom0 console %}
$ qubes-policy-editor include/admin-policy-rwx
{% endqubecode %}

Add this line to _include/admin-policy-rwx_:

{% qubecode dom0 plaintext caption="include/admin-policy-rwx" %}
sys-policy  @adminvm  allow  target=dom0
{% endqubecode %}

## Test

Use **qubes-policy** tools to administer qubes on **sys-policy**.

{% qubecode sys-policy console %}
$ qubes-policy --list
{% endqubecode %}

{% endcontentfor %}

{% contentfor discussion %}
Use **qubes-policy** tools on **sys-policy** to administer Qrexec policies.
{% endcontentfor %}
