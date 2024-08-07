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
{: .d-inline-block }
sys-policy
{: .label .label-purple }

{: .white-title }
> dom0
> 
> Create offline policy qube
>
> {: .white-title }
>> /usr/bin/bash
```bash
qvm-create --verbose --template fedora-39-xfce --class AppVM --label purple sys-policy
qvm-prefs --verbose --set sys-policy netvm None
```
>
> Grant offline policy qube permissions to edit RPC policies:
> 
> {: .white-title }
>> /usr/bin/bash
```bash
qubes-policy-editor include/admin-policy-rwx
```
> 
> Add this line to _include/admin-policy-rwx_:
> 
> {: .white-title }
>> include/admin-policy-rwx
```
sys-policy  @adminvm  allow  target=dom0
```

## Test

{: .purple-title }
> sys-policy
>
> Use **qubes-policy** tools to administer qubes on **sys-policy**. For example:
> 
> {: .purple-title }
>> /usr/bin/bash
```bash
qubes-policy --list
```
{% endcontentfor %}

{% contentfor discussion %}
Use **qubes-policy** tools on **sys-policy** to administer Qrexec policies.
{% endcontentfor %}
