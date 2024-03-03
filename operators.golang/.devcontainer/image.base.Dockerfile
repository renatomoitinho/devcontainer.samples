ARG GO_VERSION=1.22.0

ARG ALPINE_VERSION=3.19

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}

LABEL maintainer="Renato Moitinho"

RUN apk add -q --update --progress --no-cache \
    alpine-sdk \
    git \
    sudo \
    openssh-client \
    zsh \
    docker \
    bash \
    python3 \
    py3-pip \
    tzdata \ca-certificates \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /root/.ssh

RUN go install golang.org/x/tools/gopls@latest

RUN sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended &> /dev/null

ENV ENV="/root/.ashrc" \
    ZSH=/root/.oh-my-zsh \
    EDITOR=vi \
    LANG=en_US.UTF-8

RUN printf 'ZSH_THEME="robbyrussell"\nENABLE_CORRECTION="false"\nplugins=(git copyfile extract colorize dotenv encode64 golang)\nsource $ZSH/oh-my-zsh.sh' > "/root/.zshrc"

RUN echo "exec `which zsh`" > "/root/.ashrc"

# INSTALL AWS CLI
RUN pip3 install awscli --break-system-packages --upgrade --user

ENV PATH $PATH:/root/.local/bin

# INSTALL KUBECTL
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.22.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# OPERATOR SDK
RUN OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/v1.33.0 \
    && curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_linux_amd64 \
    && chmod +x operator-sdk_linux_amd64 \
    && mv operator-sdk_linux_amd64 /usr/local/bin/operator-sdk

# KUBEBUILDER
RUN curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/linux/amd64" \
    && chmod +x kubebuilder && mv kubebuilder /usr/local/bin/

# INSTALL KIND
RUN go install sigs.k8s.io/kind@v0.22.0

# CONTROLLER GEN
RUN go install sigs.k8s.io/controller-tools/cmd/controller-gen@latest

# SETUP ENV TEST
RUN go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest

# GINKGO
RUN go install github.com/onsi/ginkgo/v2/ginkgo@latest

# INSTALL KUSTOMIZE
RUN GOBIN=$GOPATH/bin/ GO111MODULE=on go install sigs.k8s.io/kustomize/kustomize/v5@latest

ENV PATH $PATH:$GOPATH/bin

COPY ./.kind  /home/.kind