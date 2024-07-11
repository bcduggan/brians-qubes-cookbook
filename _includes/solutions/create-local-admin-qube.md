{% include solutions/create-qube.md adminvm=include.adminvm qube=include.qube %}

## Add **{{ include.qube }}** to the Qubes RPC policy include files for global admin privileges.

### `/etc/qubes/policy.d/include/admin-global-ro`

```
{{ include.qube }} @adminvm allow target=dom0
{{ include.qube }} @tag:created-by-{{ include.qube }} allow target=dom0
{{ include.qube }} {{ include.qube }} allow target=dom0
```

### `/etc/qubes/policy.d/include/admin-local-ro`

```
{{ include.qube }} @adminvm allow target=dom0
```

### `/etc/qubes/policy.d/include/admin-local-rwx`

```
{{ include.qube }} @tag:created-by-{{ include.qube }} allow target=dom0
{{ include.qube }} {{ include.qube }} allow target=dom0
```

## Create new admin policy file for **{{ include.qube }}**

### `/etc/qubes/policy.d/30-{{ include.qube }}.policy`

```
admin.vm.Create.TemplateVM * {{ include.qube }} @adminvm allow target=dom0
admin.vm.Create.AppVM * {{ include.qube }} @adminvm allow target=dom0
admin.vm.Create.StandaloneVM * {{ include.qube }} @adminvm allow target=dom0
admin.vm.Remove * {{ include.qube }} @tag:created-by-{{ include.qube }} allow target=dom0
qubes.Filecopy * {{ include.qube }} @tag:created-by-{{ include.qube }} allow
qubes.WaitForSession * {{ include.qube }} @tag:created-by-{{ include.qube }} allow
qubes.VMShell * {{ include.qube }} @tag:created-by-{{ include.qube }} allow
```
