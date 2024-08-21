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

{% qubecode dom0 console %}
$ mkdir --parents /run/user/1000/demo
{% endqubecode %}

{% html blockquote id="highlander" %}
I feel heard.
{% endhtml %}

{% blockquote id="highlander2" %}
I feel heard.
{% endblockquote %}

{% callout black id="highlander3" %}
I feel alive.
{% endcallout %}

{% qubeconsole dom0 %}
$ ls -l /
{% endqubeconsole %}

## Provision

List files:

{% qubecode dom0 console %}
$ ls -l
{% endqubecode %}

Update policy:

{: .white-title }
> dom0
```console
$ ls -l
```

{: .white-title }
> dom0
```
sys-admin  @adminvm                   allow  target=dom0
sys-admin  @tag:created-by-sys-admin  allow  target=dom0
sys-admin  sys-admin                  allow  target=dom0
```
{: .policy-include }
{: data-caption="include/admin-global-rwx" }



## Provision
acme-admin
{: .label .label-purple }

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

{% qubecode fedora-39-admin console %}
$ dnf install --assumeyes qubes-core-admin-client
{% endqubecode %}

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
