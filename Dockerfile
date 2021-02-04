FROM library/node:latest

LABEL maintainer="Gerardo Junior <me@gerardo-junior.com>"
LABEL url="https://github.com/kucherik/nodejs-docker.git"

ENV USER 'node'
ENV WORKDIR '/src'

# Create project directory
RUN mkdir -p ${WORKDIR}

# Empowering user with sudo
RUN set -xe && \
    # addgroup -g 1000 $USER && \
    # adduser -u 1000 -G $USER -s /bin/sh -D $USER && \
    apk --no-cache --update add --virtual .persistent-deps sudo && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default && \
    chown -Rf ${USER} ${WORKDIR}

# Add tools script
COPY ./tools /opt/tools
RUN chmod -R +x /opt/tools/
ENV PATH ${PATH}:/opt/tools

# Set image settings
VOLUME [${WORKDIR}]
WORKDIR ${WORKDIR}
USER ${USER}
ENTRYPOINT ["/bin/sh", "/opt/tools/entrypoint.sh"]
CMD [ "npm", "run", "start" ]
