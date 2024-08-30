---
nav_order: 30
title: Enable updates proxy forwarder
slug: enable-updates-proxy-forwarder
layout: recipe
---

{% contentfor problem %}
You want to access some network resources over http proxy in non-template qubes
{% endcontentfor %}

{% contentfor solution %}
## Provision

Install **debian-12** template.

{% qubeconsole dom0 %}
$ qvm-template install debian-12
{% endqubeconsole %}

Create Debian-12-minimal Acme compartment template, **debian-12-acme**.

{% qubeconsole dom0 %}
$ qvm-clone debian-12 debian-12-acme
{% endqubeconsole %}

Add provenance tag to **debian-12-acme**.

{% qubeconsole dom0 %}
$ qvm-tags debian-12-acme add cloned-from-debian-12 
{% endqubeconsole %}

Create **acme-updates-proxy-client** without network access.

{% qubeconsole dom0 %}
$ qvm-create --class AppVM --template debian-12-acme --label blue --property netvm= acme-updates-proxy-client
{% endqubeconsole %}

Enable the updates proxy forwarder service on **acme-updates-proxy-client**.

{% qubeconsole dom0 %}
$ qvm-service --enable acme-updates-proxy-client updates-proxy-setup 
{% endqubeconsole %}

Add *updates-proxy-client* tag to **acme-updates-client** for targeting in policy.

{% qubeconsole dom0 %}
$ qvm-tags acme-updates-proxy-client add updates-proxy-client
{% endqubeconsole %}

## Policies

Allow qubes with the *updates-proxy-client* tag access to the updates proxy on **sys-net**.

{% qubepolicy sys-policy include/admin-global-rwx %}
qubes.UpdatesProxy * @tag:updates-proxy-client @default allow target=sys-net
{% endqubepolicy %}

## Test
 
Use `http://127.0.0.1:8082` for `http_proxy` and `https://127.0.0.1:8082` for `https_proxy` as environment variables or application configuration.

{% qubeconsole acme-updates-proxy-client %}
$ curl --location --proxy "http://127.0.0.1:8082" http://debian.org/intro
$ curl --location --proxy "https://127.0.0.1:8082" https://debian.org/intro
{% endqubeconsole %}

**git** only works with the *http* version of the proxy. The `-c` option sets a configuration option from a command line option.

{% qubeconsole acme-updates-proxy-client %}
$ git -c http.proxy="http://127.0.0.1:8082" clone https://github.com/QubesOS/qubes-secpack.git
{% endqubeconsole %}

{% endcontentfor %}

{% contentfor discussion %}
There's no app qube configuration.
{% endcontentfor %}
