FROM centos:7.3.1611

LABEL maintainer="USGS EROS LCMAP http://eros.usgs.gov http://github.com/usgs-eros/lcmap-spark" \
      description="CentOS based Spark image for LCMAP" \
      org.apache.mesos.version=1.4.0 \
      org.apache.spark.version=2.2.0 \
      net.java.openjdk.version=1.8.0 \
      org.python.version=3.6 \
      org.centos=7.3.1611

EXPOSE 8081 4040 8888

ENV HOME=/home/lcmap \
    USER=lcmap \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true \
    PYSPARK_PYTHON=python3 \
    MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so \    
    TINI_SUBREAPER=true \
    LIBPROCESS_SSL_ENABLED=1 \
    LIBPROCESS_SSL_SUPPORT_DOWNGRADE=1 \
    LIBPROCESS_SSL_VERIFY_CERT=0 \
    LIBPROCESS_SSL_ENABLE_SSL_V3=0 \
    LIBPROCESS_SSL_ENABLE_TLS_V1_0=0 \
    LIBPROCESS_SSL_ENABLE_TLS_V1_1=0 \
    LIBPROCESS_SSL_ENABLE_TLS_V1_2=1 \
    LIBPROCESS_SSL_CIPHERS=ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:AES256-SHA256:AES128-SHA256 \
    LIBPROCESS_SSL_CERT_FILE=/certs/mesos.crt \
    LIBPROCESS_SSL_KEY_FILE=/certs/mesos.key \
    LIBPROCESS_SSL_CA_FILE=/certs/trustedroot.crt \
    LIBPROCESS_SSL_CA_DIR=/certs \
    LIBPROCESS_SSL_ECDH_CURVE=auto

ENV PATH=$SPARK_HOME/bin:${PATH} \
    PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$SPARK_HOME/python/lib/pyspark.zip

# Add a user to run as inside the container to prevent accidental foo while mounting volumes.
# Use "docker run -u `id -u`" at runtime to assign proper UIDs for file permissions.
# Mesos username must match this username (and be assigned permissions by Mesos admin.)

RUN yum install -y sudo && \
    adduser -ms /bin/bash $USER && \
    echo "$USER ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER && \
    echo "alias sudo='sudo env PATH=$PATH'" > /etc/profile.d/sudo.sh && \
    chmod 0440 /etc/sudoers.d/$USER

COPY pom.xml /root
COPY notebook $HOME/notebook

RUN yum update  -y 
RUN yum install -y java-1.8.0-openjdk-devel.x86_64 \
                   http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-3.noarch.rpm \
                   mesos \ 
                   bzip2 \
                   gcc  \
                   maven
RUN yum -y downgrade mesos-1.4.0
RUN curl https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz -o /opt/spark.tgz
RUN cd /opt && tar -zxf spark.tgz && rm -f spark.tgz &&  ln -s spark-* spark && cd -
RUN curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /root/mc.sh
RUN bash /root/mc.sh -u -b -p /usr/local
RUN conda install python=3.6 pip jupyter numpy --yes
RUN pip install lcmap-merlin==2.0rc2
RUN mvn -f /root/pom.xml dependency:copy-dependencies -DoutputDirectory=$SPARK_HOME/jars
RUN yum erase -y maven gcc bzip2
RUN yum clean all
RUN rm -rf /var/cache/yum /root/.cache /root/.m2 /root/pom.xml /root/mc.sh
RUN conda clean --all -y

USER $USER
WORKDIR $HOME
RUN sudo chown -R $USER:$USER .

