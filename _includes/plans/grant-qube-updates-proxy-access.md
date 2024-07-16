{%- case include.section -%}
  {%- when "problem" %}

You want to grant a qube access to the updates proxy.

  {%- when "solution" %}

## Install updates proxy forwarder Systemd socket service on {{ include.ingredients.client-qube-template }}:

On Fedora:

```bash
{{ include.ingredients.client-qube-template }}.fedora$ dnf install qubes-core-agent qubes-core-agent-systemd
```

On Debian install:

```bash
{{ include.ingredients.client-qube-template }}.debian$ apt install qubes-core-agent
```

## Enable the updates proxy forwarder on {{ include.ingredients.client-qube-template }}:

```bash
{{ include.ingredients.adminvm }}$ qvm-features service.updates-proxy-setup 1
```

## Grant {{ include.ingredients.client-qube }} permission to use the qubes.UpdatesProxy RPC on {{ include.ingredients.service-qube }}

`/etc/qubes/policy.d/30-{{ include.ingredients.client-qube }}.policy`

```plaintext
qubes.UpdatesProxy * {{ include.ingredients.client-qube }} @default allow target={{ include.ingredients.service-qube }}
```

  {%- when "discussion" %}

`systemctl status qubes-updates-proxy-forwarder`

{%- endcase -%}
