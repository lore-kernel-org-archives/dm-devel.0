From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: dm-thin: wakeup worker only when deferred bios exist
Date: Sun, 1 Dec 2019 01:15:37 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1912010110570.31846@mx.ewheeler.net>
References: <1573740655-104317-1-git-send-email-jefflexu@linux.alibaba.com>
	<20191114154848.GA21426@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191114154848.GA21426@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>, joseph.qi@linux.alibaba.com, ejt@redhat.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, 14 Nov 2019, Mike Snitzer wrote:

> On Thu, Nov 14 2019 at  9:10am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
> > Single thread fio test (read, bs=4k, ioengine=libaio, iodepth=128,
> > numjobs=1) over dm-thin device has poor performance versus bare nvme
> > disk on v5.4.0-rc7.
> > 
> > Further investigation with perf indicates that queue_work_on() consumes
> > over 20% CPU time when doing IO over dm-thin device. The call stack is
> > as follows.
> > 
> > - 46.64% thin_map
> >    + 22.28% queue_work_on
> >    + 12.98% dm_thin_find_block
> >    + 5.07% cell_defer_no_holder
> >    + 2.42% bio_detain.isra.33
> >    + 0.95% inc_all_io_entry.isra.31.part.32
> >      0.80% remap.isra.41
> > 
> > In cell_defer_no_holder(), wakeup_worker() is always called, no matter whether
> > the cell->bios list is empty or not. In single thread IO model, cell->bios list
> > is most likely empty. So skip waking up worker thread if cell->bios list is
> > empty.
> > 
> > A significant IO performance of single thread can be seen with this patch.
> > The original IO performance is 445 MiB/s with the fio test previously
> > described, while it is 643 MiB/s after applying the patch, which is a
> > 44% performance improvement.
> > 
> > Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> 
> Nice find, implementation detail questions inlined below.

Indeed!  

This cherry-picks clean into v4.19.y.  

Is there any reason this would be unsafe in 4.19?

--
Eric Wheeler


> 
> > ---
> >  drivers/md/dm-bio-prison-v1.c |  8 +++++++-
> >  drivers/md/dm-bio-prison-v1.h |  2 +-
> >  drivers/md/dm-thin.c          | 10 ++++++----
> >  3 files changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
> > index b538989..b2a9b8d 100644
> > --- a/drivers/md/dm-bio-prison-v1.c
> > +++ b/drivers/md/dm-bio-prison-v1.c
> > @@ -219,11 +219,17 @@ static void __cell_release_no_holder(struct dm_bio_prison *prison,
> >  
> >  void dm_cell_release_no_holder(struct dm_bio_prison *prison,
> >  			       struct dm_bio_prison_cell *cell,
> > -			       struct bio_list *inmates)
> > +			       struct bio_list *inmates, int *empty)
> >  {
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(&prison->lock, flags);
> > +	/*
> > +	 * The empty flag should represent the list state exactly
> > +	 * when the list is merged into @inmates, thus get the
> > +	 * list state when prison->lock is held.
> > +	 */
> > +	*empty = bio_list_empty(&cell->bios);
> >  	__cell_release_no_holder(prison, cell, inmates);
> >  	spin_unlock_irqrestore(&prison->lock, flags);
> >  }
> > diff --git a/drivers/md/dm-bio-prison-v1.h b/drivers/md/dm-bio-prison-v1.h
> > index cec52ac..500edbc 100644
> > --- a/drivers/md/dm-bio-prison-v1.h
> > +++ b/drivers/md/dm-bio-prison-v1.h
> > @@ -89,7 +89,7 @@ void dm_cell_release(struct dm_bio_prison *prison,
> >  		     struct bio_list *bios);
> >  void dm_cell_release_no_holder(struct dm_bio_prison *prison,
> >  			       struct dm_bio_prison_cell *cell,
> > -			       struct bio_list *inmates);
> > +			       struct bio_list *inmates, int *empty);
> >  void dm_cell_error(struct dm_bio_prison *prison,
> >  		   struct dm_bio_prison_cell *cell, blk_status_t error);
> >  
> > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > index fcd8877..51fd396 100644
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -480,9 +480,9 @@ static void cell_visit_release(struct pool *pool,
> >  
> >  static void cell_release_no_holder(struct pool *pool,
> >  				   struct dm_bio_prison_cell *cell,
> > -				   struct bio_list *bios)
> > +				   struct bio_list *bios, int *empty)
> >  {
> > -	dm_cell_release_no_holder(pool->prison, cell, bios);
> > +	dm_cell_release_no_holder(pool->prison, cell, bios, empty);
> >  	dm_bio_prison_free_cell(pool->prison, cell);
> >  }
> >  
> > @@ -886,12 +886,14 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
> >  {
> >  	struct pool *pool = tc->pool;
> >  	unsigned long flags;
> > +	int empty;
> >  
> >  	spin_lock_irqsave(&tc->lock, flags);
> > -	cell_release_no_holder(pool, cell, &tc->deferred_bio_list);
> > +	cell_release_no_holder(pool, cell, &tc->deferred_bio_list, &empty);
> >  	spin_unlock_irqrestore(&tc->lock, flags);
> >  
> > -	wake_worker(pool);
> > +	if (!empty)
> > +		wake_worker(pool);
> >  }
> 
> Think your point is tc->deferred_bio_list may have bios already, before
> the call to cell_release_no_holder, so simply checking if it is empty
> after the cell_release_no_holder call isn't enough?
> 
> But if tc->deferred_bio_list isn't empty then there is work that needs
> to be done, regardless of whether this particular cell created work, so
> I'm left wondering if you first tried simply checking if
> tc->deferred_bio_list is empty after cell_release_no_holder() in
> cell_defer_no_holder?
> 
> Thanks,
> Mike
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
