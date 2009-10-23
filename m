From: heinzm@redhat.com
Subject: [PATCH 5/6] dm-replicator: adjust Kconfig and Makefile
Date: Fri, 23 Oct 2009 17:16:56 +0200
Message-ID: <1256311017-11291-6-git-send-email-heinzm@redhat.com>
References: <1256311017-11291-1-git-send-email-heinzm@redhat.com>
	<1256311017-11291-2-git-send-email-heinzm@redhat.com>
	<1256311017-11291-3-git-send-email-heinzm@redhat.com>
	<1256311017-11291-4-git-send-email-heinzm@redhat.com>
	<1256311017-11291-5-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256311017-11291-5-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Allow for configuration and build of the remote replication target.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 drivers/md/Kconfig  |    8 ++++++++
 drivers/md/Makefile |    5 +++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2158377..f763ff2 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
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
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 1dc4185..5c7d8f5 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
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
       cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
-- 
1.6.2.5
