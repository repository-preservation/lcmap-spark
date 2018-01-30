lcmap-spark  - WIP
==================

A simple, portable environment for executing science models and performing exploratory analysis at scale.

What is Spark?
--------------
`From the website <https://spark.apache.org/>`_, Apache Spark is a fast and general engine for large scale data processing.  It can run on a laptop or on thousands of machines, processes data too big to fit in memory, and moves functions to data rather than data to functions.

Spark has connectors to many data sources, offers interactive development and is open source.

Read more about Spark: https://spark.apache.org.

What is LCMAP-Spark?
--------------------
lcmap-spark is a ready to go Docker base image for the LCMAP Science Execution Environment.

It contains Apache Spark, the Spark-Cassandra Connector and a Jupyter Notebook server to quickly allow science developers to get up and running on the LCMAP SEE.

A base set of Python libraries are already installed for creating time series data out of LCMAP Information Warehouse and Datastore Analysis Ready Data.  Conda is configured and available for installing additional packages.

Applications can be developed on a laptop using lcmap-spark and when they are ready for prime time, published and run at scale through simple configuration values: No code changes are necessary.

lcmap-spark targets and is tested against Apache Mesos for distributed computing.

Anatomy of A Spark Job
----------------------
1. Create Spark Cluster
2. Load and partition input data
3. Construct execution graph
4. Save calculation results
5. Shut down Spark Cluster

.. code-block:: python

   # Assumes read_timeseries_data, calculate_change_detection and save_to_cassandra
   # exist elsewhere in your codebase... they are not part of Spark.

   import pyspark

   # create Spark cluster
   sc = pyspark.SparkContext()

   # load and partition input data (10 partitions)
   rdd1 = sc.parallelize(read_timeseries_data(), 10)

   # construct execution graph
   rdd2 = rdd1.map(calculate_change_detection)

   # save calculation results
   save_to_cassandra(rdd2)

   # shut down Spark cluster
   sc.close()

Apache Spark builds a directed acyclic graph of functions to be applied against the input data and only begins executing these functions when an action, such as saving data to Cassandra, is performed.

The fundamental data structure used is a Resilient Distributed Dataset, which is a `"collection of elements partitioned across the nodes of the cluster that can be operated on in parallel." <https://spark.apache.org/docs/latest/rdd-programming-guide.html>`_.

The `laziness <https://en.wikipedia.org/wiki/Lazy_evaluation>`_ of RDDs is key, as it allows Spark to avoid realizing the full dataset at once.  This means datasets much larger than available physical memory may be operated on.

Running A Spark Job
-------------------
Spark jobs may be executed from a Jupyter Notebook, a Spark shell, or from the command line.

* ``spark-submit`` runs Spark jobs from a command line
* ``spark-shell`` is a Scala shell
* ``pyspark`` is a Python shell
* ``notebook`` is a Jupyter Notebook server

See https://spark.apache.org/docs/latest/quick-start.html and https://jupyter.org for more information.

.. code-block:: bash

    # Run any job from the command line
    docker run -it \
               --rm \
               --user=`id -u` \
               --network=host \
               --pid=host \
               usgseros/lcmap-spark:latest \
               spark-submit your_spark_job.py

    # Run Scala jobs interactively from the Scala shell
    docker run -it \
               --rm \
               --user=`id -u` \
               --network=host \
               --pid=host \
               usgseros/lcmap-spark:latest \
               spark-shell

    # Run Python jobs interactively from the PySpark shell
    docker run -it \
               --rm \
               --user=`id -u` \
               --network=host \
               --pid=host \
               usgseros/lcmap-spark:latest \
               pyspark

    # Run any job interactively from the Jupyter Notebook server
    docker run -it \
               --rm \
               --user=`id -u` \
               --network=host \
               --pid=host \
               --volume=/path/to/your/notebooks/:/home/lcmap/notebook/yours \
               usgseros/lcmap-spark:latest \
               jupyter --ip=$HOSTNAME notebook

               
Shippable Artifacts
-------------------
The shippable artifact for lcmap-spark is a Docker image published to https://hub.docker.com/r/usgseros/lcmap-spark/.

* Contains all code and libraries necessary to connect to LCMAP SEE
* Provides a consistent, immutable execution environment
* Is a base image, suitable for exploratory analysis or as starting points for derivative images

LCMAP SEE applications are independent software projects, publishing their own Docker images derived from lcmap-spark.


Modes
-----
There are two modes for lcmap-spark: ``distributed`` and ``non-distributed``.

* ``distributed`` mode takes advantage of Apache Mesos as a resource manager, which allows Spark to run functions in parallel across many physical hosts.
* ``non-distributed`` mode runs the Spark application on the local host system only, but is able to use all the available CPU cores and memory on that host.
* Switching modes is achieved by setting parameters during cluster creation

See httpsmodes for configuring distributed and non-distributed 
  
               
Distributed Mode
----------------
Distributed mode uses Apache Mesos as a resource manager for Spark, which allows Spark to run functions in parallel across many physical hosts.

In order to run a distributed instance of lcmap-spark, you must have the ability to run a Docker container locally, and you must have network access to a Mesos Master, ideally over a 10 Gigabit or greater network.  

Connecting to Mesos
Requesting Resources
Running Spark Jobs
Resource Allocation Lifecycle
Releasing Resources

When connecting to Mesos the same local Docker image is automatically downloaded onto the Mesos nodes (from hub.docker.com) and used as the execution environment for application code.  This provides a consistent and reliable way to develop, deploy and run Spark applications and all their necessary dependencies.

Running lcmap-spark on a standalone cluster or on Yarn have not been tested.


Non-distributed Mode
--------------------
The only requirement for running a non-distributed instance of lcmap-spark is the ability to start a Docker container.
Create Spark Cluster
Specify CPU and memory 


Mesos
-----
The official Spark on Mesos documentation is `here <https://spark.apache.org/docs/latest/running-on-mesos.html>`_

When running on Mesos, Spark also provides two modes: (1) Client Mode (2) Cluster Mode.

``lcmap-spark`` targets (1) Client Mode using the Docker containerizer.

Mesos based runtime configuration and instructions.

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



Developing A SEE application
============================


Derivative Docker Image
-----------------------

``FROM lcmap-spark:<version>``


Installing Python Dependencies
------------------------------
Conda is installed.
Python 3 is installed and available as python3.
