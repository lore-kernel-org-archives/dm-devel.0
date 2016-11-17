From: Douglas Anderson <dianders@chromium.org>
Subject: [PATCH] RFC: dm: avoid the mutex lock in dm_bufio_shrink_count()
Date: Thu, 17 Nov 2016 13:16:38 -0800
Message-ID: <1479417398-2593-1-git-send-email-dianders@chromium.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: David Rientjes <rientjes@google.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Sonny Rao <sonnyrao@chromium.org>, linux@roeck-us.net, Douglas Anderson <dianders@chromium.org>, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

As reported in my recent patch ("dm: Avoid sleeping while holding the
dm_bufio lock"), we've seen in-field reports of lots of tasks sitting
blocked on:

  mutex_lock+0x4c/0x68
  dm_bufio_shrink_count+0x38/0x78
  shrink_slab.part.54.constprop.65+0x100/0x464
  shrink_zone+0xa8/0x198

Analysis of dm_bufio_shrink_count() shows that it's not much work to
avoid grabbing the mutex there.  Presumably if we can avoid grabbing
this mutex then other tasks (including those handling swap) may
sometimes return faster.

Note that it's likely that this won't be a huge savings since we'll
just need to grab the mutex if dm_bufio_shrink_scan() is called, but
it still seems like it would be a sane tradeoff.

This does slightly change the behavior of dm_bufio_shrink_count().  If
anyone was relying on dm_bufio_shrink_count() to return the total
count _after_ some in-progress operation finished then they'll no
longer get that behavior.  It seems unlikely anyone would be relying
on this behavior, though, because:
- Someone would have to be certain that the operation was already in
  progress _before_ dm_bufio_shrink_count() was called.  If the
  operation wasn't already in progress then we'd get the lock first.
- There aren't exactly lots of long-running operations where the
  dm_bufio lock is held the whole time.  Most functions using the
  dm_bufio lock grab and drop it almost constantly.  That means that
  getting the dm_bufio doesn't mean that any in-progress dm_bufio
  transactions are all done.
Maybe the above argument would be obvious to someone wise in the ways
of dm_bufio but it's a useful argument to make for those like me who
are trying to make a small fix without full comprehension of all of
dm_bufio's finer details.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
It's a bit unclear if this is actually useful and I don't have any
test cases showing the benefit, but posting it in case someone else
has good test cases or thinks it's a clear win.

Same caveat that this development was done on Chrome OS Kernel 4.4

 drivers/md/dm-bufio.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index b3ba142e59a4..885ba5482d9f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -89,6 +89,7 @@ struct dm_bufio_client {
 
 	struct list_head lru[LIST_SIZE];
 	unsigned long n_buffers[LIST_SIZE];
+	unsigned long n_all_buffers;
 
 	struct block_device *bdev;
 	unsigned block_size;
@@ -485,6 +486,7 @@ static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)
 	struct dm_bufio_client *c = b->c;
 
 	c->n_buffers[dirty]++;
+	c->n_all_buffers++;
 	b->block = block;
 	b->list_mode = dirty;
 	list_add(&b->lru_list, &c->lru[dirty]);
@@ -502,6 +504,7 @@ static void __unlink_buffer(struct dm_buffer *b)
 	BUG_ON(!c->n_buffers[b->list_mode]);
 
 	c->n_buffers[b->list_mode]--;
+	c->n_all_buffers--;
 	__remove(b->c, b);
 	list_del(&b->lru_list);
 }
@@ -515,6 +518,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
 
 	BUG_ON(!c->n_buffers[b->list_mode]);
 
+	/* NOTE: don't update n_all_buffers: -1 + 1 = 0 */
 	c->n_buffers[b->list_mode]--;
 	c->n_buffers[dirty]++;
 	b->list_mode = dirty;
@@ -1588,17 +1592,10 @@ static unsigned long
 dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct dm_bufio_client *c;
-	unsigned long count;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_FS)
-		dm_bufio_lock(c);
-	else if (!dm_bufio_trylock(c))
-		return 0;
 
-	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
-	dm_bufio_unlock(c);
-	return count;
+	return c->n_all_buffers;
 }
 
 /*
-- 
2.8.0.rc3.226.g39d4020

