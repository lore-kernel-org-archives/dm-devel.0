From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID:  allow metadata devices
Date: Mon, 23 May 2011 14:43:22 -0500
Message-ID: <201105231943.p4NJhMva018187@localhost6.localdomain6>
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

Add metadata device functionality to dm-raid.c

Add the ability to parse and use metadata devices.  Metadata
devices are not strictly required.  If they are provided, they are used
to store a superblock and bitmap.  Without the metadata area, many features of
RAID are not supported.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -148,9 +148,16 @@ static void context_free(struct raid_set
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++)
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		if (rs->dev[i].meta_dev)
+			dm_put_device(rs->ti, rs->dev[i].meta_dev);
+		if (rs->dev[i].rdev.sb_page)
+			put_page(rs->dev[i].rdev.sb_page);
+		rs->dev[i].rdev.sb_page = NULL;
+		rs->dev[i].rdev.sb_loaded = 0;
 		if (rs->dev[i].data_dev)
 			dm_put_device(rs->ti, rs->dev[i].data_dev);
+	}
 
 	kfree(rs);
 }
@@ -160,7 +167,15 @@ static void context_free(struct raid_set
  *  <meta_dev>: meta device name or '-' if missing
  *  <data_dev>: data device name or '-' if missing
  *
- * This code parses those words.
+ * The following are acceptable:
+ *    - -
+ *    - <data_dev>
+ *    <meta_dev> <data_dev>
+ * The following is not allowed:
+ *    <meta_dev> -
+ *
+ * This code parses those words.  If there is a failure,
+ * context_free must be used to unwind the operations.
  */
 static int dev_parms(struct raid_set *rs, char **argv)
 {
@@ -183,8 +198,16 @@ static int dev_parms(struct raid_set *rs
 		rs->dev[i].rdev.mddev = &rs->md;
 
 		if (strcmp(argv[0], "-")) {
-			rs->ti->error = "Metadata devices not supported";
-			return -EINVAL;
+			ret = dm_get_device(rs->ti, argv[0],
+					    dm_table_get_mode(rs->ti->table),
+					    &rs->dev[i].meta_dev);
+			rs->ti->error = "RAID metadata device lookup failure";
+			if (ret)
+				return ret;
+
+			rs->dev[i].rdev.sb_page = alloc_page(GFP_KERNEL);
+			if (!rs->dev[i].rdev.sb_page)
+				return -ENOMEM;
 		}
 
 		if (!strcmp(argv[1], "-")) {
@@ -194,6 +217,10 @@ static int dev_parms(struct raid_set *rs
 				return -EINVAL;
 			}
 
+			rs->ti->error = "No data device supplied with metadata device";
+			if (rs->dev[i].meta_dev)
+				return -EINVAL;
+
 			continue;
 		}
 
@@ -205,6 +232,10 @@ static int dev_parms(struct raid_set *rs
 			return ret;
 		}
 
+		if (rs->dev[i].meta_dev) {
+			metadata_available = 1;
+			rs->dev[i].rdev.meta_bdev = rs->dev[i].meta_dev->bdev;
+		}
 		rs->dev[i].rdev.bdev = rs->dev[i].data_dev->bdev;
 		list_add(&rs->dev[i].rdev.same_set, &rs->md.disks);
 		if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
@@ -321,12 +352,32 @@ static int parse_raid_params(struct raid
 	argv++;
 	num_raid_params--;
 
+	for (i = 0; i < rs->md.raid_disks; i++) {
+		/*
+		 * We set each individual device as In_sync with a
+		 * completed 'recovery_offset'.  This is always true
+		 * unless there has been a device failure/replacement.
+		 * In such an event, one of the following actions
+		 * will take place:
+		 * 1) User specifies 'rebuild'
+		 *    - device is reset when param is read
+		 * 2) a new device is supplied
+		 *    - MD doesn't find matching superblock and resets device
+		 * 3) device failure was transient and returns on reload
+		 *    - MD notices failure and resets device for bitmap replay
+		 * 4) device hadn't completed recovery after previous failure
+		 *    - MD reads superblock and overrides recovery_offset
+		 *
+		 * What is found in the superblocks of the devices is always
+		 * authoritative, unless 'rebuild' or '[no]sync' was specified.
+		 */
+		set_bit(In_sync, &rs->dev[i].rdev.flags);
+		rs->dev[i].rdev.recovery_offset = MaxSector;
+	}
+
 	/*
 	 * Second, parse the unordered optional arguments
 	 */
-	for (i = 0; i < rs->md.raid_disks; i++)
-		set_bit(In_sync, &rs->dev[i].rdev.flags);
-
 	for (i = 0; i < num_raid_params; i++) {
 		if (!strcmp(argv[i], "nosync")) {
 			rs->md.recovery_cp = MaxSector;
@@ -473,8 +524,6 @@ static int raid_is_congested(struct dm_t
  *	<raid_type> <#raid_params> <raid_params>		\
  *	<#raid_devs> { <meta_dev1> <dev1> .. <meta_devN> <devN> }
  *
- * ** metadata devices are not supported yet, use '-' instead **
- *
  * <raid_params> varies by <raid_type>.  See 'parse_raid_params' for
  * details on possible <raid_params>.
  */
@@ -672,7 +721,10 @@ static int raid_status(struct dm_target 
 
 		DMEMIT(" %d", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
-			DMEMIT(" -"); /* metadata device */
+			if (rs->dev[i].meta_dev)
+				DMEMIT(" %s", rs->dev[i].meta_dev->name);
+			else
+				DMEMIT(" -");
 
 			if (rs->dev[i].data_dev)
 				DMEMIT(" %s", rs->dev[i].data_dev->name);
@@ -729,6 +781,7 @@ static void raid_resume(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 
+	bitmap_load(&rs->md);
 	mddev_resume(&rs->md);
 }
 
