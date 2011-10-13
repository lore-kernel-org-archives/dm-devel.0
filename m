From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio
Date: Thu, 13 Oct 2011 18:31:47 -0400
Message-ID: <20111013223147.GA14220@redhat.com>
References: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
	<20111013194001.GA12863@redhat.com>
	<Pine.LNX.4.64.1110131817300.11120@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110131817300.11120@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 13 2011 at  6:19pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > +static int dm_bufio_trylock(struct dm_bufio_client *c)
> > +{
> > +	return dm_bufio_trylock(c);
> > +}
> > +
> > +static void dm_bufio_unlock(struct dm_bufio_client *c)
> > +{
> > +	dm_bufio_unlock(c);
> > +}
> 
> These two functions are recursive nonsense :) There should be
> "return mutex_trylock(&c->lock);" and "mutex_unlock(&c->lock);".

Heheh.  Sorry, M-x replace-string gone wild.

Here is a fixed version.

---
 drivers/md/persistent-data/dm-bufio.c |   71 ++++++++++++++++++++++-----------
 1 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/md/persistent-data/dm-bufio.c b/drivers/md/persistent-data/dm-bufio.c
index 6be4386..e7d1aac 100644
--- a/drivers/md/persistent-data/dm-bufio.c
+++ b/drivers/md/persistent-data/dm-bufio.c
@@ -151,6 +151,23 @@ static inline int dm_bufio_cache_index(struct dm_bufio_client *c)
 #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
 #define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
 
+#define dm_bufio_in_request()	(!!current->bio_list)
+
+static void dm_bufio_lock(struct dm_bufio_client *c)
+{
+	mutex_lock_nested(&c->lock, dm_bufio_in_request());
+}
+
+static int dm_bufio_trylock(struct dm_bufio_client *c)
+{
+	return mutex_trylock(&c->lock);
+}
+
+static void dm_bufio_unlock(struct dm_bufio_client *c)
+{
+	mutex_unlock(&c->lock);
+}
+
 /*----------------------------------------------------------------*/
 
 /* Default cache size --- available memory divided by the ratio */
@@ -595,14 +612,14 @@ static void __wait_for_free_buffer(struct dm_bufio_client *c)
 
 	add_wait_queue(&c->free_buffer_wait, &wait);
 	set_task_state(current, TASK_UNINTERRUPTIBLE);
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 
 	io_schedule();
 
 	set_task_state(current, TASK_RUNNING);
 	remove_wait_queue(&c->free_buffer_wait, &wait);
 
