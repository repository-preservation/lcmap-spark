# lcmap-spark
LCMAP SEE Spark base image.

## Features
* Run Spark locally or on Mesos
* Interactive development and analysis via Jupyter Notebooks
* Connect to Apache Cassandra with the Spark-Cassandra Connector and DataFrames
* Includes Spark 2.2, JDK 1.8, Python 3.6 and MKL-enabled Numpy 

## Running

```
# Run the Jupyter Notebook server then follow the instructions in the console

docker run -it \
           --rm \
           --user=`id -u` \
           --network=host \
           --pid=host \
           --volume=/path/to/your/notebooks/:/home/lcmap/notebook/yours \
           usgseros/lcmap-spark:latest \
           jupyter --ip=$HOSTNAME notebook


# Run the PySpark shell

docker run -it \
           --rm \
           --user=`id -u` \
           --network=host \
           --pid=host \
           usgseros/lcmap-spark:latest \
           pyspark


# Run spark-submit

docker run -it \
           --rm \
           --user=`id -u` \
           --network=host \
           --pid=host \
           usgseros/lcmap-spark:latest \
           spark-submit
```

## Building
```
# Build the image
make

# Push the image to Dockerhub
make push
```

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
* WARNING: Do not copy keys into a derivative Docker image, as this is a security violation.  Add the keys at runtime only
* must be located on host machine and mounted as filesystem into image
* /certs/mesos.crt
* /certs/mesos.key
* /certs/TrustedRoot.crt
