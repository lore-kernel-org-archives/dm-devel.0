From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 03/11] [PATCH 18/19] [dm-thin] [bio prison] Don't
	use the bi_next field for the holder of a cell.
Date: Thu,  2 Feb 2012 16:39:06 +0000
Message-ID: <1328200754-13642-4-git-send-email-ejt@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1328200754-13642-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

The holder can be passed down to lower devices which may want to use
bi_next themselves.  Also added BUG_ON checks to confirm fix.
---
 drivers/md/dm-thin.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c308757..6ef03a2 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -124,7 +124,7 @@ struct cell {
 	struct hlist_node list;
 	struct bio_prison *prison;
 	struct cell_key key;
-	unsigned count;
+	struct bio *holder;
 	struct bio_list bios;
 };
 
@@ -220,8 +220,8 @@ static struct cell *__search_bucket(struct hlist_head *bucket,
  * This may block if a new cell needs allocating.  You must ensure that
  * cells will be unlocked even if the calling thread is blocked.
  *
- * Returns the number of entries in the cell prior to the new addition
- * or < 0 on failure.
+ * Returns 1 if the cell was already held, 0 if @inmate is the new holder,
+ * or < 0 on error.
  */
 static int bio_detain(struct bio_prison *prison, struct cell_key *key,
 		      struct bio *inmate, struct cell **ref)
@@ -256,21 +256,25 @@ static int bio_detain(struct bio_prison *prison, struct cell_key *key,
 
 			cell->prison = prison;
 			memcpy(&cell->key, key, sizeof(cell->key));
-			cell->count = 0;
+			cell->holder = inmate;
 			bio_list_init(&cell->bios);
 			hlist_add_head(&cell->list, prison->cells + hash);
+			r = 0;
+
+		} else {
+			mempool_free(cell2, prison->cell_pool);
+			cell2 = NULL;
+			r = 1;
+			bio_list_add(&cell->bios, inmate);
 		}
-	}
 
-	r = cell->count++;
-	bio_list_add(&cell->bios, inmate);
+	} else {
+		r = 1;
+		bio_list_add(&cell->bios, inmate);
+	}
 	spin_unlock_irqrestore(&prison->lock, flags);
 
-	if (cell2)
-		mempool_free(cell2, prison->cell_pool);
-
 	*ref = cell;
-
 	return r;
 }
 
@@ -286,6 +290,7 @@ static void __cell_release(struct cell *cell, struct bio_list *inmates)
 	if (inmates)
 		bio_list_merge(inmates, &cell->bios);
 
+	bio_list_add_head(inmates, cell->holder);
 	mempool_free(cell, prison->cell_pool);
 }
 
@@ -662,8 +667,10 @@ static void remap_and_issue(struct thin_c *tc, struct bio *bio,
 		spin_lock_irqsave(&pool->lock, flags);
 		bio_list_add(&pool->deferred_flush_bios, bio);
 		spin_unlock_irqrestore(&pool->lock, flags);
-	} else
+	} else {
+		BUG_ON(bio->bi_next);
 		generic_make_request(bio);
+	}
 }
 
 /*
@@ -1302,8 +1309,10 @@ static void process_deferred_bios(struct pool *pool)
 		return;
 	}
 
-	while ((bio = bio_list_pop(&bios)))
+	while ((bio = bio_list_pop(&bios))) {
+		BUG_ON(bio->bi_next);
 		generic_make_request(bio);
+	}
 }
 
 static void do_worker(struct work_struct *ws)
-- 
1.7.5.4
