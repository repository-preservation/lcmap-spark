.DEFAULT_GOAL := build

download-spark:
	mkdir tmp; wget -O tmp/spark-2.1.0-bin-hadoop2.7.tgz http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz

unpack-spark: download-spark
	cd tmp; gunzip *gz; tar -xvf *tar;

init: download-spark unpack-spark

build:
	docker build -t usgseros/mesos-spark --rm=true --compress .
	docker tag usgseros/mesos-spark usgseros/mesos-spark:latest
	docker tag usgseros/mesos-spark usgseros/mesos-spark:1.1.1-2.1.0

push:
	docker login; docker push usgseros/mesos-spark

all: init build push
