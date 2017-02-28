From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/33] multipath-tools fixes from SUSE
Date: Tue, 28 Feb 2017 17:22:56 +0100
Message-ID: <20170228162329.14517-1-mwilck@suse.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

As announced previously, here comes a collection of multipath-tools patches
that SUSE is using for SLES12 SP2.

The whole series can be roughly broken down into the following logical
parts. Details can be found in the indvidual patches.

A) Modified boot sequence (01, 02, 04):

Under SLES12, the systemd service startup sequence has been changed such that
multipathd is now started after "udev settle" has finished. This has solved a
variety of sporadic, hard-to-track boot-time problems for us. The bottom line is
that until "udev settle" finishes, the udev db is incomplete when multipathd
tries to derive device information from it. That may cause multipathd to infer
incorrectly that a certain map is degraded, causing all kinds of problems.

B) Changed command line option semantices with find_multipaths (16, 17):

SUSE uses "multipath -i" in udev rules during device detection, as discussed
by Hannes on this list previously. This doesn't work well with the
"find_multipaths" option. We worked around this by relying on WWID for the
"find_multipaths" case, as other distributions do.

C) Avoid unnecessary domap() calls in configure() (18-28):

This patch series fixes another group of boot-time problems we encountered
in reboot tests. In many cases, multipathd has already set up valid maps
during initrd processing. When multipathd is restarted after switching to the
root FS, more often than not, no configuration changes are necessary. Yet
domap() is called for every map again. This call may race with other boot-time
operations such as LVM pvscan or mount commands and cause sporadic boot failures.

The idea of this series of patches is to detect this situation and avoid calling
making device mapper calls if the multipath internal representation of the map
already matches the kernel state. The logic of this series works only if the
udev db is in a sane state after switching root, thus it's closely related to
A).

Side note: This modified logic was also the background of my earlier remarks
about the possible processing of uevent batches using configure(). Based on
this series, further changes for configure could be written that would make
this possible.

D) Misc bug fixes (all except those mentioned so far).

For those who prefer github, the whole series is also available on
https://github.com/mwilck/multipath-tools/commits/upstream_170228

Best Regards,
Martin

Hannes Reinecke (15):
  multipathd.service: fixup Wants= and Before= statements
  multipathd: start daemon after udev trigger
  multipath: do not check daemon from udev rules
  Invalid error code when using multipathd CLI
  multipathd: set timeout for CLI commands correctly
  libmultipath: fall back to search paths by devt
  libmultipath: Do not crash on empty features
  multipathd: Set CLI timeout correctly
  multipath: avoid crash when using modified configuration
  multipathd: issue systemd READY after initial configuration
  libmultipath/discovery: do not cache 'access_state' sysfs attribute
  libmultipath: use existing alias from bindings file
  kpartx: sanitize delete partitions
  tur: Add pthread_testcancel()
  multipathd: fixup check for new path states

Martin Wilck (18):
  Add support for "multipath=off" and "nompath" on kernel cmdline
  multipath -ll: set DI_SERIAL
  libmultipath: move suspend logic to _dm_flush_map
  multipath: ignore -i if find_multipaths is set
  multipathd: imply -n if find_multipaths is set
  multipathd: use weaker "force_reload" at startup
  libmultipath: setup_features: log msg if queue_if_no_path is ignored
  libmultipath: setup_feature: print log msg if no_path_retry cant be
    set
  libmultipath: setup_feature: handle "retain_attached_hw_handler"
  libmultipath: disassemble_map: skip no_path_retry check
  libmultipath: disassemble_map: treat minio like assemble_map does
  libmultipath: select_action: check special features separately
  libmultipath: sysfs_attr_set_value: use const char*
  libmultipath: reload map if not known to udev
  libmultipath: differentiate ACT_NOTHING and ACT_IMPOSSIBLE
  libmultipath: coalesce_paths: trigger uevent if nothing done
  libmultipath/checkers: make RADOS checker optional
  Make libdmmp build optional

 Makefile                       |   6 +-
 Makefile.inc                   |   6 ++
 kpartx/devmapper.c             | 229 +++++++++++++++++++++++++++++++++++++++--
 kpartx/devmapper.h             |   7 +-
 kpartx/kpartx.c                |  44 ++------
 libmpathcmd/mpath_cmd.c        |   4 +
 libmpathcmd/mpath_cmd.h        |   2 +-
 libmultipath/alias.c           |   8 ++
 libmultipath/checkers/Makefile |   6 +-
 libmultipath/checkers/tur.c    |   1 +
 libmultipath/config.h          |   6 ++
 libmultipath/configure.c       | 117 +++++++++++++++++++--
 libmultipath/configure.h       |   1 +
 libmultipath/devmapper.c       | 102 ++++++++----------
 libmultipath/devmapper.h       |   9 +-
 libmultipath/discovery.c       |  19 ++--
 libmultipath/dmparser.c        |  26 +++--
 libmultipath/print.c           |   2 +-
 libmultipath/propsel.c         |   4 +-
 libmultipath/structs.c         |  39 ++++---
 libmultipath/sysfs.c           |   2 +-
 libmultipath/sysfs.h           |   2 +-
 libmultipath/util.c            |  59 +++++++++++
 libmultipath/util.h            |   1 +
 libmultipath/uxsock.c          |   9 +-
 multipath/main.c               |  37 ++++---
 multipath/multipath.rules      |   5 +
 multipathd/cli_handlers.c      |   3 +-
 multipathd/main.c              |  31 ++++--
 multipathd/multipathd.service  |  10 +-
 30 files changed, 603 insertions(+), 194 deletions(-)

-- 
2.11.0