-	mutex_lock(&c->lock);
+	dm_bufio_lock(c);
 }
 
 /*
@@ -836,9 +853,9 @@ static void *new_read(struct dm_bufio_client *c, sector_t block, enum new_flag n
 	int need_submit;
 	struct dm_buffer *b;
 
-	mutex_lock(&c->lock);
+	dm_bufio_lock(c);
 	b = __bufio_new(c, block, nf, bp, &need_submit);
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 
 	if (!b || IS_ERR(b))
 		return b;
@@ -867,19 +884,21 @@ void *dm_bufio_get(struct dm_bufio_client *c, sector_t block,
 void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
 		    struct dm_buffer **bp)
 {
+	BUG_ON(dm_bufio_in_request());
 	return new_read(c, block, NF_READ, bp);
 }
 
 void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 		   struct dm_buffer **bp)
 {
+	BUG_ON(dm_bufio_in_request());
 	return new_read(c, block, NF_FRESH, bp);
 }
 
 void dm_bufio_release(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
-	mutex_lock(&c->lock);
+	dm_bufio_lock(c);
 	BUG_ON(test_bit(B_READING, &b->state));
 	BUG_ON(!b->hold_count);
 	b->hold_count--;
@@ -898,26 +917,27 @@ void dm_bufio_release(struct dm_buffer *b)
 			__free_buffer_wake(b);
 		}
 	}
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 }
 
 void dm_bufio_mark_buffer_dirty(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
 
-	mutex_lock(&c->lock);
+	dm_bufio_lock(c);
 
 	if (!test_and_set_bit(B_DIRTY, &b->state))
 		__relink_lru(b, LIST_DIRTY);
 
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 }
 
 void dm_bufio_write_dirty_buffers_async(struct dm_bufio_client *c)
 {
-	mutex_lock(&c->lock);
+	BUG_ON(dm_bufio_in_request());
+	dm_bufio_lock(c);
 	__write_dirty_buffers_async(c, 0);
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 }
 
 /*
@@ -933,7 +953,7 @@ int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
 	unsigned long buffers_processed = 0;
 	struct dm_buffer *b, *tmp;
 
-	mutex_lock(&c->lock);
+	dm_bufio_lock(c);
 	__write_dirty_buffers_async(c, 0);
 
 again:
@@ -947,10 +967,10 @@ again:
 			if (buffers_processed < c->n_buffers[LIST_DIRTY]) {
 				dropped_lock = 1;
 				b->hold_count++;
-				mutex_unlock(&c->lock);
+				dm_bufio_unlock(c);
 				wait_on_bit(&b->state, B_WRITING,
 					    do_io_schedule, TASK_UNINTERRUPTIBLE);
-				mutex_lock(&c->lock);
+				dm_bufio_lock(c);
 				b->hold_count--;
 			} else
 				wait_on_bit(&b->state, B_WRITING,
@@ -978,7 +998,7 @@ again:
 			goto again;
 	}
 	wake_up(&c->free_buffer_wait);
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 
 	a = xchg(&c->async_write_error, 0);
 	f = dm_bufio_issue_flush(c);
@@ -1003,6 +1023,7 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 		.sector = 0,
 		.count = 0,
 	};
+	BUG_ON(dm_bufio_in_request());
 	return dm_io(&io_req, 1, &io_reg, NULL);
 }
 
@@ -1023,7 +1044,9 @@ void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block)
 	struct dm_bufio_client *c = b->c;
 	struct dm_buffer *new;
 
-	mutex_lock(&c->lock);
+	BUG_ON(dm_bufio_in_request());
+
+	dm_bufio_lock(c);
 
 retry:
 	new = __find(c, new_block);
@@ -1054,7 +1077,7 @@ retry:
 		wait_on_bit(&b->state, B_WRITING,
 			    do_io_schedule, TASK_UNINTERRUPTIBLE);
 	}
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 	dm_bufio_release(b);
 }
 
@@ -1094,10 +1117,12 @@ static void drop_buffers(struct dm_bufio_client *c)
 	struct dm_buffer *b;
 	int i;
 
+	BUG_ON(dm_bufio_in_request());
+
 	/* an optimization ... so that the buffers are not written one-by-one */
 	dm_bufio_write_dirty_buffers_async(c);
 
-	mutex_lock(&c->lock);
+	dm_bufio_lock(c);
 	while ((b = __get_unclaimed_buffer(c)))
 		__free_buffer_wake(b);
 
@@ -1110,7 +1135,7 @@ static void drop_buffers(struct dm_bufio_client *c)
 	for (i = 0; i < LIST_N; i++)
 		BUG_ON(!list_empty(&c->lru[i]));
 
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 }
 
 /*
@@ -1166,9 +1191,9 @@ static int shrink(struct shrinker *shrinker, struct shrink_control *sc)
 	unsigned long nr_to_scan = sc->nr_to_scan;
 
 	if (sc->gfp_mask & __GFP_IO) {
-		mutex_lock(&c->lock);
+		dm_bufio_lock(c);
 	} else {
-		if (!mutex_trylock(&c->lock))
+		if (!dm_bufio_trylock(c))
 			return !nr_to_scan ? 0 : -1;
 	}
 
@@ -1179,7 +1204,7 @@ static int shrink(struct shrinker *shrinker, struct shrink_control *sc)
 	if (r > INT_MAX)
 		r = INT_MAX;
 
-	mutex_unlock(&c->lock);
+	dm_bufio_unlock(c);
 
 	return r;
 }
@@ -1356,7 +1381,7 @@ static void cleanup_old_buffers(void)
 
 	mutex_lock(&dm_bufio_clients_lock);
 	list_for_each_entry(c, &dm_bufio_all_clients, client_list) {
-		if (!mutex_trylock(&c->lock))
+		if (!dm_bufio_trylock(c))
 			continue;
 
 		while (!list_empty(&c->lru[LIST_CLEAN])) {
@@ -1367,7 +1392,7 @@ static void cleanup_old_buffers(void)
 				break;
 		}
 
-		mutex_unlock(&c->lock);
+		dm_bufio_unlock(c);
 	}
 	mutex_unlock(&dm_bufio_clients_lock);
 }
