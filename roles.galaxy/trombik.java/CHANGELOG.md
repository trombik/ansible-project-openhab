## Release 2.0.0

* 55d8380 bugfix: update README
* 0088c78 bugfix: update java versions for OpenBSD
* b164af5 bugfix: ignore yaml files under .kitchen
* 8aa2b1d bugfix: s/python/python3/
* 696a631 backword incompatible: drop Debian support
* ffd0800 bugfix: remove loops from package installation tasks
* 54948c4 bugfix: update supported platform versions
* 3a55faa bugfix: QA

### Backward incompatibility

This release drops Debian support due to lack of resource to maintain Debian
virtual machine image.

## Release 1.4.0

* ae6feb1 bugfix: incorrect box name for OpenBSD
* d1f9455 bugfix: remove deprecation warnings
* ecae6bf feature: support FreeBSD 11.2, drop EoLed 11.1 from tests
* bd736bf bugfix: QA

## Release 1.3.0

* 8bfd4ed bugfix: update author information
* aa368ed bugfix: QA
* bc8ddea feature: support Ubuntu 1804 and OpenBSD 6.3

## Release 1.2.2

* 98ce62d [bugfix] update rubocop to the latest (#1)

## Release 1.2.1

* c1d656f [bugfix] remove fixed version from `var/OpenBSD.yml` (#25)
* 7bc1d98 [bugfix] QA and fixes #19 (#23)
* 38b1c7f [bugfix] use specinfra with freebsd mount(8) fix (#20)

## Release 1.2.0

* 114620e install jps by installing `-devel` package (#17)

## Release 1.1.1

* 04ac0ab remove the workaround (#14)

## Release 1.1.0

* 193d346 Support Debian 8.6 (#10)

## Release 1.0.0

* Initial release
