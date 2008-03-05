From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 12/13] dm headers: adjust Makefile for dm-{io, log,
	kcopyd} standalone modules
Date: Wed,  5 Mar 2008 19:56:03 +0100
Message-ID: <1204743364-3248-13-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/Makefile linux-2.6.25-rc4/drivers/md/Makefile
index d9aa7ed..2e86b80 100644
--- linux-2.6.25-rc4.orig/drivers/md/Makefile
+++ linux-2.6.25-rc4/drivers/md/Makefile
@@ -3,10 +3,10 @@
 #
 
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o kcopyd.o
+		   dm-ioctl.o
 dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
-dm-mirror-objs	:= dm-log.o dm-raid1.o
+dm-mirror-objs	:= dm-raid1.o
 dm-rdac-objs	:= dm-mpath-rdac.o
 dm-hp-sw-objs	:= dm-mpath-hp-sw.o
 md-mod-objs     := md.o bitmap.o
@@ -39,7 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_MULTIPATH_HP)	+= dm-hp-sw.o
 obj-$(CONFIG_DM_MULTIPATH_RDAC)	+= dm-rdac.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
-obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
+obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-io.o dm-kcopyd.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
 quiet_cmd_unroll = UNROLL  $@
-- 
1.5.4.1
