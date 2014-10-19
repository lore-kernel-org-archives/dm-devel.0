From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 21/17] dm thin: refactor requeue_io
	to eliminate spinlock bouncing
Date: Sun, 19 Oct 2014 19:02:37 -0400
Message-ID: <1413759757-7935-4-git-send-email-snitzer@redhat.com>
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

Also refactor some other bio_list erroring helpers.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 917ade5..5fb5df1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -457,21 +457,32 @@ struct dm_thin_endio_hook {
 	struct rb_node rb_node;
 };
 
-static void requeue_bio_list(struct thin_c *tc, struct bio_list *master)
+static void __merge_bio_list(struct bio_list *bios, struct bio_list *master)
+{
+	bio_list_merge(bios, master);
+	bio_list_init(master);
+}
+
+static void error_bio_list(struct bio_list *bios, int error)
 {
 	struct bio *bio;
+
+	while ((bio = bio_list_pop(bios)))
+		bio_endio(bio, error);
+}
+
+static void error_thin_bio_list(struct thin_c *tc, struct bio_list *master, int error)
+{
 	struct bio_list bios;
 	unsigned long flags;
 
 	bio_list_init(&bios);
 
 	spin_lock_irqsave(&tc->lock, flags);
-	bio_list_merge(&bios, master);
-	bio_list_init(master);
+	__merge_bio_list(&bios, master);
 	spin_unlock_irqrestore(&tc->lock, flags);
 
-	while ((bio = bio_list_pop(&bios)))
-		bio_endio(bio, DM_ENDIO_REQUEUE);
+	error_bio_list(&bios, error);
 }
 
 static void requeue_deferred_cells(struct thin_c *tc)
@@ -493,26 +504,18 @@ static void requeue_deferred_cells(struct thin_c *tc)
 
 static void requeue_io(struct thin_c *tc)
 {
-	requeue_bio_list(tc, &tc->deferred_bio_list);
-	requeue_bio_list(tc, &tc->retry_on_resume_list);
-	requeue_deferred_cells(tc);
-}
-
-static void error_thin_retry_list(struct thin_c *tc)
-{
-	struct bio *bio;
-	unsigned long flags;
 	struct bio_list bios;
+	unsigned long flags;
 
 	bio_list_init(&bios);
 
 	spin_lock_irqsave(&tc->lock, flags);
-	bio_list_merge(&bios, &tc->retry_on_resume_list);
-	bio_list_init(&tc->retry_on_resume_list);
+	__merge_bio_list(&bios, &tc->deferred_bio_list);
+	__merge_bio_list(&bios, &tc->retry_on_resume_list);
 	spin_unlock_irqrestore(&tc->lock, flags);
 
-	while ((bio = bio_list_pop(&bios)))
-		bio_io_error(bio);
+	error_bio_list(&bios, DM_ENDIO_REQUEUE);
+	requeue_deferred_cells(tc);
 }
 
 static void error_retry_list(struct pool *pool)
@@ -521,7 +524,7 @@ static void error_retry_list(struct pool *pool)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(tc, &pool->active_thins, list)
-		error_thin_retry_list(tc);
+		error_thin_bio_list(tc, &tc->retry_on_resume_list, -EIO);
 	rcu_read_unlock();
 }
 
@@ -1752,7 +1755,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 	unsigned count = 0;
 
 	if (tc->requeue_mode) {
-		requeue_bio_list(tc, &tc->deferred_bio_list);
+		error_thin_bio_list(tc, &tc->deferred_bio_list, DM_ENDIO_REQUEUE);
 		return;
 	}
 
-- 
1.8.3.1
