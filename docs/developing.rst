Developing lcmap-spark
======================

Building
--------

.. code-block:: bash
     
    # Build the image
    make

    # Push to dockerhub
    make push

* Perform development on the develop branch and set version to x.x-SNAPSHOT.
* Release to master.  Remove -SNAPSHOT from version.
* Tag master with version.
* Perform github release.

See https://help.github.com/articles/creating-releases.

