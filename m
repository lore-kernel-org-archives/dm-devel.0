From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] RFC: dm: avoid the mutex lock in dm_bufio_shrink_count()
Date: Wed, 23 Nov 2016 15:42:27 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1611231531340.31481@file01.intranet.prod.int.rdu2.redhat.com>
References: <1479417398-2593-1-git-send-email-dianders@chromium.org> <alpine.DEB.2.10.1611171413450.99747@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1611171413450.99747@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Douglas Anderson <dianders@chromium.org>, Mike Snitzer <snitzer@redhat.com>, shli@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux@roeck-us.net, Sonny Rao <sonnyrao@chromium.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 17 Nov 2016, David Rientjes wrote:

> On Thu, 17 Nov 2016, Douglas Anderson wrote:
> 
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index b3ba142e59a4..885ba5482d9f 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > @@ -89,6 +89,7 @@ struct dm_bufio_client {
> >  
> >  	struct list_head lru[LIST_SIZE];
> >  	unsigned long n_buffers[LIST_SIZE];
> > +	unsigned long n_all_buffers;
> >  
> >  	struct block_device *bdev;
> >  	unsigned block_size;
> > @@ -485,6 +486,7 @@ static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)
> >  	struct dm_bufio_client *c = b->c;
> >  
> >  	c->n_buffers[dirty]++;
> > +	c->n_all_buffers++;
> >  	b->block = block;
> >  	b->list_mode = dirty;
> >  	list_add(&b->lru_list, &c->lru[dirty]);
> > @@ -502,6 +504,7 @@ static void __unlink_buffer(struct dm_buffer *b)
> >  	BUG_ON(!c->n_buffers[b->list_mode]);
> >  
> >  	c->n_buffers[b->list_mode]--;
> > +	c->n_all_buffers--;
> >  	__remove(b->c, b);
> >  	list_del(&b->lru_list);
> >  }
> > @@ -515,6 +518,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
> >  
> >  	BUG_ON(!c->n_buffers[b->list_mode]);
> >  
> > +	/* NOTE: don't update n_all_buffers: -1 + 1 = 0 */
> >  	c->n_buffers[b->list_mode]--;
> >  	c->n_buffers[dirty]++;
> >  	b->list_mode = dirty;
> > @@ -1588,17 +1592,10 @@ static unsigned long
> >  dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
> >  {
> >  	struct dm_bufio_client *c;
> > -	unsigned long count;
> >  
> >  	c = container_of(shrink, struct dm_bufio_client, shrinker);
> > -	if (sc->gfp_mask & __GFP_FS)
> > -		dm_bufio_lock(c);
> > -	else if (!dm_bufio_trylock(c))
> > -		return 0;
> >  
> > -	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
> > -	dm_bufio_unlock(c);
> > -	return count;
> > +	return c->n_all_buffers;
> >  }
> >  
> >  /*
> 
> Would be better to just avoid taking the mutex at all and returning 
> c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY] with a comment that 
> the estimate might be wrong, but the actual count may vary between 
> ->count_objects() and ->scan_objects() anyway, so we don't actually care?

Yes - here I'm sending a patch that reads c->n_buffers without the lock.


From: Mikulas Patocka <mpatocka@redhat.com>

dm-bufio: don't take the lock in dm_bufio_shrink_count

dm_bufio_shrink_count is called from do_shrink_slab to find out how many
freeable objects are there. The reported value doesn't have to be precise,
so we don't need to take the dm-bufio lock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -1587,18 +1587,9 @@ dm_bufio_shrink_scan(struct shrinker *sh
 static unsigned long
 dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct dm_bufio_client *c;
-	unsigned long count;
+	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
 
-	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_FS)
-		dm_bufio_lock(c);
-	else if (!dm_bufio_trylock(c))
-		return 0;
-
-	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
-	dm_bufio_unlock(c);
-	return count;
+	return ACCESS_ONCE(c->n_buffers[LIST_CLEAN]) + ACCESS_ONCE(c->n_buffers[LIST_DIRTY]);
 }
 
 /*
