{%- case include.section -%}
  {%- when "problem" %}

You want to administer qubes without interacting with _dom0_.

  {%- when "solution" %}

    {% include recipes/clone-qube.md ingredients=page.clone-template-for-adminvm section="solution" %}

## Install __qvm-* tools__:

```
{{ page.adminvm-template }}$ sudo dnf install qubes-core-admin-client
```

## Install **qubesctl**:

```
{{ page.adminvm-template }}$ sudo dnf install qubes-mgmt-salt-admin-tools
```

## Create **{{ page.adminvm }}**

```bash
dom0$ qvm-create --class AppVM --template {{ page.adminvm-template }} --label blue {{ page.adminvm }} ...
```

## Add **{{ page.adminvm }}** to the Qubes RPC policy include files for admin privileges.

### `/etc/qubes/policy.d/include/admin-global-ro`

```
{{ page.adminvm }} @adminvm allow target=dom0
{{ page.adminvm }} @tag:created-by-{{ page.adminvm }} allow target=dom0
{{ page.adminvm }} {{ page.adminvm }} allow target=dom0
```

### `/etc/qubes/policy.d/include/admin-local-ro`

```
{{ page.adminvm }} @adminvm allow target=dom0
```

### `/etc/qubes/policy.d/include/admin-local-rwx`

```
{{ page.adminvm }} @tag:created-by-{{ page.adminvm }} allow target=dom0
{{ page.adminvm }} {{ page.adminvm }} allow target=dom0
```

## Create new admin policy file for **{{ page.adminvm }}**

### `/etc/qubes/policy.d/30-{{ page.adminvm }}.policy`

```
admin.vm.Create.TemplateVM * {{ page.adminvm }} @adminvm allow target=dom0
admin.vm.Create.AppVM * {{ page.adminvm }} @adminvm allow target=dom0
admin.vm.Create.StandaloneVM * {{ page.adminvm }} @adminvm allow target=dom0
admin.vm.Remove * {{ page.adminvm }} @tag:created-by-{{ page.adminvm }} allow target=dom0
qubes.Filecopy * {{ page.adminvm }} @tag:created-by-{{ page.adminvm }} allow
qubes.WaitForSession * {{ page.adminvm }} @tag:created-by-{{ page.adminvm }} allow
qubes.VMShell * {{ page.adminvm }} @tag:created-by-{{ page.adminvm }} allow
```

  {%- when "discussion" %}

admin.vm.Create.* allows creating a VM with any template VM available on the system, even if the admin qube doesn't have permission to see the template VM.

{%- endcase -%}
