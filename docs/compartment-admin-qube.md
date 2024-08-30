---
nav_order: 60
title: Compartment admin qube
slug: compartment-admin-qube
layout: recipe
dependencies: system-admin-qube
---

{% contentfor problem %}
You want to administer specific qubes from a non-**dom0** qube.
{% endcontentfor %}

{% contentfor solution %}

## Provision

## Configure client template

Install the following packages:

- qubes-core-admin-client

{% qubeconsole fedora-40-admin %}
$ dnf install --assumeyes qubes-core-admin-client
{% endqubeconsole %}

{: .black-title }
> fedora-40-admin
> 
```bash
dnf install --assumeyes qubes-core-admin-client
```

## Update policies

{: .purple-title }
> sys-policy
> 
> Grant **sys-admin** privileges to administer all qubes:
```bash
qubes-policy-edit include/admin-global-rwx
```
> Add these lines to _include/admin-global-rwx_:
> 
> {: .dom0-title }
>> include/admin-global-rwx
>>
```
sys-admin  @adminvm                   allow  target=dom0
sys-admin  @tag:created-by-sys-admin  allow  target=dom0
sys-admin  sys-admin                  allow  target=dom0
```
> 
    admin.vm.Create.TemplateVM    *  sys-admin  @adminvm                   allow  target=dom0
    admin.vm.Create.AppVM         *  sys-admin  @adminvm                   allow  target=dom0
    admin.vm.Create.StandaloneVM  *  sys-admin  @adminvm                   allow  target=dom0
    admin.vm.Remove               *  sys-admin  @tag:created-by-sys-admin  allow  target=dom0
    qubes.Filecopy                *  sys-admin  @tag:created-by-sys-admin  allow
    qubes.WaitForSession          *  sys-admin  @tag:created-by-sys-admin  allow
    qubes.VMShell                 *  sys-admin  @tag:created-by-sys-admin  allow

## Test

{: .purple-title }
> sys-admin
> 
> Use **qvm** tools to administer qubes on **{{ page.qubes.client.app }}**:
```bash
qvm-ls --all
```
{% endcontentfor %}

{% contentfor discussion %}
There's no app qube configuration.
{% endcontentfor %}
