From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/13] systemd integraion
Date: Fri, 15 Nov 2013 11:29:31 +0100
Message-ID: <1384511384-27642-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

this is a patch series for proper systemd integration.
Main idea is to have the CLI socket controlled by systemd,
so that the daemon will be started automatically if someone
calls 'multipathd -kSomething'.
The neat thing with this is that we can use the systemd-provided
watchdog to detect stalls in checkerloop(), which always have
been bitten us in the past and are really hard to diagnose
remotely.
Plus with socket activation we can now safely implement a
'one-shot' mode, where the daemon exits if no maps are discovered.
Which means that we can enable the socket always, and don't
have to worry about a daemon sitting in the background eating
up resources and doing nothing.
Oh. And some general fixes, too.

Hannes Reinecke (13):
  Improve logging for orphan_path()
  Set priority to '0' for PATH_BLOCKED or PATH_DOWN
  libmultipath: fixup strlcpy
  libmultipath: return error numbers from sysfs_get_XXX
  libmultipath: do not stall on recv_packet()
  multipathd: switch to socket activation for systemd
  multipathd: use sd_notify() to inform systemd
  multipathd: Add option '-s' to suppress timestamps
  multipathd: Implement systemd watchdog integration
  multipathd: enable core dumps for systemd
  multipathd: Read environment variables from systemd
  multipathd: measure path check time
  multipathd: no_map_shutdown option

 libmultipath/Makefile         |  2 +-
 libmultipath/config.h         |  1 +
 libmultipath/configure.c      |  4 +-
 libmultipath/debug.c          | 17 ++++----
 libmultipath/devmapper.c      | 16 ++++----
 libmultipath/dict.c           | 32 +++++++++++++++
 libmultipath/discovery.c      | 43 +++++++++++---------
 libmultipath/discovery.h      |  2 +-
 libmultipath/propsel.c        |  2 +-
 libmultipath/structs_vec.c    |  9 ++---
 libmultipath/structs_vec.h    |  2 +-
 libmultipath/util.c           |  3 +-
 libmultipath/uxsock.c         | 41 +++++++++++++++++--
 multipath.conf.annotated      |  9 +++++
 multipath/multipath.conf.5    | 14 ++++++-
 multipathd/Makefile           |  4 +-
 multipathd/main.c             | 94 ++++++++++++++++++++++++++++++++++---------
 multipathd/multipathd.8       | 11 ++++-
 multipathd/multipathd.service | 10 +++--
 multipathd/multipathd.socket  |  5 +++
 multipathd/uxclnt.c           |  4 +-
 multipathd/uxlsnr.c           |  4 +-
 22 files changed, 245 insertions(+), 84 deletions(-)
 create mode 100644 multipathd/multipathd.socket

-- 
1.8.1.4
