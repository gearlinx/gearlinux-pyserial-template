# Template for pySerial application and container image for Gearlinux

This repository can be used as a template for developing a custom Python
application that uses pySerial to communicate with a serial port on a Gearlinux
device, to be run on any Gearlinux device that supports containers.

The Python script `main.py` is run when the container starts, which opens
the serial port `/dev/tty0` with pySerial.
The script then enters a loop where it writes the string "Hello world" to the
port, waits up to 1 second to read a reply, prints the reply (which can be
viewed in the container's logs), and then waits 10 seconds before restarting
the loop.
This is useful to check that the container and serial port are configured
correctly. Connecting a loopback plug (with RXD and TXD lines bridged) will
show the read message matches the written message.

Click "Use this template" to create a new repository based on the contents
of this template repository.
After creating a new repository from the template, you may edit `main.py` or
import your own Python application into the repository.
Add pip dependencies to `requirements.txt`.

A GitHub Action will build the container images for ARM64, ARM 32-bit, and x64
architectures, and push them to `ghcr.io/{owner}/{repository}`.
The pushed images will be tagged with a `git describe` commit hash, and
`latest`, and can be found in the GitHub repository's "Packages" list.

## Development 

After modifying any source files, build the container image for your host
machine by running:

    make

Run the image locally, for example with a USB serial port:

    make run TTY=/dev/ttyUSB0

Build container images for ARM64, ARM, and x64 architectures and save to local build cache:

    make multiarch

Build container images for all architectures and push to a remote registry:

    make push IMAGE_NAME="ghcr.io/{owner}/{repository}"

## Deploying the container

Deploy to a Gearlinux device by adding a container and setting the image name
to the name and tag of the built image.
For example: `ghcr.io/gearlinx/gearlinux-pyserial-template:latest`.

For a Gearlinux device to access private packages pushed to the GitHub Container
Registry, an image registry entry for `ghcr.io` must be configured on the device
with your GitHub username and a
[personal access token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
with appropriate permissions, for example, a classic token that permits the
`read:packages` scope.

Configure a serial port to be mapped through to the container at device path
`/dev/tty0`, which is the path expected by the Python application.

Check the **Compute / Container** section of your Gearlinux device's software
manual administration reference for details.

