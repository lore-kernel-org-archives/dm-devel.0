From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-region-hash: fix strange usage of
 mempool_alloc.
Date: Wed, 3 May 2017 14:19:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1705031412260.21503@file01.intranet.prod.int.rdu2.redhat.com>
References: <87efx1xb9h.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1704210847510.31816@file01.intranet.prod.int.rdu2.redhat.com>
	<87k26ar38n.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87k26ar38n.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 24 Apr 2017, NeilBrown wrote:

> On Fri, Apr 21 2017, Mikulas Patocka wrote:
> 
> > On Mon, 10 Apr 2017, NeilBrown wrote:
> >
> >> mempool_alloc() should only be called with GFP_ATOMIC when
> >> it is not safe to wait. Passing __GFP_NOFAIL to kmalloc()
> >> says that it is safe to wait indefinitely.  So this code is
> >> inconsistent.
> >> 
> >> Clearly it is OK to wait indefinitely in this code, and
> >> mempool_alloc() is able to do that.  So just use
> >> mempool_alloc, and allow it to sleep.  If no memory is
> >> available it will wait for something to be returned to the
> >> pool, and will retry a normal allocation regularly.
> >
> > The region hash code is buggy anyway, because it may allocate more entries 
> > than the size of the pool and not give them back.
> >
> > That kmalloc was introduced in the commit c06aad854 to work around a 
> > deadlock due to incorrect mempool usage.
> >
> > Your patch slightly increases the probability of the deadlock because 
> > mempool_alloc does all allocations with __GFP_NOMEMALLOC, so it uses 
> > higher limit than kmalloc(GFP_NOIO).
> >
> 
> Thanks for the review.
> 
> I had a look at how the allocation 'dm_region' objects are used,
> and it would take a bit of work to make it really safe.
> My guess is __rh_find() should be allowed to fail, and the various
> callers need to handle failure.
> For example, dm_rh_inc_pending() would be given a second bio_list,
> and would move any bios for which rh_inc() fails, onto that list.
> Then do_writes() would merge that list back into ms->writes.
> That way do_mirror() would not block indefinitely and forward progress
> could be assured ... maybe.
> It would take more work than I'm able to give at the moment, so
> I'm happy to just drop this patch.
> 
> Thanks,
> NeilBrown

I think that the only way how to fix this would be to preallocate the all 
the regions when the target is created.

But, with the default region size 512kiB, it would cause high memory 
consumption (approximatelly 1GB of RAM for 20TB device).

Mikulas
