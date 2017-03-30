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

A release branch should be created for each new Mesos and Spark combination.  Changes and updates should be committed directly to these release branches. Docker images should be rebuilt and pushed from them as well.

Versioning example: for Mesos 1.1.1 and Spark 2.1.0, the Mesos-Spark
release branch should be named ```releases/1.1.1-2.1.0```, and the Docker image should be tagged ```1.1.1-2.1.0```.

## MesosClusterDispatcher
The MesosClusterDispatcher is a Spark component that is used to run Spark on Mesos in cluster mode.  

It listens on port 7077 and 8081 and serves as the master when running ```spark-submit```.  

The Mesos-Spark image can run the MesosClusterDispatcher as all required dependencies are included in the image.

Please see http://spark.apache.org/docs/latest/running-on-mesos.html for more information.

### Configuring
Environment variables are used to configure the MesosClusterDispatcher. These are all required.

| Variable        | Example Value  |
| ------------- | ------------- |
| MESOS_MASTER   | mesos://mesos-master-host:5050 |
| ZOOKEEPER      | zookeeper-host:2181 |
| FRAMEWORK_NAME | TestSparkCluster |

### Running
An entrypoint script has been created and is available at ```/opt/spark/dist/sbin/dispatcher-entry-point.sh```.  The work directory for this image is set to ```/opt/spark/dist``` so an entrypoint need only reference ```sbin/dispatcher-entry-point.sh```.  All logging output is available at stdout.

Example:
```ENTRYPOINT ["sbin/dispatcher-entry-point.sh"]```

```
$ docker run -e MESOS_MASTER=mesos://mesos-master:5050 \
             -e ZOOKEEPER=zookeeper:2181 \
             -e FRAMEWORK_NAME=TestSparkCluster \
             --entrypoint sbin/dispatcher-entry-point.sh \
             --network lcmapservices_lcmap \
             -it usgseros/mesos-spark
```
