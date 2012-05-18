From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm thin: fix table output when pool target
	disables discard passdown internally
Date: Fri, 18 May 2012 11:04:01 -0400
Message-ID: <1337353441-12647-1-git-send-email-snitzer@redhat.com>
References: <1337310059-8517-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337310059-8517-1-git-send-email-snitzer@redhat.com>
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

When the thin pool target clears the discard_passdown parameter
internally, it incorrectly reports this to userspace on the table line.
This patch corrects this by no longer changing the table line to reflect
that discard passdown was disabled.

We can still tell when discard passdown is overridden by looking for the
message "Discard unsupported by data device (sdX): Disabling discard passdown."

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2fd87b5..eb3d138 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1632,6 +1632,21 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
 	pool->low_water_blocks = pt->low_water_blocks;
 	pool->pf = pt->pf;
 
+	/*
+	 * If discard_passdown was enabled verify that the data device
+	 * supports discards.  Disable discard_passdown if not; otherwise
+	 * -EOPNOTSUPP will be returned.
+	 */
+	if (pt->pf.discard_passdown) {
+		struct request_queue *q = bdev_get_queue(pt->data_dev->bdev);
+		if (!q || !blk_queue_discard(q)) {
+			char buf[BDEVNAME_SIZE];
+			DMWARN("Discard unsupported by data device (%s): Disabling discard passdown.",
+			       bdevname(pt->data_dev->bdev, buf));
+			pool->pf.discard_passdown = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -1988,19 +2003,6 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto out_flags_changed;
 	}
 
-	/*
-	 * If discard_passdown was enabled verify that the data device
-	 * supports discards.  Disable discard_passdown if not; otherwise
-	 * -EOPNOTSUPP will be returned.
-	 */
-	if (pf.discard_passdown) {
-		struct request_queue *q = bdev_get_queue(data_dev->bdev);
-		if (!q || !blk_queue_discard(q)) {
-			DMWARN("Discard unsupported by data device: Disabling discard passdown.");
-			pf.discard_passdown = 0;
-		}
-	}
-
 	pt->pool = pool;
 	pt->ti = ti;
 	pt->metadata_dev = metadata_dev;
@@ -2385,7 +2387,7 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		       (unsigned long long)pt->low_water_blocks);
 
 		count = !pool->pf.zero_new_blocks + !pool->pf.discard_enabled +
-			!pool->pf.discard_passdown;
+			!pt->pf.discard_passdown;
 		DMEMIT("%u ", count);
 
 		if (!pool->pf.zero_new_blocks)
@@ -2394,7 +2396,7 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		if (!pool->pf.discard_enabled)
 			DMEMIT("ignore_discard ");
 
-		if (!pool->pf.discard_passdown)
+		if (!pt->pf.discard_passdown)
 			DMEMIT("no_discard_passdown ");
 
 		break;
