{% assign qube = site.data.book.qubes[include.qube] %}
## Create **{{ include.qube }}** through **{{ include.adminvm }}**

```bash
qvm-create --verbose --template {{ qube.template }} --class {{ qube.class }} --label {{ qube.label }} {{ include.qube }}
```
