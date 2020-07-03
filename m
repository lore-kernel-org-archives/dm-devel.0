From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: do cleanup from a workqueue
Date: Fri, 3 Jul 2020 10:26:46 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007031020150.23220@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200625113122.7540-1-willy@infradead.org> <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com> <20200626230847.GI2005@dread.disaster.area> <alpine.LRH.2.02.2006270848540.14350@file01.intranet.prod.int.rdu2.redhat.com>
 <20200629003550.GJ2005@dread.disaster.area> <alpine.LRH.2.02.2006290918030.11293@file01.intranet.prod.int.rdu2.redhat.com> <20200629223410.GK2005@dread.disaster.area>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200629223410.GK2005@dread.disaster.area>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids



On Tue, 30 Jun 2020, Dave Chinner wrote:

> https://lore.kernel.org/linux-fsdevel/20190809215733.GZ7777@dread.disaster.area/
> 
> If you did that when I suggested it, this problem would be solved.
> i.e. The only way to fix this problem once adn for all is to stop
> using the shrinker as a mechanism to issue and wait on IO. If you
> need background writeback of dirty buffers, do it from a
> WQ_MEM_RECLAIM workqueue that isn't directly in the memory reclaim
> path and so can issue writeback and block safely from a GFP_KERNEL
> context. Kick the workqueue from the shrinker context, but get rid
> of the IO submission and waiting from the shrinker and all the
> GFP_NOFS memory reclaim recursion problems go away.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Hi

This is a patch that moves buffer cleanup to a workqueue. Please review 
it.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

kswapd should not block because it degrades system performance.
So, move reclaim of buffers to a workqueue.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   60 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2020-07-03 14:07:43.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2020-07-03 15:35:23.000000000 +0200
@@ -108,7 +108,10 @@ struct dm_bufio_client {
 	int async_write_error;
 
 	struct list_head client_list;
+
 	struct shrinker shrinker;
+	struct work_struct shrink_work;
+	atomic_long_t need_shrink;
 };
 
 /*
@@ -1634,8 +1637,7 @@ static unsigned long get_retain_buffers(
 	return retain_bytes;
 }
 
-static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
-			    gfp_t gfp_mask)
+static void __scan(struct dm_bufio_client *c)
 {
 	int l;
 	struct dm_buffer *b, *tmp;
@@ -1646,42 +1648,58 @@ static unsigned long __scan(struct dm_bu
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
-			if (__try_evict_buffer(b, gfp_mask))
+			if (count - freed <= retain_target)
+				atomic_long_set(&c->need_shrink, 0);
+			if (!atomic_long_read(&c->need_shrink))
+				return;
+			if (__try_evict_buffer(b, GFP_KERNEL)) {
+				atomic_long_dec(&c->need_shrink);
 				freed++;
-			if (!--nr_to_scan || ((count - freed) <= retain_target))
-				return freed;
+			}
 			cond_resched();
 		}
 	}
-	return freed;
 }
 
-static unsigned long
-dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+static void shrink_work(struct work_struct *w)
+{
+	struct dm_bufio_client *c = container_of(w, struct dm_bufio_client, shrink_work);
+
+	dm_bufio_lock(c);
+	__scan(c);
+	dm_bufio_unlock(c);
+}
+
+static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct dm_bufio_client *c;
-	unsigned long freed;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_FS)
-		dm_bufio_lock(c);
-	else if (!dm_bufio_trylock(c))
-		return SHRINK_STOP;
+	atomic_long_add(sc->nr_to_scan, &c->need_shrink);
+	queue_work(dm_bufio_wq, &c->shrink_work);
 
-	freed  = __scan(c, sc->nr_to_scan, sc->gfp_mask);
-	dm_bufio_unlock(c);
-	return freed;
+	return sc->nr_to_scan;
 }
 
-static unsigned long
-dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
 	unsigned long count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
 			      READ_ONCE(c->n_buffers[LIST_DIRTY]);
 	unsigned long retain_target = get_retain_buffers(c);
+	unsigned long queued_for_cleanup = atomic_long_read(&c->need_shrink);
+
+	if (unlikely(count < retain_target))
+		count = 0;
+	else
+		count -= retain_target;
 
-	return (count < retain_target) ? 0 : (count - retain_target);
+	if (unlikely(count < queued_for_cleanup))
+		count = 0;
+	else
+		count -= queued_for_cleanup;
+
+	return count;
 }
 
 /*
@@ -1772,6 +1790,9 @@ struct dm_bufio_client *dm_bufio_client_
 		__free_buffer_wake(b);
 	}
 
+	INIT_WORK(&c->shrink_work, shrink_work);
+	atomic_long_set(&c->need_shrink, 0);
+
 	c->shrinker.count_objects = dm_bufio_shrink_count;
 	c->shrinker.scan_objects = dm_bufio_shrink_scan;
 	c->shrinker.seeks = 1;
@@ -1817,6 +1838,7 @@ void dm_bufio_client_destroy(struct dm_b
 	drop_buffers(c);
 
 	unregister_shrinker(&c->shrinker);
+	flush_work(&c->shrink_work);
 
 	mutex_lock(&dm_bufio_clients_lock);
 
