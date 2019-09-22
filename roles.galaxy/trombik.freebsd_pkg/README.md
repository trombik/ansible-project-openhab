# trombik.freebsd_pkg

Edit `pkg.conf(5)`. To add/remove repositories, use
[trombik.freebsd_pkg_repo](https://github.com/trombik/ansible-role-freebsd_pkg_repo).

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `freebsd_pkg_conf_dir` | base directory of `pkg.conf(5)`. | `/usr/local/etc` |
| `freebsd_pkg_conf_file` | path to `pkg.conf(5)` | `{{ freebsd_pkg_conf_dir }}/pkg.conf` |
| `freebsd_pkg_config` | content of `pkg.conf(5)` | `""` |

# Dependencies

None

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - ansible-role-freebsd_pkg
  vars:
    freebsd_pkg_config: |
      IGNORE_OSVERSION=yes
```

# License

```
Copyright (c) 2019 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
