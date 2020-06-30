From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Date: Tue, 30 Jun 2020 08:34:36 +0200
Message-ID: <20200630063436.GA2369@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200629050851.GC1492837@kernel.org>
 <20200629121816.GC25523@casper.infradead.org>
 <20200629125231.GJ32461@dhcp22.suse.cz>
 <6421BC93-CF2F-4697-B5CB-5ECDAA9FCB37@kernel.org>
 <20200629212830.GJ25523@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200629212830.GJ25523@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Mon 29-06-20 22:28:30, Matthew Wilcox wrote:
[...]
> The documentation is hard to add a new case to, so I rewrote it.  What
> do you think?  (Obviously I'll split this out differently for submission;
> this is just what I have in my tree right now).

I am fine with your changes. Few notes below.

> -It turned out though that above approach has led to
> -abuses when the restricted gfp mask is used "just in case" without a
> -deeper consideration which leads to problems because an excessive use
> -of GFP_NOFS/GFP_NOIO can lead to memory over-reclaim or other memory
> -reclaim issues.

I believe this is an important part because it shows that new people
coming to the existing code shouldn't take it as correct and rather
question it. Also having a clear indication that overuse is causing real
problems that might be not immediately visible to subsystems outside of
MM.

> -FS/IO code then simply calls the appropriate save function before
> -any critical section with respect to the reclaim is started - e.g.
> -lock shared with the reclaim context or when a transaction context
> -nesting would be possible via reclaim.  

[...]

> +These functions should be called at the point where any memory allocation
> +would start to cause problems.  That is, do not simply wrap individual
> +memory allocation calls which currently use ``GFP_NOFS`` with a pair
> +of calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead,
> +find the lock which is taken that would cause problems if memory reclaim
> +reentered the filesystem, place a call to memalloc_nofs_save() before it
> +is acquired and a call to memalloc_nofs_restore() after it is released.
> +Ideally also add a comment explaining why this lock will be problematic.

The above text has mentioned the transaction context nesting as well and
that was a hint by Dave IIRC. It is imho good to have an example of
other reentrant points than just locks. I believe another useful example
would be something like loop device which is mixing IO and FS layers but
I am not familiar with all the details to give you an useful text.

[...]
> @@ -104,16 +134,19 @@ ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
>  alignment is also guaranteed to be at least the respective size.
>  
>  For large allocations you can use vmalloc() and vzalloc(), or directly
> -request pages from the page allocator. The memory allocated by `vmalloc`
> -and related functions is not physically contiguous.
> +request pages from the page allocator.  The memory allocated by `vmalloc`
> +and related functions is not physically contiguous.  The `vmalloc`
> +family of functions don't support the old ``GFP_NOFS`` or ``GFP_NOIO``
> +flags because there are hardcoded ``GFP_KERNEL`` allocations deep inside
> +the allocator which are hard to remove.  However, the scope APIs described
> +above can be used to limit the `vmalloc` functions.

I would reiterate "Do not just wrap vmalloc by the scope api but rather
rely on the real scope for the NOFS/NOIO context". Maybe we want to
stress out that once a scope is defined it is sticky to _all_
allocations and all allocators within that scope. The text is already
saying that but maybe we want to make it explicit and make it stand out.

[...]
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 6484569f50df..9fc091274d1d 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -186,9 +186,10 @@ static inline gfp_t current_gfp_context(gfp_t flags)
>  		 * them.  noio implies neither IO nor FS and it is a weaker
>  		 * context so always make sure it takes precedence.
>  		 */
> -		if (current->memalloc_nowait)
> +		if (current->memalloc_nowait) {
>  			flags &= ~__GFP_DIRECT_RECLAIM;
> -		else if (current->memalloc_noio)
> +			flags |= __GFP_NOWARN;

I dunno. I wouldn't make nowait implicitly NOWARN as well. At least not
with the initial implementation. Maybe we will learn later that there is
just too much unhelpful noise in the kernel log and will reconsider but
I wouldn't just start with that. Also we might learn that there will be
other modifiers for atomic (or should I say non-sleeping) scopes to be
defined. E.g. access to memory reserves but let's just wait for real
usecases.


Thanks a lot Matthew!
-- 
Michal Hocko
SUSE Labs
