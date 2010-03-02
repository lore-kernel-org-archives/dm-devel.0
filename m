From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 13/14] dm-multisnap-mikulas-config
Date: Mon,  1 Mar 2010 19:23:57 -0500
Message-ID: <1267489438-6271-14-git-send-email-snitzer@redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Add the exception store to Kconfig and Makefile.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/Kconfig  |    9 +++++++++
 drivers/md/Makefile |    6 ++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index c3b55a8..0c3ce3b 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -259,6 +259,15 @@ config DM_MULTISNAPSHOT
 	  A submenu allows to select a specific shared snapshot store
 	  driver.
 
+config DM_MULTISNAPSHOT_MIKULAS
+	tristate "Mikulas' snapshot store"
+	depends on DM_MULTISNAPSHOT
+	---help---
+	  Mikulas Patocka's snapshot store.
+
+	  A B+-tree-based log-structured storage allowing unlimited
+	  number of snapshots.
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 674649c..084d632 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -8,6 +8,11 @@ dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
 dm-multisnapshot-y += dm-multisnap.o
+dm-store-mikulas-y += dm-multisnap-mikulas.o dm-multisnap-alloc.o \
+		   dm-multisnap-blocks.o dm-multisnap-btree.o \
+		   dm-multisnap-commit.o dm-multisnap-delete.o \
+		   dm-multisnap-freelist.o dm-multisnap-io.o \
+		   dm-multisnap-snaps.o dm-bufio.o
 dm-mirror-y	+= dm-raid1.o
 dm-log-userspace-y \
 		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
@@ -43,6 +48,7 @@ obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
 obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MULTISNAPSHOT)	+= dm-multisnapshot.o
+obj-$(CONFIG_DM_MULTISNAPSHOT_MIKULAS) += dm-store-mikulas.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
-- 
1.6.5.2
