From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 13 of 15] dm raid allow metadata devices
Date: Fri, 3 Dec 2010 13:55:52 -0600
Message-ID: <201012031955.oB3Jtq7j003709@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-raid-allow-metadata-devices.patch

Add the ability to parse and use metadata devices.  Metadata
devices are not required.  If they are provided, they are used
to store a (minimal) superblock and bitmap.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -7,6 +7,7 @@
 #include "md.h"
 #include "raid5.h"
 #include "dm.h"
+#include "bitmap.h"
 
 #define DM_MSG_PREFIX "raid"
 
@@ -32,6 +33,13 @@ struct raid_set {
 	struct dm_target *ti;
 	struct mddev_s md;
 	struct raid_type *raid_type;
+
+	enum sync {
+		DEFAULTSYNC,    /* Synchronize if necessary */
+		NOSYNC,         /* Devices known to be already in sync */
+		FORCESYNC,      /* Force a sync to happen */
+	} sync;
+
 	struct target_callbacks callbacks;
 	struct raid_dev dev[0];
 };
@@ -115,6 +123,12 @@ static void context_free(struct raid_set
 {
 	int i;
 	for (i = 0; i < rs->md.raid_disks; i++) {
+		if (rs->dev[i].meta_dev)
+			dm_put_device(rs->ti, rs->dev[i].meta_dev);
+		if (rs->dev[i].rdev.sb_page)
+			put_page(rs->dev[i].rdev.sb_page);
+		rs->dev[i].rdev.sb_page = NULL;
+		rs->dev[i].rdev.sb_loaded = 0;
 		if (rs->dev[i].data_dev)
 			dm_put_device(rs->ti, rs->dev[i].data_dev);
 	}
@@ -125,11 +139,20 @@ static void context_free(struct raid_set
  *  <meta_dev>: meta device name or '-' if missing
  *  <data_dev>: data device name or '-' if missing
  *
- * This code parses those words.
+ * The following are acceptable:
+ *	- -
+ *	- <data_dev>
+ *	<meta_dev> <data_dev>
+ * The following is not allowed:
+ *	<meta_dev> -
+ *
+ * This code parses those words.  If there is a failure,
+ * context_free must be used to unwind the operations.
  */
 static int dev_parms(struct raid_set *rs, char **argv)
 {
 	int i;
+	int metadata_available = 0;
 
 	for (i = 0; i < rs->md.raid_disks; i++, argv += 2) {
 		int err = 0;
@@ -147,8 +170,16 @@ static int dev_parms(struct raid_set *rs
 		rs->dev[i].rdev.mddev = &rs->md;
 
 		if (strcmp(argv[0], "-") != 0) {
-			rs->ti->error = "Metadata devices not supported";
-			return -EINVAL;
+			err = dm_get_device(rs->ti, argv[0],
+					    dm_table_get_mode(rs->ti->table),
+					    &rs->dev[i].meta_dev);
+			rs->ti->error = "RAID metadata device lookup failure";
+			if (err)
+				return err;
+
+			rs->dev[i].rdev.sb_page = alloc_page(GFP_KERNEL);
+			if (!rs->dev[i].rdev.sb_page)
+				return -ENOMEM;
 		}
 
 		if (strcmp(argv[1], "-") == 0) {
@@ -157,6 +188,10 @@ static int dev_parms(struct raid_set *rs
 			    (rs->dev[i].rdev.recovery_offset == 0))
 				return -EINVAL;
 
+			rs->ti->error = "No data device supplied with metadata device";
+			if (rs->dev[i].meta_dev)
+				return -EINVAL;
+
 			continue;
 		}
 
@@ -167,10 +202,44 @@ static int dev_parms(struct raid_set *rs
 		if (err)
 			return err;
 
+		if (rs->dev[i].meta_dev) {
+			metadata_available = 1;
+			rs->dev[i].rdev.meta_bdev = rs->dev[i].meta_dev->bdev;
+		}
 		rs->dev[i].rdev.bdev = rs->dev[i].data_dev->bdev;
 		list_add(&rs->dev[i].rdev.same_set, &rs->md.disks);
 	}
 
+	if (metadata_available) {
+		rs->md.external = 0;
+		rs->md.persistent = 1;
+		rs->md.major_version = 2;
+	}
+	/*
+	 * Now we know if there were any metadata devices specified.
+	 * DEFAULTSYNC is to perform the sync if there are no metadata
+	 * devices, but to defer judgement (not perform the sync) if
+	 * there are metadata devices.
+	 *
+	 * FIXME: make sure we don't need to make further adjustments if
+	 *        there are devices to rebuild (that should be handled
+	 *        independently by rdev's recovery_offset)
+	 */
+	switch (rs->sync) {
+	case NOSYNC:
+		rs->md.recovery_cp = MaxSector;
+		break;
+	case FORCESYNC:
+		rs->md.recovery_cp = 0;
+		break;
+	case DEFAULTSYNC:
+		rs->md.recovery_cp = (metadata_available) ? MaxSector : 0;
+		break;
+	default:
+		BUG();
+	}
+
+
 	rs->ti->error = NULL;
 	return 0;
 }
@@ -228,17 +297,27 @@ static int parse_raid_params(struct raid
 		return -EINVAL;
 
 	rs->ti->error = "Bad RAID option";
+	/*
+	 * Default behavior is to treat as in-sync
+	 * FIXME: Might be better to default to MaxSector
+	 *        if there are metadata disks, but 0 otherwise
+	 */
+	rs->sync = DEFAULTSYNC;
 	if (num_raid_params) {
 		if (!strcmp(argv[0], "nosync"))
-			rs->md.recovery_cp = MaxSector;
+			rs->sync = NOSYNC;
 		else if (!strcmp(argv[0], "sync"))
-			rs->md.recovery_cp = 0;
-		else
+			rs->sync = FORCESYNC;
+		else /* No other valid options yet */
 			return -EINVAL;
 	}
 
-	rs->md.persistent = 0;
+	/*
+	 * These will be adjusted in dev_parms if
+	 * metadata devices are provided.
+	 */
 	rs->md.external = 1;
+	rs->md.persistent = 0;
 
 	rs->ti->error = NULL;
 	return 0;
@@ -272,8 +351,6 @@ static void raid_unplug(void *v)
  *	<raid_type> <#raid_params> <raid_params>		\
  *	<#raid_devs> { <meta_dev1> <dev1> .. <meta_devN> <devN> }
  *
- * ** metadata devices are not supported yet, use '-' instead **
- *
  * <raid_params> varies by <raid_type>.  See 'parse_raid_params' for
  * details on possible <raid_params>.
  */
@@ -442,7 +519,10 @@ static int raid_status(struct dm_target 
 
 		DMEMIT("%d ", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
-			DMEMIT("- "); /* metadata device */
+			if (rs->dev[i].meta_dev)
+				DMEMIT("%s ", rs->dev[i].meta_dev->name);
+			else
+				DMEMIT("- ");
 
 			if (rs->dev[i].data_dev)
 				DMEMIT("%s ", rs->dev[i].data_dev->name);
@@ -501,6 +581,7 @@ static void raid_resume(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 
+	bitmap_load(&rs->md);
 	mddev_resume(&rs->md);
 }
 
