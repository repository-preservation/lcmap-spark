FROM mesosphere/spark:1.0.9-2.1.0-1-hadoop-2.7

MAINTAINER USGS LCMAP http://eros.usgs.gov

RUN apt-get update

WORKDIR /opt/spark/dist

COPY files/ /

ENV SPARK_HOME /opt/spark/dist

# This lets docker manage the execution
ENV SPARK_NO_DAEMONIZE "true"

EXPOSE 7077

EXPOSE 8081

ENTRYPOINT ["sbin/dispatcher-entry-point.sh"]
