lcmap-spark  - WIP
==================

lcmap-spark is the application of Apache Spark for the LCMAP SEE.

Shippable Artifacts
-------------------
The shippable artifact for lcmap-spark is a Docker image published to https://hub.docker.com/r/usgseros/lcmap-spark/.

* Contains all code and libraries necessary to connect to LCMAP SEE
* Provides a consistent, immutable execution environment
* Is a base image only, suitable for exploratory analysis or as starting points for derivative images

SEE applications are independent software projects, publishing their own Docker images derived from lcmap-spark.

Modes
-----
There are two modes lcmap-spark operates in: (1) distributed and (2) non-distributed.

* Distributed mode takes advantage of Apache Mesos as a resource manager, which allows Spark to run functions in parallel across many physical hosts.
* Non-distributed mode runs the Spark application on the local host system only, but is able to use all the available CPU cores and memory on that host.
* Switching between modes is achieved through environment variable changes.

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


Anatomy of A Spark Job
----------------------
Spark Job is really a canned Spark Session
Create Spark Cluster
Spark Jobs
Load partitioned input data
Executing functions
Lazy, immutable data
Caching intermediate results
Retrieving calculation results
Storing results


Anatomy of an Interactive Spark Session
---------------------------------------
spark, pyspark or Jupyter Notebook
Create Spark Cluster
* with ``spark`` and ``pyspark`` this is done for you, with Jupyter you must do this yourself.
Load partitioned input data
Execute functions
Examine function outputs
Optionally retrieve and store outputs


Developing A SEE application
============================


Derivative Docker Image
-----------------------

``FROM lcmap-spark:<version>``


Installing Python Dependencies
------------------------------
Conda is installed.
Python 3 is installed and available as python3.
