# openig-docker-sample

OpenIG with Docker Sample

* Jetty v8.2.0.v20160908
  * (OpenIG 4.0.0 needs Jetty v7.x or v8.x)

## Usage

### 1. [Download "openig-war-4.0.0.war"](https://backstage.forgerock.com/downloads/OpenIG) 

Put into `war/` directory.

```
$ cd openig-docker
$ ls war/
openig-war-4.0.0.war
```

### 2. Build 

```
$ docker build --rm -t myig-image .
```

### 3. Run

e.g.  [http://openig.docker.test:28082/](http://openig.docker.test:28082/)

```
$ docker run --name myig -h "openig.docker.test" -p 28082:8080 -it myig-image:latest
```

(docker-compose.yml)

```
version: '3'

services:
  openig:
    build:
      context: openig
      dockerfile: Dockerfile
    hostname: 'openig.docker.test'
    ports:
      - 28082:8080
    volumes:
      - ./.data/openig:/openig
```
