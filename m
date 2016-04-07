From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 00/18] Multipath patch sync
Date: Thu,  7 Apr 2016 18:19:54 -0500
Message-ID: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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

This is a resend of my previous batch of patches.  The only one that has
changed (besides in offsets) is patch 10 "multipathd: delay reloads during
creation". I renamed the config option "missing_uev_wait_timeout". When
it triggers, multipath will simply print a warning message and re-enable
reloads as if it had received the uevent.

I also added a new patch that adds a new keyword to the weightedpath
prioritizer, so that you can refer to paths in a persistent way.

Benjamin Marzinski (18):
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
  multipath: add wwn keyword to weightedpath prio

 Makefile                                 |   1 +
 Makefile.inc                             |  12 +-
 kpartx/devmapper.c                       |  17 ++-
 kpartx/devmapper.h                       |   2 +-
 kpartx/kpartx.c                          |  70 ++++++++++-
 libmpathcmd/Makefile                     |  30 +++++
 libmpathcmd/mpath_cmd.c                  | 178 +++++++++++++++++++++++++++
 libmpathcmd/mpath_cmd.h                  | 125 +++++++++++++++++++
 libmpathpersist/Makefile                 |   9 +-
 libmpathpersist/mpath_persist.c          |   2 +-
 libmpathpersist/mpath_updatepr.c         |  14 +--
 libmultipath/Makefile                    |   5 +-
 libmultipath/config.c                    |   7 +-
 libmultipath/config.h                    |   5 +
 libmultipath/configure.c                 |  20 +--
 libmultipath/defaults.h                  |   6 +-
 libmultipath/devmapper.c                 |  46 +++++--
 libmultipath/devmapper.h                 |   2 +-
 libmultipath/dict.c                      |  20 ++-
 libmultipath/discovery.c                 |  28 +++--
 libmultipath/discovery.h                 |   2 +
 libmultipath/print.c                     |  25 ++--
 libmultipath/print.h                     |   4 +
 libmultipath/prioritizers/alua.c         |  44 ++++---
 libmultipath/prioritizers/alua_rtpg.c    |  69 +++++++----
 libmultipath/prioritizers/alua_rtpg.h    |   2 +-
 libmultipath/prioritizers/weightedpath.c |  37 ++++++
 libmultipath/prioritizers/weightedpath.h |   1 +
 libmultipath/propsel.c                   |   2 +-
 libmultipath/structs.h                   |  10 ++
 libmultipath/uxsock.c                    |  73 +++--------
 libmultipath/uxsock.h                    |   5 +-
 libmultipath/wwids.c                     |  19 +--
 mpathpersist/Makefile                    |   2 +-
 multipath.conf.defaults                  |   1 +
 multipath/Makefile                       |   5 +-
 multipath/main.c                         |   6 +-
 multipath/multipath.conf.5               |  36 +++++-
 multipathd/Makefile                      |   5 +-
 multipathd/cli.c                         |  22 ++--
 multipathd/cli.h                         |  20 +--
 multipathd/cli_handlers.c                |  73 ++++++++---
 multipathd/main.c                        | 205 ++++++++++++++++++++++++++-----
 multipathd/main.h                        |   1 +
 multipathd/multipathd.8                  |   4 +
 multipathd/multipathd.init.suse          |   2 +-
 multipathd/multipathd.service            |   3 +-
 multipathd/uxclnt.c                      |  13 +-
 multipathd/uxlsnr.c                      |  11 +-
 49 files changed, 1031 insertions(+), 270 deletions(-)
 create mode 100644 libmpathcmd/Makefile
 create mode 100644 libmpathcmd/mpath_cmd.c
 create mode 100644 libmpathcmd/mpath_cmd.h

-- 
1.8.3.1
