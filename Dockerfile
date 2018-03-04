FROM alpine:latest

# Set environment variables
ENV MURMUR_VERSION=1.2.19

COPY ./script/docker-mumble /usr/bin/docker-mumble

RUN apk --no-cache add \
        pwgen \
        openssl \
    && adduser -SDH murmur \
    && mkdir \
        /data \
        /opt \
        /var/run/murmur \
    && chown -R murmur:nobody \
        /var/run/murmur \
    && wget \
        https://github.com/mumble-voip/mumble/releases/download/${MURMUR_VERSION}/murmur-static_x86-${MURMUR_VERSION}.tar.bz2 -O - |\
        bzcat -f |\
        tar -x -C /opt -f - \
    && mv /opt/murmur* /opt/murmur \
    && chown murmur:root /usr/bin/docker-mumble \
    && chmod 700 /usr/bin/docker-mumble

# Exposed port should always match what is set in /murmur/murmur.ini
EXPOSE 64738/tcp 64738/udp

# Set the working directory
WORKDIR /etc/murmur

# Configure runtime container and start murmur
ENTRYPOINT ["/usr/bin/docker-mumble"]

# Switch to murmur user
USER murmur
