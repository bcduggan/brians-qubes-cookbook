---
title: Conventions
layout: default
nav_order: 1
slug: conventions
---

# Naming qubes

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

# Labeling qubes

# Cloning qubes

The Qubes Admin API automatically adds tags to new qubes in some circumstances. When a local admin qube creates a new qube, the Admin API automatically adds a "created-by-[admin-qube]" tag. This indicates that we can record provenance data about qubes in tags.

Qubes does not automatically add any tags to cloned qubes. But we can add this provenance data manually with this process.

Neither of these methods of tracing provenance can currently self-update if we change the name of the original qube. But neither can tags that track the admin qube that created a qube.
