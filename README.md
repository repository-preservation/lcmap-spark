# lcmap-mesos-spark
Creates and publishes a Docker image for running Spark standalone or Spark on Mesos.


## Building
```
# Pull down and unpack spark
make init

# Build the image
make

# Push the image to Dockerhub
make push

# Init, build and push all in one step.
make all
```

## Developing and Releasing
Releases for LCMAP Mesos Spark are handled via release branches.  

A release branch should be created for each new version.  Changes and updates
should be committed directly to the release branches.

Release branch versions correspond to the Mesos and Spark version which are
in the image.

Example, for Mesos 1.1.1 and Spark 2.1.0, the Mesos-Spark
release branch is named ```releases/1.1.1-2.1.0```, and the Docker image is
tagged ```1.1.1-2.1.0```.


## Configuring and Running the MesosClusterDispatcher

Entrypoint to be used:
```ENTRYPOINT ["sbin/dispatcher-entry-point.sh"]```

Environment variables are used to configure the Mesos Cluster Dispatcher image.

| Variable        | Example Value  |
| ------------- | ------------- |
| MESOS_MASTER   | mesos://localhost:5050 |
| ZOOKEEPER      | 127.0.0.1:2181 |
| FRAMEWORK_NAME | TestSparkCluster |


## Running
```
$ docker run -e MESOS_MASTER=mesos://mesos-master:5050 \
             -e ZOOKEEPER=zookeeper:2181 \
             -e FRAMEWORK_NAME=TestSparkCluster \
             --entrypoint sbin/dispatcher-entry-point.sh \
             --network lcmapservices_lcmap \
             -it usgseros/mesos-cluster-dispatcher
```
