From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 1/4] bcache: convert cached_dev.count from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 10:37:36 +0300
Message-ID: <1508485059-21881-2-git-send-email-elena.reshetova@intel.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, kent.overstreet@gmail.com, koverstreet@google.com, ejt@redhat.comg, snitzer@redhat.com, shli@kernel.org, agk@redhat.com, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
List-Id: dm-devel.ids

atomic_t variables are currently used to implement reference
counters with the following properties:
 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided
refcount_t type and API that prevents accidental counter overflows
and underflows. This is important since overflows and underflows
can lead to use-after-free situation and be exploitable.

The variable cached_dev.count is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 drivers/md/bcache/bcache.h    | 7 ++++---
 drivers/md/bcache/super.c     | 6 +++---
 drivers/md/bcache/writeback.h | 2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2ed9bd2..8ed8ad6 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -184,6 +184,7 @@
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
+#include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
@@ -299,7 +300,7 @@ struct cached_dev {
 	struct semaphore	sb_write_mutex;
 
 	/* Refcount on the cache set. Always nonzero when we're caching. */
-	atomic_t		count;
+	refcount_t		count;
 	struct work_struct	detach;
 
 	/*
@@ -806,13 +807,13 @@ do {									\
 
 static inline void cached_dev_put(struct cached_dev *dc)
 {
-	if (atomic_dec_and_test(&dc->count))
+	if (refcount_dec_and_test(&dc->count))
 		schedule_work(&dc->detach);
 }
 
 static inline bool cached_dev_get(struct cached_dev *dc)
 {
-	if (!atomic_inc_not_zero(&dc->count))
+	if (!refcount_inc_not_zero(&dc->count))
 		return false;
 
 	/* Paired with the mb in cached_dev_attach */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fc0a31b..676e6f4 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -889,7 +889,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 	closure_init_stack(&cl);
 
 	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
-	BUG_ON(atomic_read(&dc->count));
+	BUG_ON(refcount_read(&dc->count));
 
 	mutex_lock(&bch_register_lock);
 
@@ -1016,7 +1016,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	 * dc->c must be set before dc->count != 0 - paired with the mb in
 	 * cached_dev_get()
 	 */
-	atomic_set(&dc->count, 1);
+	refcount_set(&dc->count, 1);
 
 	/* Block writeback thread, but spawn it */
 	down_write(&dc->writeback_lock);
@@ -1028,7 +1028,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
 		bch_sectors_dirty_init(&dc->disk);
 		atomic_set(&dc->has_dirty, 1);
-		atomic_inc(&dc->count);
+		refcount_inc(&dc->count);
 		bch_writeback_queue(dc);
 	}
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index e35421d..5937e0d 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -89,7 +89,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
 {
 	if (!atomic_read(&dc->has_dirty) &&
 	    !atomic_xchg(&dc->has_dirty, 1)) {
-		atomic_inc(&dc->count);
+		refcount_inc(&dc->count);
 
 		if (BDEV_STATE(&dc->sb) != BDEV_STATE_DIRTY) {
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_DIRTY);
-- 
2.7.4
