From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 10/17] dm thin: implement thin_merge
Date: Fri, 17 Oct 2014 14:37:12 -0400
Message-ID: <1413571039-31986-10-git-send-email-snitzer@redhat.com>
References: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Introduce thin_merge so that any additional constraints from the data
volume may be taken into account when determing the maximum number of
sectors that can be issued relative to the specified logical offset.

This is particularly important if/when the data volume is layered ontop
of a more sophisticated device (e.g. dm-raid or some other DM target).

Reviewed-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 3f2b1d1..34e42a2 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3620,6 +3620,21 @@ err:
 	DMEMIT("Error");
 }
 
+static int thin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+		      struct bio_vec *biovec, int max_size)
+{
+	struct thin_c *tc = ti->private;
+	struct request_queue *q = bdev_get_queue(tc->pool_dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = tc->pool_dev->bdev;
+	bvm->bi_sector = dm_target_offset(ti, bvm->bi_sector);
+
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
 static int thin_iterate_devices(struct dm_target *ti,
 				iterate_devices_callout_fn fn, void *data)
 {
@@ -3644,7 +3659,7 @@ static int thin_iterate_devices(struct dm_target *ti,
 
 static struct target_type thin_target = {
 	.name = "thin",
-	.version = {1, 13, 0},
+	.version = {1, 14, 0},
 	.module	= THIS_MODULE,
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
@@ -3654,6 +3669,7 @@ static struct target_type thin_target = {
 	.presuspend = thin_presuspend,
 	.postsuspend = thin_postsuspend,
 	.status = thin_status,
+	.merge = thin_merge,
 	.iterate_devices = thin_iterate_devices,
 };
 
-- 
1.8.3.1
