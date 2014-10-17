From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 13/17] dm thin: factor out
	remap_and_issue_overwrite
Date: Fri, 17 Oct 2014 14:37:15 -0400
Message-ID: <1413571039-31986-13-git-send-email-snitzer@redhat.com>
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

Purely cleanup of duplicated code, no functional change.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index fffdebc..4658635 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -890,6 +890,20 @@ static void ll_zero(struct thin_c *tc, struct dm_thin_new_mapping *m,
 	}
 }
 
+static void remap_and_issue_overwrite(struct thin_c *tc, struct bio *bio,
+				      dm_block_t data_block,
+				      struct dm_thin_new_mapping *m)
+{
+	struct pool *pool = tc->pool;
+	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
+
+	h->overwrite_mapping = m;
+	m->bio = bio;
+	save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
+	inc_all_io_entry(pool, bio);
+	remap_and_issue(tc, bio, data_block);
+}
+
 /*
  * A partial copy also needs to zero the uncopied region.
  */
@@ -924,15 +938,9 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	 * If the whole block of data is being overwritten, we can issue the
 	 * bio immediately. Otherwise we use kcopyd to clone the data first.
 	 */
-	if (io_overwrites_block(pool, bio)) {
-		struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
-
-		h->overwrite_mapping = m;
-		m->bio = bio;
-		save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
-		inc_all_io_entry(pool, bio);
-		remap_and_issue(tc, bio, data_dest);
-	} else {
+	if (io_overwrites_block(pool, bio))
+		remap_and_issue_overwrite(tc, bio, data_dest, m);
+	else {
 		struct dm_io_region from, to;
 
 		from.bdev = origin->bdev;
@@ -1001,16 +1009,10 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	if (!pool->pf.zero_new_blocks)
 		process_prepared_mapping(m);
 
-	else if (io_overwrites_block(pool, bio)) {
-		struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
-
-		h->overwrite_mapping = m;
-		m->bio = bio;
-		save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
-		inc_all_io_entry(pool, bio);
-		remap_and_issue(tc, bio, data_block);
+	else if (io_overwrites_block(pool, bio))
+		remap_and_issue_overwrite(tc, bio, data_block, m);
 
-	} else
+	else
 		ll_zero(tc, m,
 			data_block * pool->sectors_per_block,
 			(data_block + 1) * pool->sectors_per_block);
-- 
1.8.3.1
