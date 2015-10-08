From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/18] multipath patch sync
Date: Thu,  8 Oct 2015 14:44:33 -0500
Message-ID: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Here are a number of my patches that haven't been applied upstream yet.
All of them except the last four are just resends of patches I've
submitted earlier. Out of the last four, only the very last is a new
feature, which was discussed a couple of months ago.

Benjamin Marzinski (18):
  libmultipath: Add prioritizer context data
  fix memory leaks on realloc failures
  multipathd: use /run instead of /var/run
  retrigger uevents to try and get the uid through udev
  update multipath rules to deal with partition devices
  change order of multipath.rules
  make kpartx -d remove all partitions
  Fix issues with user_friendly_names initramfs bindings
  Make multipath deactivate devices before iscsi shutdown
  resize reply buffer for mutipathd help message
  Add libmpathcmd library and use it internally
  add raw format multipathd commands
  libmultipath: add ignore_new_boot_devs option
  Make use of /run depend on systemd
  libmpathpersist: uninstall man page correctly
  Increase host buffer size
  Fix sun partition numbering
  Make multipath ignore devices without mpath prefix

 Makefile                                 |   1 +
 Makefile.inc                             |   2 +
 kpartx/kpartx.c                          |   4 +-
 kpartx/sun.c                             |   2 -
 libmpathcmd/Makefile                     |  30 ++++++
 libmpathcmd/mpath_cmd.c                  | 178 +++++++++++++++++++++++++++++++
 libmpathcmd/mpath_cmd.h                  | 125 ++++++++++++++++++++++
 libmpathpersist/Makefile                 |  13 +--
 libmpathpersist/mpath_persist.c          |   4 +-
 libmpathpersist/mpath_updatepr.c         |  14 +--
 libmultipath/Makefile                    |   3 +-
 libmultipath/config.c                    |  10 +-
 libmultipath/config.h                    |   4 +
 libmultipath/configure.c                 |  16 +--
 libmultipath/defaults.h                  |  10 +-
 libmultipath/devmapper.c                 |  67 ++++++++----
 libmultipath/devmapper.h                 |   1 +
 libmultipath/dict.c                      |  24 ++++-
 libmultipath/discovery.c                 |  28 ++---
 libmultipath/dmparser.c                  |   6 +-
 libmultipath/print.c                     |  25 +++--
 libmultipath/print.h                     |   4 +-
 libmultipath/prio.c                      |  34 +++++-
 libmultipath/prio.h                      |   7 ++
 libmultipath/prioritizers/alua.c         |  58 +++++++---
 libmultipath/prioritizers/alua_rtpg.c    |  22 +++-
 libmultipath/prioritizers/alua_rtpg.h    |   4 +-
 libmultipath/prioritizers/const.c        |   4 +
 libmultipath/prioritizers/datacore.c     |   3 +
 libmultipath/prioritizers/def_func.h     |  11 ++
 libmultipath/prioritizers/emc.c          |   4 +
 libmultipath/prioritizers/hds.c          |   4 +
 libmultipath/prioritizers/hp_sw.c        |   4 +
 libmultipath/prioritizers/iet.c          |   4 +
 libmultipath/prioritizers/ontap.c        |   4 +
 libmultipath/prioritizers/random.c       |   4 +
 libmultipath/prioritizers/rdac.c         |   4 +
 libmultipath/prioritizers/weightedpath.c |   3 +
 libmultipath/propsel.c                   |   4 +-
 libmultipath/structs.h                   |  10 +-
 libmultipath/util.c                      |  30 ++++++
 libmultipath/util.h                      |   1 +
 libmultipath/uxsock.c                    |  73 +++----------
 libmultipath/uxsock.h                    |   5 +-
 libmultipath/wwids.c                     |  21 ++--
 mpathpersist/Makefile                    |   2 +-
 multipath/Makefile                       |   9 +-
 multipath/main.c                         |  14 ++-
 multipath/multipath.rules                |  16 ++-
 multipathd/Makefile                      |   5 +-
 multipathd/cli.c                         |  93 +++++++++++-----
 multipathd/cli.h                         |  22 +++-
 multipathd/cli_handlers.c                | 108 +++++++++----------
 multipathd/cli_handlers.h                |   2 +
 multipathd/main.c                        |  57 ++++++----
 multipathd/multipathd.init.suse          |   2 +-
 multipathd/multipathd.service            |   1 +
 multipathd/uxclnt.c                      |  13 ++-
 multipathd/uxlsnr.c                      |  30 ++++--
 59 files changed, 951 insertions(+), 312 deletions(-)
 create mode 100644 libmpathcmd/Makefile
 create mode 100644 libmpathcmd/mpath_cmd.c
 create mode 100644 libmpathcmd/mpath_cmd.h
 create mode 100644 libmultipath/prioritizers/def_func.h

-- 
1.8.3.1
