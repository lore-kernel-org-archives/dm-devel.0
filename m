From: heinzm@redhat.com
Subject: [PATCH v2] dm raid: avoid BUG() in __rdev_sectors()
Date: Fri, 30 Jun 2017 15:45:58 +0200
Message-ID: <20170630134558.6834-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Avoid the BUG() and catch invalid rdev size in the constructor.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b4b75da..2e10c2f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1571,7 +1571,7 @@ static sector_t __rdev_sectors(struct raid_set *rs)
 			return rdev->sectors;
 	}
 
-	BUG(); /* Constructor ensures we got some. */
+	return 0;
 }
 
 /* Calculate the sectors per device and per array used for @rs */
@@ -2941,7 +2941,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	bool resize;
 	struct raid_type *rt;
 	unsigned int num_raid_params, num_raid_devs;
-	sector_t calculated_dev_sectors;
+	sector_t calculated_dev_sectors, rdev_sectors;
 	struct raid_set *rs = NULL;
 	const char *arg;
 	struct rs_layout rs_layout;
@@ -3017,7 +3017,14 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	resize = calculated_dev_sectors != __rdev_sectors(rs);
+	rdev_sectors = __rdev_sectors(rs);
+	if (!rdev_sectors) {
+		ti->error = "Invalid rdev size";
+		r = -EINVAL;
+		goto bad;
+	}
+
+	resize = calculated_dev_sectors != rdev_sectors;
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
-- 
2.9.4
