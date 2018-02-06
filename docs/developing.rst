Developing lcmap-spark
======================

Developing
----------

* Perform development on the develop branch
* Set version to x.x-SNAPSHOT.

Building
--------

.. code-block:: bash
     
    # Build the image
    make

    # Push to dockerhub
    make push

Releasing
---------
* Release to master.
* Remove -SNAPSHOT from version.
* Tag master with version.
* Perform github release.

See https://help.github.com/articles/creating-releases.

