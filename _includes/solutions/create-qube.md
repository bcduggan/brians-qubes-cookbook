## Create **{{ include.qube }}** through **{{ include.adminvm }}**

```bash
qvm-create --verbose --template {{ site.data.qubes[include.qube].template }} --class {{ site.data.qubes[include.qube].class }} --label {{ site.data.qubes[include.qube].label }} {{ include.qube }}
```
