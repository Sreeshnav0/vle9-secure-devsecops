FROM nginx:alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY index.html /usr/share/nginx/html/index.html

RUN chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d \
    && sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf \
    && sed -i 's|pid        /run/nginx.pid;|pid        /tmp/nginx.pid;|' /etc/nginx/nginx.conf

USER appuser

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
