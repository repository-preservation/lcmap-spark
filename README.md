# lcmap-spark
LCMAP SEE Spark base image.

## Features
* Run Spark locally or on Mesos
* Interactive development and analysis via Jupyter Notebooks
* Connect to Apache Cassandra with the Spark-Cassandra Connector and DataFrames
* Includes Spark 2.2, JDK 1.8, Python 3.6 and MKL-enabled Numpy 

## Building
```
# Build the image
make

# Push the image to Dockerhub
make push
```
## Running
Running the LCMAP SEE Notebook server is a piece of cake.  Just run this command with these three thousand flags:

```
$ docker run --user `id -u` \
             --publish-all \
             --network host \
             --pid host \
             -v /path/to/your/notebooks:/home/lcmap/notebook/yours \
             usgseros/lcmap-spark:latest \
             jupyter --ip=$HOSTNAME notebook --allow-root
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
