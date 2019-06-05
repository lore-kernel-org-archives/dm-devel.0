From: Gen Zhang <blackgod016574@gmail.com>
Subject: Re: dm-region-hash: Fix a missing-check bug in __rh_alloc()
Date: Wed, 5 Jun 2019 22:58:20 +0800
Message-ID: <20190605145820.GA3465@zhanggen-UX430UQ>
References: <20190524031248.GA6295@zhanggen-UX430UQ>
 <79ec221d-6970-3b30-0660-4a288a4c465e@suse.cz>
 <20190605122159.GA32538@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190605122159.GA32538@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 05, 2019 at 08:21:59AM -0400, Mike Snitzer wrote:
> On Wed, Jun 05 2019 at  2:05am -0400,
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
> > On 24. 05. 19, 5:12, Gen Zhang wrote:
> > > In function __rh_alloc(), the pointer nreg is allocated a memory space
> > > via kmalloc(). And it is used in the following codes. However, when 
> > > there is a memory allocation error, kmalloc() fails. Thus null pointer
> > > dereference may happen. And it will cause the kernel to crash. Therefore,
> > > we should check the return value and handle the error.
> > > Further, in __rh_find(), we should also check the return value and
> > > handle the error.
> > > 
> > > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> > > 
> > > ---
> > > diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> > > index 1f76045..2fa1641 100644
> > > --- a/drivers/md/dm-region-hash.c
> > > +++ b/drivers/md/dm-region-hash.c
> > > @@ -290,8 +290,11 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
> > >  	struct dm_region *reg, *nreg;
> > >  
> > >  	nreg = mempool_alloc(&rh->region_pool, GFP_ATOMIC);
> > > -	if (unlikely(!nreg))
> > > +	if (unlikely(!nreg)) {
> > >  		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
> > > +		if (!nreg)
> > > +			return NULL;
> > 
> > What's the purpose of checking NO_FAIL allocations?
> 
> There isn't, that was already pointed out in a different thread for this
> same patch (think patch was posted twice):
> https://www.redhat.com/archives/dm-devel/2019-May/msg00124.html
> 
> Mike
Thanks for your reply. The first thread is not replied for a period, so
the second one is posted. But I don't know why Jiri replied to the first
thread.

Thanks
Gen
