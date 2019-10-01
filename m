From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 1/4] dm raid: change rs_set_dev_and_array_sectors
	API and callers
Date: Tue,  1 Oct 2019 17:47:52 +0200
Message-ID: <61aa36cbaa3b61834c4aece52f6c37ff79a6bd3f.1569888100.git.heinzm@redhat.com>
References: <cover.1569888100.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1569888100.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Add a size argument to rs_set_dev_and_array_sectors as prerequisite
to fixing grown device resynchronization not occuring when new MD
bitmap pages have to be allocated as a result of the extension in
a follwup patch.

Also avoid code duplication by using rs_set_rdev_sectors
in the aforementioned function.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b0aa595e4375..89f805e851cf 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1615,13 +1615,12 @@ static int _check_data_dev_sectors(struct raid_set *rs)
 }
 
 /* Calculate the sectors per device and per array used for @rs */
-static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
+static int rs_set_dev_and_array_sectors(struct raid_set *rs, sector_t sectors, bool use_mddev)
 {
 	int delta_disks;
 	unsigned int data_stripes;
+	sector_t array_sectors = sectors, dev_sectors = sectors;
 	struct mddev *mddev = &rs->md;
-	struct md_rdev *rdev;
-	sector_t array_sectors = rs->ti->len, dev_sectors = rs->ti->len;
 
 	if (use_mddev) {
 		delta_disks = mddev->delta_disks;
@@ -1656,12 +1655,9 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 		/* Striped layouts */
 		array_sectors = (data_stripes + delta_disks) * dev_sectors;
 
-	rdev_for_each(rdev, mddev)
-		if (!test_bit(Journal, &rdev->flags))
-			rdev->sectors = dev_sectors;
-
 	mddev->array_sectors = array_sectors;
 	mddev->dev_sectors = dev_sectors;
+	rs_set_rdev_sectors(rs);
 
 	return _check_data_dev_sectors(rs);
 bad:
@@ -2911,7 +2907,7 @@ static int rs_setup_reshape(struct raid_set *rs)
 
 	/* Remove disk(s) */
 	} else if (rs->delta_disks < 0) {
-		r = rs_set_dev_and_array_sectors(rs, true);
+		r = rs_set_dev_and_array_sectors(rs, rs->ti->len, true);
 		mddev->reshape_backwards = 1; /* removing disk(s) -> backward reshape */
 
 	/* Change layout and/or chunk size */
@@ -3067,7 +3063,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 *
 	 * Any existing superblock will overwrite the array and device sizes
 	 */
-	r = rs_set_dev_and_array_sectors(rs, false);
+	r = rs_set_dev_and_array_sectors(rs, rs->ti->len, false);
 	if (r)
 		goto bad;
 
-- 
2.21.0
