# lcmap-spark
Creates and publishes a Docker image to host the Mesos Cluster Dispatcher.


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


## Configuration
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
             --network lcmapservices_lcmap \
             -it usgseros/mesos-cluster-dispatcher
```

## Developing and Releasing
Releases for Mesos Cluster Dispatcher are handled via release branches.  

For each new version of the image to be released, a new release branch should
be created and the Dockerfile & Makefile, etc should be updated with the desired
changes.  Any additional bug fixes should be committed against the appropriate
release branch.  

Release branch versions corresponds to the Mesos version and Spark version
which are included.

Example, for Mesos 1.1.1 and Spark 2.1.0, the Mesos Cluster Dispatcher
release branch is named releases/1.1.1-2.1.0, and the Docker image is tagged
as such.
