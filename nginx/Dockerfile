FROM arm64v8/nginx:1.27

RUN groupadd -g 2000 laravel \
    && useradd -d /home/laravel -u 2000 -g 2000 laravel

COPY ./default.conf /etc/nginx/conf.d/default.conf
