From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: store stacktrace in the buffers
Date: Mon, 23 Nov 2015 19:20:06 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511231918420.19229@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch stores stacktrace in the buffers to allow finding buffer leaks.
We use the option DM_DEBUG_BLOCK_STACK_TRACING.

The option DM_DEBUG_BLOCK_STACK_TRACING is moved from persistent-data
directory to device mapper directory because it will be used not only for
persistent data. When the option is enabled, each buffer stores the
stacktrace of the last dm_bufio_get, dm_bufio_read or dm_bufio_new call
that increased the hold count to 1. If the buffer is not released when the
bufio client is destroyed, the stacktrace is printed.

When DM_DEBUG_BLOCK_STACK_TRACING, the buffer leaks are considered
warnings - i.e. the kernel continues afterwards. If not, buffer leaks are
considered BUGs and the kernel crashes. I believe that if we made buffer
leaks always warnings, users would ignore them and the code would never be
fixed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-4.4-rc2/drivers/md/Kconfig
===================================================================
--- linux-4.4-rc2.orig/drivers/md/Kconfig
+++ linux-4.4-rc2/drivers/md/Kconfig
@@ -240,6 +240,15 @@ config DM_BUFIO
 	 as a cache, holding recently-read blocks in memory and performing
 	 delayed writes.
 
+config DM_DEBUG_BLOCK_STACK_TRACING
+       bool "Keep stack trace of persistent data block lock holders"
+       depends on STACKTRACE_SUPPORT && DM_BUFIO
+       select STACKTRACE
+       ---help---
+	 Enable this for messages that may help debug problems with the
+	 block manager locking used by thin provisioning and caching.
+
+	 If unsure, say N.
 config DM_BIO_PRISON
        tristate
        depends on BLK_DEV_DM
Index: linux-4.4-rc2/drivers/md/persistent-data/Kconfig
===================================================================
--- linux-4.4-rc2.orig/drivers/md/persistent-data/Kconfig
+++ linux-4.4-rc2/drivers/md/persistent-data/Kconfig
@@ -7,12 +7,3 @@ config DM_PERSISTENT_DATA
 	 Library providing immutable on-disk data structure support for
 	 device-mapper targets such as the thin provisioning target.
 
-config DM_DEBUG_BLOCK_STACK_TRACING
-       bool "Keep stack trace of persistent data block lock holders"
-       depends on STACKTRACE_SUPPORT && DM_PERSISTENT_DATA
-       select STACKTRACE
-       ---help---
-	 Enable this for messages that may help debug problems with the
-	 block manager locking used by thin provisioning and caching.
-
-	 If unsure, say N.
Index: linux-4.4-rc2/drivers/md/dm-bufio.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/dm-bufio.c
+++ linux-4.4-rc2/drivers/md/dm-bufio.c
@@ -16,6 +16,7 @@
 #include <linux/shrinker.h>
 #include <linux/module.h>
 #include <linux/rbtree.h>
+#include <linux/stacktrace.h>
 
 #define DM_MSG_PREFIX "bufio"
 
@@ -149,6 +150,11 @@ struct dm_buffer {
 	struct list_head write_list;
 	struct bio bio;
 	struct bio_vec bio_vec[DM_BUFIO_INLINE_VECS];
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+#define MAX_STACK	10
+	struct stack_trace stack_trace;
+	unsigned long stack_entries[MAX_STACK];
+#endif
 };
 
 /*----------------------------------------------------------------*/
@@ -253,6 +259,17 @@ static LIST_HEAD(dm_bufio_all_clients);
  */
 static DEFINE_MUTEX(dm_bufio_clients_lock);
 
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+static void buffer_record_stack(struct dm_buffer *b)
+{
+	b->stack_trace.nr_entries = 0;
+	b->stack_trace.max_entries = MAX_STACK;
+	b->stack_trace.entries = b->stack_entries;
+	b->stack_trace.skip = 2;
+	save_stack_trace(&b->stack_trace);
+}
+#endif
+
 /*----------------------------------------------------------------
  * A red/black tree acts as an index for all the buffers.
  *--------------------------------------------------------------*/
@@ -454,6 +471,10 @@ static struct dm_buffer *alloc_buffer(st
 
 	adjust_total_allocated(b->data_mode, (long)c->block_size);
 
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+	memset(&b->stack_trace, 0, sizeof b->stack_trace);
+#endif
+
 	return b;
 }
 
@@ -1063,6 +1084,10 @@ static void *new_read(struct dm_bufio_cl
 
 	dm_bufio_lock(c);
 	b = __bufio_new(c, block, nf, &need_submit, &write_list);
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+	if (b && b->hold_count == 1)
+		buffer_record_stack(b);
+#endif
 	dm_bufio_unlock(c);
 
 	__flush_write_list(&write_list);
@@ -1462,6 +1487,7 @@ static void drop_buffers(struct dm_bufio
 {
 	struct dm_buffer *b;
 	int i;
+	bool warned = false;
 
 	BUG_ON(dm_bufio_in_request());
 
@@ -1476,9 +1502,21 @@ static void drop_buffers(struct dm_bufio
 		__free_buffer_wake(b);
 
 	for (i = 0; i < LIST_SIZE; i++)
-		list_for_each_entry(b, &c->lru[i], lru_list)
+		list_for_each_entry(b, &c->lru[i], lru_list) {
+			WARN_ON(!warned);
+			warned = true;
 			DMERR("leaked buffer %llx, hold count %u, list %d",
 			      (unsigned long long)b->block, b->hold_count, i);
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+			print_stack_trace(&b->stack_trace, 1);
+			b->hold_count = 0;	/* avoid the BUG */
+#endif
+		}
+
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+	while ((b = __get_unclaimed_buffer(c)))
+		__free_buffer_wake(b);
+#endif
 
 	for (i = 0; i < LIST_SIZE; i++)
 		BUG_ON(!list_empty(&c->lru[i]));
