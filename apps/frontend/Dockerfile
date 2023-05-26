FROM nginx:alpine
EXPOSE 8080
RUN mkdir -p /usr/share/nginx/html/
COPY build/ /usr/share/nginx/html/
COPY nginx_default.conf /etc/nginx/templates/default.conf.template