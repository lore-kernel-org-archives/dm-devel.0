From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/4] dm cache: convert dm_cache_metadata.ref_count from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 10:37:37 +0300
Message-ID: <1508485059-21881-3-git-send-email-elena.reshetova@intel.com>
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

The variable dm_cache_metadata.ref_count is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 drivers/md/dm-cache-metadata.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 4a4e9c7..0d72124 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -13,6 +13,7 @@
 #include "persistent-data/dm-transaction-manager.h"
 
 #include <linux/device-mapper.h>
+#include <linux/refcount.h>
 
 /*----------------------------------------------------------------*/
 
@@ -100,7 +101,7 @@ struct cache_disk_superblock {
 } __packed;
 
 struct dm_cache_metadata {
-	atomic_t ref_count;
+	refcount_t ref_count;
 	struct list_head list;
 
 	unsigned version;
@@ -753,7 +754,7 @@ static struct dm_cache_metadata *metadata_open(struct block_device *bdev,
 	}
 
 	cmd->version = metadata_version;
-	atomic_set(&cmd->ref_count, 1);
+	refcount_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);
 	cmd->bdev = bdev;
 	cmd->data_block_size = data_block_size;
@@ -791,7 +792,7 @@ static struct dm_cache_metadata *lookup(struct block_device *bdev)
 
 	list_for_each_entry(cmd, &table, list)
 		if (cmd->bdev == bdev) {
-			atomic_inc(&cmd->ref_count);
+			refcount_inc(&cmd->ref_count);
 			return cmd;
 		}
 
@@ -862,7 +863,7 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 
 void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 {
-	if (atomic_dec_and_test(&cmd->ref_count)) {
+	if (refcount_dec_and_test(&cmd->ref_count)) {
 		mutex_lock(&table_lock);
 		list_del(&cmd->list);
 		mutex_unlock(&table_lock);
-- 
2.7.4
