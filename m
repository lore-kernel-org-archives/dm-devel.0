From: heinzm@redhat.com
Subject: [PATCH 6/6] dm raid45 target: add raid45 modules to
 Makefile and adjust Kconfig
Date: Mon, 15 Jun 2009 19:21:20 +0200
Message-ID: <4a368310./SfyJd7gH/o3WhnF%heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
List-Id: dm-devel.ids


This patch adjusts Makefile and Kconfig.

Heinz

 drivers/md/{Makefile.orig => Makefile} |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Makefile.orig b/drivers/md/Makefile
index 45cc595..92541a2 100644
--- a/drivers/md/Makefile.orig
+++ b/drivers/md/Makefile
@@ -39,6 +39,9 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_RAID45)		+= dm-raid45.o dm-log.o dm-memcache.o \
+				   dm-region-hash.o dm-message.o
+
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
 drivers/md/{Kconfig.orig => Kconfig} |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Kconfig.orig b/drivers/md/Kconfig
index 36e0675..a6d0f87 100644
--- a/drivers/md/Kconfig.orig
+++ b/drivers/md/Kconfig
@@ -264,4 +264,13 @@ config DM_UEVENT
 	---help---
 	Generate udev events for DM events.
 
+config DM_RAID45
+	tristate "RAID 4/5 target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	select ASYNC_XOR
+	---help---
+	A target that supports RAID4 and RAID5 mappings.
+
+	If unsure, say N.
+
 endif # MD
