FROM centos:7.3.1611

LABEL maintainer="USGS EROS LCMAP http://eros.usgs.gov http://github.com/usgs-eros/lcmap-spark" \
      description="CentOS based Spark image for LCMAP" \
      org.apache.mesos.version=1.4.0 \
      org.apache.spark.version=2.2.0 \
      net.java.openjdk.version=1.8.0 \
      org.python.version=3.6 \
      org.centos=7.3.1611

EXPOSE 8081 4040 8888

RUN yum update -y && \
    yum install -y sudo java-1.8.0-openjdk-devel.x86_64 && \
    yum install -y http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-3.noarch.rpm && \
    yum install -y mesos && \
    yum -y downgrade mesos-1.4.0 && \
    sudo yum clean all && \
    sudo rm -rf /var/cache/yum && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

ENV HOME=/home/lcmap \
    USER=lcmap \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true \
    PYSPARK_PYTHON=python3 \
    MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so \    
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TINI_SUBREAPER=true \
    LIBPROCESS_SSL_ENABLED=1 \
    LIBPROCESS_SSL_SUPPORT_DOWNGRADE=1 \
    LIBPROCESS_SSL_VERIFY_CERT=0 \
    LIBPROCESS_SSL_ENABLE_SSL_V3=0 \
    LIBPROCESS_SSL_ENABLE_TLS_V1_0=0 \
    LIBPROCESS_SSL_ENABLE_TLS_V1_1=0 \
    LIBPROCESS_SSL_ENABLE_TLS_V1_2=1 \
    LIBPROCESS_SSL_CERT_FILE=/certs/mesos.crt \
    LIBPROCESS_SSL_KEY_FILE=/certs/mesos.key \
    LIBPROCESS_SSL_CA_FILE=/certs/TrustedRoot.crt \
    LIBPROCESS_SSL_CA_DIR=/certs \
    LIBPROCESS_SSL_ECDH_CURVE=auto

ENV PATH=$SPARK_HOME/bin:${PATH}:$HOME/miniconda3/bin \
    PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$SPARK_HOME/python/lib/pyspark.zip


##########################################################################
# Add a user to run as inside the container.
#
# This will prevent accidental foo while mounting volumes.
#
# To enable access between external and internal users on mounted volume
# files, set 'other' perms appropriately. e.g. chmod xx6
#
# Mesos user must match this user (and be assigned permissions by Mesos admin.)
#
##########################################################################
RUN adduser -ms /bin/bash lcmap && \
    echo "lcmap ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/lcmap && \
    chmod 0440 /etc/sudoers.d/lcmap

USER $USER
WORKDIR $HOME
##########################################################################

# Install Spark
RUN cd /opt && \
    sudo curl https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz -o spark.tgz && \
    sudo tar -zxf spark.tgz && \
    sudo rm -f spark.tgz && \
    sudo ln -s spark-* spark

# Install miniconda then numpy from default repo for mkl based implementation.
RUN sudo yum install -y bzip2 && \
    curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o mc.sh && \
    chmod 755 mc.sh && \
    ./mc.sh -b && \
    rm -rf mc.sh && \
    sudo yum erase -y bzip2 && \
    sudo yum clean all && \
    conda install python=3.6 pip jupyter numpy --yes
    
# Install spark-cassandra connector
COPY pom.xml .
RUN sudo yum install -y maven  && \
    sudo mvn dependency:copy-dependencies -DoutputDirectory=$SPARK_HOME/jars && \
    sudo yum erase -y maven && \
    sudo yum clean all && \
    sudo rm -rf /var/cache/yum && \
    sudo rm -rf /root/.cache /root/.m2

COPY examples $HOME/notebook/examples
RUN sudo chown -R lcmap:lcmap .

