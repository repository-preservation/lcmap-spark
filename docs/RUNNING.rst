====================
Running lcmap-spark 
====================
``lcmap-spark`` is an application of Apache Spark targeting the needs of the LCMAP SEE.  As such, ``lcmap-spark`` supports a subset of the deployment and runtime configurations offered by Spark.

Apache Spark offers several runtime environments: (1) Local (2) Spark cluster (3) Yarn (4) Mesos.

``lcmap-spark`` supports (1) Local and (4) Mesos only.

When running on Mesos, Spark also provides two modes: (1) Client Mode (2) Cluster Mode.

``lcmap-spark`` targets (1) Client Mode using the Docker containerizer.

Local
-----
Local runtime configuration and instructions.

Mesos
-----
The official Spark on Mesos documentation is `here <https://spark.apache.org/docs/latest/running-on-mesos.html>`_

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
