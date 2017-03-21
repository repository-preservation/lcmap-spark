.DEFAULT_GOAL := build

download-spark:
	wget -P tmp http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz

unpack-spark: download-spark
	cd tmp; gunzip *gz; tar -xvf *tar;

init: download-spark unpack-spark

build:
	docker build -t usgseros/mesos-cluster-dispatcher --rm=true --compress .
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:latest
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:2.1

push:
	docker login; docker push usgseros/mesos-cluster-dispatcher

all: init build push
