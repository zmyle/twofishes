# Dockerized Twofishes

This is a dockerized version of [Twofishes](https://github.com/foursquare/fsqio/tree/master/src/jvm/io/fsq/twofishes).

Twofishes is a coarse, splitting geocoder and reverse geocoder in scala; built and maintained by Foursquare.

Coarse means its geo-indices do NOT include full address data but merely data about neighborhoods, cities, counties and up. It is highly optimized for coarse geocoding and thus makes it the perfect tool for your searches for cities, counties, etc.. You can for example translate something like 'Berlin' into lat/long coordinates and then search your database for the K nearest neighbors. It also provides autocomplete endpoints which you can use to suggest cities to users as they type.


# start a twofishes instance

```
docker run -d -p 8080:8080 -p 8081:8081 --name twofishes zmyle/twofishes
```

NOTE: this image will download and unzip the revgeo index on the first run (~1.6GB). Therefore, the first startup of this image might take a bit longer.

## use a different version/index

```
docker run -d -p 8080:8080 -p 8081:8081 --name twofishes \
  -e "TWOFISHES_BINARY_URL=https://s3.amazonaws.com/twofishes-data/binaries/server-assembly-0.84.9.jar" \
  -e "TWOFISHES_DATAINDEX_URL=https://s3.amazonaws.com/twofishes-data/indexes/2015-03-05.tar.gz" \
  zmyle/twofishes
```
This will download and install the binary at https://s3.amazonaws.com/twofishes-data/binaries/server-assembly-0.84.9.jar and as well as download and install the prebuilt revgeo index from https://s3.amazonaws.com/twofishes-data/indexes/2015-03-05.tar.gz.

## jvm settings

Twofishes consumes a bit under 2GB of memory for the full index. The jvm in this image runs with those settings by default: [Dockerfile JVM Options](https://github.com/zmyle/twofishes/blob/master/Dockerfile#L11). We recommend running it with at least 6G when you run it for real:

```
docker run -d -p 8080:8080 -p 8081:8081 -e "TWOFISHES_JAVA_OPTS=-Xmx6g -Xms6g" --name twofishes zmyle/twofishes
```

# env options

| ENV | What? | Default |
| --- | ----- | ------- |
| TWOFISHES_BINARY_URL | A fqdn of a prebuilt twofishes binary; must be downloadable from within the docker container. | https://s3.amazonaws.com/twofishes-data/binaries/server-assembly-0.84.9.jar |
| TWOFISHES_DATAINDEX_URL | A fqdn of a tar archive that contains a prebuilt twofishes revgeo index; must be downloadable from within the docker container | https://s3.amazonaws.com/twofishes-data/indexes/2015-03-05.tar.gz |
| TWOFISHES_JAVA_OPTS | Java options that get passed to the twofishes java-process | -Xmx2g -Xms2g |

See also: [Dockerfile](https://github.com/zmyle/twofishes/blob/master/Dockerfile)

# docker compose

There's a [compose file](https://github.com/zmyle/twofishes/blob/master/composefile.yml) ready for you to use.

# data

The twofishes website (twofishes.net) that provides prebuilt binaries and indicies has been down for several months now. We are starting to host data in S3. Here's an overview of available binaries and indicies:

## binaries

* [0.84.9](https://s3.amazonaws.com/twofishes-data/binaries/server-assembly-0.84.9.jar)

## indicies

* [2015-03-05](https://s3.amazonaws.com/twofishes-data/indexes/2015-03-05.tar.gz)

