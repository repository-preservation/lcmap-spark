.DEFAULT_GOAL := build
VERSION:=`cat version.txt`
IMAGE:=usgseros/lcmap-spark
TAG:=$(VERSION)
BRANCH:=$(or $(TRAVIS_BRANCH),`git rev-parse --abbrev-ref HEAD | tr / -`)

build:
	@docker build -t $(IMAGE):$(TAG) -t $(IMAGE):latest --rm=true --compress $(PWD)

tag:
	@$(if $(BRANCH)=='develop',docker tag $(IMAGE) $(IMAGE):$(TAG)-$(BRANCH), docker tag $(IMAGE) $(IMAGE):$(TAG))

login:
	@$(if $(and $(DOCKER_USER), $(DOCKER_PASS)), docker login -u $(DOCKER_USER) -p $(DOCKER_PASS), docker login)

push: login
	docker push $(IMAGE):$(TAG)

branch:
	@echo $(BRANCH)

isdevelop:
	@$(if $(BRANCH)=='develop', echo "develop", echo "not")
