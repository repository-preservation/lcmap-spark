====================
Running lcmap-spark 
====================
lcmap-spark is an application of Apache Spark targeting the needs of the LCMAP SEE.  This guide will show you how to run lcmap-spark locally and on Apache Mesos.  Running on a standalone Spark cluster or on Yarn have not been tested.

Dependencies
------------
Code and system dependencies are packaged into a Docker image.  This image is used on the local client to either create and run an in-memory Spark instance locally or connect to a Mesos master over the network.

When connecting to Mesos the same Docker image run locally is automatically downloaded onto the Mesos nodes and used as the execution environment for application code.  This provides a consistent and reliable way to develop, deploy and run Spark applications and all their necessary dependencies.

lcmap-spark provides a minimal set of dependencies useful for exploratory analysis and development.  Each application should create and publish their own Docker image, specifying lcmap-spark as the base image with ``FROM lcmap-spark:<version>``.

Local
-----
Local runtime configuration and instructions.

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
