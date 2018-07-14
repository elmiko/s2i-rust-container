# This image provides a Rust 1.21 environment you can use to run your Rust
# applications.
FROM centos/s2i-base-centos7

EXPOSE 8080

ENV RUST_VERSION=latest \
    PATH=$HOME/.local/bin:$PATH \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

ENV SUMMARY="Platform for building and running Rust $RUST_VERSION applications" \
    DESCRIPTION="Rust $RUST_VERSION available as docker container is a base plaform for \
building and running various Rust $RUST_VERSION applications and frameworks."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Rust latest" \
      io.openshift.expose-servivces="8080:http" \
      io.openshift.tags="builder,rust,rust121" \
      name="elmiko/rust-latest-centos7" \
      version="latest" \
      release="1" \
      maintainer="michael mccune <msm@opbstudios.com>"

RUN yum install -y epel-release && \
    INSTALL_PKGS="rust cargo" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# - In order to drop the root user, we have to make some directories world
#   writable as OpenShift default security model is to run the container
#   under random UID.
RUN chown -R 1001:0 /opt/app-root && \
    fix-permissions /opt/app-root && \
    rpm-file-permissions

USER 1001

# Set the default CMD to print the usage of the language image.
CMD $STI_SCRIPTS_PATH/usage
