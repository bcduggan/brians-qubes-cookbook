---
nav_order: 32
title: Configure guix to use updates proxy
slug: configure-guix-updates-proxy
layout: recipe
service: qubes.UpdatesProxy
---

{% contentfor problem %}
You want to use the guix package manager in an offline qube.
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

## Configure

### Client 

#### Template

Install the **guix** package manager on **debian-12-acme-workstation**.

{% qubeconsole debian-12-acme-workstation %}
$ apt install guix
{% endqubeconsole %}

#### AppVM

Persist **guix** directories.

{% qubeconsole debian-12-acme-workstation %}
$ mkdir --parents /rw/config/qubes-bind-dirs.d
$ vim /rw/config/qubes-bind-dirs.d/50_user.conf
binds+=( '/gnu' )
binds+=( '/etc/systemd/system/guix-daemon.service.d' )
{% endqubeconsole %}

Create *updates-proxy-forwarder.conf* to modify the environment for **guix-daemon**.

{% qubeconsole debian-12-acme-workstation %}
$ vim /etc/systemd/system/guix-daemon.service.d/updates-proxy-forwarder.conf
[Service]
Environment="http_proxy=http://127.0.0.1:8082"
Environment="https_proxy=https://127.0.0.1:8082"
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
