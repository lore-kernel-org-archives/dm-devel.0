From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/4] misc multipath patches
Date: Mon,  8 Jun 2015 13:16:41 -0500
Message-ID: <1433787405-24716-1-git-send-email-bmarzins@redhat.com>
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

The first two of these patches attempt to make it easier for external
programs to communicate with multipathd. The first refactors the
multipathd interactive command code into a seperate library that other
programs can use.  The second patch makes the output a bit easier to
parse.

The third patch deals with a boot race that can happen on install or
first boot.

The last patch modifies my earlier "multipathd: use /run instead of /var/run"
patch to make in only apply if systemd is being used.

Benjamin Marzinski (4):
  Add libmpathcmd library and use it internally
  add raw format multipathd commands
  libmultipath: add ignore_new_boot_devs option
  Make use of /run depend on systemd

 Makefile                         |   1 +
 Makefile.inc                     |   2 +
 libmpathcmd/Makefile             |  30 +++++++
 libmpathcmd/mpath_cmd.c          | 178 +++++++++++++++++++++++++++++++++++++++
 libmpathcmd/mpath_cmd.h          | 125 +++++++++++++++++++++++++++
 libmpathpersist/Makefile         |   9 +-
 libmpathpersist/mpath_updatepr.c |  14 +--
 libmultipath/Makefile            |   3 +-
 libmultipath/config.c            |   4 +-
 libmultipath/config.h            |   1 +
 libmultipath/configure.c         |  13 ++-
 libmultipath/defaults.h          |   6 +-
 libmultipath/dict.c              |  12 +--
 libmultipath/print.c             |  25 +++---
 libmultipath/print.h             |   4 +-
 libmultipath/uxsock.c            |  73 ++++------------
 libmultipath/uxsock.h            |   5 +-
 libmultipath/wwids.c             |  21 +++--
 mpathpersist/Makefile            |   2 +-
 multipath/Makefile               |   5 +-
 multipath/main.c                 |   5 +-
 multipathd/Makefile              |   5 +-
 multipathd/cli.c                 |   5 +-
 multipathd/cli.h                 |   6 +-
 multipathd/cli_handlers.c        |  50 ++++++++---
 multipathd/cli_handlers.h        |   2 +
 multipathd/main.c                |   6 +-
 multipathd/uxclnt.c              |  13 ++-
 multipathd/uxlsnr.c              |  11 +--
 29 files changed, 489 insertions(+), 147 deletions(-)
 create mode 100644 libmpathcmd/Makefile
 create mode 100644 libmpathcmd/mpath_cmd.c
 create mode 100644 libmpathcmd/mpath_cmd.h

-- 
1.8.3.1
