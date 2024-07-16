{%- case include.section -%}
  {%- when "problem" %}

You want to use SSH through an updates proxy.

  {%- when "solution" %}

Add `ConnectPort 22` to `/etc/tinyproxy/tinyproxy-updates.conf` on updates proxy service qube.

  {%- when "discussion" %}

`systemctl status qubes-updates-proxy-forwarder`

{%- endcase -%}
