From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio & dm-verity: use ACCESS_ONCE instead of
	volatile
Date: Wed, 15 Aug 2012 19:08:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208151907120.8587@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is a simple cleanup patch.

Mikulas

---

dm-bufio & dm-verity: use ACCESS_ONCE instead of volatile

If the variable can be asynchronously modified and we want to prevent
compiler optimizations that could assume that the variable is the same,
use ACCESS_ONCE macro, as documented in Documentation/atomic_ops.txt.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c  |    6 +++---
 drivers/md/dm-verity.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-3.5.1-fast/drivers/md/dm-bufio.c
===================================================================
--- linux-3.5.1-fast.orig/drivers/md/dm-bufio.c	2012-08-16 00:46:43.000000000 +0200
+++ linux-3.5.1-fast/drivers/md/dm-bufio.c	2012-08-16 00:49:08.000000000 +0200
@@ -280,7 +280,7 @@ static void __cache_size_refresh(void)
 	BUG_ON(!mutex_is_locked(&dm_bufio_clients_lock));
 	BUG_ON(dm_bufio_client_count < 0);
 
-	dm_bufio_cache_size_latch = *(volatile unsigned long *)&dm_bufio_cache_size;
+	dm_bufio_cache_size_latch = ACCESS_ONCE(dm_bufio_cache_size);
 
 	/*
 	 * Use default if set to 0 and report the actual cache size used.
@@ -811,7 +811,7 @@ static void __get_memory_limit(struct dm
 {
 	unsigned long buffers;
 
-	if (*(volatile unsigned long *)&dm_bufio_cache_size != dm_bufio_cache_size_latch) {
+	if (ACCESS_ONCE(dm_bufio_cache_size) != dm_bufio_cache_size_latch) {
 		mutex_lock(&dm_bufio_clients_lock);
 		__cache_size_refresh();
 		mutex_unlock(&dm_bufio_clients_lock);
@@ -1589,7 +1589,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_client_destro
 
 static void cleanup_old_buffers(void)
 {
-	unsigned long max_age = *(volatile unsigned *)&dm_bufio_max_age;
+	unsigned long max_age = ACCESS_ONCE(dm_bufio_max_age);
 	struct dm_bufio_client *c;
 
 	if (max_age > ULONG_MAX / HZ)
Index: linux-3.5.1-fast/drivers/md/dm-verity.c
===================================================================
--- linux-3.5.1-fast.orig/drivers/md/dm-verity.c	2012-08-16 00:46:14.000000000 +0200
+++ linux-3.5.1-fast/drivers/md/dm-verity.c	2012-08-16 00:47:11.000000000 +0200
@@ -438,7 +438,7 @@ static void verity_prefetch_io(struct dm
 		verity_hash_at_level(v, io->block, i, &hash_block_start, NULL);
 		verity_hash_at_level(v, io->block + io->n_blocks - 1, i, &hash_block_end, NULL);
 		if (!i) {
-			unsigned cluster = *(volatile unsigned *)&dm_verity_prefetch_cluster;
+			unsigned cluster = ACCESS_ONCE(dm_verity_prefetch_cluster);
 
 			cluster >>= v->data_dev_block_bits;
 			if (unlikely(!cluster))
