From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/78] SUSE SLES resync
Date: Mon, 16 Mar 2015 13:35:47 +0100
Message-ID: <1426509425-15978-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

here are the patches which I've queued up during SLES12 development.
Most of them are (more or less) obvious bugfixes, but there are some
things which would warrant a deeper review:
- device-mapper cookie handling: This _really_ is an arcane topic,
  and I would love to have someone from the device-mapper team
  to review it. I'm still facing some issues where udev emits
  a warning 'conflicting device node /dev/mapper/XXX ..', so
  there might be some issue with it.
- Asynchronous configuration: On large systems configure() as
  being called during multipathd startup might exceed the systemd
  job timeout, resulting in multipathd being killed by systemd.
  For that I've been implementing an udev retrigger method, which
  just issues an 'add' event for all available block devices.
- Related to the above: I've implemented an asynchronous 'reconfigure'
  CLI call, as for the same reason systemd might kill the multipathd
  during a 'restart' operation
- systemd/udev integration: This is _a pain_. It took me months to
  come up with a working solution. _Especially_ as apparently RH
  is shipping an '11-dm-multipath.rules' udev ruleset for multipathd,
  which supposedly should be handling this.
  It didn't do it for me, though, so I've attached my own version here.
  The udev integration I've been settling for works like this:
  - 11-dm-mpath.rules checks if the device is eligible for multipathing
    For that I've implemented a new option '-u' which looks at the
    uevent variables _only_.
  - if a device should be handled by multipathing the 'by-id' and
    'by-uuid' persistent symlinks are _not_ generated, as this would
    trigger systemd to start scanning/mounting/lvm activation/whatnot;
    the 'by-id' and 'by-uuid' symlinks are only generated for the
    multipath devices themselves.
  - I've added a new multipath.rules file which should be inserted between
    55-scsi-sg3_id.rules and 58-scsi_sg3_symlink.rules. This will
    intercept the SCSI IDENT variables and blank them out if the (block)
    device is handled by multipathing.
- sysfs VPD page handling. I've planned to implement this as a direct
  replacement of the original scsi_id program, but then it turned out
  that our WWID handling is actually too generic for that: Both getuid
  and uid_attribute can basically take _any_ value, so it's impossible
  to tell if the system uses the original (scsi_id compatible) IDs or
  not. And as the VPD parsing code can only generate scsi_id compatible
  IDs we might run into compability issues.
  So it's disabled per default. I'd really would like to clean it up,
  as I suspect that about 95% of the installations are using scsi_id
  compatible IDs. But for this to happen we need to clarify/restrict
  the ID generation mechanism.

As usual, comments and reviews are welcome.

The patchset is based upon the 'find_multipaths' patchset from
Ben Marzinski; it can be retrieved from

github.com:/hreinecke/multipath-tools.git branch suse-resync

Cheers,

Hannes

