Modes
=====

Local Mode
--------------------
The only requirement for running a local instance of lcmap-spark is the ability to start a Docker container.  The Docker image must be built and available on the host machine but does not need to be published to https://hub.docker.com.

pyspark
~~~~~~~

.. code-block:: bash
   
   docker run -it --rm --net host -u `id -u` \
              usgseros/lcmap-spark:latest \
              pyspark --master local[*] \
                      --total-executor-cores 4 \
                      --driver-memory 1024m \
                      --executor-memory 1024m \
                      --conf spark.app.name=$USER \
                      --conf spark.driver.host=$HOSTNAME

spark-submit
~~~~~~~~~~~~
https://spark.apache.org/docs/latest/submitting-applications.html

.. code-block:: python

   import pyspark

   def run():
       sc = pyspark.SparkContext()
       rdd = sc.parallelize(range(3))
       print("Sum of range(3) is:{}".format(rdd.sum()))
       sc.stop()

   if __name__ == '__main__':
       run()

.. code-block:: bash

   docker run -it --rm --net host -u `id -u` -v /home/user/jobs:/home/lcmap/jobs \
              usgseros/lcmap-spark:latest \
              spark-submit --master local[*] \
                           --total-executor-cores 4 \
                           --driver-memory 1024m \
                           --executor-memory 1024m \
                           --conf spark.app.name=$USER\
                           --conf spark.driver.host=$HOSTNAME \
                           jobs/job.py

This examples assumes a Python job module is available at ```/home/user/jobs/job.py``` on the host system.

Job modules must be made accessible inside the Docker image at runtime, so in this simple case a Docker volume mount was used.

This works well for development and testing in ``local`` mode, but in ``cluster`` mode the job files must be
built into the image.
                       
notebook
~~~~~~~~

.. code-block:: bash

   export IMAGE="usgseros/lcmap-spark:latest"
   export MASTER="local[*]"

   docker run -it --rm --net host -u `id -u` -v /home/user/notebook/demo:/home/lcmap/notebook/demo \
              -e IMAGE=$IMAGE \
              -e MASTER=$MASTER \
              $IMAGE \
              jupyter --ip=$HOSTNAME notebook

.. code-block:: python

   """Example Notebook connecting to Spark"""
   
   import os
   import pyspark

   
   def conf():
       return {'spark.driver.host':                          os.environ['HOSTNAME'], 
               'spark.mesos.principal':                      os.environ.get('MESOS_PRINCIPAL', ''), 
               'spark.mesos.secret':                         os.environ.get('MESOS_SECRET', ''), 
               'spark.mesos.role':                           os.environ.get('MESOS_ROLE', ''),
               'spark.mesos.executor.docker.image':          os.environ['IMAGE'],
               'spark.mesos.executor.docker.forcePullImage': 'false',
               'spark.mesos.task.labels':                    'lcmap-spark:{}'.format(os.environ['USER']),                    
               'spark.serializer':                           'org.apache.spark.serializer.KryoSerializer',                                  
               'spark.python.worker.memory':                 '1g',
               'spark.executor.cores':                       '1',
               'spark.cores.max':                            '1000',
               'spark.executor.memory':                      '4g'}

               
   def context(conf):
       return pyspark.SparkContext(master=os.environ['MASTER'],
                                   appName='lcmap-spark:{}'.format(os.environ['USER']),
                                   conf=pyspark.SparkConf().setAll([conf]))

                                   
   def application():
       sc = None
       try:
           sc   = context(conf())
           rdd  = sc.parallelize(range(1000000))
           return {'min': rdd.min(), 'max': rdd.max()}
       finally:
           sc.stop()

           
Setting Spark configuration values via the ``--conf`` flag works for ``pyspark`` and ``spark-submit``.  When running ``notebook`` however, these values must be specified when creating the SparkContext through code.

If you wish to pass these values in from the host machine at runtime, consider setting them as environment variables using the ``-e`` Docker flag and then accessing them through ``os.environ`` in your notebook.

Notebooks may be persisted on the host filesystem and loaded at runtime into Docker, keeping notebook management and version control outside of lcmap-spark.

Set the ``-u`` Docker flag value to match the host system user's UID to avoid improper file permissions when mounting volumes.

Cluster Mode
------------

https://spark.apache.org/docs/latest/cluster-overview.html

Cluster mode uses Apache Mesos as a cluster manager for Spark, which allows Spark to run functions in parallel across many physical hosts.

Cluster mode requirements are:

* ability to run lcmap-spark locally
* network access to Mesos Master(s), ideally over a 10 Gigabit or greater link
* Mesos username
* Mesos role
* Mesos password
* Mesos certificates

When run in cluster mode, the lcmap-spark image is automatically downloaded onto the Mesos nodes and used to create Docker containers, which create the Spark cluster and execute Spark & application code.

