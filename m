From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 fix 19/17] dm thin: requeue
	deferred_cells when in requeue_mode
Date: Sun, 19 Oct 2014 19:02:35 -0400
Message-ID: <1413759757-7935-2-git-send-email-snitzer@redhat.com>
References: <1413759757-7935-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413759757-7935-1-git-send-email-snitzer@redhat.com>
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

Fold into "dm thin: defer whole cells rather than individual bios"

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f5c59cf..1351df0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -382,6 +382,11 @@ static void cell_success(struct pool *pool, struct dm_bio_prison_cell *cell)
 	cell_error_with_code(pool, cell, 0);
 }
 
+static void cell_requeue(struct pool *pool, struct dm_bio_prison_cell *cell)
+{
+	cell_error_with_code(pool, cell, DM_ENDIO_REQUEUE);
+}
+
 /*----------------------------------------------------------------*/
 
 /*
@@ -469,10 +474,28 @@ static void requeue_bio_list(struct thin_c *tc, struct bio_list *master)
 		bio_endio(bio, DM_ENDIO_REQUEUE);
 }
 
+static void requeue_deferred_cells(struct thin_c *tc)
+{
+	struct pool *pool = tc->pool;
+	unsigned long flags;
+	struct list_head cells;
+	struct dm_bio_prison_cell *cell, *tmp;
+
+	INIT_LIST_HEAD(&cells);
+
+	spin_lock_irqsave(&tc->lock, flags);
+	list_splice_init(&tc->deferred_cells, &cells);
+	spin_unlock_irqrestore(&tc->lock, flags);
+
+	list_for_each_entry_safe(cell, tmp, &cells, user_list)
+		cell_requeue(pool, cell);
+}
+
 static void requeue_io(struct thin_c *tc)
 {
 	requeue_bio_list(tc, &tc->deferred_bio_list);
 	requeue_bio_list(tc, &tc->retry_on_resume_list);
+	requeue_deferred_cells(tc);
 }
 
 static void error_thin_retry_list(struct thin_c *tc)
@@ -1260,6 +1283,11 @@ static void process_discard_cell(struct thin_c *tc, struct dm_bio_prison_cell *c
 	struct dm_thin_lookup_result lookup_result;
 	struct dm_thin_new_mapping *m;
 
+	if (tc->requeue_mode) {
+		cell_requeue(pool, cell);
+		return;
+	}
+
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
@@ -1499,6 +1527,11 @@ static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 	dm_block_t block = get_bio_block(tc, bio);
 	struct dm_thin_lookup_result lookup_result;
 
+	if (tc->requeue_mode) {
+		cell_requeue(pool, cell);
+		return;
+	}
+
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
@@ -1815,12 +1848,6 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 	struct dm_bio_prison_cell *cell;
 	unsigned i, j, count;
 
-	// FIXME: push down into per cell processing
-	if (tc->requeue_mode) {
-		requeue_bio_list(tc, &tc->deferred_bio_list);
-		return;
-	}
-
 	INIT_LIST_HEAD(&cells);
 
 	spin_lock_irqsave(&tc->lock, flags);
-- 
1.8.3.1
