From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 05/17] dm transaction manager: add
	support for prefetching blocks of metadata
Date: Fri, 17 Oct 2014 02:06:55 -0400
Message-ID: <1413526027-21630-6-git-send-email-snitzer@redhat.com>
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

Introduce the dm_tm_issue_prefetches interface.  If you're using a
non-blocking clone the tm will build up a list of requested blocks that
weren't in core.  dm_tm_issue_prefetches will request those blocks to be
prefetched.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 .../md/persistent-data/dm-transaction-manager.c    | 77 +++++++++++++++++++++-
 .../md/persistent-data/dm-transaction-manager.h    |  7 ++
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 3bc30a0..9cb797d 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -10,6 +10,8 @@
 #include "dm-persistent-data-internal.h"
 
 #include <linux/export.h>
+#include <linux/mutex.h>
+#include <linux/hash.h>
 #include <linux/slab.h>
 #include <linux/device-mapper.h>
 
@@ -17,6 +19,61 @@
 
 /*----------------------------------------------------------------*/
 
+#define PREFETCH_SIZE 128
+#define PREFETCH_BITS 7
+#define PREFETCH_SENTINEL ((dm_block_t) -1ULL)
+
+struct prefetch_set {
+	struct mutex lock;
+	dm_block_t blocks[PREFETCH_SIZE];
+};
+
+static unsigned prefetch_hash(dm_block_t b)
+{
+	return hash_64(b, PREFETCH_BITS);
+}
+
+static void prefetch_wipe(struct prefetch_set *p)
+{
+	unsigned i;
+	for (i = 0; i < PREFETCH_SIZE; i++)
+		p->blocks[i] = PREFETCH_SENTINEL;
+}
+
+static void prefetch_init(struct prefetch_set *p)
+{
+	mutex_init(&p->lock);
+	prefetch_wipe(p);
+}
+
+static void prefetch_add(struct prefetch_set *p, dm_block_t b)
+{
+	unsigned h = prefetch_hash(b);
+
+	mutex_lock(&p->lock);
+	if (p->blocks[h] == PREFETCH_SENTINEL)
+		p->blocks[h] = b;
+
+	mutex_unlock(&p->lock);
+}
+
+static void prefetch_issue(struct prefetch_set *p, struct dm_block_manager *bm)
+{
+	unsigned i;
+
+	mutex_lock(&p->lock);
+
+	for (i = 0; i < PREFETCH_SIZE; i++)
+		if (p->blocks[i] != PREFETCH_SENTINEL) {
+			dm_bm_prefetch(bm, p->blocks[i]);
+			p->blocks[i] = PREFETCH_SENTINEL;
+		}
+
+	mutex_unlock(&p->lock);
+}
+
+/*----------------------------------------------------------------*/
+
 struct shadow_info {
 	struct hlist_node hlist;
 	dm_block_t where;
@@ -37,6 +94,8 @@ struct dm_transaction_manager {
 
 	spinlock_t lock;
 	struct hlist_head buckets[DM_HASH_SIZE];
+
+	struct prefetch_set prefetches;
 };
 
 /*----------------------------------------------------------------*/
@@ -117,6 +176,8 @@ static struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
 	for (i = 0; i < DM_HASH_SIZE; i++)
 		INIT_HLIST_HEAD(tm->buckets + i);
 
+	prefetch_init(&tm->prefetches);
+
 	return tm;
 }
 
@@ -268,8 +329,14 @@ int dm_tm_read_lock(struct dm_transaction_manager *tm, dm_block_t b,
 		    struct dm_block_validator *v,
 		    struct dm_block **blk)
 {
-	if (tm->is_clone)
-		return dm_bm_read_try_lock(tm->real->bm, b, v, blk);
+	if (tm->is_clone) {
+		int r = dm_bm_read_try_lock(tm->real->bm, b, v, blk);
+
+		if (r == -EWOULDBLOCK)
+			prefetch_add(&tm->real->prefetches, b);
+
+		return r;
+	}
 
 	return dm_bm_read_lock(tm->bm, b, v, blk);
 }
@@ -317,6 +384,12 @@ struct dm_block_manager *dm_tm_get_bm(struct dm_transaction_manager *tm)
 	return tm->bm;
 }
 
+void dm_tm_issue_prefetches(struct dm_transaction_manager *tm)
+{
+	prefetch_issue(&tm->prefetches, tm->bm);
+}
+EXPORT_SYMBOL_GPL(dm_tm_issue_prefetches);
+
 /*----------------------------------------------------------------*/
 
 static int dm_tm_create_internal(struct dm_block_manager *bm,
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
index 2772ed2..2e0d4d6 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.h
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -109,6 +109,13 @@ int dm_tm_ref(struct dm_transaction_manager *tm, dm_block_t b,
 struct dm_block_manager *dm_tm_get_bm(struct dm_transaction_manager *tm);
 
 /*
+ * If you're using a non-blocking clone the tm will build up a list of
+ * requested blocks that weren't in core.  This call will request those
+ * blocks to be prefetched.
+ */
+void dm_tm_issue_prefetches(struct dm_transaction_manager *tm);
+
+/*
  * A little utility that ties the knot by producing a transaction manager
  * that has a space map managed by the transaction manager...
  *
-- 
1.9.3
