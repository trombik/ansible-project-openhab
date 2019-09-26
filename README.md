# My `OpenHab` project

The purpose of the project is to build a home-automation system to manage
sensors that I created for myself. Project requirements include:

* a management dashboards to test, monitor, and control my devices (`OpenHab`)
* dash boards that show consolidated graphs and history of metrics (`grafana`)
* automated deployment (`ansible`)
* integrated test and production environments (`Vagrant`)

## Requirements

### Requirements on Local machine

* Unix machine
* `ruby`
* `bundler`
* `ansible`
* `vagrant`
* `VirtualBox`

### Requirements on target machine

* Ubuntu 1804
* Configured network interface
* Configured `sshd`
* A Unix account that can run `sudo(1)` as root
* `python`

### Tested hardware and OS

The system is tested on Ubuntu 1803, and deployed to a [Orange Pi Lite 2]
(http://www.orangepi.org/Orange%20Pi%20Lite%202/) with `armbian`.

## Components used in the system

The system is built on a single machine. It is possible to deploy each
components in the project on multiple machines by modifying `ansible` group
variables and inventory files.

### `OpenHab`

The core component for general management of devices.

### `influxdb` and `grafana`

They are used for persistent metrics storage and graphical representation of
metrics.

### `telegraf`

`telegraf` is used as a metric collector from MQTT topics and from other
sources, such as local machine. Note that `OpenHab` is NOT used to collect
metrics even though it has a feature for that. `OpenHab` does subscribe to
topics for metrics at one point, but dose nothing for persistent metrics.

### MQTT server

`mosquitto` is used as MQTT server where devices can publish metrics, and
subscribe command topics.

## Environments

The project provides two environments. One for development and tests, and
another for production system.

`virtualbox` environment is used for development, where `virtualbox` VM is
launched and provisioned.

`prod` is for production system. It can be VMs on cloud service, or a physical
machine.

### Inventory

TBW

## Usage

Clone the repository.

```
git clone https://github.com/trombik/ansible-project-openhab
cd ansible-project-openhab
```

Setup `bundler`.

```
bundle install --path=~/.vendor/bundle
```

Replace `~/.vendor/bundle` with your directory to install gems.

The project is managed by a `Rakefile`. It provides targets to launch virtual
machines, provision them, and test the configured system.

Launch the VM.

```
bundle exec rake up
```

Provision the VM.

```
bundle exec rake provision
```

Test the system.

```
bundle exec rake test:serverspec:all
```

Login to the system (only for `virtualbox` environment).

```
vagrant ssh hab.i.trombik.org
```

Destroy the VM.

```
bundle exec rake clean
```

### Environment variables

#### HTTP proxy

The `Rakefile` supports proxy on local machine. It assumes that the proxy is
running on local machine, listening on port 8080. If it detects the port is
open, then, automatically set necessary proxy setting during the deployment,
which makes the process faster. Any HTTP proxy application works. Here I use
`polipo`.

```
polipo logFile= daemonise=false diskCacheRoot=~/tmp/cache allowedClients='0.0.0.0/0' proxyAddress='0.0.0.0' logSyslog=false logLevel=0xff proxyPort=8080 relaxTransparency=true
```

If you use other application on that port, `VAGRANT_HTTP_PROXY_PORT`
environment variable can be defined to override port 8080. Replace
`~/tmp/cache` with your cache directory.

#### Switching environment

`ANSIBLE_ENVIRONMENT` is an environment variable to switch the target
environment. If not defined, `virtualbox`, where you develop the system, is
assumed. Another environment is `prod`, which is the live production system.

To deploy to `prod`, run:

```
ANSIBLE_ENVIRONMENT=prod bundle exec rake provision
```

#### User to deploy

By default, user `vagrant` for `virtualbox` environment, and the Unix account
on the local machine, is used as `ssh` account. To override it, use
`ANSIBLE_USER` environment variable.

#### `ansible-vault`

To decrypt password protected files by `ansible-vault`, the `Rakefile` use
`ANSIBLE_VAULT_PASSWORD_FILE` environment variable. It should be path to
`ansible-vault` password file on local machine.

#### User to run specs

To test the system in `prod` environment, `SUDO_PASSWORD` environment variable
must be set, which is used to run specs on the target machine. Your local Unix
account (or `ANSIBLE_USER` account) must be able to run `sudo(1)` on the
target machine.

## Web UI locations in `virtualbox` environment

| Application | URI |
|-----------|------------------------------------------------------------------------------|
| `grafana` | `virtualbox`: [http://172.16.100.200/grafana](http://172.16.100.200/grafana) |
| `OpenHab` | `virtualbox`: [http://172.16.100.200/](http://172.16.100.200/)               |

## Create a `mtree` file

```
cat .mtreeignore
./roles.galaxy
./.*
./tmp/
```

```
mtree -c -d -X .mtreeignore
mtree -f ../mtree.txt -u
```
## Security considerations

### General security considerations

Metrics and operations that are allowed for users must be carefully assessed
before implementing a production system.

Operations available to users must have alternatives in case of power failures,
networking issues, and disasters. Broken system can cause fatal accidents.

### `OpenHab` does not implement authentication nor authorization

Current version (2.5.x) does not implement any authentication. The official
advice is "_use HTTP basic authentication_".

Even with basic authentication, it does not provide authorization. Users can
do everything, or not at all.

### Embedding `grafana` panels and dashboards

`OpenHab` implements persistent data and basic graphing capability. But when
you need more than simple graphs, it cannot beat `grafana`.

Embedding `grafana` panels requires `<iframe>` HTML tag. The default
configuration does not allow this because of the risk of
[Clickjacking](https://www.owasp.org/index.php/Clickjacking).

```
[[security]]
# default is false
allow_embedding = true
```

There are two options to allow embedding panels and dashboards to `OpenHab`
UI.

#### As a `grafana` user

Users login to `grafana` first. Then, open `OpenHab` UI.

1. Create a `guest` user with a password that is easily remembered, such as
   `password`.
2. Assign the user to role `Viewer`

Pros:

* Existing `grafana` panels and dashboards can be reused without
  modification
* Anonymous access is not allowed

Cons:
    * Users need to login to `grafana` before seeing the graphs
    * `cookie_samesite` in `[[security]]` must be set to `none`, which means
      the system is vulnerable to CSRF attack

#### As an anonymous `grafana` user

Users do not login to `grafana`. They do nothing to view `OpenHab` UI with
`grafana` panels and dashboards.

1. Create a organization for anonymous users
2. Configure data sources to be used in panels and dashboards for anonymous
   users

Pros:

* Users do not need to login to `grafana`
* No need to lower the default security

Cons:
    * A `grafana` organization for anonymous users is required
    * Data sources and dashboards must be configured for that organization
    * Anyone can view dashboards that belong to the organization without
      authentication
