From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/2] multipath: Stop extra scans on stacked
	devices
Date: Wed, 12 Feb 2014 11:15:15 -0600
Message-ID: <1392225317-13898-1-git-send-email-bmarzins@redhat.com>
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

Whenever there is a DM_DEVICE_RESUME ioctl, a uevent is generated. Right now,
when multipath is reloading existing devices do to paths going or coming,
lvmetad will rescan those devices. This is unnecessary, and can cause a lot
of overhead. Also, multipath devices with no working paths will get scanned.
These patches make multipath set a new flag, DM_SUBSYSTEM_UDEV_FLAG0, when it
is reloading devices due to path changes, and lvmetad can safely ignore it.
They also add a new udev rules file, 11-dm-mpath.rules, to disable scanning
when it would not be useful.

Benjamin Marzinski (2):
  New udev rules to deal with stacked devices
  Mark reloads with udev flag

 Makefile.inc                |  1 +
 kpartx/devmapper.c          |  4 ++--
 kpartx/devmapper.h          |  8 +++++++-
 kpartx/kpartx.c             |  8 ++++----
 libmultipath/configure.c    |  4 ++--
 libmultipath/devmapper.c    | 26 ++++++++++++++------------
 libmultipath/devmapper.h    | 10 ++++++++--
 multipath/11-dm-mpath.rules | 34 ++++++++++++++++++++++++++++++++++
 multipath/Makefile          |  3 +++
 multipathd/cli_handlers.c   |  4 ++--
 10 files changed, 77 insertions(+), 25 deletions(-)
 create mode 100644 multipath/11-dm-mpath.rules

-- 
1.8.4.2
