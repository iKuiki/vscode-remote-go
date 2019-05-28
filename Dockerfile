#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------

FROM golang:1

RUN go get -u -v \
    github.com/mdempsky/gocode \
    github.com/uudashr/gopkgs/cmd/gopkgs \
    github.com/ramya-rao-a/go-outline \
    github.com/acroca/go-symbols \
    golang.org/x/tools/cmd/guru \
    golang.org/x/tools/cmd/gorename \
    github.com/rogpeppe/godef \
    github.com/zmb3/gogetdoc \
    github.com/sqs/goreturns \
    golang.org/x/tools/cmd/goimports \
    golang.org/x/lint/golint \
    github.com/alecthomas/gometalinter \
    honnef.co/go/tools/... \
    github.com/golangci/golangci-lint/cmd/golangci-lint \
    github.com/mgechev/revive \
    github.com/derekparker/delve/cmd/dlv \
    golang.org/x/tools/cmd/gopls 2>&1

# gocode-gomod
RUN go get -x -d github.com/stamblerre/gocode 2>&1 \
    && go build -o gocode-gomod github.com/stamblerre/gocode \
    && mv gocode-gomod $GOPATH/bin/

# Copy default endpoint specific user settings overrides into container to specify Go path
COPY settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive

# Install git, process tools, lsb-release (common in install instructions for CLIs), zsh, locales, git-flow vim
RUN apt-get update && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    && apt-get -y install git procps lsb-release zsh less locales git-flow vim \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    # Add zh_CN locale support
    && echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen

ENV DEBIAN_FRONTEND=dialog

# Set time zone
ENV TZ=Asia/Shanghai

# Install Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Set the default shell to zsh rather than sh
ENV SHELL /bin/zsh
