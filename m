From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/17] Multipath patch sync
Date: Mon, 28 Mar 2016 22:12:57 -0500
Message-ID: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Here's a bunch of miscellaneous multipath patches. The first couple are
resends, with the following changes:

multipathd: use /run instead of /var/run
-----------------------------------------
Added Makefile code to verify that /var/run is actually a symlink 

retrigger uevents to try and get the uid through udev
-----------------------------------------------------
This is the same as before. There is no good udev hint to use here. If
the whole udev worker thread is killed, udev sends an empty uevent, which
we could check for, but if a killable callout takes too long, udev with
just not run any later callouts, and not flag this in any way. So if we're
just missing the id information, there's no way to know why.

Fix issues with user_friendly_names initramfs bindings
------------------------------------------------------
This no longer has the initramfs checking code. Instead it just fixes
the -B option to make it actually work with multipathd.

Add libmpathcmd library and use it internally
---------------------------------------------
This is the same as before. As far as I know, there were no objections
to it last time.

libmultipath: add ignore_new_boot_devs option
---------------------------------------------
This also no longer uses the initramfs checking code. It is simply a
commandline option.

libmultipath: Cut down on alua prioritizer ioctls
-------------------------------------------------
This now uses the sysfs files, as Hannes suggested.


The rest of the patches are new. Please apply.
Thanks.

Benjamin Marzinski (17):
  multipathd: use /run instead of /var/run
  retrigger uevents to try and get the uid through udev
  Fix issues with user_friendly_names initramfs bindings
  Add libmpathcmd library and use it internally
  libmultipath: add ignore_new_boot_devs option
  libmultipath: fix PAD and PRINT macros
  libmultipath: Cut down on alua prioritizer ioctls
  multipathd: fail if pidfile can't be created
  libmultipath: check correct function for define
  multipathd: delay reloads during creation
  multipath: Fix minor text issues
  kpartx: verify partition devices
  multipath: add exclusive_pref_bit for alua prio
  multipathd: print "fail" when remove fails
  multipath: check partitions unused before removing
  multipathd.service: remove blk-availability Requires
  multipathd: use 64-bit int for command key

 Makefile                              |   1 +
 Makefile.inc                          |  12 ++-
 kpartx/devmapper.c                    |  17 ++-
 kpartx/devmapper.h                    |   2 +-
 kpartx/kpartx.c                       |  70 ++++++++++++-
 libmpathcmd/Makefile                  |  30 ++++++
 libmpathcmd/mpath_cmd.c               | 178 +++++++++++++++++++++++++++++++
 libmpathcmd/mpath_cmd.h               | 125 ++++++++++++++++++++++
 libmpathpersist/Makefile              |   9 +-
 libmpathpersist/mpath_persist.c       |   2 +-
 libmpathpersist/mpath_updatepr.c      |  14 +--
 libmultipath/Makefile                 |   5 +-
 libmultipath/config.c                 |   7 +-
 libmultipath/config.h                 |   5 +
 libmultipath/configure.c              |  20 ++--
 libmultipath/defaults.h               |   6 +-
 libmultipath/devmapper.c              |  46 ++++++--
 libmultipath/devmapper.h              |   2 +-
 libmultipath/dict.c                   |  20 +++-
 libmultipath/discovery.c              |  28 ++---
 libmultipath/discovery.h              |   2 +
 libmultipath/print.c                  |  17 ++-
 libmultipath/prioritizers/alua.c      |  44 +++++---
 libmultipath/prioritizers/alua_rtpg.c |  69 ++++++++----
 libmultipath/prioritizers/alua_rtpg.h |   2 +-
 libmultipath/propsel.c                |   2 +-
 libmultipath/structs.h                |  10 ++
 libmultipath/uxsock.c                 |  73 +++----------
 libmultipath/uxsock.h                 |   5 +-
 libmultipath/wwids.c                  |  19 ++--
 mpathpersist/Makefile                 |   2 +-
 multipath.conf.defaults               |   1 +
 multipath/Makefile                    |   5 +-
 multipath/main.c                      |   6 +-
 multipath/multipath.conf.5            |  29 ++++-
 multipathd/Makefile                   |   5 +-
 multipathd/cli.c                      |  22 ++--
 multipathd/cli.h                      |  20 ++--
 multipathd/cli_handlers.c             |  73 ++++++++++---
 multipathd/main.c                     | 192 ++++++++++++++++++++++++++++------
 multipathd/main.h                     |   1 +
 multipathd/multipathd.8               |   4 +
 multipathd/multipathd.init.suse       |   2 +-
 multipathd/multipathd.service         |   3 +-
 multipathd/uxclnt.c                   |  13 ++-
 multipathd/uxlsnr.c                   |  11 +-
 46 files changed, 966 insertions(+), 265 deletions(-)
 create mode 100644 libmpathcmd/Makefile
 create mode 100644 libmpathcmd/mpath_cmd.c
 create mode 100644 libmpathcmd/mpath_cmd.h

-- 
1.8.3.1
