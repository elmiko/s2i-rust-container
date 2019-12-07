# This image provides a Rust environment you can use to run your Rust
# applications.
FROM centos/s2i-core-centos7

EXPOSE 8080

ENV RUST_VERSION=1.39.0 \
    PATH=$HOME/.local/bin:$PATH \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

ENV SUMMARY="Platform for building and running Rust $RUST_VERSION applications" \
    DESCRIPTION="Rust $RUST_VERSION available as docker container is a base plaform for \
building and running various Rust $RUST_VERSION applications and frameworks."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Rust 1.39.0" \
      io.openshift.expose-servivces="8080:http" \
      io.openshift.tags="builder,rust,rust139" \
      name="quay.io/elmiko/rust-centos7" \
      version="1.39.0" \
      release="1" \
      maintainer="michael mccune <msm@opbstudios.com>"

RUN INSTALL_PKGS="rust cargo" && \
    yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y --enablerepo='*'

COPY ./s2i/bin /usr/libexec/s2i

USER 1001

# Set the default CMD to print the usage of the language image.
CMD ["/usr/libexec/s2i/usage"]
