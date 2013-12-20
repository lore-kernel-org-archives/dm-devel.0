From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 14/20] dm thin: requeue bios to DM core
	if no_free_space and in read-only mode
Date: Fri, 20 Dec 2013 18:37:27 -0500
Message-ID: <1387582653-13647-15-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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

Now that we switch the pool to read-only mode when the data device runs
out of space it causes active writers to get IO errors once we resume
after resizing the data device.

If no_free_space is set, save bios to the 'retry_on_resume_list' and
requeue them on resume (once the data or metadata device may have been
resized).

With this patch the resize_io test passes again (on slower storage):
 dmtest run --suite thin-provisioning -n /resize_io/

Later patches fix some subtle races associated with the pool mode
transitions done as part of the pool's -ENOSPC handling.  These races
are exposed on fast storage (e.g. PCIe SSD).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f19b9e3..6e747eb 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -164,7 +164,7 @@ struct pool {
 
 	struct pool_features pf;
 	bool low_water_triggered:1;	/* A dm event has been sent */
-	bool no_free_space:1;		/* A -ENOSPC warning has been issued */
+	bool no_free_space:1;		/* bios will be requeued if set */
 
 	struct dm_bio_prison *prison;
 	struct dm_kcopyd_client *copier;
@@ -986,6 +986,20 @@ static void retry_on_resume(struct bio *bio)
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
 
+static void handle_unserviceable_bio(struct pool *pool, struct bio *bio)
+{
+	/*
+	 * When pool is read-only, no cell locking is needed because
+	 * nothing is changing.
+	 */
+	WARN_ON_ONCE(get_pool_mode(pool) != PM_READ_ONLY);
+
+	if (pool->no_free_space)
+		retry_on_resume(bio);
+	else
+		bio_io_error(bio);
+}
+
 static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *cell)
 {
 	struct bio *bio;
@@ -995,7 +1009,7 @@ static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *c
 	cell_release(pool, cell, &bios);
 
 	while ((bio = bio_list_pop(&bios)))
-		retry_on_resume(bio);
+		handle_unserviceable_bio(pool, bio);
 }
 
 static void process_discard(struct thin_c *tc, struct bio *bio)
@@ -1249,7 +1263,7 @@ static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
 	switch (r) {
 	case 0:
 		if (lookup_result.shared && (rw == WRITE) && bio->bi_size)
-			bio_io_error(bio);
+			handle_unserviceable_bio(tc->pool, bio);
 		else {
 			inc_all_io_entry(tc->pool, bio);
 			remap_and_issue(tc, bio, lookup_result.block);
@@ -1258,7 +1272,7 @@ static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
 
 	case -ENODATA:
 		if (rw != READ) {
-			bio_io_error(bio);
+			handle_unserviceable_bio(tc->pool, bio);
 			break;
 		}
 
@@ -1569,9 +1583,9 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		if (get_pool_mode(tc->pool) == PM_READ_ONLY) {
 			/*
 			 * This block isn't provisioned, and we have no way
-			 * of doing so.  Just error it.
+			 * of doing so.
 			 */
-			bio_io_error(bio);
+			handle_unserviceable_bio(tc->pool, bio);
 			return DM_MAPIO_SUBMITTED;
 		}
 		/* fall through */
-- 
1.8.1.4
