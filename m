From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/6] mm: Add become_kswapd and restore_kswapd
Date: Thu, 25 Jun 2020 14:31:43 +0200
Message-ID: <20200625123143.GK1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-3-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-3-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Thu 25-06-20 12:31:18, Matthew Wilcox wrote:
> Since XFS needs to pretend to be kswapd in some of its worker threads,
> create methods to save & restore kswapd state.  Don't bother restoring
> kswapd state in kswapd -- the only time we reach this code is when we're
> exiting and the task_struct is about to be destroyed anyway.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Certainly better than an opencoded PF_$FOO manipulation
Acked-by: Michal Hocko <mhocko@suse.com>

I would just ask for a clarification because this is rellying to have a
good MM knowledge to follow

> +/*
> + * Tell the memory management that we're a "memory allocator",

I would go with.
Tell the memory management that the caller is working on behalf of the
background memory reclaim (aka kswapd) and help it to make a forward
progress. That means that it will get an access to memory reserves
should there be a need to allocate memory in order to make a forward
progress. Note that the caller has to be extremely careful when doing
that.

Or something like that.

> + * and that if we need more memory we should get access to it
> + * regardless (see "__alloc_pages()"). "kswapd" should
> + * never get caught in the normal page freeing logic.
> + *
> + * (Kswapd normally doesn't need memory anyway, but sometimes
> + * you need a small amount of memory in order to be able to
> + * page out something else, and this flag essentially protects
> + * us from recursively trying to free more memory as we're
> + * trying to free the first piece of memory in the first place).
> + */
> +#define KSWAPD_PF_FLAGS		(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD)
> +
> +static inline unsigned long become_kswapd(void)
> +{
> +	unsigned long flags = current->flags & KSWAPD_PF_FLAGS;
> +	current->flags |= KSWAPD_PF_FLAGS;
> +	return flags;
> +}
> +
> +static inline void restore_kswapd(unsigned long flags)
> +{
> +	current->flags &= ~(flags ^ KSWAPD_PF_FLAGS);
> +}
> +
>  static inline void set_current_io_flusher(void)
>  {
>  	current->flags |= PF_LOCAL_THROTTLE;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b6d84326bdf2..27ae76699899 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3870,19 +3870,7 @@ static int kswapd(void *p)
>  	if (!cpumask_empty(cpumask))
>  		set_cpus_allowed_ptr(tsk, cpumask);
>  
> -	/*
> -	 * Tell the memory management that we're a "memory allocator",
> -	 * and that if we need more memory we should get access to it
> -	 * regardless (see "__alloc_pages()"). "kswapd" should
> -	 * never get caught in the normal page freeing logic.
> -	 *
> -	 * (Kswapd normally doesn't need memory anyway, but sometimes
> -	 * you need a small amount of memory in order to be able to
> -	 * page out something else, and this flag essentially protects
> -	 * us from recursively trying to free more memory as we're
> -	 * trying to free the first piece of memory in the first place).
> -	 */
> -	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> +	become_kswapd();
>  	set_freezable();
>  
>  	WRITE_ONCE(pgdat->kswapd_order, 0);
> @@ -3932,8 +3920,6 @@ static int kswapd(void *p)
>  			goto kswapd_try_sleep;
>  	}
>  
> -	tsk->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD);
> -
>  	return 0;
>  }
>  
> -- 
> 2.27.0
> 

-- 
Michal Hocko
SUSE Labs
