{%- case include.section -%}
  {%- when "problem" %}

You want to use SSH through an updates proxy.

  {%- when "solution" %}

Install the `netcat` package.

`/etc/ssh/ssh_config.d/90-qubes-proxy.conf`

```
Host *
    ProxyCommand /usr/bin/netcat -X connect -x 127.0.0.1:8082 %h %p
```

  {%- when "discussion" %}

`systemctl status qubes-updates-proxy-forwarder`

{%- endcase -%}
