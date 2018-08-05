FROM resin/rpi-raspbian:jessie|g" Dockerfile.armv7
MAINTAINER snchan20@yahoo.com

ENV SEAFILE_SERVER_VERSION 6.3.2

ENV SEAFILE_SERVER_URL https://github.com/haiwen/seafile-rpi/releases/download/v6.3.2/seafile-server_6.3.2_stable_pi.tar.gz|g' Dockerfile.armv7
docker build . -f Dockerfile.armv7 -t $TAG

ENV TOPDIR /var/seafile
ENV BINDIR $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION}
ENV SHAREDDIR $TOPDIR/shared

RUN apt-get update \
    && apt-get install -y \
        python2.7 \
        libpython2.7 \
        python-setuptools \
        python-imaging \
        python-ldap \
        python-urllib3 \
        sqlite3 \
        wget \
        nano \
        nginx \
    && apt-get autoremove \
    && apt-get clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/* 
RUN mkdir -p $TOPDIR \
    && cd $TOPDIR \
    && wget ${SEAFILE_SERVER_URL} \
    && tar -xzf seafile-server_* \
    && mkdir installed \
    && mv seafile-server_* installed \
    && ln -s $TOPDIR/seafile-server-6.3.2 $TOPDIR/seafile-server-latest \
    && rm /etc/nginx/sites-enabled/default
    
COPY seafile/ $BINDIR/
COPY nginx/ /etc/nginx/sites-available/
COPY entry_point.sh $TOPDIR

EXPOSE 80 443
VOLUME ["/var/seafile/shared"]

WORKDIR $BINDIR
ENTRYPOINT ["/var/seafile/entry_point.sh"]
