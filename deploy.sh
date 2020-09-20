
docker rmi --force seafile-server-beta
docker rm --force seafile-server-beta
docker image prune -f

docker build . -t seafile-server-beta

docker run -it --name seafile-server-beta \
           -p 28716:443 \
           -e "PROTOCOL=https" \
           -e "DOMAIN=cameron.servebeer.com" \
           -v /var/seafile/docker-beta:/var/seafile/shared \
           -v /etc/letsencrypt/live/cameron.servebeer.com/fullchain.pem:/etc/ssl/fullchain1.pem \
           -v /etc/letsencrypt/live/cameron.servebeer.com/privkey.pem:/etc/ssl/privkey1.pem \
           seafile-server-beta
