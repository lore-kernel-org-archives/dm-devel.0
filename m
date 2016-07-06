From: heinzm@redhat.com
Subject: [PATCH 24/26] dm raid: use rs->raid_disks to avoid
	memory leaks on free and more consistent throughout
Date: Wed,  6 Jul 2016 19:24:55 +0200
Message-ID: <1467825897-26058-25-git-send-email-heinzm@redhat.com>
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

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4caf51fe..2ea3982 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -717,7 +717,7 @@ static void raid_set_free(struct raid_set *rs)
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		if (rs->dev[i].meta_dev)
 			dm_put_device(rs->ti, rs->dev[i].meta_dev);
 		md_rdev_clear(&rs->dev[i].rdev);
@@ -757,7 +757,7 @@ static int parse_dev_params(struct raid_set *rs, struct dm_arg_set *as)
 	if (!arg)
 		return -EINVAL;
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		rs->dev[i].rdev.raid_disk = i;
 
 		rs->dev[i].meta_dev = NULL;
@@ -961,7 +961,7 @@ static int validate_raid_redundancy(struct raid_set *rs)
 		 *	    C	 D    D	   E	E
 		 */
 		if (__is_raid10_near(rs->md.new_layout)) {
-			for (i = 0; i < rs->raid_disks; i++) {
+			for (i = 0; i < rs->md.raid_disks; i++) {
 				if (!(i % copies))
 					rebuilds_per_group = 0;
 				if ((!rs->dev[i].rdev.sb_page ||
@@ -1085,7 +1085,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	 * What is found in the superblocks of the devices is always
 	 * authoritative, unless 'rebuild' or '[no]sync' was specified.
 	 */
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		set_bit(In_sync, &rs->dev[i].rdev.flags);
 		rs->dev[i].rdev.recovery_offset = MaxSector;
 	}
@@ -2714,7 +2714,7 @@ static void configure_discard_support(struct raid_set *rs)
 	/* RAID level 4,5,6 require discard_zeroes_data for data integrity! */
 	raid456 = (rs->md.level == 4 || rs->md.level == 5 || rs->md.level == 6);
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		struct request_queue *q;
 
 		if (!rs->dev[i].rdev.bdev)
@@ -3186,7 +3186,6 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		sync_action = decipher_sync_action(&rs->md);
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D' or 'A' now */
-		rdev_for_each(rdev, mddev)
 		for (i = 0; i < rs->raid_disks; i++)
 			DMEMIT(__raid_dev_status(&rs->dev[i].rdev, array_in_sync));
 
-- 
2.5.5
