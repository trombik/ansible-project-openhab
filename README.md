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
