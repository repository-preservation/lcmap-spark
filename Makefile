.DEFAULT_GOAL := build
TAG:=`cat version.txt`
IMAGE:=usgseros/lcmap-spark

build:
	docker build -t $(IMAGE):$(TAG) -t $(IMAGE):latest --rm=true --compress $(PWD)

push:
	docker login
	docker push $(IMAGE):$(TAG)
	docker push $(IMAGE):latest
