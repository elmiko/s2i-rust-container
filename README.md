# Rust source-to-image container image

This repository contains the artifacts to create a
[source-to-image](https://github.com/openshift/source-to-image) style
container image that will build [Rust](https://www.rust-lang.org/) binaries.
It is based on Centos8 and installs Rust from the
[EPEL](https://fedoraproject.org/wiki/EPEL) repositories.

## How to use this image

To build a Rust application from a Git repository you will need to use
the [Cargo](https://doc.rust-lang.org/cargo/index.html) package manager. To
see an example of how to structure your project, look at the
[test application](test/cargo-test-app).

The two primary methods for generating applications from this image are:
remote build using OpenShift, local build using the s2i tool.

### Building and Running an application with OpenShift

#### Prerequisites

* A terminal shell with the OpenShift command line client available
* An active login to an OpenShift cluster

#### Procedure

1. Launch the build and deployment of the application
   ```
   oc new-app quay.io/elmiko/rust-centos8~https://github.com/s2i-rust-container.git \
       --context-dir=test/cargo-test-app \
       --name=cargo-test-app
   ```
1. Expose a route to the service
   ```
   oc expose svc/cargo-test-app
   ```

#### Validation

Use the `curl` utility to read a test message from the service.

```
curl http://`oc get route/cargo-test-app --template='{{.spec.host}}'`
```

### Building and Running an application with Podman

#### Prerequisites

* A terminal shell with the `s2i` and `podman` commands available

#### Procedure

1. Build the image
   ```
   s2i build https://github.com/elmiko/s2i-rust-container.git \
           --context-dir=test/cargo-test-app \
           quay.io/elmiko/rust-centos8 cargo-test-app
   ```
1. Run the image
   ```
   podman run -d -p 8080:8080 cargo-test-app
   ```

#### Validation

Use the `curl` utility to read a test message from the service.

```
curl 127.0.0.1:8080
```

### Environment variables

To set these environment variables, you can place them as a key value pair
into a `.s2i/environment` file inside your source code repository. You can
also define them using the environment variable options available with your
container tooling.

* DISABLE_RELEASE

  Set this variable to a non-empty value to inhibit the release build process
  in cargo. This will force cargo to build the application with a debug
  profile.


## Building and maintaining this image

The image that is produced from this repository(`quay.io/elmiko/rust-centos`)
is automatically built on update. It is updated and rebuilt when new Rust
releases are available and for bug fixes.

### Repository layout

The `master` branch contains all current fixes and Rust installations, it is
mirrored in the image repository with a `latest` tag.

The version branches labelled `vX.Y.Z` correspond to Rust versions that have
been released in EPEL. Each branch has a corresponding image tag in the
image repository.

### Rebuilding the image locally

To rebuild the image you need `make` and `podman` installed, then run:

```
make image
```

If nothing fails you will see a new image tagged `localhost/rust-centos8:latest`
in your registry.

### New Rust versions

When new versions of Rust are available in the upstream EPEL repositories, the
Dockerfile should be updated as follows.

* Update the `RUST_VERSION` environment variable
* Update the `io.k8s.display-name` label
* Update the `io.openshift.tags` label
* Update the `version` label

Finally, a repository branch corresponding to the version in the format
`vX.Y.Z` should be created for the new version.

### Bug Fixes

When bugs arise they should be fixed on the `master` branch of this repository
and then ported to the most recent version branch only. This is due to the
nature of the Rust installation being based on the most current packages in
EPEL. It is often difficult or impossible to maintain proper historical version
installations due to changes in the package repository dependencies.
