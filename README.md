# vscode-builder
Build vscode from source using a docker container.

Creates a docker image with all the necessary dependencies to build vscode from
source and spawns a container to compile and package the editor in rpm and deb
format. Telemetry urls are removed from code before compiling and telemetry is
disabled by default.

To build vscode:

```
$ git clone https://github.com/egdoc/vscode-builder
$ cd vscode-builder
$ make patch && sudo make build
```
