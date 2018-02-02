Examples
========


pyspark - local mode
--------------------

.. code-block:: bash
   
   docker run -it --rm --net host -u `id -u` \
              usgseros/lcmap-spark:latest \
              pyspark --master local[*] \
                      --total-executor-cores 4 \
                      --driver-memory 1024m \
                      --executor-memory 1024m \
                      --conf spark.app.name=$USER \
                      --conf spark.driver.host=$HOSTNAME

                      
pyspark - cluster mode
----------------------

.. code-block:: bash
                
   docker run -it --rm --net host -u `id -u` \
              -v /home/user/mesos-keys:/certs \
              usgseros/lcmap-spark:latest \
              pyspark --master mesos://zk://host1:2181,host2:2181,host3:2181/mesos \
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


spark-submit - local mode
-------------------------

.. code-block:: python
                
   # save to /home/user/jobs/job.py on host filesystem
   
   import pyspark

   def run():
       sc = pyspark.SparkContext()
       rdd = sc.parallelize(range(3))
       print("Sum of range(3) is:{}".format(rdd.sum()))
       sc.stop()

   if __name__ == '__main__':
       run()

.. code-block:: bash

   docker run -it --rm --net host -u `id -u` \
              -v /home/user/jobs:/home/lcmap/jobs \
              usgseros/lcmap-spark:latest \
              spark-submit --master local[*] \
                           --total-executor-cores 4 \
                           --driver-memory 1024m \
                           --executor-memory 1024m \
                           --conf spark.app.name=$USER\
                           --conf spark.driver.host=$HOSTNAME \
                           jobs/job.py


spark-submit - cluster mode
---------------------------

.. code-block:: bash

   # must be built into image at /home/lcmap/jobs/job.py

   import pyspark

   def run():
       sc = pyspark.SparkContext()
       rdd = sc.parallelize(range(3))
       print("Sum of range(3) is:{}".format(rdd.sum()))
       sc.stop()

   if __name__ == '__main__':
       run()

.. code-block:: bash

   docker run -it --rm --net host -u `id -u` \
              -v /home/user/mesos-keys:/certs \
              usgseros/lcmap-spark:latest \
              spark-submit --master mesos://zk://host1:2181,host2:2181,host3:2181/mesos \
                           --total-executor-cores 4 \
                           --driver-memory 1024m \
                           --executor-memory 1024m \
                           --conf spark.app.name=$USER\
                           --conf spark.driver.host=$HOSTNAME \
                           jobs/job.py

                           
notebook - local mode
---------------------

.. code-block:: bash

   export IMAGE="usgseros/lcmap-spark:latest"
   export MASTER="local[*]"

   docker run -it --rm --net host -u `id -u` \
              -v /home/user/notebook/demo:/home/lcmap/notebook/demo \
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


notebook - cluster mode
-----------------------

.. code-block:: bash

   export IMAGE="usgseros/lcmap-spark:latest"
   export MASTER="mesos://zk://host1:2181,host2:2181,host3:2181/mesos"
   export MESOS_PRINCIPAL="<mesos-principal>"
   export MESOS_SECRET="<mesos-secret>"
   export MESOS_ROLE="<mesos-role>"
   
   docker run -it --rm --net host -u `id -u` \
              -v /home/user/notebook/demo:/home/lcmap/notebook/demo \
              -v /home/user/mesos-keys:/certs \
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

