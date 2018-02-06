Developing lcmap-spark
======================

Developing
----------
* Develop on the develop branch
* Set version to x.x-SNAPSHOT

Releasing
---------
* Remove -SNAPSHOT from version
* Merge develop into master on github
* Tag master with version number
* Perform github release
  
How To Build
------------

.. code-block:: bash
     
    # Build the image
    make

    # Push image to dockerhub
    make push

