#  Laravel 2 Docker to Development (Apple Silicon)

### Traefik + Nginx + Redis + PHP-FPM + MySQL + XDebug + Mailpit + RabbitMQ + OpenSearch + Varnish

The docker stack is composed of the following containers

| Name                 | Version |
|----------------------|---------|
| traefik              | 3.2     |
| nginx                | 1.27    |
| php-fpm              | 8.2     |
| php-fpm-xdebug       | 3.2.2   |
| redis                | 7.4     |
| mysql                | 8.4.3   |
| mailpit              | 1.21    |
| rabbitmq             | 4.0.4   |
| opensearch           | 2.18    |
| opensearch-dashboard | 2.18    |
| varnish              | 7.6     |

### Container traefik
Starts a reverse proxy and load balancer for project<br>
Opens local port: `80`, `443`

### Container nginx
Builds from the nginx folder. <br>
Mounts the folder laravel from the project main folder into the container volume `/home/laravel`.<br>

### Container php-fpm
Builds from the php-fpm folder.<br>
Mounts the folder laravel from the project main folder into the container volume `/home/laravel`.<br>
This container includes all dependencies for Laravel.<br>

### Container php-fpm-xdebug
Builds from the php-fpm-xdebug folder.<br>
Mounts the folder laravel from the project main folder into the container volume `/home/laravel`.<br>
This container includes all dependencies for Laravel (also contain xDebug).<br>

### Container redis:
Starts a redis container.<br>

### Container mysql:
Please change or set the mysql environment variables
    
    MYSQL_DATABASE: 'xxxx'
    MYSQL_ROOT_PASSWORD: 'xxxx'
    MYSQL_USER: 'xxxx'
    MYSQL_PASSWORD: 'xxxx'
    MYSQL_ALLOW_EMPTY_PASSWORD: 'xxxxx'

Default values:

    MYSQL_DATABASE: 'laravel'
    MYSQL_ROOT_PASSWORD: 'root_pass'
    MYSQL_USER: 'laravel_user'
    MYSQL_PASSWORD: 'PASSWD#'
    MYSQL_ALLOW_EMPTY_PASSWORD: 'false'

Opens up port: `3306`

Note: On your host, port 3306 might already be in use. So before running docker-compose.yml, under the docker-compose.yml's mysql section change the host's port number to something other than 3306, select any as long as that port is not already being used locally on your machine.

### Container mailpit:
Starts a mailpit container.<br>
Opens up port: `8025`

### Container rabbitmq:
Starts a rabbitmq container.<br>
Opens up port: `15672`

### Container opensearch:
Starts an opensearch container.<br>

### Container opensearch-dashboard:
Starts an opensearch dashboard container.<br>
Opens up port: `5601`

### Container varnish:
Builds from the varnish folder.
Starts a varnish container.<br>
Opens up port: `6081`

## Setup
Copy your `.env.sample` to `.env` file in root folder, and change `PROJECT_NAME` and `PROJECT_VIRTUAL_HOST`:<br>
`PROJECT_NAME` - help you to create simple and clear container names.<br>
`PROJECT_VIRTUAL_HOST` - it is your main url address.<br>

For example:

    PROJECT_NAME=laravel
    PROJECT_VIRTUAL_HOST=laravel.test

Edit your `/etc/hosts` and add next line:<br>
`127.0.0.1 laravel.test traefik.laravel.test mail.laravel.test search.laravel.test dashboard.laravel.test rabbit.laravel.test`<br>

To start/build the stack.<br>
Use - `docker-compose up` or `docker-compose up -d` to run the container on detached mode.<br>
Compose will take some time to execute.<br>
After the build has finished you can press the ctrl+c and docker-compose stop all containers.

## Installing Laravel
To the run installation process use next commands.<br>
Create and install new project:

    ./scripts/composer global require laravel/installer
    ./scripts/composer create-project laravel/laravel .
    ./scripts/npm install
    ./scripts/npm run build
    ./scripts/php artisan key:generate
    ./scripts/php artisan migrate

## Setting up Laravel
To access the laravel homepage, go to the following url: https://laravel.test<br>

## How to use xDebug
You could enable or disable xDebug with the next command: `./scripts/switch_mode [fpm|xdebug]`<br>
`fpm` - Enable container without xDebug <br>
`xdebug` - Enable container with xDebug <br>


Also, you can open:<br>
https://traefik.laravel.test - **Traefik Dashboard** (traefik/traefik123 for access)<br>
https://mail.laravel.test - **Mailpit**<br>
https://search.laravel.test - **OpenSearch**<br>
https://dashboard.laravel.test - **OpenSearch Dashboard**<br>
https://rabbit.laravel.test - **RabbitMQ** (guest/guest for access)<br>

## Feature Updates
- v1.0.0 - Initial release

## Branches
| Name | Laravel |
|------|---------|
| main | 11.x    |