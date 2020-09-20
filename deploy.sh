docker rm --force seafile-server-beta

docker build . -t seafile-server-beta

docker run -it --name seafile-server-beta \
           -p 28716:443 \
           -e "PROTOCOL=https" \
           -e "DOMAIN=cameron.servebeer.com" \
           -e "PORT=28716" \
           -v /var/seafile/docker-beta:/var/seafile/shared \
           -v /etc/letsencrypt/live/cameron.servebeer.com/fullchain.pem:/etc/ssl/fullchain1.pem \
           -v /etc/letsencrypt/live/cameron.servebeer.com/privkey.pem:/etc/ssl/privkey1.pem \
           seafile-server-beta /bin/bash
