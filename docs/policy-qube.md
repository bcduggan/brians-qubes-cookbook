---
nav_order: 2
title: Policy qube
slug: policy-qube
layout: recipe
qubes:
  adminvm: dom0
  client:
    app: sys-policy
    template: fedora-39-xfce
policies:
  include/admin-policy-rwx: |-
    sys-policy  @adminvm  allow  target=dom0
---

{% contentfor problem %}
You want to grant RPC policy edit privileges to a non-**dom0** qube.
{% endcontentfor %}

{% contentfor solution %}

## Create policy app qube

{% include qvm/create.md adminvm=page.qubes.adminvm qube=page.qubes.client.app template=page.qubes.client.template class="AppVM" label="purple" %}
{% include qvm/prefs.md adminvm=page.qubes.adminvm qube=page.qubes.client.app pref="netvm" value="None" %}

## Grant qube permissions to edit RPC policies

{% include policies.md adminvm=page.qubes.adminvm policies=page.policies %}

## Test

Use **qvm** tools to administer qubes on **{{ page.qubes.client.app }}**. For example:

{% include cli.md host=page.qubes.client.app command="qubes-policy --list" %}

{% endcontentfor %}

{% contentfor discussion %}
We just made and admin qube!
{% endcontentfor %}
