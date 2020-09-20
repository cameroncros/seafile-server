FROM alpine:latest

ENV SEAFILE_SERVER_VERSION 7.1.4
ENV SEAFILE_SERVER_URL https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_SERVER_VERSION}/seafile-server_${SEAFILE_SERVER_VERSION}_pi-bionic-stable.tar.gz

ENV TOPDIR /var/seafile
ENV BINDIR $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION}
ENV SHAREDDIR $TOPDIR/shared

RUN apk update && apk add nginx python3-dev py-pip

RUN mkdir -p $TOPDIR \
    && cd $TOPDIR \
    && wget ${SEAFILE_SERVER_URL} \ 
    && tar -xzf seafile-server_* \
    && mkdir installed \
    && mv seafile-server_* installed \
    && ln -s $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION} $TOPDIR/seafile-server-latest

COPY seafile/ $BINDIR/
COPY nginx/ /etc/nginx/sites-available/
COPY entry_point.sh $TOPDIR/

EXPOSE 80 443
VOLUME ["/var/seafile/shared"]

WORKDIR $BINDIR
ENTRYPOINT ["/var/seafile/entry_point.sh"]
