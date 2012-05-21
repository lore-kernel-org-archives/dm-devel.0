From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 12/13] Make generic_make_request handle
 arbitrarily large bios
Date: Mon, 21 May 2012 13:17:06 -0400
Message-ID: <20120521171706.GH23993@redhat.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com>
 <20120518180550.0a6cdc34@notabene.brown>
 <20120518081444.GA27205@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120518081444.GA27205-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 04:14:44AM -0400, Kent Overstreet wrote:
> On Fri, May 18, 2012 at 06:05:50PM +1000, NeilBrown wrote:
> > 
> > Hi Kent,
> >  there is lots of good stuff in this series and I certainly hope a lot of it
> >  can eventually go upstream.
> > 
> >  However there is a part of this patch that I don't think is safe:
> > 
> > 
> > > +static void __bio_submit_split(struct closure *cl)
> > > +{
> > > +	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
> > > +	struct bio *bio = s->bio, *n;
> > > +
> > > +	do {
> > > +		n = bio_split(bio, bio_max_sectors(bio),
> > > +			      GFP_NOIO, s->q->bio_split);
> > > +		if (!n)
> > > +			continue_at(cl, __bio_submit_split, bio_split_wq);
> > > +
> > > +		closure_get(cl);
> > > +		generic_make_request(n);
> > > +	} while (n != bio);
> > > +
> > > +	continue_at(cl, bio_submit_split_done, NULL);
> > > +}
> > 
> > Firstly a small point:  Can bio_split ever return NULL here?  I don't
> > think it can, so there is no need to test.
> > But if it can, then calling generic_make_request(NULL) doesn't seem like a
> > good idea.
> > 
> > More significantly though::
> >   This is called from generic_make_request which can be called recursively and
> > enforces a tail-recursion semantic.
> > If that generic_make_request was a recursive call, then the
> > generic_make_request in __bio_submit_split will not start the request, but
> > will queue the bio for later handling.  If we then call bio_split again, we
> > could try to allocation from a mempool while we are holding one entry
> > allocated from that pool captive.  This can deadlock.
> > 
> > i.e. if the original bio is so large that it needs to be split into 3 pieces,
> > then we will try to allocate the second piece before the first piece has a
> > chance to be released.  If this happens in enough threads to exhaust the pool
> > (4 I think), it will deadlock.
> > 
> > I realise this sounds like a very unlikely case, but of course they happen.
> > 
> > One possible approach might be to count how many splits will be required,
> > then have an interface to mempools so you can allocate them all at once,
> > or block and wait.
> 
> Yeah, I actually thought of that (I probably should've documented it,
> though).
> 
> That's why the code is checking if bio_split() returned NULL; my verison
> of bio_split() checks if current->bio_list is non NULL, and if it is it
> doesn't pass __GFP_WAIT to bio_alloc_bioset().
> 
> (I was debating whether bio_split() should do that itself or leave it up
> to the caller. I tend to think it's too easy to accidentally screw up -
> and not notice it - so it should be enforced by generic code. Possibly
> the check should be moved to bio_alloc_bioset(), though.)
> 
> If we do get a memory allocation failure, then we just punt to workqueue
> - continue_at() runs __bio_submit_split from the bio_split workqueue -
> where we can safely use the mempool.

May be I am missing something, hence I will ask.  Is punting to workqueue
will really solve the issue raised by Neil. 

Due to spliting required, we will be holding some bios in the stack and
these bios can't be submitted till further allocation from pool happens. So
will it matter whether we are waiting for allocation in submitting process
context or in worker thread context.

IOW, say you have a pool of 2 bios. We allocate 1 bio (say bio A),  and submit
it for IO (now 1 bio left in pool). Now, bio A needs to be split up, so we
allocate bio B and submit it (pool is empty now). Now we try to submit bio
B and this also needs to be split. There are no more free bios so we will
wait for some to get free but none of the bios (A and B) have actually
been submitted for IO so nothing will get freed and we have a deadlock
(This is assuming that memory is tight enough that we are not able to do
any allocations from the slab backing the mempool).

biodoc.txt says following.

**************************************************************************
The caller of bio_alloc is expected to taken certain steps to avoid
deadlocks, e.g. avoid trying to allocate more memory from the pool while
already holding memory obtained from the pool.
[TBD: This is a potential issue, though a rare possibility
 in the bounce bio allocation that happens in the current code, since
 it ends up allocating a second bio from the same pool while
 holding the original bio ]
**************************************************************************

Thanks
Vivek
