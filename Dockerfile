FROM debian:buster

ENV SEAFILE_SERVER_VERSION 8.0.3
ENV SEAFILE_FOLDER seafile-server-${SEAFILE_SERVER_VERSION}
ENV SEAFILE_TAR_GZ seafile-server-${SEAFILE_SERVER_VERSION}-buster-armv7.tar.gz
ENV SEAFILE_SERVER_URL https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_SERVER_VERSION}/${SEAFILE_TAR_GZ}

ENV TOPDIR /var/seafile
ENV LC_ALL en_US.UTF-8

ENV ADMIN_EMAIL admin@seafile
ENV ADMIN_PASSWORD password

RUN apt-get update && apt-get install -y nginx python3.7-dev bash wget sqlite python3-pil python3-setuptools python3-ldap libevent-2.1-6 libsearpc1 procps

RUN echo Downloading ${SEAFILE_SERVER_URL} to ${TOPDIR}
RUN mkdir -p ${TOPDIR} \
    && cd ${TOPDIR} \
    && wget --quiet ${SEAFILE_SERVER_URL} \ 
    && tar -xzf ${SEAFILE_TAR_GZ} \
    && mv ${SEAFILE_FOLDER} seafile-server-latest

RUN sed -i 's/bind = "127.0.0.1:8000"/bind = "0.0.0.0:8000"/g' ${TOPDIR}/seafile-server-latest/setup-seafile.sh

COPY nginx/ /etc/nginx/sites-available/
COPY entry_point.sh $TOPDIR/
COPY check_init_admin.py ${TOPDIR}/seafile-server-latest/
EXPOSE 80 443
VOLUME ["/var/seafile/shared"]

WORKDIR $TOPDIR/shared
ENTRYPOINT ["/var/seafile/entry_point.sh"]
