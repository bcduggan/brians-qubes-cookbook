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
{: .d-inline-block }
fedora-39-admin
{: .label .label-black }
sys-admin
{: .label .label-purple }

{: .white-title }
> dom0
> 
> Create admin template and system admin app qube.
> 
> {: .white-title }
>> /usr/bin/bash
```bash
{% include qvm/clone.md adminvm=page.qubes.adminvm original="fedora-39-xfce" clone=page.qubes.client.template -%}
{% include qvm/create.md adminvm=page.qubes.adminvm template="fedora-39-admin" label="purple" class="AppVM" qube=page.qubes.client.app -%}
qvm-prefs --verbose --set sys-admin netvm None
```

## Configure client template

{: .black-title }
> fedora-39-admin
> 
> Install the following packages:
> 
> {: .black-title }
>> /usr/bin/bash
```bash
dnf install --assumeyes qubes-core-admin-client
```

## Update policies

{: .purple-title }
> sys-policy
> 
> Allow **sys-policy** to use all global admin RPCs on all qubes, including **dom0**, through **dom0**:
> 
> {: .purple-title }
>> /usr/bin/bash
```bash
qubes-policy-editor include/admin-global-rwx
```
> 
> Add these lines to _include/admin-global-rwx_:
> 
> {: .white-title }
>> include/admin-global-rwx
>>
```
sys-admin  @adminvm  allow  target=dom0
sys-admin  @anyvm    allow  target=dom0
```
> 
>
> Allow **sys-policy** to use all local admin RPCs on all qubes, including **dom0**, through **dom0**:
> 
> {: .purple-title }
>> /usr/bin/bash
```bash
qubes-policy-editor include/admin-local-rwx
```
> 
> Add these lines to _include/admin-local-rwx_:
> 
> {: .white-title }
>> include/admin-local-rwx
>>
```
sys-admin  @adminvm  allow  target=dom0
sys-admin  @anyvm    allow  target=dom0
```

## Test

{: .purple-title }
> sys-admin
> 
> Use _qvm_ tools to administer qubes on **{{ page.qubes.client.app }}**:
> 
> {: .purple-title }
>> /usr/bin/bash
```bash
qvm-ls --all
```
{% endcontentfor %}

{% contentfor discussion %}
There's no app qube configuration.
{% endcontentfor %}