Hannes Reinecke (78):
  libmultipath: remove compilation warning in devmapper.c
  mpath_persist: Do not call exit() from a shared library
  libmultipath: filter for missing property in get_refwwid()
  Double uevent stacksize yet again
  discovery: do not fail discovery on individual devices
  libmultipath: Prefer deprecated 'getuid' callout
  libmultipath: Skip paths with empty wwid
  Make systemd installation path configurable
  Add multipath rules for systemd support
  Fixup multipathd.socket to resolve ordering dependeny
  Fixup dependencies in multipathd.service
  multipathd: set correct PID when running in debug mode
  Do not print empty device strings during discovery
  kpartx.rules: do not call blkid
  Use 'SCSI_IDENT_.*' as the default property whitelist
  Fixup wwid blacklist printing
  Allow for empty path argument when printing information
  Disable reassign maps per default
  multipathd: implement 'list path <path>' cli command
  Make checker_put() and prio_put() idempotent
  Remove trailing linefeed from sysfs attributes
  multipath: implement option '-u' for uevents
  Install multipath rule under '56-multipath.rules'
  multipath.rules: Whitelist devices
  multipath.rules: fixup race condition with systemd
  11-dm-mpath.rules: Import blkid values if all paths are down
  kpartx.rules: Skip kpartx for multipath events
  multipathd: handle DOMAP_RETRY
  multipathd: cleanup foreground operation
  Update hwtable for EMC XtremIO
  multipath: check for running daemon when called with '-u'
  Revert 'return PATH_DOWN for quiesced paths'
  Do not treat 'transport-offline' paths as 'offline'
  Check for valid DM_DEVICE_INFO before proceeding
  Separate out uevent parsing functions
  Use poll() when receiving uevents
  mpath_persist: cleanup
  kpartx: use standard 'major' and 'minor' macros
  multipath: Use standard 'major' macro
  Remove sysfs_get_dev
  Add paths with a size of '0' as 'ghost' paths
  Remove last argument from verify_paths()
  Fixup device-mapper 'cookie' handling
  multipath: do not print state 'orphan' for option '-l'
  Return error when receiving CLI packet
  Implement 'uxsock_timeout' keyword
  Do not print empty multipaths section
  multipathd: reload map if reinstate failed
  multipathd: do not remove paths without uevents
  Allow zero-sized devices during configuration
  Rework uev_add_path()
  multipathd: Issue warning on CLI command timeout
  Use strlen() when checking for valid wwid
  multipathd: Use standard lists for CLI handling
  uxlsnr: use typedef for trigger function
  multipathd: lock cli client list
  multipath: enable sync support
  Remove dm_udev_XXX wrapper functions
  Revert to ACT_RELOAD in domap if the map exists
  multipathd: use local variable for watchdog configuration
  Ignore devices when sysfs_get_tgt_nodename fails
  Skip USB devices during discovery
  Read wwid from sysfs vpg_pg83 attribute
  Assign local priority for NAA VPD descriptor
  Use sysfs attribute vpd_pg80 to read serial number
  Update multipath.conf.5 to clarify wwid generation
  libmultipath: Fall back to SG_IO if no UID could be assigned
  libmultipath: unset 'uid_attribute' on failure
  Separate out vpd parsing functions
  multipathd: use SG_IO as fallback to generate uid
  Do not automatically fall back to vpd uid generation
  libmultipath: make vpd page 0x80 optional
  multipathd: push down lock in checkerloop()
  Allow specific CLI commands to run unlocked
  Push down vector lock during uevent processing
  multipathd: timeout CLI commands when waiting for lock
  multipathd: asynchronous configuration
  multipathd: trigger all devices on startup

 Makefile.inc                     |   8 +-
 kpartx/devmapper.c               |  53 +++-
 kpartx/devmapper.h               |  11 +-
 kpartx/kpartx.c                  |  35 +--
 kpartx/kpartx.rules              |  10 +-
 libmpathpersist/mpath_persist.c  | 172 ++++++-----
 libmpathpersist/mpath_updatepr.c |  20 +-
 libmpathpersist/mpathpr.h        |   3 +-
 libmultipath/blacklist.c         |   8 +-
 libmultipath/blacklist.h         |   2 +-
 libmultipath/checkers.c          |   2 +-
 libmultipath/config.c            |   2 +
 libmultipath/config.h            |   8 +-
 libmultipath/configure.c         |  82 ++++--
 libmultipath/defaults.h          |   4 +-
 libmultipath/devmapper.c         |  77 +++--
 libmultipath/devmapper.h         |   4 +-
 libmultipath/dict.c              |  33 +++
 libmultipath/discovery.c         | 613 ++++++++++++++++++++++++++++++++++-----
 libmultipath/discovery.h         |   8 +-
 libmultipath/hwtable.c           |  13 +
 libmultipath/list.h              |  49 +++-
 libmultipath/lock.h              |   4 +-
 libmultipath/log_pthread.c       |   2 +-
 libmultipath/print.c             |  20 +-
 libmultipath/prio.c              |   4 +-
 libmultipath/propsel.c           |   6 +-
 libmultipath/structs_vec.c       |  29 +-
 libmultipath/structs_vec.h       |   2 +-
 libmultipath/sysfs.c             |  53 ++++
 libmultipath/sysfs.h             |   2 +
 libmultipath/uevent.c            | 316 ++++++++++++--------
 libmultipath/uxsock.c            |  32 +-
 libmultipath/uxsock.h            |   4 +-
 multipath.conf.defaults          |   2 +-
 multipath/11-dm-mpath.rules      |   8 +-
 multipath/Makefile               |   2 +
 multipath/dev_t.h                |   3 -
 multipath/main.c                 |  53 +++-
 multipath/multipath.8            |   6 +-
 multipath/multipath.conf.5       |  42 ++-
 multipath/multipath.rules        |  14 +
 multipathd/cli.c                 |  47 ++-
 multipathd/cli.h                 |   4 +-
 multipathd/cli_handlers.c        |  64 +++-
 multipathd/cli_handlers.h        |   1 +
 multipathd/main.c                | 400 ++++++++++++++++---------
 multipathd/main.h                |   2 +
 multipathd/multipathd.service    |   4 +-
 multipathd/multipathd.socket     |   8 +-
 multipathd/uxclnt.c              |  26 +-
 multipathd/uxclnt.h              |   2 +-
 multipathd/uxlsnr.c              | 102 +++++--
 multipathd/uxlsnr.h              |   8 +-
 54 files changed, 1834 insertions(+), 655 deletions(-)
 delete mode 100644 multipath/dev_t.h
 create mode 100644 multipath/multipath.rules

-- 
1.8.4.5
