FROM ubuntu:bionic

# Set metadata
LABEL maintainer="The Mimix Company <code@mimix.io>"
LABEL version="1.0.1"
LABEL description="Dockerfile for Nebula builder"

# Set environment
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt-get update
RUN apt-get install -y software-properties-common build-essential
RUN apt-get install -y curl sbcl cl-launch make git xz-utils wget sudo gcc g++ jq rsync zip
RUN apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1

# Install Docker
RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt-get update
RUN apt-get install -y docker-ce

# Install Wine and friends
RUN add-apt-repository universe
RUN add-apt-repository restricted
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y mono-complete wine64-development wine32-development

# Setup SSH
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh && ssh-keyscan github.com > /root/.ssh/known_hosts

# Install Node.js and friends
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm config set user 0
RUN npm config set unsafe-perm true
RUN npm install -g electron
RUN npm install -g electron-packager
RUN npm install -g electron-builder

# Install Lisp and friends
RUN mkdir -p ~/bin ~/common-lisp
RUN git clone https://gitlab.common-lisp.net/asdf/asdf.git ~/common-lisp/asdf
RUN git clone https://github.com/ebzzry/marie ~/common-lisp/marie
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp
RUN sbcl --noinform --load quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (sb-ext:exit))'
RUN rm -f quicklisp.lisp 2>&1 /dev/null

# Stage the builder
RUN mkdir -p /opt/bin
COPY ./nebula-builder /opt/bin/nebula-builder
COPY ./ssh-run /opt/bin/ssh-run
COPY ./fetch /opt/bin/fetch

# Run the builder
CMD [ "/bin/bash", "-c", "/opt/bin/nebula-builder --build-dir /var/lib/build --sources /var/lib/sources --releases /var/lib/releases --token $TOKEN --targets $TARGETS --tag $TAG" ]
