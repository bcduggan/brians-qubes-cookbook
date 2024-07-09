{%- assign qube-name = include.recipe.namespace | default: site.data.qubes.namespace -%}
{%- if include.recipe.app -%}
  {%- assign app = include.recipe.app | prepend: "-" -%}
  {%- assign qube-name = qube-name | append: app -%}
{%- endif -%}
{%- if include.recipe.template-for-dispvms -%}
  {%- assign qube-name = qube-name | append: "-dvm" -%}
{%- endif -%}

{%- case include.section -%}
  {%- when "problem" %}
You want a consistent, concise naming pattern across all qubes.
  {%- when "solution" %}
Name this qube **{{ qube-name }}**.
  {%- when "discussion" -%}
Qube names must be unique.

Qube names can be a maximum of N characters long.

Qube names can only contain lowercase, alphanumeric characters and hyphens.

Default Qubes OS qubes follow this naming pattern:

`namespace[-app][-dvm]`

The `app` and `dvm` components are optional.

The collection of **sys-****_app_** qubes fits this pattern most clearly:

```
      sys-net
      ^^^ ^^^
namespace app
```

And:

``` 
      sys-net-dvm
      ^^^ ^^^ ^^^
namespace app dvm-template
```

Templates are less obvious:

```
debian-12
^^^^^^^^^
namespace
```

With application:
```
debian-12-xfce
debian-12-minimal
^^^^^^^^^ ^^^^^^^
namespace app
```

The least obvious are the default app qubes:

```
     work
 personal
untrusted
^^^^^^^^^
namespace
```

To extend these, you could add an application:

```
     work-email
     ^^^^ ^^^^^
namespace app
```

{%- endcase -%}