<INSERT DIAGRAM OF THIS HERE>

Host System ---> lcmap-spark ---> SparkContext (Spark Master) ---> 
... Mesos Master ---> Mesos Executors ---> lcmap-spark ---> Spark Worker ---> **Bazinga**



This provides a reliable way to create a consistent, immutable environment, dynamically, across a cluster of machines.

pyspark
~~~~~~~

.. code-block:: bash
                
   docker run -it --rm --net host -u `id -u` -v /home/user/mesos-keys:/certs
              usgseros/lcmap-spark:latest \
              pyspark --master <mesos://zk://host1:2181,host2:2181,host3:2181/mesos> \
                      --total-executor-cores 4 \
                      --driver-memory 1024m \
                      --executor-memory 1024m \
                      --conf spark.app.name=$USER:pyspark \
                      --conf spark.driver.host=$HOSTNAME \
                      --conf spark.mesos.principal=<MESOS_PRINCIPAL> \
                      --conf spark.mesos.secret=<MESOS_SECRET> \
                      --conf spark.mesos.role=<MESOS_ROLE> \
                      --conf spark.mesos.executor.docker.image=usgseros/lcmap-spark:latest \
                      --conf spark.mesos.executor.docker.forcePullImage=false \
                      --conf spark.mesos.task.labels=$USER:demo
                      
spark-submit
~~~~~~~~~~~~

.. code-block:: bash

   import pyspark

   def run():
       sc = pyspark.SparkContext()
       rdd = sc.parallelize(range(3))
       print("Sum of range(3) is:{}".format(rdd.sum()))
       sc.stop()

   if __name__ == '__main__':
       run()

.. code-block:: bash

   docker run -it --rm --net host -u `id -u` -v /home/user/jobs:/home/lcmap/jobs \
              usgseros/lcmap-spark:latest \
              spark-submit --master mesos://zk://host1:2181,host2:2181,host3:2181/mesos \
                           --total-executor-cores 4 \
                           --driver-memory 1024m \
                           --executor-memory 1024m \
                           --conf spark.app.name=$USER\
                           --conf spark.driver.host=$HOSTNAME \
                           jobs/job.py


notebook
~~~~~~~~

.. code-block:: bash

   export IMAGE="usgseros/lcmap-spark:latest"
   export MASTER="mesos://zk://host1:2181,host2:2181,host3:2181/mesos"

   docker run -it --rm --net host -u `id -u` -v /home/user/notebook/demo:/home/lcmap/notebook/demo \
              -e IMAGE=$IMAGE \
              -e MASTER=$MASTER \
              -e MESOS_PRINCIPAL=$MESOS_PRINCIPAL \
              -e MESOS_SECRET=$MESOS_SECRET \
              -e MESOS_ROLE=$MESOS_ROLE \
              $IMAGE \
              jupyter --ip=$HOSTNAME notebook

.. code-block:: python

   """Example Notebook connecting to Spark"""

   import os
   import pyspark

   
   def conf():
       return {'spark.driver.host':                          os.environ['HOSTNAME'], 
               'spark.mesos.principal':                      os.environ.get('MESOS_PRINCIPAL', ''), 
               'spark.mesos.secret':                         os.environ.get('MESOS_SECRET', ''), 
               'spark.mesos.role':                           os.environ.get('MESOS_ROLE', ''),
               'spark.mesos.executor.docker.image':          os.environ['IMAGE'],
               'spark.mesos.executor.docker.forcePullImage': 'false',
               'spark.mesos.task.labels':                    'lcmap-spark:{}'.format(os.environ['USER']),                    
               'spark.serializer':                           'org.apache.spark.serializer.KryoSerializer',                                  
               'spark.python.worker.memory':                 '1g',
               'spark.executor.cores':                       '1',
               'spark.cores.max':                            '1000',
               'spark.executor.memory':                      '4g'}

               
   def context(conf):
       return pyspark.SparkContext(master=os.environ['MASTER'],
                                   appName='lcmap-spark:{}'.format(os.environ['USER']),
                                   conf=pyspark.SparkConf().setAll([conf]))

                                   
   def application():
       sc = None
       try:
           sc   = context(conf())
           rdd  = sc.parallelize(range(1000000))
           return {'min': rdd.min(), 'max': rdd.max()}
       finally:
           sc.stop()


Apache Mesos
------------
https://spark.apache.org/docs/latest/running-on-mesos.html

When running on Mesos, there are two modes that determine where the SparkContext runs: client and cluster.

lcmap-spark uses client mode only: The driver program (SparkContext) will always run on the local client machine.

**This shouldn't be confused with Spark's local and cluster modes, which determine where the Spark Workers run.**

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
