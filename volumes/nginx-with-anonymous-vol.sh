echo "🧹 Cleaning up any existing container 'nginx-with-vol'"
docker rm -f nginx-with-vol

echo "Press enter to start nginx-with-vol"
read -r
docker run -d --name nginx-with-vol \
 -p 80:80 \
 -v $(pwd)/html:/usr/share/nginx/html \
 nginx