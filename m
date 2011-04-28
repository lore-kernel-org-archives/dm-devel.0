From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID:  add region_size param
Date: Thu, 28 Apr 2011 14:10:13 -0500
Message-ID: <201104281910.p3SJADWK029447@localhost6.localdomain6>
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

Patch name: dm-raid-add-region_size-param.patch

Allow the user to specify region_size.  Ensure that the supplied value meets
MD's constraints that the number of regions does not exceed 2^21.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -50,6 +50,7 @@ struct raid_dev {
 #define DMPF_STRIPE_CACHE      0x10
 #define DMPF_MIN_RECOVERY_RATE 0x20
 #define DMPF_MAX_RECOVERY_RATE 0x40
+#define DMPF_REGION_SIZE       0x80
 
 struct raid_set {
 	struct dm_target *ti;
@@ -235,6 +236,56 @@ static int dev_parms(struct raid_set *rs
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
@@ -247,12 +298,13 @@ static int dev_parms(struct raid_set *rs
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
@@ -362,6 +414,13 @@ static int parse_raid_params(struct raid
 				return -EINVAL;
 			}
 			rs->md.sync_speed_max = (int)value;
+		} else if (!strcmp(key, "region_size")) {
+			rs->print_flags |= DMPF_REGION_SIZE;
+			region_size = value;
+			if (!is_power_of_2(region_size)) {
+				rs->ti->error = "Region size is not a power of 2";
+				return -EINVAL;
+			}
 		} else {
 			DMERR("Unable to parse RAID parameter: %s", key);
 			rs->ti->error = "Unable to parse RAID parameters";
@@ -369,6 +428,9 @@ static int parse_raid_params(struct raid
 		}
 	}
 
+	if (validate_region_size(rs, region_size))
+		return -EINVAL;
+
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
 	rs->md.external = 1;
@@ -571,7 +633,6 @@ static int raid_status(struct dm_target 
 			DMEMIT(" sync");
 		if (rs->print_flags & DMPF_NOSYNC)
 			DMEMIT(" nosync");
-
 		for (i = 0; i < rs->md.raid_disks; i++)
 			if (rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
@@ -598,6 +659,9 @@ static int raid_status(struct dm_target 
 			DMEMIT(" stripe_cache %d",
 			       conf ? conf->max_nr_stripes * 2 : 0);
 		}
+		if (rs->print_flags & DMPF_REGION_SIZE)
+			DMEMIT(" region_size %lu",
+			       rs->md.bitmap_info.chunksize >> 9);
 
 		DMEMIT(" %d", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
