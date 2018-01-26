lcmap-spark
===========
LCMAP SEE Spark base image.

Features
--------
* Run `Spark <https://spark.apache.org/docs/latest/>`_  locally or on `Mesos <https://mesos.apache.org/>`_
* Interactive development and analysis via `Jupyter Notebooks <https://jupyter.org/>`_
* Connect to `Apache Cassandra <https://cassandra.apache.org/>`_ with the `Spark-Cassandra Connector <https://github.com/datastax/spark-cassandra-connector/>`_ and `DataFrames <https://spark.apache.org/docs/latest/sql-programming-guide.html>`_
* Includes Spark 2.2, JDK 1.8, Python 3.6 and MKL-enabled Numpy 

Running
-------

.. code-block:: bash

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

Building
--------

.. code-block:: bash
                
    # Build the image
    make

    # Push the image to Dockerhub
    make push

Notebooks [WIP]
---------------
* Use example notebooks
* Install custom notebooks

Example Notebooks [WIP]
-----------------------
* get spark context & perform simple operation
* python, java, clojure

SSL Certificates for Mesos Authentication
-----------------------------------------
The following three files must be present in the image /certs directory.  They can be obtained from
Mesos admins.

* mesos.crt
* mesos.key
* trustedroot.crt

Mount a volume at runtime as including them in a published image constitutes a security violation.  Assuming the files exist at ``/home/user/certs`` on the host machine.

.. code-block:: bash

    docker run <flags> --volume=/home/user/certs:/certs usgseros/lcmap-spark <command>

Versioning
----------
lcmap-spark follows semantic versioning: http://semver.org/

License
-------
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to http://unlicense.org.
