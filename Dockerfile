FROM debian:buster

ENV SEAFILE_SERVER_VERSION 7.1.4
ENV SEAFILE_SERVER_URL https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_SERVER_VERSION}/seafile-server_${SEAFILE_SERVER_VERSION}_pi-buster-stable.tar.gz

ENV TOPDIR /var/seafile
ENV SEAFILE_CENTRAL_CONF_DIR $TOPDIR
ENV BINDIR $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION}
ENV SHAREDDIR $TOPDIR/shared

ENV ADMIN_EMAIL admin@seafile
ENV ADMIN_PASSWORD password

RUN apt-get update && apt-get install -y nginx python3.7-dev bash wget sqlite python3-pil python3-setuptools python3-ldap libevent-2.1-6 libsearpc1 procps vim

RUN mkdir -p $TOPDIR \
    && cd $TOPDIR \
    && wget --quiet ${SEAFILE_SERVER_URL} \ 
    && tar -xzf seafile-server_* \
    && mkdir installed \
    && mv seafile-server_* installed \
    && ln -s $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION} $TOPDIR/seafile-server-latest

# Fixes
ENV PYTHONPATH $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION}/seafile/lib/python3.7/site-packages:$TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION}/seafile/lib64/python3.7/site-packages

COPY seafile/ $BINDIR/
COPY nginx/ /etc/nginx/sites-available/
COPY entry_point.sh $TOPDIR/

EXPOSE 80 443
VOLUME ["/var/seafile/shared"]

WORKDIR $BINDIR
ENTRYPOINT ["/var/seafile/entry_point.sh"]
