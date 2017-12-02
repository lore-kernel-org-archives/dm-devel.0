From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 12/12] dm raid: add component device size check
Date: Sat,  2 Dec 2017 01:03:59 +0100
Message-ID: <8993b91a108b24e41e28988c676a191c135d20a1.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Check all component data device sizes versus calculated size.
Reject in case device(s) are too small.
---
 drivers/md/dm-raid.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 89c05302c765..dfbc2bd787c1 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1581,6 +1581,24 @@ static sector_t __rdev_sectors(struct raid_set *rs)
 	return 0;
 }
 
+/* Check that calculated dev_sectors fits all component devices. */
+static int _check_data_dev_sectors(struct raid_set *rs)
+{
+	sector_t ds = ~0;
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, &rs->md)
+		if (!test_bit(Journal, &rdev->flags) && rdev->bdev) {
+			ds = min(ds, to_sector(i_size_read(rdev->bdev->bd_inode)));
+			if (ds < rs->md.dev_sectors) {
+				rs->ti->error = "Component device(s) too small";
+				return -EINVAL;
+			}
+		}
+
+	return 0;
+}
+
 /* Calculate the sectors per device and per array used for @rs */
 static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 {
@@ -1630,7 +1648,7 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 	mddev->array_sectors = array_sectors;
 	mddev->dev_sectors = dev_sectors;
 
-	return 0;
+	return _check_data_dev_sectors(rs);
 bad:
 	rs->ti->error = "Target length not divisible by number of data devices";
 	return -EINVAL;
-- 
2.13.6
