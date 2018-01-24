# lcmap-spark
Creates and publishes a Docker image for running Spark standalone or Spark on Mesos.


## Building
```
# Build the image
make

# Push the image to Dockerhub
make push
```

## Developing [WIP]
Releases for LCMAP Spark are handled via release branches.  

A release branch should be created for each new Mesos and Spark combination.  Changes and updates should be committed directly to these release branches. Docker images should be rebuilt and pushed from them as well.

Versioning example: for Mesos 1.1.1 and Spark 2.1.0, the Mesos-Spark
release branch should be named ```releases/1.1.1-2.1.0```, and the Docker image should be tagged ```1.1.1-2.1.0```.

## Compatibility [WIP]
* jdk 1.8
* python 3.6
* mesos 1.4
* spark-cassandra connector 

## Notebooks [WIP]
* Use example notebooks
* Install custom notebooks

## Example Notebooks [WIP]
* get spark context & perform simple operation
* python, java, clojure

## Open questions [WIP]
* does Python and Miniconda belong in this image or a derivative
* does Clojure belong in this image or a derivative

## Certs for Mesos Authentication [WIP]
* must be located on host machine and mounted as filesystem into image
*/certs/mesos.crt
*/certs/mesos.key
*/certs/TrustedRoot.crt
