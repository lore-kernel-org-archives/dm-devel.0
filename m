From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 01/14] dm-thin: don't use the bi_next
	field	for the holder of a cell.
Date: Tue, 20 Mar 2012 18:24:44 +0000
Message-ID: <20120320182444.GI4495@agk-dp.fab.redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1331911358-8848-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 16, 2012 at 03:22:24PM +0000, Joe Thornber wrote:
> This also has the effect of simplifying some code that had to work out
> which bio was the holder.
 
Further simplification.
 - cell isn't uninitialised
 - cell2 doesn't need initialising
 - avoid else clause indentation
 - inmates is never uninitialised (as per comment)

Alasdair


From: Alasdair G Kergon <agk@redhat.com>

Clean up prison code after holders patch.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-thin.c |   79 +++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

Index: linux-3.3/drivers/md/dm-thin.c
===================================================================
--- linux-3.3.orig/drivers/md/dm-thin.c
+++ linux-3.3/drivers/md/dm-thin.c
@@ -225,55 +225,57 @@ static struct cell *__search_bucket(stru
 static int bio_detain(struct bio_prison *prison, struct cell_key *key,
 		      struct bio *inmate, struct cell **ref)
 {
-	int r;
+	int r = 1;
 	unsigned long flags;
 	uint32_t hash = hash_key(prison, key);
-	struct cell *uninitialized_var(cell), *cell2 = NULL;
+	struct cell *cell, *cell2;
 
 	BUG_ON(hash > prison->nr_buckets);
 
 	spin_lock_irqsave(&prison->lock, flags);
+
 	cell = __search_bucket(prison->cells + hash, key);
+	if (cell) {
+		bio_list_add(&cell->bios, inmate);
+		goto out;
+	}
 
-	if (!cell) {
-		/*
-		 * Allocate a new cell
-		 */
-		spin_unlock_irqrestore(&prison->lock, flags);
-		cell2 = mempool_alloc(prison->cell_pool, GFP_NOIO);
-		spin_lock_irqsave(&prison->lock, flags);
+	/*
+	 * Allocate a new cell
+	 */
+	spin_unlock_irqrestore(&prison->lock, flags);
+	cell2 = mempool_alloc(prison->cell_pool, GFP_NOIO);
+	spin_lock_irqsave(&prison->lock, flags);
 
-		/*
-		 * We've been unlocked, so we have to double check that
-		 * nobody else has inserted this cell in the meantime.
-		 */
-		cell = __search_bucket(prison->cells + hash, key);
+	/*
+	 * We've been unlocked, so we have to double check that
+	 * nobody else has inserted this cell in the meantime.
+	 */
+	cell = __search_bucket(prison->cells + hash, key);
+	if (cell) {
+		mempool_free(cell2, prison->cell_pool);
+		bio_list_add(&cell->bios, inmate);
+		goto out;
+	}
 
-		if (!cell) {
-			cell = cell2;
-			cell2 = NULL;
-
-			cell->prison = prison;
-			memcpy(&cell->key, key, sizeof(cell->key));
-			cell->holder = inmate;
-			bio_list_init(&cell->bios);
-			hlist_add_head(&cell->list, prison->cells + hash);
-			r = 0;
+	/*
+	 * Use new cell.
+	 */
+	cell = cell2;
 
-		} else {
-			mempool_free(cell2, prison->cell_pool);
-			cell2 = NULL;
-			r = 1;
-			bio_list_add(&cell->bios, inmate);
-		}
+	cell->prison = prison;
+	memcpy(&cell->key, key, sizeof(cell->key));
+	cell->holder = inmate;
+	bio_list_init(&cell->bios);
+	hlist_add_head(&cell->list, prison->cells + hash);
 
-	} else {
-		r = 1;
-		bio_list_add(&cell->bios, inmate);
-	}
+	r = 0;
+
+out:
 	spin_unlock_irqrestore(&prison->lock, flags);
 
 	*ref = cell;
+
 	return r;
 }
 
@@ -286,10 +288,8 @@ static void __cell_release(struct cell *
 
 	hlist_del(&cell->list);
 
-	if (inmates) {
-		bio_list_add(inmates, cell->holder);
-		bio_list_merge(inmates, &cell->bios);
-	}
+	bio_list_add(inmates, cell->holder);
+	bio_list_merge(inmates, &cell->bios);
 
 	mempool_free(cell, prison->cell_pool);
 }
@@ -335,8 +335,7 @@ static void __cell_release_no_holder(str
 	struct bio_prison *prison = cell->prison;
 
 	hlist_del(&cell->list);
-	if (inmates)
-		bio_list_merge(inmates, &cell->bios);
+	bio_list_merge(inmates, &cell->bios);
 
 	mempool_free(cell, prison->cell_pool);
 }
