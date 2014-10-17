From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 16/17] dm thin: direct dispatch when
	breaking sharing
Date: Fri, 17 Oct 2014 02:07:06 -0400
Message-ID: <1413526027-21630-17-git-send-email-snitzer@redhat.com>
References: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
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

From: Joe Thornber <ejt@redhat.com>

This use of direct submission in process_shared_bio() reduces latency
for submitting bios in the shared cell by avoiding adding those bios to
the deferred list and waiting for the next iteration of the worker.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 66 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 3e1f40d..b585c0d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1357,11 +1357,49 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 	}
 }
 
+static void __remap_and_issue_shared_cell(void *context,
+					  struct dm_bio_prison_cell *cell)
+{
+	struct remap_info *info = context;
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&cell->bios))) {
+		if ((bio_data_dir(bio) == WRITE) ||
+		    (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA)))
+			thin_defer_bio(info->tc, bio);
+		else {
+			struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));;
+
+			h->shared_read_entry = dm_deferred_entry_inc(info->tc->pool->shared_read_ds);
+			inc_all_io_entry(info->tc->pool, bio);
+			bio_list_add(&info->bios, bio);
+		}
+	}
+}
+
+static void remap_and_issue_shared_cell(struct thin_c *tc,
+					struct dm_bio_prison_cell *cell,
+					dm_block_t block)
+{
+	struct bio *bio;
+	struct remap_info info;
+
+	info.tc = tc;
+	bio_list_init(&info.bios);
+
+	cell_visit_release(tc->pool, __remap_and_issue_shared_cell,
+			   &info, cell);
+
+	while ((bio = bio_list_pop(&info.bios)))
+		remap_and_issue(tc, bio, block);
+}
+
 static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 			       dm_block_t block,
-			       struct dm_thin_lookup_result *lookup_result)
+			       struct dm_thin_lookup_result *lookup_result,
+			       struct dm_bio_prison_cell *virt_cell)
 {
-	struct dm_bio_prison_cell *cell;
+	struct dm_bio_prison_cell *data_cell;
 	struct pool *pool = tc->pool;
 	struct dm_cell_key key;
 
@@ -1370,19 +1408,23 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 	 * of being broken so we have nothing further to do here.
 	 */
 	build_data_key(tc->td, lookup_result->block, &key);
-	if (bio_detain(pool, &key, bio, &cell))
+	if (bio_detain(pool, &key, bio, &data_cell)) {
+		cell_defer_no_holder(tc, virt_cell);
 		return;
+	}
 
-	if (bio_data_dir(bio) == WRITE && bio->bi_iter.bi_size)
-		break_sharing(tc, bio, block, &key, lookup_result, cell);
-	else {
+	if (bio_data_dir(bio) == WRITE && bio->bi_iter.bi_size) {
+		break_sharing(tc, bio, block, &key, lookup_result, data_cell);
+		cell_defer_no_holder(tc, virt_cell);
+	} else {
 		struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
 
 		h->shared_read_entry = dm_deferred_entry_inc(pool->shared_read_ds);
 		inc_all_io_entry(pool, bio);
-		cell_defer_no_holder(tc, cell);
+		remap_and_issue(tc, bio, block);
 
-		remap_and_issue(tc, bio, lookup_result->block);
+		remap_and_issue_shared_cell(tc, data_cell, lookup_result->block);
+		remap_and_issue_shared_cell(tc, virt_cell, lookup_result->block);
 	}
 }
 
@@ -1446,11 +1488,9 @@ static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
-		if (lookup_result.shared) {
-			process_shared_bio(tc, bio, block, &lookup_result);
-			// FIXME: we can't remap because we're waiting on a commit
-			cell_defer_no_holder(tc, cell); /* FIXME: pass this cell into process_shared? */
-		} else {
+		if (lookup_result.shared)
+			process_shared_bio(tc, bio, block, &lookup_result, cell);
+		else {
 			inc_all_io_entry(pool, bio);
 			remap_and_issue(tc, bio, lookup_result.block);
 			inc_remap_and_issue_cell(tc, cell, lookup_result.block);
-- 
1.9.3
