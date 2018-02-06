.DEFAULT_GOAL := build
VERSION    := `cat version.txt`
IMAGE      := usgseros/lcmap-spark
BRANCH     := $(or $(TRAVIS_BRANCH),`git rev-parse --abbrev-ref HEAD | tr / -`)
BUILD_TAG  := $(IMAGE):build
TAG        := $(shell if [ "$(BRANCH)" = "master" ];\
                         then echo "$(IMAGE):$(VERSION)";\
                         else echo "$(IMAGE):$(VERSION)-$(BRANCH)";\
                      fi)


build:
	@docker build -t $(BUILD_TAG) --rm=true --compress $(PWD)

tag:
	@docker tag $(BUILD_TAG) $(TAG)

login:
	@$(if $(and $(DOCKER_USER), $(DOCKER_PASS)), docker login -u $(DOCKER_USER) -p $(DOCKER_PASS), docker login)

push: login
	docker push $(TAG)

debug:
	@echo "VERSION:   $(VERSION)"
	@echo "IMAGE:     $(IMAGE)"
	@echo "BRANCH:    $(BRANCH)"
	@echo "BUILD_TAG: $(BUILD_TAG)"
	@echo "TAG:       $(TAG)"

all: debug build tag push

