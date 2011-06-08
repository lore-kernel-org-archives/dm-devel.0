From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 7] DM RAID:  add region_size param
Date: Wed, 08 Jun 2011 17:17:15 -0500
Message-ID: <1307571435.18638.7.camel@f14.redhat.com>
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

Allow the user to specify region_size.  Ensure that the supplied value meets
MD's constraints that the number of regions does not exceed 2^21.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -51,7 +51,7 @@ struct raid_dev {
 #define DMPF_MAX_RECOVERY_RATE 0x20
 #define DMPF_MAX_WRITE_BEHIND  0x40
 #define DMPF_STRIPE_CACHE      0x80
-
+#define DMPF_REGION_SIZE       0X100
 struct raid_set {
 	struct dm_target *ti;
 
@@ -236,6 +236,65 @@ static int dev_parms(struct raid_set *rs
 }
 
 /*
+ * validate_region_size
+ * @rs
+ * @region_size:  region size in sectors.  If 0, pick a size (4MiB default)
+ *
+ * Set rs->md.bitmap_info.chunksize (which really refers to 'region size')
+ * Ensure that (ti->len/region_size < 2^21) - required by MD bitmap
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ */
+static int validate_region_size(struct raid_set *rs, unsigned long region_size)
+{
+	unsigned long min_region_size = rs->ti->len / (1 << 21);
+
+	if (!region_size) {
+		/* Pick a reasonable default - Math in sectors */
+
+		if (min_region_size > (1 << 13)) {
+			DMINFO("Choosing default region size of %lu sectors",
+			       region_size);
+			rs->md.bitmap_info.chunksize = min_region_size;
+		} else {
+			DMINFO("Choosing default region size of 4MiB");
+			rs->md.bitmap_info.chunksize = 1 << 13; /* sectors */
+		}
+	} else {
+		/* User-supplied value - validate it */
+
+		if (region_size > rs->ti->len) {
+			rs->ti->error = "Supplied region size is too large";
+			return -EINVAL;
+		}
+
+		if (region_size < min_region_size) {
+			DMERR("Supplied region_size = %lu (Min = %lu)",
+			      region_size, min_region_size);
+			rs->ti->error = "Supplied region size is too small";
+			return -EINVAL;
+		}
+
+		if (!is_power_of_2(region_size)) {
+			rs->ti->error = "Region size is not a power of 2";
+			return -EINVAL;
+		}
+
+		if (region_size < rs->md.chunk_sectors) {
+			rs->ti->error = "Region size is smaller than the chunk size";
+			return -EINVAL;
+		}
+		rs->md.bitmap_info.chunksize = region_size;
+	}
+
+	/* Convert to Bytes */
+	rs->md.bitmap_info.chunksize <<= 9;
+
+	return 0;
+}
+
+
+/*
  * Possible arguments are...
  * RAID456:
  *	<chunk_size> [optional_args]
@@ -248,12 +307,13 @@ static int dev_parms(struct raid_set *rs
  *    [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
  *    [max_write_behind <sectors>]	See '-write-behind=' (man mdadm)
  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
+ *    [region_size <sectors>]           Defines granularity of bitmap
  */
 static int parse_raid_params(struct raid_set *rs, char **argv,
 			     unsigned num_raid_params)
 {
 	unsigned i, rebuild_cnt = 0;
-	unsigned long value;
+	unsigned long value, region_size = 0;
 	char *key;
 
 	/*
@@ -364,6 +424,9 @@ static int parse_raid_params(struct raid
 				return -EINVAL;
 			}
 			rs->md.sync_speed_max = (int)value;
+		} else if (!strcmp(key, "region_size")) {
+			rs->print_flags |= DMPF_REGION_SIZE;
+			region_size = value;
 		} else {
 			DMERR("Unable to parse RAID parameter: %s", key);
 			rs->ti->error = "Unable to parse RAID parameters";
@@ -371,6 +434,14 @@ static int parse_raid_params(struct raid
 		}
 	}
 
+	if (validate_region_size(rs, region_size))
+		return -EINVAL;
+
+	if (rs->md.chunk_sectors)
+		rs->ti->split_io = rs->md.chunk_sectors;
+	else
+		rs->ti->split_io = region_size;
+
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
 	rs->md.external = 1;
@@ -468,7 +539,6 @@ static int raid_ctr(struct dm_target *ti
 		goto bad;
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
-	ti->split_io = rs->md.chunk_sectors;
 	ti->private = rs;
 
 	mutex_lock(&rs->md.reconfig_mutex);
@@ -566,7 +636,6 @@ static int raid_status(struct dm_target 
 			DMEMIT(" sync");
 		if (rs->print_flags & DMPF_NOSYNC)
 			DMEMIT(" nosync");
-
 		for (i = 0; i < rs->md.raid_disks; i++)
 			if ((rs->print_flags & DMPF_REBUILD) &&
 			    rs->dev[i].data_dev &&
@@ -594,6 +663,9 @@ static int raid_status(struct dm_target 
 			DMEMIT(" stripe_cache %d",
 			       conf ? conf->max_nr_stripes * 2 : 0);
 		}
+		if (rs->print_flags & DMPF_REGION_SIZE)
+			DMEMIT(" region_size %lu",
+			       rs->md.bitmap_info.chunksize >> 9);
 
 		DMEMIT(" %d", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
Index: linux-2.6/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-2.6.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-2.6/Documentation/device-mapper/dm-raid.txt
@@ -35,6 +35,9 @@ The possible parameters are as follows:
  [max_recovery_rate <kB/sec/disk>]      Throttle RAID initialization
  [max_write_behind <sectors>]           See '-write-behind=' (man mdadm)
  [stripe_cache <sectors>]               Stripe cache size for higher RAIDs
+ [region_size <sectors>]	Array_size / region_size = # of regions.  A
+ 	      			region is the granularity at which the bitmap
+				tracks whether a device is in-sync or not.
 
 Line 3 contains the list of devices that compose the array in
 metadata/data device pairs.  If the metadata is stored separately, a '-'
