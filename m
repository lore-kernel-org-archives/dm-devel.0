From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirror patches - device failure detection/race
	fix/deadlock fix
Date: Tue, 2 Aug 2005 19:27:43 +0100
Message-ID: <20050802182743.GB5224@agk.surrey.redhat.com>
References: <278411eef6c06676d89c4ab5530cde8e@redhat.com>
	<20050802173543.GA5224@agk.surrey.redhat.com>
	<c387ba5e1b8301718a021f96e04c70e5@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c387ba5e1b8301718a021f96e04c70e5@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 02, 2005 at 01:02:02PM -0500, Jon Brassow wrote:
> That's what the mempool is all about.  :)  I suppose, if you were under 
> memory pressure long enough and the kernel never successfully reclaimed 
> memory, it *might* return NULL -- in which case, the kernel oops's.  I 
> think this is so unlikely, that I would be willing to put in a BUG() 
> call if nreg is found to be NULL.  

> BTW, the scenario is exactly the 
> same as if the gfp_flag was GFP_NOIO -- if the kernel can't get us 
> memory, it can't get us memory.
 
The two cases are quite different.

With NOIO - how it currently works - it'll sleep if there isn't enough 
memory and *never* return NULL.

> >Doesn't it need to be able to sleep to get the benefit of the mempool?
> No.  mempool will try to allocate memory honoring the flags you have 
> set (in this case GFP_ATOMIC).  If unsuccessful, it will tap into the 
> memory reserve you have created when you did a mempool_create.  So, 
> when there is no memory left to give us, we have 64 _regions_ left in 
> our repository.

But that's a finite reserve.  Consider what happens if mempool_allocs 
occur faster than mempool_frees: eventually your reserve drops to 0
and mempool_alloc returns NULL - or have I missed some rate-limiting
properties of the code that would prevent this?

> Are you asking me to "combine" the patches?  I can do that.

I think the irqsaves are only necessary because of locking bugs
in race.patch: We know the irq state throughout the code, and there's 
only a small section that gets used in both states and genuinely
needs irqsave.

This one is self-evidently unnecessary, for example:
        write_lock_irq(&rh->hash_lock);
-       spin_lock(&rh->region_lock);
+       spin_lock_irqsave(&rh->region_lock, flags);

Alasdair
-- 
agk@redhat.com
