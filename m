From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 2/3 v2] dm-writecache: convert wait queue to
 wake_up_process
Date: Fri, 8 Jun 2018 11:30:58 -0400
Message-ID: <20180608153058.GA13368@redhat.com>
References: <20180606153201.708853388@debian.vm>
	<alpine.LRH.2.02.1806071147110.10781@file01.intranet.prod.int.rdu2.redhat.com>
	<20180608151315.GA9505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180608151315.GA9505@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jun 08 2018 at 11:13P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Jun 07 2018 at 11:48am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > This is second version of this patch - it also removes the label 
> > continue_locked, because it is no longer needed. If forgot to refresh the 
> > patch before sending it, so I sent an olded version.
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Subject: [patch 2/3 v2] dm-writecache: convert wait queue to wake_up_process
> > 
> > If there's just one process that can wait on a queue, we can use
> > wake_up_process. According to Linus, it is safe to call wake_up_process
> > on a process even if the process may be doing something else.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/md/dm-writecache.c |   34 +++++++++++++++-------------------
> >  1 file changed, 15 insertions(+), 19 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/dm-writecache.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-writecache.c	2018-06-05 22:54:49.000000000 +0200
> > +++ linux-2.6/drivers/md/dm-writecache.c	2018-06-07 17:44:11.000000000 +0200
> > @@ -1273,10 +1272,11 @@ static void writecache_writeback_endio(s
> >  	struct dm_writecache *wc = wb->wc;
> >  	unsigned long flags;
> >  
> > -	raw_spin_lock_irqsave(&wc->endio_thread_wait.lock, flags);
> > +	raw_spin_lock_irqsave(&wc->endio_list_lock, flags);
> > +	if (unlikely(list_empty(&wc->endio_list)))
> > +		wake_up_process(wc->endio_thread);
> >  	list_add_tail(&wb->endio_entry, &wc->endio_list);
> > -	swake_up_locked(&wc->endio_thread_wait);
> > -	raw_spin_unlock_irqrestore(&wc->endio_thread_wait.lock, flags);
> > +	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
> >  }
> 
> I'm not following the logic you're using for the above pattern of using
> wake_up_process if the list is empty.. seems unintuitive.
> 
> Given you add to the list (be it endio here, or flush elsewhere), why
> not just add to the list and then always wake_up_process()?

I'd prefer the following, so please help me understand why you aren't
doing it this way.  Thanks.

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5961c7794ef3..17cd81ce6ec3 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1103,9 +1103,9 @@ static int writecache_flush_thread(void *data)
 
 static void writecache_offload_bio(struct dm_writecache *wc, struct bio *bio)
 {
-	if (bio_list_empty(&wc->flush_list))
-		wake_up_process(wc->flush_thread);
+	lockdep_assert_held(&wc->lock);
 	bio_list_add(&wc->flush_list, bio);
+	wake_up_process(wc->flush_thread);
 }
 
 static int writecache_map(struct dm_target *ti, struct bio *bio)
@@ -1295,10 +1295,9 @@ static void writecache_writeback_endio(struct bio *bio)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&wc->endio_list_lock, flags);
-	if (unlikely(list_empty(&wc->endio_list)))
-		wake_up_process(wc->endio_thread);
 	list_add_tail(&wb->endio_entry, &wc->endio_list);
 	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
+	wake_up_process(wc->endio_thread);
 }
 
 static void writecache_copy_endio(int read_err, unsigned long write_err, void *ptr)
@@ -1309,10 +1308,9 @@ static void writecache_copy_endio(int read_err, unsigned long write_err, void *p
 	c->error = likely(!(read_err | write_err)) ? 0 : -EIO;
 
 	raw_spin_lock_irq(&wc->endio_list_lock);
-	if (unlikely(list_empty(&wc->endio_list)))
-		wake_up_process(wc->endio_thread);
 	list_add_tail(&c->endio_entry, &wc->endio_list);
 	raw_spin_unlock_irq(&wc->endio_list_lock);
+	wake_up_process(wc->endio_thread);
 }
 
 static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *list)
