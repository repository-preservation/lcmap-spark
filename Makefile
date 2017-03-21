.DEFAULT_GOAL := build

build: 
	docker build -t usgseros/mesos-cluster-dispatcher --rm=true --compress .
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:latest
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:2.1

push: 
	docker login; docker push usgseros/mesos-cluster-dispatcher

all: build push

#run:
#	docker run -e MESOS_MASTER=mesos://192.168.0.5:5050 -e ZOOKEEPER=192.168.32.4:2181 -e FRAMEWORK_NAME=MySparkCluster --network lcmapservices_lcmap -it usgseros/mesos-cluster-dispatcher

