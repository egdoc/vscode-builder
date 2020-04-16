# Author: Egidio Docile <egdoc.dev@gmail.com>
TELEMETRY_URLS = (dc\.services\.visualstudio\.com)|(vortex\.data\.microsoft\.com)
LATEST_RELEASE = $(shell curl https://github.com/microsoft/vscode/releases \
  | grep -oP '(?<=class="muted-link" href=").*\.tar\.gz' \
  | head -n 1)

vscode:
	curl -L https://github.com$(LATEST_RELEASE) | tar -xvpz
	mv vscode-* vscode

.PHONY: patch
patch:  vscode
	@grep -rl --exclude-dir=.git -E "$(TELEMETRY_URLS)" vscode \
	  | xargs --no-run-if-empty sed --in-place --regexp-extended "s/$(TELEMETRY_URLS)/0\.0\.0\.0/g"
	@cp product.json vscode

.PHONY: build
build:
	@docker build . --tag=egdoc/vscode-compiler
	@docker run \
	  --rm \
	  --interactive \
	  --tty \
	  --name vscode-compiler \
	  --volume "$(CURDIR)/vscode":/home/compiler/src:z \
	  --user 1000 \
	  --ulimit nofile=4000:4000 \
	  --workdir /home/compiler/src \
	  egdoc/vscode-compiler \
	  /bin/bash -c 'yarn \
	    && yarn gulp vscode-linux-x64 \
	    && yarn gulp vscode-linux-x64-build-rpm \
	    && yarn gulp vscode-linux-x64-build-deb'
