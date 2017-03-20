CONTAINERS=`docker ps -a -q`
IMAGES=`docker images -q`

build-cluster-dispatcher: 
	docker build -t usgseros/mesos-cluster-dispatcher -f mcd.docker --rm=true --compress .
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:latest
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:2.1

push-cluster-dispatcher: 
	docker login; docker push usgseros/mesos-cluster-dispatcher

cluster-dispatcher: build-cluster-dispatcher push-cluster-dispatcher

run-dispatcher:
	docker run -e MESOS_MASTER=mesos://192.168.0.5:5050 -e ZOOKEEPER=192.168.32.4:2181 -e FRAMEWORK_NAME=foshizzle --network lcmapservices_lcmap -it usgseros/mesos-cluster-dispatcher

