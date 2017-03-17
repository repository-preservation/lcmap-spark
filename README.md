# lcmap-spark
## Features
- Creates and publishes a Docker image for use as an Apache Spark Executor within Apache Mesos
- Creates and publishes a Docker image to host the Mesos Cluster Dispatcher

## Releases
- Release branches are maintained for each version of the Dockerfiles that are published while master is always the latest. 
- Version number correspond to Apache Spark releases. 
- Images are published to Docker Hub under the usgseros organization.

## Mesos Cluster Dispatcher
Build and push.
```
make build-cluster-dispatcher
make push-cluster-dispatcher

# builds and pushes
make cluster-dispatcher
```

Configure
## LCMAP Spark Executor
Build and push.
```
make build-spark-executor
make push-spark-executor

# builds and pushes
make spark-executor
```

Additional Documentation forthcoming.
