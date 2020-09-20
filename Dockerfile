FROM debian:buster

ARG 1

ENV SEAFILE_SERVER_VERSION 7.1.4
ENV SEAFILE_SERVER_URL https://github.com/haiwen/seafile-rpi/releases/download/v${SEAFILE_SERVER_VERSION}/seafile-server_${SEAFILE_SERVER_VERSION}_pi-buster-stable.tar.gz

ENV TOPDIR /var/seafile
ENV BINDIR $TOPDIR/seafile-server-${SEAFILE_SERVER_VERSION}
ENV SHAREDDIR $TOPDIR/shared

RUN apt-get update && apt-get install -y nginx python-dev bash wget sqlite python-pil python-setuptools libevent-2.1-6 libsearpc1
#RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py
#RUN python -m pip install setuptools pillow


RUN mkdir -p $TOPDIR \
    && cd $TOPDIR \
    && wget --quiet ${SEAFILE_SERVER_URL} \ 
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
CMD "/var/seafile/entry_point.sh"
