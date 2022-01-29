# PHP/Symfony docker scaffolding

El proyecto contiene todo lo necesario para empezar a crear una aplicación con PHP/Symonfy 5.4 y docker. Adicionalmente, se usará un servidor reverso como Nginx y una base de datos MySQL. Podrá instalar librerías adicionales.

## Uso

Para poder utilizarlo, tan solo tendrás que clonar el proyecto desde Github. Posteriormente, te recomiendo borrar la información de git y volverlo a inicializar. Así se desvinculará el historial de git de ESTE proyecto y podrás inicializar el tuyo.

```shell
git clone https://github.com/junisan/php-symfony-docker-scaffolding.git [new-name]
cd [new-name]
#Lanzar el proyecto en desarrollo
docker-compose up
#Lanzar el proyecto en producción
docker-compose -f docker-compose.prod.yml

# Adicionalmente, elimina el git de este proyecto y comienza el tuyo
rm -rf .git
git init
```

## Configuración

El proyecto no está personalizado para un proyecto en concreto, así que tendrás que personalizarlo en base a tus necesidades: nombres de dominio y configuraciones propias. A continuación te resumo los cambios más importantes.

### MySQL

Deberás indicar los credenciales de la base de datos y ajustarlo según tu necesidad. 

```shell
MYSQL_DATABASE=dbname
MYSQL_ROOT_PASSWORD=secretpass
MYSQL_USER=user
MYSQL_PASSWORD=pass
```

Posteriormente, ajusta el DSN de la base de datos en el fichero de Symfony, para que este se pueda conectar:

```env
DATABASE_URL="mysql://db_user:db_password@mysql:3306/db_name?serverVersion=5.7"
```

Adicionalmente, el fichero entrypoint.sh de PHP, leerá esta variable. Si la detecta, no arrancará el proceso de php-fpm hasta que sea capaz de establecer comunicación.

### Nginx

Deberás configurar los ficheros de configuración de nginx en base a tus necesidades, generalmente en base al dominio de tu proyecto. Edita el fichero de desarrollo y de producción del dominio, ubicados en /docker/nginx/conf.d. Ajusta el nombre de dominio (actualmente escucha todos) y las opciones del proxy.

Adicionalmente, ajusta el CORS si necesitas hacer llamadas asíncronas desde el cliente. Ajusta los nombres de dominio (u orígenes) que permitas conectar con ajax en el fichero /docker/nginx/snippets/cors_sites.conf. Recuerda que este fichero contiene expresiones regulares, por lo que deberás respetar el formato.

### PHP

A lo largo del proceso de desarrollo, seguramente necesites instalar nuevas extensiones de PHP, como librerías de gráficos o capacidades de compresión con zip. Para ello, edita el fichero Dockerfile, ubicado en la raíz del proyecto. Ahí deberás añadir la instalación y configuración de las librerías. Busca la frase "If you need extensions, add them here...".

Las configuraciones de php.ini dependen del entorno. Generalmente no deberás tocarlas, pero si necesitas hacer ajustes en base al entorno, edita los ficheros php.dev.ini y php.prod.ini.

### Docker Compose

En este fichero deberás (siempre que quieras) personalizar los nombres de los servicios, redes y volúmenes que usará docker. Ajusta los nombres o puertos, o en definitiva lo que necesites.

Ten en cuenta que existen 2 ficheros de docker-compose: el fichero docker-compose.yml (configuración del entorno de desarrollo, como volúmenes en tiempo real del código) y docker-compose.prod.yml (que contiene las definiciones exclusivas para producción.) Haga los ajustes que necesite.

> El fichero de docker-compose.prod.yml no está preparado para producción realmente. El uso de bases de datos sobre contenedores está cuestionado. Deberá adaptarlo para usar su propia infraestructura.
