ARG GO_VERSION=1.22.0

ARG ALPINE_VERSION=3.19

FROM --platform=amd64 golang:${GO_VERSION}-alpine${ALPINE_VERSION}

RUN apk add --update --no-cache bash doas \
    alpine-sdk \
    openssh-client \
    git \
    ca-certificates \
    docker \
    zsh \
    python3 \
    py3-pip \
    tzdata \ 
    && rm -rf /var/cache/apk/*

RUN adduser -D developer --home /home/developer -G wheel \
    && echo 'permit :wheel as root' > /etc/doas.d/doas.conf \
    && echo 'permit nopass :wheel as root' >> /etc/doas.d/doas.conf \
    && su developer \
    && addgroup developer docker \
    && chown developer:docker /var/run

USER developer

ENV HOME /home/developer

ENV GOPATH ${HOME}/go

ENV PATH $PATH:$GOPATH/bin

COPY ./.kind  ${HOME}/.kind

# INSTALL AWS CLI
RUN pip3 install awscli --break-system-packages --upgrade --user

ENV PATH $PATH:/root/.local/bin

# INSTALL KUBECTL
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && doas mv ./kubectl /usr/local/bin/kubectl

# OPERATOR SDK
RUN OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/1.33.0 \
    && curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_linux_amd64 \
    && chmod +x operator-sdk_linux_amd64 \
    && doas mv operator-sdk_linux_amd64 /usr/local/bin/operator-sdk

# KUBEBUILDER
RUN curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/linux/amd64" \
    && chmod +x kubebuilder && doas mv kubebuilder /usr/local/bin/

# INSTALL GOPLS
RUN GOBIN=$GOPATH/bin/ go install golang.org/x/tools/gopls@latest

# INSTALL KIND
RUN GOBIN=$GOPATH/bin/ go install sigs.k8s.io/kind@v0.22.0

# CONTROLLER GEN
RUN GOBIN=$GOPATH/bin/ go install sigs.k8s.io/controller-tools/cmd/controller-gen@v0.14.0

# SETUP ENV TEST
RUN GOBIN=$GOPATH/bin/ go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest

# GINKGO
RUN GOBIN=$GOPATH/bin/ go install github.com/onsi/ginkgo/v2/ginkgo@v2.16.0

# INSTALL KUSTOMIZE
RUN GOBIN=$GOPATH/bin/ GO111MODULE=on go install sigs.k8s.io/kustomize/kustomize/v5@v5.3.0

USER root