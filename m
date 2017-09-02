From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/31] multipath/kpartx udev rules cleanup,
	and fixes
Date: Sun,  3 Sep 2017 00:38:29 +0200
Message-ID: <20170902223900.7339-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The main part of this series is a cleanup of the udev rules for
multipath and kpartx. More about that further down.

 - patch 01 is an obvious bug fix
 - patch 02-08 are fixes for kpartx problems that I encountered
   during testing, with related tests. The interesting one here is
   04, which adds the ability to rename partition mappings if the
   current name doesn't match the specified scheme. The purpose
   is to provide consistent naming of partition mappings across
   the OS, even in the presence of other tools such as parted
   that may follow different conventions.
 - 09-15 are changes to the core code I found necessary for the
   udev rules cleanup, most importantly a helper to figure out
   quickly whether a given multipath has usable paths
   (multipath -U). This replaces the former SUSE-specific tests
   for DM_DEPS and DM_TABLE_STATE.
 - 16ff are the actual changes to the udev rules. This was motivated
   by Ben Marzinski who asked Hannes and me a while ago to remove
   the SUSE-isms in the rules files (patch 23), and cleanup mainly
   kpartx.rules.

More about the udev rules changes:

Multipath maps are special because they can exist without any
usable members/paths, and users expect them to be at least partly
functional in such situations. Care has to be taken to avoid I/O
on maps that may not be able to process it, and not to loose any
symlinks that might be used by systemd to access the partition.
Partitions on multipath maps have similar semantics, with the added
difficulty that no first-hand information about the parent device
is available. A lot of the existing code was trying to fix these
corner case situations, but sometimes incorrectly or not cleanly.
I have pointed out the issues in the individual commit messages.
One important point is that checking DM_NR_VALID_PATHS>0 is not
in sufficient to affirm that I/O will succeed. That was the reason
for writing the "multipath -U" helper.

Also, multipath maps receive frequent udev events that don't
matter to upper layers at all. In such cases, further scanning
should be avoided. This is implemented much more cleanly now,
I hope. 

Following the example of the dm core, I split the kpartx rules
up in "early" rules for setting properties and symlinks, and
"late" rules for taking actions such as running kpartx. I believe
that this makes the code better readable.
CAUTION: The new rules files matter for other packages such as dracut.
Distribution package builders have to be careful here. If this patch set
is accepted, respective patches will be send to the dracut maintainers.

Following Ben's suggestions, a new rules file is added that
is responsible for deleting partition device nodes for multipath
member devices.

I didn't expect this series to grow so large, but after having
worked and tested for considerable time, this is the first
version that I find ready for serious review. I smoke-tested the
interaction of rules files, multipathd, udev, systemd, and
kpartx quite a bit with failover and 0-paths scenarios, successfully.

The changes are less drastic than the stats below suggest.
A considerable part just moves functionality out of existing code
into separate functions in order to use it elsewhere.

Regards,
Martin

Martin Wilck (31):
  libmultipath: fix partition_delimiter config option
  kpartx: helper functions for name and uuid generation
  kpartx: search partitions by UUID, and rename
  test-kpartx: add tests for renaming functionality
  kpartx: fix a corner case when renaming partitions
  kpartx: fix part deletion without partition table
  test-kpartx: test deletion with empty part table
  kpartx: only recognize dasd part table on DASD
  libmultipath: support MPATH_UDEV_NO_PATHS_FLAG on map creation
  libmultipath: add get_udev_device
  libmultipath: get_refwwid: use get_udev_device
  libmultipath: use const char* in some dm helpers
  libmultipath: add DI_NOIO flag for pathinfo
  libmultipath: add dm_get_multipath
  multipath: implement "check usable paths" (-C/-U)
  11-dm-mpath.rules: multipath -U for READY check
  11-dm-mpath.rules: import more ID_FS_xxx vars from db
  11-dm-mpath.rules: no need to test before IMPORT
  11-dm-mpath.rules: handle new maps with READY==0
  11-dm-mpath.rules: don't set READY->ACTIVATION
  11-dm-mpath.rules: Remember DM_ACTIVATION
  multipath.rules: set ID_FS_TYPE to "mpath_member"
  kpartx.rules: don't rely on DM_DEPS and DM_TABLE_STATE
  kpartx.rules: respect DM_UDEV_LOW_PRIORITY_FLAG
  kpartx.rules: improved logic for by-uuid and by-label links
  kpartx.rules: create by-partuuid and by-partlabel symlinks
  kpartx.rules: generate type-name links only for multipath devices
  kpartx.rules: fix logic for adding partitions
  multipath/kpartx rules: avoid superfluous scanning
  kpartx/del-part-nodes.rules: new udev file
  kpartx.rules: move symlink code to other files

 kpartx/Makefile             |   2 +
 kpartx/dasd.c               |   3 +
 kpartx/del-part-nodes.rules |  32 ++++++++
 kpartx/devmapper.c          | 194 ++++++++++++++++++++++++++++++++++++++++++--
 kpartx/devmapper.h          |  18 +++-
 kpartx/dm-parts.rules       |  39 +++++++++
 kpartx/kpartx.c             | 105 +++++++-----------------
 kpartx/kpartx.rules         |  58 ++++++-------
 kpartx/test-kpartx          |  50 ++++++++++++
 libmultipath/config.h       |   1 +
 libmultipath/configure.c    |  58 ++++++++++---
 libmultipath/configure.h    |   1 +
 libmultipath/devmapper.c    |  87 ++++++++++++--------
 libmultipath/devmapper.h    |   5 +-
 libmultipath/discovery.c    |   8 ++
 libmultipath/discovery.h    |   2 +
 multipath/11-dm-mpath.rules |  76 +++++++++++++----
 multipath/main.c            |  90 +++++++++++++++++++-
 multipath/multipath.8       |  13 ++-
 multipath/multipath.rules   |   2 +-
 20 files changed, 659 insertions(+), 185 deletions(-)
 create mode 100644 kpartx/del-part-nodes.rules
 create mode 100644 kpartx/dm-parts.rules

-- 
2.14.0
