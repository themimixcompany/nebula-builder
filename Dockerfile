FROM ubuntu:bionic

# Labels
LABEL maintainer="rom@mimix.io"
LABEL version="0.0.1"
LABEL description="Dockerfile for mvp-builder"

# Packages
RUN apt-get update -y
RUN apt-get install -y curl sbcl cl-launch make git xz-utils wget sudo gcc g++ make
RUN sudo apt-get install -y libx11-xcb1 libgtk-3-0 libnss3 libxss1 libasound2 libssl1.1

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs npm
RUN npm config set user 0
RUN npm config set unsafe-perm true
RUN npm install -g electron

# Lisp
RUN mkdir -p ~/bin ~/common-lisp
RUN git clone https://gitlab.common-lisp.net/asdf/asdf.git ~/common-lisp/asdf
RUN git clone https://github.com/ebzzry/mof ~/common-lisp/mof
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp
RUN sbcl --noinform --load quicklisp.lisp --eval  '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (sb-ext:exit))'

# Builder
COPY ./mvp-builder /usr/bin/mvp-builder
RUN chmod +x /usr/bin/mvp-builder

# Other directories
RUN mkdir -p /var/lib/staging
RUN mkdir -p /releases

# Entrypoint
CMD [ "/usr/bin/mvp-builder", "--staging-dir", "/var/lib/staging", "--releases-dir", "/releases" ]
