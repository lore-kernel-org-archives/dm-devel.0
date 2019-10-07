From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH] dm clone: add bucket_lock_irq/bucket_unlock_irq
	helpers
Date: Mon,  7 Oct 2019 20:54:41 +0300
Message-ID: <20191007175441.13328-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, mpatocka@redhat.com
Cc: ntsironis@arrikto.com
List-Id: dm-devel.ids

Introduce bucket_lock_irq() and bucket_unlock_irq() helpers and use them
in places where it is known that interrupts are enabled.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-clone-target.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index f7d1070a4d40..b3d89072d21c 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -552,6 +552,12 @@ struct hash_table_bucket {
 #define bucket_unlock_irqrestore(bucket, flags) \
 	spin_unlock_irqrestore(&(bucket)->lock, flags)
 
+#define bucket_lock_irq(bucket) \
+	spin_lock_irq(&(bucket)->lock)
+
+#define bucket_unlock_irq(bucket) \
+	spin_unlock_irq(&(bucket)->lock)
+
 static int hash_table_init(struct clone *clone)
 {
 	unsigned int i, sz;
@@ -849,7 +855,6 @@ static void hydration_overwrite(struct dm_clone_region_hydration *hd, struct bio
  */
 static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 {
-	unsigned long flags;
 	unsigned long region_nr;
 	struct hash_table_bucket *bucket;
 	struct dm_clone_region_hydration *hd, *hd2;
@@ -857,19 +862,19 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	region_nr = bio_to_region(clone, bio);
 	bucket = get_hash_table_bucket(clone, region_nr);
 
-	bucket_lock_irqsave(bucket, flags);
+	bucket_lock_irq(bucket);
 
 	hd = __hash_find(bucket, region_nr);
 	if (hd) {
 		/* Someone else is hydrating the region */
 		bio_list_add(&hd->deferred_bios, bio);
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 		return;
 	}
 
 	if (dm_clone_is_region_hydrated(clone->cmd, region_nr)) {
 		/* The region has been hydrated */
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 		issue_bio(clone, bio);
 		return;
 	}
@@ -878,16 +883,16 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	 * We must allocate a hydration descriptor and start the hydration of
 	 * the corresponding region.
 	 */
-	bucket_unlock_irqrestore(bucket, flags);
+	bucket_unlock_irq(bucket);
 
 	hd = alloc_hydration(clone);
 	hydration_init(hd, region_nr);
 
-	bucket_lock_irqsave(bucket, flags);
+	bucket_lock_irq(bucket);
 
 	/* Check if the region has been hydrated in the meantime. */
 	if (dm_clone_is_region_hydrated(clone->cmd, region_nr)) {
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 		free_hydration(hd);
 		issue_bio(clone, bio);
 		return;
@@ -897,7 +902,7 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	if (hd2 != hd) {
 		/* Someone else started the region's hydration. */
 		bio_list_add(&hd2->deferred_bios, bio);
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 		free_hydration(hd);
 		return;
 	}
@@ -909,7 +914,7 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	 */
 	if (unlikely(get_clone_mode(clone) >= CM_READ_ONLY)) {
 		hlist_del(&hd->h);
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 		free_hydration(hd);
 		bio_io_error(bio);
 		return;
@@ -923,11 +928,11 @@ static void hydrate_bio_region(struct clone *clone, struct bio *bio)
 	 * to the destination device.
 	 */
 	if (is_overwrite_bio(clone, bio)) {
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 		hydration_overwrite(hd, bio);
 	} else {
 		bio_list_add(&hd->deferred_bios, bio);
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 		hydration_copy(hd, 1);
 	}
 }
@@ -994,7 +999,6 @@ static unsigned long __start_next_hydration(struct clone *clone,
 					    unsigned long offset,
 					    struct batch_info *batch)
 {
-	unsigned long flags;
 	struct hash_table_bucket *bucket;
 	struct dm_clone_region_hydration *hd;
 	unsigned long nr_regions = clone->nr_regions;
@@ -1008,13 +1012,13 @@ static unsigned long __start_next_hydration(struct clone *clone,
 			break;
 
 		bucket = get_hash_table_bucket(clone, offset);
-		bucket_lock_irqsave(bucket, flags);
+		bucket_lock_irq(bucket);
 
 		if (!dm_clone_is_region_hydrated(clone->cmd, offset) &&
 		    !__hash_find(bucket, offset)) {
 			hydration_init(hd, offset);
 			__insert_region_hydration(bucket, hd);
-			bucket_unlock_irqrestore(bucket, flags);
+			bucket_unlock_irq(bucket);
 
 			/* Batch hydration */
 			__batch_hydration(batch, hd);
@@ -1022,7 +1026,7 @@ static unsigned long __start_next_hydration(struct clone *clone,
 			return (offset + 1);
 		}
 
-		bucket_unlock_irqrestore(bucket, flags);
+		bucket_unlock_irq(bucket);
 
 	} while (++offset < nr_regions);
 
-- 
2.11.0
