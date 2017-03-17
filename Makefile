CONTAINERS=`docker ps -a -q`
IMAGES=`docker images -q`

download-spark:
	wget -P tmp http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz

unpack-spark: download-spark
	cd tmp; gunzip *gz; tar -xvf *tar;

spark: download-spark unpack-spark

build-cluster-dispatcher: spark
	docker build -t usgseros/mesos-cluster-dispatcher -f mesos-cluster-dispatcher.docker --rm=true --compress .
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:latest
	docker tag usgseros/mesos-cluster-dispatcher usgseros/mesos-cluster-dispatcher:2.1

push-cluster-dispatcher: 
	docker login; docker push usgseros/mesos-cluster-dispatcher
 
cluster-dispatcher: build-cluster-dispatcher push-cluster-dispatcher

build-spark-executor: spark
	docker build -t usgseros/lcmap-spark-executor -f lcmap-spark-executor.docker --rm=true --compress .
	docker tag usgseros/lcmap-spark-executor usgseros/lcmap-spark-executor:latest
	docker tag usgseros/lcmap-spark-executor usgseros/lcmap-spark-executor:2.1

push-spark-executor:
	docker login; docker push usgseros/spark-executor

spark-executor: build-spark-executor push-spark-executor

clean-spark:
	@rm -rf tmp;

clean-containers: 
	@docker rm $(CONTAINERS)

clean-images: clean
	@docker rmi $(IMAGES)

clean-all: clean-containers clean-images clean-spark

