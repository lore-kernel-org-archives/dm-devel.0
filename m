From: thornber@redhat.com
Subject: Re: [PATCH 5/8] [dm-thin] Fix a race condition between
 discard bios and ordinary bios.
Date: Thu, 24 Jan 2013 13:23:00 +0000
Message-ID: <20130124132259.GA6658@raspberrypi>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-6-git-send-email-ejt@redhat.com>
	<20130124023503.GG30267@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130124023503.GG30267@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 24, 2013 at 02:35:03AM +0000, Alasdair G Kergon wrote:
> On Thu, Dec 13, 2012 at 08:19:13PM +0000, Joe Thornber wrote:
> > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > index 504f3d6..8e47f44 100644
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -222,10 +222,28 @@ struct thin_c {
> >  
> >  	struct pool *pool;
> >  	struct dm_thin_device *td;
> > +
> > +	/*
> > +	 * The cell structures are too big to put on the stack, so we have
> > +	 * a couple here for use by the main mapping function.
> > +	 */
> > +	spinlock_t lock;
> > +	struct dm_bio_prison_cell cell1, cell2;
> 
> We're also trying to cut down on locking on these code paths.
> (High i/o load, many many cores?)
> 
> Have you hit any problems while testing due to the stack size?
> The cells don't seem ridiculously big - could we perhaps just put them on 
> the stack for now?  If we do hit stack size problems in real world
> configurations, then we can try to compare the locking approach with an
> approach that uses a separate (local) mempool for each cell (or a
> mempool with double-sized elements).

I haven't hit any stack size issues.  But the cell structures are 60
bytes each and putting two of them on the stack seems wasteful.  I
don't have enough knowledge to say this will be ok for all
architectures and so took the safe option.

As for the spinlock; I agree that we need to be getting rid of locks
on the fast path.  There are two separate concerns here.

   i) lock contention.  We hold spin locks for short periods so
   hopefully this isn't happening much.  I admit this has been my main
   focus when reasoning about the cost of locks.

   ii) cpu cache invalidation caused by memory barriers.  Harder to
   reason about.  We just have to test well.  Removing locks will be a
   compromise in other ways and we need to be careful to show we're
   improving performance.  I think this is what the community is
   concerned about now?

The map function in dm-thin calls dm_thin_find_block() which hides a
multitude of locking:

   i) All functions in dm-thin-metadata.c grab a top level rw
   semaphore.  In the map function's case we use a try_read_lock so it
   wont block, if it would block the bio is deferred to the worker
   thread.

   ii) Whenever we get a metadata block from the block manager's
   cache, for instance as part of a btree lookup for the mapping, a
   rwsem is grabbed for the block.  Again the fast path uses
   non-blocking variants to exit early.

We don't need both (i) and (ii).  The original intention was to just
have block level locking.  The btree code is written carefully to
allow concurrent updates and lookups using a rolling lock scheme.  To
get this working we need to put some form of quiescing into the commit
code; we must ensure no read operations are in flight on a btree
from the prior transaction before committing the current one.  This
commit barrier shouldn't be hard to put in.

Alternatively we could accept that the top level rwsem is there and
just ditch the block level locking.  I'd still want to keep it as a
debug option, since it's great for catching errors in the metadata
handling.  In fact I did have this as an option in Kconfig originally
but you asked me to turn it on always.

Summarising our options:

  a) top level spin lock to protect the 'root block' field in
  thin_metadata, and implement the commit barrier.  And a spin lock on
  every metadata block aquisition.  More locks but the concurrent
  lookup/update for the btrees will mean fewer bios get deferred by
  the map function to another thread.

  b) Top level rwsem.  Drop block locking except as a debug option.
  More bios handed over to a separate thread for processing.

(b) is certainly simpler; if you'd like to go back to this say and
I'll get a patch to you.  (a) is better if you're just considering
lock contention, but it clearly will trigger more memory barriers.

Either way I think you should merge the patch as given.  You've just
focussed on the spin lock because you can see it being called from
that map function.  If we're serious about reducing locks then the
above piece of work is where we should start.

> > -		if (bio_detain(tc->pool, &key, bio, &cell1))
> > +		if (dm_bio_detain(tc->pool->prison, &key, bio, &tc->cell1, &cell_result)) {
> 
> This deals with the existing upstream mempool deadlock, but there are
> still some other calls to bio_detain() remaining in the file in other
> functions that take one cell from a mempool and, before returning it,
> may require a second cell from the same mempool, which could lead
> to a deadlock.
> 
> Can they be fixed too?  (Multiple mempools/larger mempool elements where
> there isn't such an easy on-stack fix?  In the worst case we might
> later end up unable to avoid having to use the bio front_pad.)

Yes, I've been unable to trigger this though so it dropped down in
priority.  We can use a similar approach to what I've done in dm-cache
and have a little 'prealloced_structs' object that we fill in at an
apposite moment.  I'll get a patch to you, this is additional work and
shouldn't hold up the current patch.

- Joe
