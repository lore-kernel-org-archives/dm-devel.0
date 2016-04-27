From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/57] SLES resync
Date: Wed, 27 Apr 2016 13:10:01 +0200
Message-ID: <1461755458-29225-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi all,

as promised several times, here's now a patchset with all the patches
queued up in my SLES repository.

The first bits are pretty much uncontroversial (I hope), mainly fixes
etc. Next there are some systemd updates, setting dependencies and such.

The _really_ important patch is

multipathd: skip uninitialized devices during reconfiguration

which basically is the cause for all the missing wwid issues we've seen.
So I wonder if we shouldn't just do away with all the tweaks we've
accumlated so far and see if that patch isn't sufficient.
According to Kay Sievers it should...

Next is a general overhaul of the 'cookie' mechanism; Ben, Mike,
mind to have a look here? It _seems_ reasonable enough, but it would
be nice to have additional confirmation for that.

Finally there are patches which probably require some more discussion:
- Asynchronous configuration: Do not call 'reconfigure' directly, but
  rather set the daemon_status to 'configuration' and defer the actual
  work to the main thread. This allows us to decouple it from the CLI
  call, and we won't run into any udev/systemd timeout issues when
  booting on large installations
- Lock pushdown: I remember to have sent this patch already at one
  point, but it got rejected. So I try again :-)
  With this patch the big vector lock is pushed down to the areas
  where we actually need it, making the entire system running far
  smoother during booting or failover in large instances.
  We have been using this patch since SLE12 GA, ie for over two
  years now. And seem to have ironed out all issues with it.

The entire patchset can be found at:

github.com:/hreinecke/multipath-tools.git
branch sles-resync

As usual, comments and reviews are welcome.
Patches are based upon the latest git, including Bens patchset.

Hannes Reinecke (57):
  kpartx: Fixup persistent name generation
  kpartx: handle more than 256 loop devices
  kpartx: parse emulated DASD devices
  kpartx: Install rules file with correct prefix
  Add HP MSA 2040 to the hardware table
  Use ALUA for HP 3PAR
  Add LIO-ORG/SUSE RBD backend hardware defaults
  Allow for empty SCSI revision
  libmultipath: Do not use 'sscanf' for parsing integers
  libmultipath: finally fix dev_loss_tmo setting
  multipathd: fixup queueing mode in 'show maps status'
  multipathd: fixup a crash when invoking CLI commands
  multipathd: print error message for invalid arguments
  libmultipath: correctly initialize pp->sg_id
  libmultipath: correctly display checker status
  libmultipath: call get_uid() for all paths
  libmultipath: additional logging messages when formatting callout
  libmpathpersist: Fixup whitespaces in Makefile
  multipathd: Do not print misleading message 'not found in pathvec'
  multipathd: Do not update the paths vec when removing paths
  libmultipath: avoid double semicolon in lock.h
  multipath: use option '-i' when called from udev
  multipath: remove warning 'failed to get wwid'
  Add dependency on systemd-udevd.service
  Load all device handler modules on startup
  11-dm-mpath.rules: Only import ID_FS_XXX variables if not set
  Ensure multipathd is started before systemd-udev-trigger.service
  libmultipath: use a shared lock to co-operate with udev
  Only filter for udev property if uid_attribute is present
  multipathd: skip uninitialized devices during reconfiguration
  multipathd: improve uxlsnr
  libmultipath: remove 'needsync' argument from dm_simplecmd_noflush
  libmultipath: remove 'use_uuid' argument from dm_addmap()
  Always set DM_UDEV_DISABLE_LIBRARY_FALLBACK
  libmultipath: pass in cookie as argument for dm_simplecmd()
  libmultipath: pass in 'cookie' as argument for dm_addmap()
  Remove 'udev_sync' argument from dm_simplecmd()
  libmultipath: Fixup 'DM_DEVICE_RELOAD' handling
  devmapper: do not flush I/O for DM_DEVICE_CREATE
  libmultipath: fixup dm_rename to complete cookie on failure
  multipathd: accept zero-size paths in ev_add_path()
  Use multipath wwid if path wwid is empty
  multipathd: set uxsock_timeout after reconfiguration
  multipathd: Do not switch paths on empty multipath tables
  libmultipath: remove 'get_info' argument for adopt_paths()
  libmultipath: ensure 'dev_t' is set when store paths
  libmultipath: sanity check on store_path()
  dmparser: Use find_path_by_dev()
  multipathd: do not flush maps on startup
  multipathd: strict loop timings
  multipathd: Provide standard error description on cli failure
  libmultipath: make 'dm_addmap' static
  multipathd: implement 'show map $map format $fmt'
  multipathd: Increase uxclnt timeout
  multipathd: asynchronous configuration
  multipathd: push down lock in checkerloop()
  Allow specific CLI commands to run unlocked

 kpartx/Makefile               |   6 +-
 kpartx/dasd.c                 |  39 +++-
 kpartx/dasd.h                 |   1 +
 kpartx/kpartx.rules           |  11 +-
 kpartx/kpartx_id              |  11 +-
 kpartx/lopart.c               | 106 +++++----
 libmpathpersist/Makefile      |   4 +-
 libmultipath/callout.c        |   6 +-
 libmultipath/config.h         |   1 +
 libmultipath/configure.c      |  33 ++-
 libmultipath/defaults.h       |   1 +
 libmultipath/devmapper.c      | 114 ++++++----
 libmultipath/devmapper.h      |   4 +-
 libmultipath/dict.c           |   4 +
 libmultipath/discovery.c      | 115 +++++-----
 libmultipath/dmparser.c       |  20 +-
 libmultipath/hwtable.c        |  41 +++-
 libmultipath/lock.h           |   4 +-
 libmultipath/print.c          |   6 +-
 libmultipath/structs.c        |  17 +-
 libmultipath/structs_vec.c    |  10 +-
 libmultipath/structs_vec.h    |   2 +-
 libmultipath/uevent.c         |  10 +-
 multipath/11-dm-mpath.rules   |  10 +-
 multipath/main.c              |   1 -
 multipath/multipath.conf.5    |  16 +-
 multipath/multipath.rules     |   2 +-
 multipathd/cli.c              | 101 +++++++--
 multipathd/cli.h              |   4 +-
 multipathd/cli_handlers.c     |  85 +++++++-
 multipathd/cli_handlers.h     |   2 +
 multipathd/main.c             | 486 +++++++++++++++++++++++++++++-------------
 multipathd/main.h             |   3 +
 multipathd/multipathd.service |   6 +-
 multipathd/uxlsnr.c           |  97 +++++----
 35 files changed, 923 insertions(+), 456 deletions(-)

-- 
2.6.6
