Modes
=====

Local Mode
----------

Cluster Mode
------------

https://spark.apache.org/docs/latest/cluster-overview.html

Cluster mode uses Apache Mesos as a cluster  manager for Spark, which allows Spark to run functions in parallel across many physical hosts.

In order to run a cluster based instance of lcmap-spark, you must have the ability to run a Docker container locally, and you must have network access to a Mesos Master, ideally over a 10 Gigabit or greater network.  

Connecting to Mesos
Requesting Resources
Running Spark Jobs
Resource Allocation Lifecycle
Releasing Resources

When connecting to Mesos the same local Docker image is automatically downloaded onto the Mesos nodes (from hub.docker.com) and used as the execution environment for application code.  This provides a consistent and reliable way to develop, deploy and run Spark applications and all their necessary dependencies.

Running lcmap-spark on a standalone cluster or on Yarn have not been tested.


Local Mode
--------------------
The only requirement for running a local instance of lcmap-spark is the ability to start a Docker container.

.. code-block:: bash
   
   docker run -it --rm --net=host -u=`id -u` usgseros/lcmap-spark:latest \
          pyspark --master local[*] \
                  --total-executor-cores 4 \
                  --driver-memory 1024m \
                  --executor-memory 1024m \
                  --conf spark.app.name=$USER \
                  --conf spark.driver.host=$HOSTNAME
 

Mesos
-----
The official Spark on Mesos documentation is `here <https://spark.apache.org/docs/latest/running-on-mesos.html>`_

When running on Mesos, Spark also provides two modes: (1) Client Mode (2) Cluster Mode.

``lcmap-spark`` targets (1) Client Mode using the Docker containerizer.

Mesos based runtime configuration and instructions.

Mesos client vs cluster mode.

SSL Certificates for Authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The following three files must be present in the image ``/certs`` directory.  They can be obtained from
Mesos admins.

* mesos.crt
* mesos.key
* trustedroot.crt

Mount a volume at runtime as including them in a published image constitutes a security violation.

.. code-block:: bash

    docker run <flags> --volume=/home/user/certs:/certs usgseros/lcmap-spark <command>

Example
~~~~~~~

.. code-block:: bash

    <insert example>
