# Rust 1.21 Docker image

This container image includes Rust 1.21 as a
[S2I](https://github.com/openshift/source-to-image) base image for your Rust
1.21 applications. It is based on CentOS builder images and installs Rust from
[EPEL](https://fedoraproject.org/wiki/EPEL).


## Description

Rust 1.21 available as docker container is a base plaform for building and
running varios Rust $RUST_VERSION applications and frameworks.

## Usage

To build a simple [rust sample application](test/cargo-test-app) using
standalone [S2I](https://github.com/openshift/source-to-image) and then deploy
the application with Docker, execute:

```
s2i build https://github.com/elmiko/s2i-rust-container.git --context-dir=1.21/test/cargo-test-app elmiko/rust-121-centos7 rust-sample-app

docker run -d -p 8080:8080 rust-sample-app

curl 127.0.0.1:8080
```

## Environment variables

To set these environment variables, you can place them as a key value pair
into a `.s2i/environment` file inside your source code repository.

* DISABLE_RELEASE

  Set this variable to a non-empty value to inhibit the release build process
  in cargo. This will force cargo to build the application with a debug
  profile.


