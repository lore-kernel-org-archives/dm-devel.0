From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/7] dm-thin: use kvmalloc
Date: Tue, 7 Jul 2015 11:11:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507071111190.23387@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1507071058350.23387@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LRH.2.02.1507071058350.23387@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mike Snitzer <msnitzer@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Make dm-thin use kvmalloc instead of kmalloc because there was a reported
allocation failure - see
https://bugzilla.redhat.com/show_bug.cgi?id=1225370

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-4.2-rc1/drivers/md/dm-thin.c
===================================================================
--- linux-4.2-rc1.orig/drivers/md/dm-thin.c	2015-07-06 17:32:35.000000000 +0200
+++ linux-4.2-rc1/drivers/md/dm-thin.c	2015-07-06 17:36:28.000000000 +0200
@@ -2791,7 +2791,7 @@ static void __pool_destroy(struct pool *
 	mempool_destroy(pool->mapping_pool);
 	dm_deferred_set_destroy(pool->shared_read_ds);
 	dm_deferred_set_destroy(pool->all_io_ds);
-	kfree(pool);
+	kvfree(pool);
 }
 
 static struct kmem_cache *_new_mapping_cache;
@@ -2813,7 +2813,7 @@ static struct pool *pool_create(struct m
 		return (struct pool *)pmd;
 	}
 
-	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	pool = kvmalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool) {
 		*error = "Error allocating memory for pool";
 		err_p = ERR_PTR(-ENOMEM);
@@ -2908,7 +2908,7 @@ bad_wq:
 bad_kcopyd_client:
 	dm_bio_prison_destroy(pool->prison);
 bad_prison:
-	kfree(pool);
+	kvfree(pool);
 bad_pool:
 	if (dm_pool_metadata_close(pmd))
 		DMWARN("%s: dm_pool_metadata_close() failed.", __func__);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
