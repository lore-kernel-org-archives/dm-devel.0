From: heinzm@redhat.com
Subject: [PATCH v2 5/5] dm-replicator: export dm_disk needed
	symbol and adjust Kconfig+Makefile
Date: Thu, 26 Nov 2009 13:29:52 +0100
Message-ID: <1259238592-12439-6-git-send-email-heinzm@redhat.com>
References: <1259238592-12439-1-git-send-email-heinzm@redhat.com>
	<1259238592-12439-2-git-send-email-heinzm@redhat.com>
	<1259238592-12439-3-git-send-email-heinzm@redhat.com>
	<1259238592-12439-4-git-send-email-heinzm@redhat.com>
	<1259238592-12439-5-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259238592-12439-5-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Export dm_disk symbol needed by the site link "blockdev"
(dm-repl-slink-blockdev.c) module to identify  devices.

Allow for configuration and build of the remote replication target
with its registry, replication log and site link modules.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Reviewed-by: Jon Brassow <jbrassow@redhat.com>
Tested-by: Jon Brassow <jbrassow@redhat.com>
---
 drivers/md/Kconfig  |    8 ++++++++
 drivers/md/Makefile |    5 +++++
 drivers/md/dm.c     |    1 +
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git linux-2.6.orig/drivers/md/Kconfig linux-2.6/drivers/md/Kconfig
index 2158377..f763ff2 100644
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -320,4 +320,12 @@ config DM_UEVENT
 	---help---
 	Generate udev events for DM events.
 
+config DM_REPLICATOR
+	tristate "Replication target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	A target that supports replication of local devices to remote sites.
+
+	If unsure, say N.
+
 endif # MD
diff --git linux-2.6.orig/drivers/md/Makefile linux-2.6/drivers/md/Makefile
index e355e7f..b4389b8 100644
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -8,6 +8,7 @@ dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
 dm-mirror-y	+= dm-raid1.o
+dm-replicator-objs	:= dm-repl.o
 dm-log-userspace-y \
 		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
 md-mod-y	+= md.o bitmap.o
@@ -44,6 +45,10 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_REPLICATOR)	+= dm-replicator.o \
+				   dm-repl-log-ringbuffer.o \
+				   dm-repl-slink-blockdev.o \
+				   dm-log.o dm-registry.o
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
diff --git linux-2.6.orig/drivers/md/dm.c linux-2.6/drivers/md/dm.c
index 724efc6..901b95e 100644
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -2573,6 +2573,7 @@ struct gendisk *dm_disk(struct mapped_device *md)
 {
 	return md->disk;
 }
+EXPORT_SYMBOL_GPL(dm_disk);
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-- 
1.6.2.5
