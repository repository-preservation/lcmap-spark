Developing lcmap-spark
======================

* lcmap-spark development should occur on topic branches
* Integration: topic branch should be merged to develop on github
* Releases: merge develop into master on github
* Update version.txt between releases
 

How To Build
------------

.. code-block:: bash
     
    ./build.sh

On topic branches, this will build a docker image tagged with <branch>-<version>, which may then
be run locally.

If build.sh is run on develop or master, a docker image will be built and tagged with <branch>-<version> and <commit> with the git commit id, then both tags will automatically be pushed to https://hub.docker.com.
