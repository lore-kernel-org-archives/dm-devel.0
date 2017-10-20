From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 3/4] dm: convert dm_dev_internal.count from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 10:37:38 +0300
Message-ID: <1508485059-21881-4-git-send-email-elena.reshetova@intel.com>
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

The variable dm_dev_internal.count is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 drivers/md/dm-table.c | 6 +++---
 drivers/md/dm.h       | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ef7b8f2..fc7d240 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -451,15 +451,15 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			return r;
 		}
 
-		atomic_set(&dd->count, 0);
+		refcount_set(&dd->count, 1);
 		list_add(&dd->list, &t->devices);
 
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
 			return r;
+		refcount_inc(&dd->count);
 	}
-	atomic_inc(&dd->count);
 
 	*result = dd->dm_dev;
 	return 0;
@@ -515,7 +515,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 		       dm_device_name(ti->table->md), d->name);
 		return;
 	}
-	if (atomic_dec_and_test(&dd->count)) {
+	if (refcount_dec_and_test(&dd->count)) {
 		dm_put_table_device(ti->table->md, d);
 		list_del(&dd->list);
 		kfree(dd);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 38c84c0..36399bb8 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -19,6 +19,7 @@
 #include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/kobject.h>
+#include <linux/refcount.h>
 
 #include "dm-stats.h"
 
@@ -38,7 +39,7 @@
  */
 struct dm_dev_internal {
 	struct list_head list;
-	atomic_t count;
+	refcount_t count;
 	struct dm_dev *dm_dev;
 };
 
-- 
2.7.4
