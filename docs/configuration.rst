Modes
=====

Local Mode
--------------------
The only requirement for running a local instance of lcmap-spark is the ability to start a Docker container.  The docker image must be built and available on the machine docker is run from but does not need to be published to https://hub.docker.com.

pyspark
~~~~~~~

.. code-block:: bash
   
   docker run -it --rm --net host -u `id -u` usgseros/lcmap-spark:latest \
          pyspark --master local[*] \
                  --total-executor-cores 4 \
                  --driver-memory 1024m \
                  --executor-memory 1024m \
                  --conf spark.app.name=$USER \
                  --conf spark.driver.host=$HOSTNAME

spark-shell
~~~~~~~~~~~

.. code-block:: bash
   
   docker run -it --rm --net host -u `id -u` usgseros/lcmap-spark:latest \
          spark-shell --master local[*] \
                      --total-executor-cores 4 \
                      --driver-memory 1024m \
                      --executor-memory 1024m \
                      --conf spark.app.name=$USER \
                      --conf spark.driver.host=$HOSTNAME

spark-submit
~~~~~~~~~~~~
Assume Python job module is in ```/home/user/jobs/job.py```.

.. code-block:: python

   import pyspark

   def run():
       sc = pyspark.SparkContext()
       rdd = sc.parallelize(range(3))
       print("Sum of range(3) is:{}".format(rdd.sum()))
       sc.close()

   if __name__ == '__main__':
       run()

.. code-block:: bash

   docker run -it --rm --net host -u `id -u` usgseros/lcmap-spark:latest \
              -v /home/user/jobs:/home/lcmap/jobs \
          spark-submit --master local[*] \
                       --total-executor-cores 4 \
                       --driver-memory 1024m \
                       --executor-memory 1024m \
                       --conf spark.app.name=$USER\
                       --conf spark.driver.host=$HOSTNAME \
                       jobs/job.py

Job files, in this case ``job.py``, must be accessible inside the Docker image.

In this simple case a Docker volume mount was used to place ``job.py`` onto the Docker filesystem.

This works well for development and testing in ``local`` mode, but in ``cluster`` mode the job files must be
built into the image.
                       
notebook
~~~~~~~~
Setting Spark configuration values via the ``--conf`` flag works for ``pyspark`` and ``spark-submit``.  When running ``notebook`` however, these values must be specified when creating the SparkContext through code.

If you wish to pass these values in from the host machine at runtime, consider setting them as environment variables using the ``-e`` Docker flag and then accessing them through ``os.environ`` in your notebook.

Notebooks may be persisted on the host filesystem and loaded at runtime into Docker, keeping notebook management and version control outside of lcmap-spark.

Be sure to include the ``-u `id -u` `` flag so file permissions translate properly between the host system user and the Docker container user.

.. code-block:: bash

   docker run -it --rm --net host -u `id -u` usgseros/lcmap-spark:latest \
              -v /home/user/notebooks/demo:/home/lcmap/notebook/demo \
              jupyter --ip=$HOSTNAME notebook


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
