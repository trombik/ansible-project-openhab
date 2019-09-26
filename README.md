# An example project

## Usage

Install external roles.

```
ansible-galaxy install -p roles.galaxy -r requirements.yml
```

Launch the VM.

```
vagrant up
```

Provision the VM.

```
vagrant provision
```

### Web UI locations in `virtualbox` environment

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
