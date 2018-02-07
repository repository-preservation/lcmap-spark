Developing lcmap-spark
======================

Developing
----------
* Perform development on a topic branch or the develop branch.
* Set the version in version.txt to x.x.  Follow semantic versioning. 
  
Building
--------
* Local builds may be performed with ``make build``.  This will create: ``usgseros/lcmap-spark:build``.
* Travis-CI will build and push ``usgseros/lcmap-spark:VERSION-BRANCH`` to Dockerhub for branch commits.
* Travis-CI will build and push ``usgseros/lcmap-spark:VERSION`` to Dockerhub for commits to ``master``.
* See `Makefile <../Makefile>`_ and `.travis.yml <../.travis.yml>`_ for details.

Releasing
---------
* Merge develop to master.
* Tag master with version.
* Perform github release.

See https://help.github.com/articles/creating-releases.

