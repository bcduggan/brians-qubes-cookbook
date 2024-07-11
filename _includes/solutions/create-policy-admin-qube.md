{% include solutions/create-qube.md adminvm=include.adminvm qube=include.qube %}

## Grant **{{ include.qube }}** global access to adminvm services

### /etc/qubes/policy.d/include/admin-global-rwx

```
{{ include.qube }} @adminvm allow target=dom0
{{ include.qube }} @tag:created-by-{{ include.qube }} allow target=dom0
{{ include.qube }} {{ include.qube }} allow target=dom0
```

### /etc/qubes/policy.d/30-{{ include.qube }}.policy

```
admin.vm.Create.TemplateVM * {{ include.qube }} @adminvm allow target=dom0
admin.vm.Create.AppVM * {{ include.qube }} @adminvm allow target=dom0
admin.vm.Create.StandaloneVM * {{ include.qube }} @adminvm allow target=dom0
admin.vm.Remove * {{ include.qube }} @tag:created-by-{{ include.qube }} allow target=dom0
qubes.Filecopy * {{ include.qube }} @tag:created-by-{{ include.qube }} allow
qubes.WaitForSession * {{ include.qube }} @tag:created-by-{{ include.qube }} allow
qubes.VMShell * {{ include.qube }} @tag:created-by-{{ include.qube }} allow
```
