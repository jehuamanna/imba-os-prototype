# Instructions

## Build 

````sh
sudo podman build -t imba .
```

## Rebase

```sh
sudo  bootc switch --transport containers-storage --enforce-container-sigpolicy localhost/imba:latest --apply
```

`--apply` reboots the system.

There are some changes that the above command might fail. I am still looking into it. 
As a backup method I push this image to ghcr and pull and rebase using:

```sh
# sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/<your user name>/imba:latest -r
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/jehuamanna/imba:latest -r

```

`-r` reboots the system

