From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 2/3 v2] dm-writecache: convert wait queue to
 wake_up_process
Date: Fri, 8 Jun 2018 17:18:16 -0400
Message-ID: <20180608211816.GB11149@redhat.com>
References: <20180606153201.708853388@debian.vm>
	<alpine.LRH.2.02.1806071147110.10781@file01.intranet.prod.int.rdu2.redhat.com>
	<20180608151315.GA9505@redhat.com>
	<20180608153058.GA13368@redhat.com>
	<alpine.LRH.2.02.1806081659450.30903@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806081659450.30903@file01.intranet.prod.int.rdu2.redhat.com>
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

On Fri, Jun 08 2018 at  5:06pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 8 Jun 2018, Mike Snitzer wrote:
> 
> > On Fri, Jun 08 2018 at 11:13P -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > I'd prefer the following, so please help me understand why you aren't
> > doing it this way.  Thanks.
> > 
> > diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> > index 5961c7794ef3..17cd81ce6ec3 100644
> > --- a/drivers/md/dm-writecache.c
> > +++ b/drivers/md/dm-writecache.c
> > @@ -1103,9 +1103,9 @@ static int writecache_flush_thread(void *data)
> >  
> >  static void writecache_offload_bio(struct dm_writecache *wc, struct bio *bio)
> >  {
> > -	if (bio_list_empty(&wc->flush_list))
> > -		wake_up_process(wc->flush_thread);
> > +	lockdep_assert_held(&wc->lock);
> >  	bio_list_add(&wc->flush_list, bio);
> > +	wake_up_process(wc->flush_thread);
> >  }
> >  
> >  static int writecache_map(struct dm_target *ti, struct bio *bio)
> > @@ -1295,10 +1295,9 @@ static void writecache_writeback_endio(struct bio *bio)
> >  	unsigned long flags;
> >  
> >  	raw_spin_lock_irqsave(&wc->endio_list_lock, flags);
> > -	if (unlikely(list_empty(&wc->endio_list)))
> > -		wake_up_process(wc->endio_thread);
> >  	list_add_tail(&wb->endio_entry, &wc->endio_list);
> >  	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
> > +	wake_up_process(wc->endio_thread);
> >  }
> >  
> >  static void writecache_copy_endio(int read_err, unsigned long write_err, void *ptr)
> > @@ -1309,10 +1308,9 @@ static void writecache_copy_endio(int read_err, unsigned long write_err, void *p
> >  	c->error = likely(!(read_err | write_err)) ? 0 : -EIO;
> >  
> >  	raw_spin_lock_irq(&wc->endio_list_lock);
> > -	if (unlikely(list_empty(&wc->endio_list)))
> > -		wake_up_process(wc->endio_thread);
> >  	list_add_tail(&c->endio_entry, &wc->endio_list);
> >  	raw_spin_unlock_irq(&wc->endio_list_lock);
> > +	wake_up_process(wc->endio_thread);
> >  }
> >  
> >  static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *list)
> 
> This is incorrect.
> 
> When you drop the spinlock, the endio thread may already take the item (it 
> may take it even before wake_up_process is called). When the endio thread 
> consumes all the items, the user may unload the device. When the user 
> unloads the device, wc is freed and wc->endio_thread points to a 
> non-existing process - and now you dereference freed "wc" structure and 
> call wake_up_process on non-existing process and cause a crash.
> 
> wake_up_process must be inside the spinlock to avoid this race condition.

OK, I understand, thanks.
