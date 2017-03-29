FROM mesosphere/mesos:1.1.1

MAINTAINER USGS LCMAP http://eros.usgs.gov

RUN apt-get update

WORKDIR /opt/spark/dist

COPY tmp/spark-2.1.0-bin-hadoop2.7/ .
COPY files/ /

# This lets docker manage the execution
ENV SPARK_NO_DAEMONIZE "true"
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/lib/libmesos.so
ENV SPARK_HOME /opt/spark/dist
ENV PATH $SPARK_HOME/bin:$PATH
ENV PYTHONPATH $SPARK_HOME/python/:$PYTHONPATH
ENV PYTHONPATH $SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH

EXPOSE 7077
EXPOSE 8081

#ENTRYPOINT ["sbin/dispatcher-entry-point.sh"]
