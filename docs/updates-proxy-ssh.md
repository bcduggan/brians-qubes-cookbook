---
nav_order: 35
title: Allow SSH through updates proxy
slug: updates-proxy-ssh
layout: recipe
service: qubes.UpdatesProxy
---

{% contentfor problem %}
You want to SSH to remote machines from offline qubes.
{% endcontentfor %}

{% contentfor solution %}
## Provision

Enable the updates proxy forwarder service on **acme-workstation-dvm**.

{% qubeconsole dom0 %}
$ qvm-service --enable acme-workstation-dvm updates-proxy-setup 
{% endqubeconsole %}

Add *updates-proxy-client* tag to **acme-workstation-dvm** for targeting in policy.

{% qubeconsole dom0 %}
$ qvm-tags acme-workstation-dvm add updates-proxy-client
{% endqubeconsole %}

## Configure service TemplateVM

Allow SSH through updates proxy.

{% qubeconsole fedora-40-xfce %}
$ vim /etc/tinyproxy/tinyproxy-updates.conf
# Some package managers fetch source through git. You need SSH and git in some offline qubes.
ConnectPort 22
{% endqubeconsole %}

## Configure workstation TemplateVM

Install netcat.

{% qubeconsole debian-12-acme-workstation %}
$ apt install netcat
{% endqubeconsole %}

## Test

{% qubeconsole acme-workstation-dvm %}
$ ssh -T -o ProxyCommand='nc -X connect -x 127.0.0.1:8082 %h %p' git@github.com
{% endqubeconsole %}

## Policies

Allow qubes with the *updates-proxy-client* tag access to the updates proxy on **sys-net**.

{% qubepolicy sys-policy include/admin-global-rwx %}
qubes.UpdatesProxy * @tag:updates-proxy-client @default allow target=sys-net
{% endqubepolicy %}

{% endcontentfor %}

{% contentfor discussion %}
There's no app qube configuration.
{% endcontentfor %}
