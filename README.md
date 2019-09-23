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

### Web UI locations

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
