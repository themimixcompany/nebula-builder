FROM ubuntu:bionic

# Metadata
LABEL maintainer="rom@mimix.io"
LABEL version="0.0.5"
LABEL description="Dockerfile for mvp-builder"

# Environment
ENV DEBIAN_FRONTEND=noninteractive

# Packages
RUN apt-get update
RUN apt-get install -y software-properties-common build-essential
RUN apt-get install -y curl sbcl cl-launch make git xz-utils wget sudo gcc g++ jq rsync zip snapcraft
RUN apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1
RUN add-apt-repository universe
RUN add-apt-repository restricted
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y mono-complete wine64-development wine32-development

# SSH
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh && ssh-keyscan github.com > /root/.ssh/known_hosts

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm config set user 0
RUN npm config set unsafe-perm true
RUN npm install -g electron
RUN npm install -g electron-forge

# Lisp
RUN mkdir -p ~/bin ~/common-lisp
RUN git clone https://gitlab.common-lisp.net/asdf/asdf.git ~/common-lisp/asdf
RUN git clone https://github.com/ebzzry/mof ~/common-lisp/mof
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp
RUN sbcl --noinform --load quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (sb-ext:exit))'
RUN rm -f quicklisp.lisp 2>&1 /dev/null

# Builder
RUN mkdir -p /opt/bin
COPY ./mvp-builder /opt/bin/mvp-builder
COPY ./ssh-run /opt/bin/ssh-run
COPY ./fetch /opt/bin/fetch

# Entrypoint
CMD [ "/bin/bash", "-c", "/opt/bin/mvp-builder --build-dir /var/lib/build --sources /var/lib/sources --releases /var/lib/releases --token $TOKEN --archs $ARCHS --tag $TAG" ]
