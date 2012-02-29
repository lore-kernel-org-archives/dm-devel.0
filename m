From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 07/13] dm thin: don't use the bi_next field for
	the holder of a cell
Date: Wed, 29 Feb 2012 09:50:11 -0500
Message-ID: <1330527017-28618-8-git-send-email-snitzer@redhat.com>
References: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

The holder can be passed down to lower devices which may want to use
bi_next themselves.  Also add BUG_ON check to confirm fix.

When releasing bios that have been detained in a cell, fix the order in
which the holder and other cellmates are added to the inmates list:
append holder first followed by the other cellmates.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f796afb..a148532 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -125,7 +125,7 @@ struct cell {
 	struct hlist_node list;
 	struct bio_prison *prison;
 	struct cell_key key;
-	unsigned count;
+	struct bio *holder;
 	struct bio_list bios;
 };
 
@@ -221,8 +221,7 @@ static struct cell *__search_bucket(struct hlist_head *bucket,
  * This may block if a new cell needs allocating.  You must ensure that
  * cells will be unlocked even if the calling thread is blocked.
  *
- * Returns the number of entries in the cell prior to the new addition
- * or < 0 on failure.
+ * Returns 1 if the cell was already held, 0 if @inmate is the new holder.
  */
 static int bio_detain(struct bio_prison *prison, struct cell_key *key,
 		      struct bio *inmate, struct cell **ref)
@@ -257,21 +256,25 @@ static int bio_detain(struct bio_prison *prison, struct cell_key *key,
 
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
 
@@ -284,8 +287,10 @@ static void __cell_release(struct cell *cell, struct bio_list *inmates)
 
 	hlist_del(&cell->list);
 
-	if (inmates)
+	if (inmates) {
+		bio_list_add(inmates, cell->holder);
 		bio_list_merge(inmates, &cell->bios);
+	}
 
 	mempool_free(cell, prison->cell_pool);
 }
-- 
1.7.1
