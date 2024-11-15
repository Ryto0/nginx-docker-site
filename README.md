Да, работа выполнена на моей ВМ, и я сделал простой сайт с какой-то там защитой, но по-другому я не понял и не разобрался с VK Cloud. Этот проект демонстрирует, как создать публичный сайт с использованием Docker и NGINX, а также защитить его с помощью NGINX и брандмауэра UFW. Мы также используем Ansible для автоматизации настройки и развёртывания. 

Содержание
Описание проекта
Шаги настройки
1. Настройка Docker-контейнера с NGINX
2. Настройка безопасности в NGINX
3. Настройка брандмауэра UFW
Использование Ansible

Шаги настройки
1. Настройка Docker-контейнера с NGINX
Мы создали Docker-контейнер для NGINX с монтированием папки, содержащей файлы сайта, и пробросом порта:

Команда запуска контейнера:
bash

`docker run -d --name nginx-container -p 80:80 -v /path/to/your/site:/usr/share/nginx/html my-nginx-site`
Описание: Контейнер запускается и обслуживает сайт по порту 80.
2. Настройка безопасности в NGINX
Мы добавили заголовки безопасности в конфигурацию NGINX для защиты от XSS и других атак:

Файл конфигурации: nginx.conf
Добавленные заголовки:
nginx

`add_header X-Frame-Options "SAMEORIGIN";
add_header X-Content-Type-Options "nosniff";
add_header X-XSS-Protection "1; mode=block";`
Файл был сохранён в папке: nginx-security/nginx.conf
Мы также ограничили разрешённые HTTP-методы, чтобы уменьшить вероятность атак:

Файл конфигурации: default.conf
Ограничение методов:
nginx

    `server {
        listen 80 default_server;
        root /usr/share/nginx/html;
        index index.html;
    
        if ($request_method !~ ^(GET|HEAD|POST)$ ) {
            return 405;
        }
        
        location / {
            try_files $uri $uri/ =404;
        }
    }`
Файл был сохранён в папке: nginx-config/default.conf
3. Настройка брандмауэра UFW
Мы включили UFW и открыли только необходимые порты:

Команды:
bash

`sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw enable`
Описание: Только HTTP и SSH трафик разрешён, всё остальное блокируется.
Использование Ansible
Мы автоматизировали настройку серверной инфраструктуры с помощью Ansible. В плейбуке Ansible были выполнены следующие задачи:

Обновление пакетов
Установка утилит
Настройка NGINX
Конфигурация UFW
Как запустить проект

