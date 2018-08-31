FROM debian:buster
LABEL maintainer="Víctor Cuadrado Juan"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y \
       sudo eatmydata systemd ansible ansible-lint \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl