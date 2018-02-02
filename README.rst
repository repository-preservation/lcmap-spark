============
lcmap-spark
============
LCMAP SEE Spark base image.


Features
--------
* Run `Spark <https://spark.apache.org/docs/latest/>`_  locally or on `Mesos <https://mesos.apache.org/>`_
* Interactive development and analysis via `Jupyter Notebooks <https://jupyter.org/>`_
* Connect to `Apache Cassandra <https://cassandra.apache.org/>`_ with the `Spark-Cassandra Connector <https://github.com/datastax/spark-cassandra-connector/>`_ and `DataFrames <https://spark.apache.org/docs/latest/sql-programming-guide.html>`_
* Includes Spark 2.2, JDK 1.8, Python 3.6 and MKL-enabled Numpy 

Example
-------

.. code-block:: bash

    docker run -it \
               --rm \
               --user=`id -u` \
               --network=host \
               --pid=host \
               usgseros/lcmap-spark:latest \
               pyspark

Documentation
-------------

* `Overview <docs/overview.rst/>`_
* `Running <docs/running.rst/>`_
* `Configuration <docs/configuration.rst/>`_
* `Applications <docs/applications.rst/>`_
* `Building <docs/building.rst/>`_

Requirements
------------

* Docker
* Network access to Mesos Master (optional)
* Mesos username (optional)
* Mesos role (optional)
* Mesos password (optional)
* Mesos certificates (optional)
                       
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
