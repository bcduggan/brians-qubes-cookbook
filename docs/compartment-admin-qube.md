---
nav_order: 4
title: Compartment admin qube
slug: compartment-admin-qube
layout: recipe
qubes:
  adminvm: sys-admin
  target:
    app: dom0
  client:
    app: acme-admin
    template: fedora-39-admin
---

{% contentfor problem %}
You want to grant local qube administration privileges to a non-**dom0** qube.
{% endcontentfor %}

{% contentfor solution %}

{% qubeconsole dom0 %}
$ ls -l /
{% endqubeconsole %}

{% qubepolicy sys-policy /path/to/file %}
thing1 thing2 thing3
thing4 thing5 thing6
{% endqubepolicy %}

## Provision

{% qubepolicy dom0 include/admin-global-rwx %}
sys-admin  @adminvm                   allow  target=dom0
sys-admin  @tag:created-by-sys-admin  allow  target=dom0
sys-admin  sys-admin                  allow  target=dom0
{% endqubepolicy %}

{% qubeconsole dom0 %}
$ qvm-clone --verbose fedora-39-xfce fedora-39-admin
$ qvm-tags fedora-39-admin add --verbose cloned-from-fedora-39-xfce
$ qvm-create --verbose --template fedora-39-admin --class AppVM --label purple fedora-39-admin
{% endqubeconsole %}

{: .white-title }
> dom0
> 
> Create admin template and global admin app qube.
> 
> {: .white-title }
>> /usr/bin/bash
```bash
{% include qvm/clone.md adminvm=page.qubes.adminvm original="fedora-39-xfce" clone=page.qubes.client.template -%}
{% include qvm/create.md adminvm=page.qubes.adminvm template="fedora-39-admin" label="purple" class="AppVM" qube=page.qubes.client.template -%}
```

## Configure client template

Install the following packages:

- qubes-core-admin-client

{% qubeconsole fedora-39-admin %}
$ dnf install --assumeyes qubes-core-admin-client
{% endqubeconsole %}

{: .black-title }
> fedora-39-admin
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
