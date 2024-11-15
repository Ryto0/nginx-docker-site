FROM nginx:latest

# Копируем ваш HTML-код в директорию NGINX
COPY html /usr/share/nginx/html
