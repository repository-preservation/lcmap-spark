Developing lcmap-spark
======================

Building
--------

.. code-block:: bash
     
    # Build the image
    make

    # Push to dockerhub
    make push

Developing
----------
* Commit and push to develop branch
* Set version to x.x-SNAPSHOT

Releasing
---------
* Remove -SNAPSHOT from version
* Merge develop into master on github
* Tag master with version number
* `Create a github release.  Add release notes <https://help.github.com/articles/creating-releases/>`_

