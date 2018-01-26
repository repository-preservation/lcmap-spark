# lcmap-spark
LCMAP SEE Spark base image.

## Features
* Run Spark locally or on Mesos
* Interactive development and analysis via Jupyter Notebooks
* Connect to Apache Cassandra with the Spark-Cassandra Connector and DataFrames
* Includes Spark 2.2, JDK 1.8, Python 3.6 and MKL-enabled Numpy 

## Running

```
# Run the Jupyter Notebook server
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

## SSL Certificates for Mesos Authentication
The following three files must be present in the image /certs directory.  They can be obtained from
Mesos admins.
* mesos.crt
* mesos.key
* trustedroot.crt

Mount a volume at runtime as including them in a published image constitutes a security violation.

#### Example
Assume the files exist at ```/home/user/certs``` on the host machine.

``` docker run <flags> --volume=/home/user/certs:/certs usgseros/lcmap-spark <command>```