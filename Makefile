.PHONY: image clean

image: Dockerfile
	podman build -t rust-centos8 -f Dockerfile .

clean:
	podman rmi localhost/rust-centos8
