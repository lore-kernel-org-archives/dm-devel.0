From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/3] initial release of dm thin provisioning
	target
Date: Fri,  8 Jul 2011 18:19:49 -0400
Message-ID: <1310163592-29683-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Dave Chinner <dchinner@redhat.com>
List-Id: dm-devel.ids

Alasdair,

Please consider this initial release of the new Device Mapper thin
provisioning target (with scalable snapshot support) for inclusion in
linux-next (with the goal being upstream inclusion in Linux 3.1).

There is significant interest in this thin provisioning target.  It is
EXPERIMENTAL but we are working aggressively to improve the code.  All
of our tests pass (test-suite listed below).  We would like to get it
upstream as soon as reasonable to encourage early adopters that might
help us with further testing and features.

It is understood that there may be various changes required but until
it gets upstream it would be very helpful if you could refrain from
editing these patches in place.  Layering on additional patches is
very much preferred (so that we can easily fold them back into the
git tree, listed below, while pending upstream inclusion).

That said, I've layered these patches ontop of your editing tree:
ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/series.html

All patches are available here too:
http://people.redhat.com/msnitzer/patches/upstream/dm-thinp/series.html

The git tree that we've been using for development can be found here
(though it is missing some checkpatch and misc. fixes I made today,
Joe will likely push those on Monday):
git://github.com/jthornber/linux-2.6.git thin-dev

The incremental patch with my checkpatch and misc fixes is here:
http://people.redhat.com/msnitzer/patches/upstream/dm-thinp/dm-thinp-checkpath-misc.patch

The thinp test-suite (requires ruby 1.9) is available here:
git://github.com/jthornber/thinp-test-suite.git

All comments/review would be appreciated.


Joe Thornber (3):
  dm: add dm_bdev
  dm persistent data: a library for storing metadata in DM targets
  dm thin: thin provisioning target

 Documentation/device-mapper/persistent-data.txt    |   90 +
 Documentation/device-mapper/thin-provisioning.txt  |  248 +++
 drivers/md/Kconfig                                 |    8 +
 drivers/md/Makefile                                |    3 +
 drivers/md/dm-thin-metadata.c                      | 1281 ++++++++++++
 drivers/md/dm-thin-metadata.h                      |  164 ++
 drivers/md/dm-thin.c                               | 2204 ++++++++++++++++++++
 drivers/md/dm.c                                    |   11 +-
 drivers/md/persistent-data/Kconfig                 |    9 +
 drivers/md/persistent-data/Makefile                |   10 +
 drivers/md/persistent-data/dm-block-manager.c      |  931 +++++++++
 drivers/md/persistent-data/dm-block-manager.h      |  110 +
 drivers/md/persistent-data/dm-btree-internal.h     |  141 ++
 drivers/md/persistent-data/dm-btree-remove.c       |  540 +++++
 drivers/md/persistent-data/dm-btree-spine.c        |  192 ++
 drivers/md/persistent-data/dm-btree.c              |  871 ++++++++
 drivers/md/persistent-data/dm-btree.h              |  146 ++
 drivers/md/persistent-data/dm-pd-module.c          |   18 +
 drivers/md/persistent-data/dm-space-map-common.h   |   99 +
 drivers/md/persistent-data/dm-space-map-disk.c     |  624 ++++++
 drivers/md/persistent-data/dm-space-map-disk.h     |   21 +
 drivers/md/persistent-data/dm-space-map-metadata.c |  878 ++++++++
 drivers/md/persistent-data/dm-space-map-metadata.h |   29 +
 drivers/md/persistent-data/dm-space-map.h          |  116 +
 .../md/persistent-data/dm-transaction-manager.c    |  442 ++++
 .../md/persistent-data/dm-transaction-manager.h    |  139 ++
 include/linux/device-mapper.h                      |    1 +
 27 files changed, 9324 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/device-mapper/persistent-data.txt
 create mode 100644 Documentation/device-mapper/thin-provisioning.txt
 create mode 100644 drivers/md/dm-thin-metadata.c
 create mode 100644 drivers/md/dm-thin-metadata.h
 create mode 100644 drivers/md/dm-thin.c
 create mode 100644 drivers/md/persistent-data/Kconfig
 create mode 100644 drivers/md/persistent-data/Makefile
 create mode 100644 drivers/md/persistent-data/dm-block-manager.c
 create mode 100644 drivers/md/persistent-data/dm-block-manager.h
 create mode 100644 drivers/md/persistent-data/dm-btree-internal.h
 create mode 100644 drivers/md/persistent-data/dm-btree-remove.c
 create mode 100644 drivers/md/persistent-data/dm-btree-spine.c
 create mode 100644 drivers/md/persistent-data/dm-btree.c
 create mode 100644 drivers/md/persistent-data/dm-btree.h
 create mode 100644 drivers/md/persistent-data/dm-pd-module.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-common.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-disk.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-disk.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-metadata.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-metadata.h
 create mode 100644 drivers/md/persistent-data/dm-space-map.h
 create mode 100644 drivers/md/persistent-data/dm-transaction-manager.c
 create mode 100644 drivers/md/persistent-data/dm-transaction-manager.h
