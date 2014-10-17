From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 06/17] dm thin: prefetch missing
	metadata pages
Date: Fri, 17 Oct 2014 02:06:56 -0400
Message-ID: <1413526027-21630-7-git-send-email-snitzer@redhat.com>
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

Prefetch metadata at the start of the worker thread and then again every
128th bio processed from the deferred list.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c |  5 +++++
 drivers/md/dm-thin-metadata.h |  5 +++++
 drivers/md/dm-thin.c          | 10 ++++++----
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index ee42d1c..43adbb8 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1809,3 +1809,8 @@ bool dm_pool_metadata_needs_check(struct dm_pool_metadata *pmd)
 
 	return needs_check;
 }
+
+void dm_pool_issue_prefetches(struct dm_pool_metadata *pmd)
+{
+	dm_tm_issue_prefetches(pmd->tm);
+}
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index efedd5a..921d15e 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -213,6 +213,11 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
 int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd);
 bool dm_pool_metadata_needs_check(struct dm_pool_metadata *pmd);
 
+/*
+ * Issue any prefetches that may be useful.
+ */
+void dm_pool_issue_prefetches(struct dm_pool_metadata *pmd);
+
 /*----------------------------------------------------------------*/
 
 #endif
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2459628..1d25b51 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1526,6 +1526,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 	struct bio *bio;
 	struct bio_list bios;
 	struct blk_plug plug;
+	unsigned count = 0;
 
 	if (tc->requeue_mode) {
 		requeue_bio_list(tc, &tc->deferred_bio_list);
@@ -1567,6 +1568,10 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			pool->process_discard(tc, bio);
 		else
 			pool->process_bio(tc, bio);
+
+		if ((count++ & 127) == 0) {
+			dm_pool_issue_prefetches(pool->pmd);
+		}
 	}
 	blk_finish_plug(&plug);
 }
@@ -1652,6 +1657,7 @@ static void do_worker(struct work_struct *ws)
 {
 	struct pool *pool = container_of(ws, struct pool, worker);
 
+	dm_pool_issue_prefetches(pool->pmd);
 	process_prepared(pool, &pool->prepared_mappings, &pool->process_prepared_mapping);
 	process_prepared(pool, &pool->prepared_discards, &pool->process_prepared_discard);
 	process_deferred_bios(pool);
@@ -1990,10 +1996,6 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		/* fall through */
 
 	case -EWOULDBLOCK:
-		/*
-		 * In future, the failed dm_thin_find_block above could
-		 * provide the hint to load the metadata into cache.
-		 */
 		thin_defer_bio(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 
-- 
1.9.3
