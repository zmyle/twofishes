# start a twofishes instance

```
docker run -d -p 8080:8080 -p 8081:8081 --name twofishes zmyle/twofishes
```

## JVM settings

In our environments, twofishes consumes a bit under 2GB of memory for the full index. The jvm in this image runs with those settings by default: [Dockerfile JVM Options](./Dockerfile#L11), but we run it with at least 3G when we run it for real:

docker run -d -p 8080:8080 -p 8081:8081 -e "TWOFISHES_JAVA_OPTS=-Xmx3g -Xms2g" --name twofishes zmyle/twofishes

# docker compose

Theres a [compose file](composefile.yml) ready for you to use.
