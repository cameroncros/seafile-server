FROM resin/rpi-raspbian:latest

RUN [ "cross-build-start" ]

ENV SEAFILE_SERVER_VERSION 6.0.9
ENV SEAFILE_SERVER_URL https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_SERVER_VERSION}/seafile-server_${SEAFILE_SERVER_VERSION}_stable_pi.tar.gz

ENV TOPDIR /var/seafile
ENV BINDIR $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION}
ENV SHAREDDIR $TOPDIR/shared

RUN apt-get update -qq && apt-get -qq -y install memcached mariadb-server sqlite3 nginx wget nano

RUN apt-get install -y python2.7-dev python-imaging python-ldap python-mysqldb
RUN curl -sSL -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && \
    rm -rf /tmp/get-pip.py && \
    pip install -U wheel

RUN mkdir -p $TOPDIR \
    && cd $TOPDIR \
    && wget ${SEAFILE_SERVER_URL} \ 
    && tar -xzf seafile-server_* \
    && mkdir installed \
    && mv seafile-server_* installed \
    && ln -s $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION} $TOPDIR/seafile-server-latest \
    && rm /etc/nginx/sites-enabled/default
    
COPY seafile/ $BINDIR/
COPY nginx/ /etc/nginx/sites-available/
COPY entry_point.sh $TOPDIR

EXPOSE 80 443
VOLUME ["/var/seafile/shared"]

WORKDIR $BINDIR
ENTRYPOINT ["/var/seafile/entry_point.sh"]

RUN [ "cross-build-end" ]
