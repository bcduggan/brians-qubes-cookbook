{%- case include.section -%}
  {%- when "problem" %}

You want to customize an existing qube without modifying it.

  {%- when "solution" %}

## Clone **{{ include.ingredients.original-qube }}**
```bash
{{ include.ingredients.adminvm }}$ qvm-clone {{ include.ingredients.original-qube }} {{ include.ingredients.clone-qube }}
```

## Tag **{{ include.ingredients.clone-qube }}**
```bash
{{ include.ingredients.adminvm }}$ qvm-tag {{ include.ingredients.clone-qube }} add --verbose cloned-from-{{ include.ingredients.original-qube }}
```

  {%- when "discussion" %}

It is possible to track cloned qube provenenance in the qube name. If we clone fedora-39-xfce to create an admin qube template, we could name the cloned qube "fedora-39-xfce-admin". But that doesn't scale very well. Qubes might allow names long enough to use the original qube as the name prefix. But we will eventually exhaust the available space if we keep cloning derivative qubes. For example, cloning "fedora-39-xfce-admin" to create an employer-specific template qube would create "fedora-39-xfce-admin-capitalist-yoke".

In addition to relying on a limited resource, storing provenance in qube names raises a couple of new issues. We'll obviously lose some readability as our qube names get longer, like "fedora-39-xfce-admin-capitalist-yoke-one". But now we have to decide whether we get more specific or less specific as we write the name from left to right. Should our example cloned qube be "fedora-39-xfce-admin", or should it really be "admin-fedora-39-xfce"? We could try to discern the "default" pattern that Qubes uses to name template VMs and try to follow it. But it would be nicer to be able to track qube provenance without overloading the purpose of qube names in the first place.

The Qubes Admin API automatically adds tags to new qubes in some circumstances. When a local admin qube creates a new qube, the Admin API automatically adds a "created-by-[admin-qube]" tag. This indicates that we can record provenance data about qubes in tags.

Qubes does not automatically add any tags to cloned qubes. But we can add this provenance data manually with this process.

Neither of these methods of tracing provenance can currently self-update if we change the name of the original qube. But neither can tags that track the admin qube that created a qube.
{%- endcase -%}
