# s2i-rust-container
Rust container images based on CentOS and EPEL intended for OpenShift and general usage that provide a platform for building and running Rust applications.

## Versions

* Rust and cargo track to latest versions avaiable from the [EPEL mirrors](https://admin.fedoraproject.org/mirrormanager/mirrors/EPEL)

* CentOS tracks to the latest version available from the [upstream s2i image](https://hub.docker.com/r/centos/s2i-base-centos7/)

## Building

To build the image, run the following

```
$ cd s2-rust-container
$ git submodule update --init
$ make build TARGET=centos7 VERSIONS=latest
```
