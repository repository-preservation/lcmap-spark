Developing A SEE application
============================
SEE applications are created by extending the ``lcmap-spark`` Docker image.  Additional dependencies may be added to the derivative Docker images, and code may be developed using ``pyspark`` and the Jupyter Notebook server.  See the `examples <examples.rst>`_.

Once the new application is ready to run on the SEE, the derivative Docker image must be published to https://hub.docker.com.  A user account is required.

``make`` is a good choice to build and push your Dockerfile. An example of doing so is:

.. code-block:: make

    .DEFAULT_GOAL := build
    VERSION    := `cat version.txt`
    IMAGE      := <YOURACCOUNT/YOUR-IMAGE-NAME>
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


Keep in mind that Dockerhub is a public resource and all images published there are public by default.

Do not include any sensitive information in your image such as usernames, passwords, URLs, machine names, IP addresses or SSH keys as doing so constitues a security violation and will result in the gnashing of teeth.

If your application requires sensitive data it can be supplied at runtime through Docker environment variables using ``-e`` or ``--env``.  An ``--env-file`` may also be used locally.


What's already installed?
-------------------------
* Python3
* Pyspark
* Conda
* Jupyter
* numpy
* cytoolz
* lcmap-merlin

For a full view of what's available in the lcmap-spark base image, see the `Dockerfile <../Dockerfile>`_.
  
Installing Additional System Dependencies
------------------------------
* ``sudo conda install X``
* ``sudo yum install X``

Installing Additional Python Dependencies
------------------------------
* ``sudo conda install X``
* ``sudo pip install X``

Derivative Docker Image
-----------------------
All SEE application Dockerfiles should begin with: ``FROM lcmap-spark:<version>``, such as ``FROM lcmap-spark:1.0``.  

For a list of available lcmap-spark images, see https://hub.docker.com/r/usgseros/lcmap-spark/tags/.
