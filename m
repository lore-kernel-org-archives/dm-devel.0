From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/7] dm: make dm_vcalloc use dm_kvmalloc
Date: Fri, 3 Jul 2015 17:03:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507031701090.28837@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Make dm_vcalloc use dm_kvmalloc, so that smaller allocations are done with
kmalloc (which is faster).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |    2 +-
 drivers/md/dm-snap.c            |    2 +-
 drivers/md/dm-table.c           |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-4.1/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-4.1.orig/drivers/md/dm-snap-persistent.c	2015-07-03 14:33:26.000000000 +0200
+++ linux-4.1/drivers/md/dm-snap-persistent.c	2015-07-03 17:38:45.000000000 +0200
@@ -600,7 +600,7 @@ static void persistent_dtr(struct dm_exc
 	free_area(ps);
 
 	/* Allocated in persistent_read_metadata */
-	vfree(ps->callbacks);
+	kvfree(ps->callbacks);
 
 	kfree(ps);
 }
Index: linux-4.1/drivers/md/dm-snap.c
===================================================================
--- linux-4.1.orig/drivers/md/dm-snap.c	2015-07-03 14:33:27.000000000 +0200
+++ linux-4.1/drivers/md/dm-snap.c	2015-07-03 17:38:45.000000000 +0200
@@ -633,7 +633,7 @@ static void dm_exception_table_exit(stru
 			kmem_cache_free(mem, ex);
 	}
 
-	vfree(et->table);
+	kvfree(et->table);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
Index: linux-4.1/drivers/md/dm-table.c
===================================================================
--- linux-4.1.orig/drivers/md/dm-table.c	2015-07-03 15:39:39.000000000 +0200
+++ linux-4.1/drivers/md/dm-table.c	2015-07-03 18:24:07.000000000 +0200
@@ -180,7 +180,7 @@ void *dm_vcalloc(unsigned long nmemb, un
 		return NULL;
 
 	size = nmemb * elem_size;
-	addr = vzalloc(size);
+	addr = dm_kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
 
 	return addr;
 }
@@ -208,7 +208,7 @@ static int alloc_targets(struct dm_table
 	n_targets = (struct dm_target *) (n_highs + num);
 
 	memset(n_highs, -1, sizeof(*n_highs) * num);
-	vfree(t->highs);
+	kvfree(t->highs);
 
 	t->num_allocated = num;
 	t->highs = n_highs;
@@ -272,7 +272,7 @@ void dm_table_destroy(struct dm_table *t
 
 	/* free the indexes */
 	if (t->depth >= 2)
-		vfree(t->index[t->depth - 2]);
+		kvfree(t->index[t->depth - 2]);
 
 	/* free the targets */
 	for (i = 0; i < t->num_targets; i++) {
@@ -284,7 +284,7 @@ void dm_table_destroy(struct dm_table *t
 		dm_put_target_type(tgt->type);
 	}
 
-	vfree(t->highs);
+	kvfree(t->highs);
 
 	/* free the device list */
 	free_devices(&t->devices, t->md);
