From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2 - v2]: DM RAID: Move 'sectors_per_dev'
	calculation
Date: Tue, 26 Jun 2012 09:57:53 -0500
Message-ID: <1340722673.25515.4.camel@f16>
References: <1340701060.19015.27.camel@f16>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1340701060.19015.27.camel@f16>
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

Version 2 in response to conflicts found with existing patches in linux-next.

 brassow


dm-raid:  Move sectors_per_dev calculation later in the device creation process

In preparation for RAID10 inclusion in dm-raid, we move the sectors_per_dev
calculation later in the device creation process.  This is because we won't
know up-front how many stripes vs how many mirrors there are - which will
change the calculation.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -101,20 +101,12 @@ static struct raid_set *context_alloc(st
 {
 	unsigned i;
 	struct raid_set *rs;
-	sector_t sectors_per_dev;
 
 	if (raid_devs <= raid_type->parity_devs) {
 		ti->error = "Insufficient number of devices";
 		return ERR_PTR(-EINVAL);
 	}
 
-	sectors_per_dev = ti->len;
-	if ((raid_type->level > 1) &&
-	    sector_div(sectors_per_dev, (raid_devs - raid_type->parity_devs))) {
-		ti->error = "Target length not divisible by number of data devices";
-		return ERR_PTR(-EINVAL);
-	}
-
 	rs = kzalloc(sizeof(*rs) + raid_devs * sizeof(rs->dev[0]), GFP_KERNEL);
 	if (!rs) {
 		ti->error = "Cannot allocate raid context";
@@ -128,7 +120,6 @@ static struct raid_set *context_alloc(st
 	rs->md.raid_disks = raid_devs;
 	rs->md.level = raid_type->level;
 	rs->md.new_level = rs->md.level;
-	rs->md.dev_sectors = sectors_per_dev;
 	rs->md.layout = raid_type->algorithm;
 	rs->md.new_layout = rs->md.layout;
 	rs->md.delta_disks = 0;
@@ -143,6 +134,7 @@ static struct raid_set *context_alloc(st
 	 *  rs->md.external
 	 *  rs->md.chunk_sectors
 	 *  rs->md.new_chunk_sectors
+	 *  rs->md.dev_sectors
 	 */
 
 	return rs;
@@ -353,6 +345,7 @@ static int parse_raid_params(struct raid
 {
 	unsigned i, rebuild_cnt = 0;
 	unsigned long value, region_size = 0;
+	sector_t sectors_per_dev = rs->ti->len;
 	sector_t max_io_len;
 	char *key;
 
@@ -530,6 +523,13 @@ static int parse_raid_params(struct raid
 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
 		return -EINVAL;
 
+	if ((rs->raid_type->level > 1) &&
+	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->parity_devs))) {
+		rs->ti->error = "Target length not divisible by number of data devices";
+		return -EINVAL;
+	}
+	rs->md.dev_sectors = sectors_per_dev;
+
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
 	rs->md.external = 1;
