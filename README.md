# start a twofishes instance

```
docker run -d -p 8080:8080 -p 8081:8081 --name twofishes zmyle/twofishes
```

NOTE: this image will download and unzip the revgeo index on the first run (~1.6GB). Therefore, the first startup of this image might take a bit longer.

## use a different version/index

```
docker run -d -p 8080:8080 -p 8081:8081 -e "TWOFISHES_JAVA_OPTS=-Xmx3g -Xms2g" -e "TWOFISHES_VERSION=0.84.9" -e "TWOFISHES_DATAINDEX_VERSION=2015-03-05" --name twofishes zmyle/twofishes
```
This will download http://twofishes.net/binaries/server-assembly-0.84.9 as the server binary and http://twofishes.net/indexes/revgeo/2015-03-05.zip as the prebuilt index.

## jvm settings

In our environments, twofishes consumes a bit under 2GB of memory for the full index. The jvm in this image runs with those settings by default: [Dockerfile JVM Options](https://github.com/zmyle/twofishes/blob/master/Dockerfile#L11), but we run it with at least 3G when we run it for real:

docker run -d -p 8080:8080 -p 8081:8081 -e "TWOFISHES_JAVA_OPTS=-Xmx3g -Xms2g" --name twofishes zmyle/twofishes

# docker compose

Theres a [compose file](https://github.com/zmyle/twofishes/blob/master/composefile.yml) ready for you to use.
