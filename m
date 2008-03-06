From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 1/1] dm-log(recover): avoid excessive
	recovering_bits in dm-log.c
Date: Thu,  6 Mar 2008 15:38:09 +0100
Message-ID: <1204814289-29600-1-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair et al,

this patch avoids the excessive lc->recovering_bits array being used in
the context of core_get_resync_work(), by basing the selection of regions
to be synchronized purely on the lc->sync_bits array.

core_set_region_sync() adjusted lc->sync_search in order to allow for
resynchronization of regions being set out-of-sync.

I'm interested, if resynchronization related semantics are sane.

If acceptable, please apply
(applies on top of my previous dm header move patches).

Heinz

---
 drivers/md/dm-log.c |   40 +++++++++++-----------------------------
 1 files changed, 11 insertions(+), 29 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.c linux-2.6.25-rc4/drivers/md/dm-log.c
index 6cc12c3..91a7f4a 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.25-rc4/drivers/md/dm-log.c
@@ -189,9 +189,8 @@ struct log_c {
 	unsigned bitset_uint32_count;
 	uint32_t *clean_bits;
 	uint32_t *sync_bits;
-	uint32_t *recovering_bits;	/* FIXME: this seems excessive */
 
-	int sync_search;
+	unsigned sync_search;
 
 	/* Resync flag */
 	enum sync {
@@ -418,18 +417,6 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	}
 	memset(lc->sync_bits, (sync == NOSYNC) ? -1 : 0, bitset_size);
 	lc->sync_count = (sync == NOSYNC) ? region_count : 0;
-
-	lc->recovering_bits = vmalloc(bitset_size);
-	if (!lc->recovering_bits) {
-		DMWARN("couldn't allocate sync bitset");
-		vfree(lc->sync_bits);
-		if (!dev)
-			vfree(lc->clean_bits);
-		vfree(lc->disk_header);
-		kfree(lc);
-		return -ENOMEM;
-	}
-	memset(lc->recovering_bits, 0, bitset_size);
 	lc->sync_search = 0;
 	log->context = lc;
 
@@ -445,7 +432,6 @@ static int core_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 static void destroy_log_context(struct log_c *lc)
 {
 	vfree(lc->sync_bits);
-	vfree(lc->recovering_bits);
 	kfree(lc);
 }
 
@@ -637,23 +623,17 @@ static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
-	if (lc->sync_search >= lc->region_count)
-		return 0;
-
-	do {
+	if (lc->sync_search < lc->region_count) {
 		*region = ext2_find_next_zero_bit(
-					     (unsigned long *) lc->sync_bits,
-					     lc->region_count,
-					     lc->sync_search);
+					(unsigned long *) lc->sync_bits,
+					lc->region_count, lc->sync_search);
 		lc->sync_search = *region + 1;
 
-		if (*region >= lc->region_count)
-			return 0;
-
-	} while (log_test_bit(lc->recovering_bits, *region));
+		if (*region < lc->region_count)
+			return 1;
+	}
 
-	log_set_bit(lc, lc->recovering_bits, *region);
-	return 1;
+	return 0;
 }
 
 static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
@@ -661,12 +641,14 @@ static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
-	log_clear_bit(lc, lc->recovering_bits, region);
 	if (in_sync) {
 		log_set_bit(lc, lc->sync_bits, region);
                 lc->sync_count++;
         } else if (log_test_bit(lc->sync_bits, region)) {
 		lc->sync_count--;
+		if (lc->sync_search > region)
+			lc->sync_search = region;
+
 		log_clear_bit(lc, lc->sync_bits, region);
 	}
 }
-- 
1.5.4.1
