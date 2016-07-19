From: heinzm@redhat.com
Subject: [PATCH] dm raid: address checkpatch.pl complaints
Date: Tue, 19 Jul 2016 14:04:00 +0200
Message-ID: <1468929840-13010-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Use 'unsigned int' where appropriate.
Return negative errors.
Correct an indentation.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b53c097..8498354 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -256,10 +256,10 @@ static void rs_config_restore(struct raid_set *rs, struct rs_layout *l)
 static struct raid_type {
 	const char *name;		/* RAID algorithm. */
 	const char *descr;		/* Descriptor text for logging. */
-	const unsigned parity_devs;	/* # of parity devices. */
-	const unsigned minimal_devs;	/* minimal # of devices in set. */
-	const unsigned level;		/* RAID level. */
-	const unsigned algorithm;	/* RAID algorithm. */
+	const unsigned int parity_devs;	/* # of parity devices. */
+	const unsigned int minimal_devs;/* minimal # of devices in set. */
+	const unsigned int level;	/* RAID level. */
+	const unsigned int algorithm;	/* RAID algorithm. */
 } raid_types[] = {
 	{"raid0",	  "raid0 (striping)",			    0, 2, 0,  0 /* NONE */},
 	{"raid1",	  "raid1 (mirroring)",			    0, 2, 1,  0 /* NONE */},
@@ -665,9 +665,9 @@ static void rs_set_new(struct raid_set *rs)
 }
 
 static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *raid_type,
-				       unsigned raid_devs)
+				       unsigned int raid_devs)
 {
-	unsigned i;
+	unsigned int i;
 	struct raid_set *rs;
 
 	if (raid_devs <= raid_type->parity_devs) {
@@ -920,9 +920,9 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
  */
 static int validate_raid_redundancy(struct raid_set *rs)
 {
-	unsigned i, rebuild_cnt = 0;
-	unsigned rebuilds_per_group = 0, copies;
-	unsigned group_size, last_group_start;
+	unsigned int i, rebuild_cnt = 0;
+	unsigned int rebuilds_per_group = 0, copies;
+	unsigned int group_size, last_group_start;
 
 	for (i = 0; i < rs->md.raid_disks; i++)
 		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
@@ -1030,12 +1030,12 @@ too_many:
  *    [raid10_format <near|far|offset>] Layout algorithm.  (Default: near)
  */
 static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
-			     unsigned num_raid_params)
+			     unsigned int num_raid_params)
 {
 	int value, raid10_format = ALGORITHM_RAID10_DEFAULT;
-	unsigned raid10_copies = 2;
-	unsigned i, write_mostly = 0;
-	unsigned region_size = 0;
+	unsigned int raid10_copies = 2;
+	unsigned int i, write_mostly = 0;
+	unsigned int region_size = 0;
 	sector_t max_io_len;
 	const char *arg, *key;
 	struct raid_dev *rd;
@@ -1447,7 +1447,7 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 		if (rs->raid10_copies < 2 ||
 		    delta_disks < 0) {
 			rs->ti->error = "Bogus raid10 data copies or delta disks";
-			return EINVAL;
+			return -EINVAL;
 		}
 
 		dev_sectors *= rs->raid10_copies;
@@ -1474,7 +1474,7 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 	return 0;
 bad:
 	rs->ti->error = "Target length not divisible by number of data devices";
-	return EINVAL;
+	return -EINVAL;
 }
 
 /* Setup recovery on @rs */
@@ -2511,7 +2511,7 @@ static int rs_setup_takeover(struct raid_set *rs)
 			/* raid1 -> raid10_near layout */
 			mddev->layout = raid10_format_to_md_layout(rs, ALGORITHM_RAID10_NEAR,
 								   rs->raid_disks);
-		 else
+		else
 			return -EINVAL;
 
 	}
@@ -2758,12 +2758,12 @@ static void configure_discard_support(struct raid_set *rs)
  * enforce recreation based on the passed in table parameters.
  *
  */
-static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
+static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
 	bool resize;
 	struct raid_type *rt;
-	unsigned num_raid_params, num_raid_devs;
+	unsigned int num_raid_params, num_raid_devs;
 	sector_t calculated_dev_sectors;
 	struct raid_set *rs = NULL;
 	const char *arg;
@@ -3299,7 +3299,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int raid_message(struct dm_target *ti, unsigned argc, char **argv)
+static int raid_message(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
@@ -3351,7 +3351,7 @@ static int raid_iterate_devices(struct dm_target *ti,
 				iterate_devices_callout_fn fn, void *data)
 {
 	struct raid_set *rs = ti->private;
-	unsigned i;
+	unsigned int i;
 	int r = 0;
 
 	for (i = 0; !r && i < rs->md.raid_disks; i++)
-- 
2.5.5
