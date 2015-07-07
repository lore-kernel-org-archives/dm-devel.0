From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/7] dm: make dm_vcalloc use kvmalloc
Date: Tue, 7 Jul 2015 11:13:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507071112280.23387@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1507071058350.23387@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LRH.2.02.1507071058350.23387@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mike Snitzer <msnitzer@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Make dm_vcalloc use kvmalloc, so that smaller allocations are done with
kmalloc (which is faster).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |    2 +-
 drivers/md/dm-snap.c            |    2 +-
 drivers/md/dm-table.c           |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-4.2-rc1/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-4.2-rc1.orig/drivers/md/dm-snap-persistent.c	2015-07-07 15:50:23.000000000 +0200
+++ linux-4.2-rc1/drivers/md/dm-snap-persistent.c	2015-07-07 15:59:43.000000000 +0200
@@ -600,7 +600,7 @@ static void persistent_dtr(struct dm_exc
 	free_area(ps);
 
 	/* Allocated in persistent_read_metadata */
-	vfree(ps->callbacks);
+	kvfree(ps->callbacks);
 
 	kfree(ps);
 }
Index: linux-4.2-rc1/drivers/md/dm-snap.c
===================================================================
--- linux-4.2-rc1.orig/drivers/md/dm-snap.c	2015-07-07 15:50:23.000000000 +0200
+++ linux-4.2-rc1/drivers/md/dm-snap.c	2015-07-07 15:59:43.000000000 +0200
@@ -633,7 +633,7 @@ static void dm_exception_table_exit(stru
 			kmem_cache_free(mem, ex);
 	}
 
-	vfree(et->table);
+	kvfree(et->table);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
Index: linux-4.2-rc1/drivers/md/dm-table.c
===================================================================
--- linux-4.2-rc1.orig/drivers/md/dm-table.c	2015-07-07 15:50:25.000000000 +0200
+++ linux-4.2-rc1/drivers/md/dm-table.c	2015-07-07 15:59:43.000000000 +0200
@@ -143,7 +143,7 @@ void *dm_vcalloc(unsigned long nmemb, un
 		return NULL;
 
 	size = nmemb * elem_size;
-	addr = vzalloc(size);
+	addr = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
 
 	return addr;
 }
@@ -171,7 +171,7 @@ static int alloc_targets(struct dm_table
 	n_targets = (struct dm_target *) (n_highs + num);
 
 	memset(n_highs, -1, sizeof(*n_highs) * num);
-	vfree(t->highs);
+	kvfree(t->highs);
 
 	t->num_allocated = num;
 	t->highs = n_highs;
@@ -235,7 +235,7 @@ void dm_table_destroy(struct dm_table *t
 
 	/* free the indexes */
 	if (t->depth >= 2)
-		vfree(t->index[t->depth - 2]);
+		kvfree(t->index[t->depth - 2]);
 
 	/* free the targets */
 	for (i = 0; i < t->num_targets; i++) {
@@ -247,7 +247,7 @@ void dm_table_destroy(struct dm_table *t
 		dm_put_target_type(tgt->type);
 	}
 
-	vfree(t->highs);
+	kvfree(t->highs);
 
 	/* free the device list */
 	free_devices(&t->devices, t->md);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
