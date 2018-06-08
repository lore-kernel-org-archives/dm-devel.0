From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 2/3 v2] dm-writecache: convert wait queue to
 wake_up_process
Date: Fri, 8 Jun 2018 11:13:15 -0400
Message-ID: <20180608151315.GA9505@redhat.com>
References: <20180606153201.708853388@debian.vm>
	<alpine.LRH.2.02.1806071147110.10781@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806071147110.10781@file01.intranet.prod.int.rdu2.redhat.com>
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

On Thu, Jun 07 2018 at 11:48am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This is second version of this patch - it also removes the label 
> continue_locked, because it is no longer needed. If forgot to refresh the 
> patch before sending it, so I sent an olded version.
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [patch 2/3 v2] dm-writecache: convert wait queue to wake_up_process
> 
> If there's just one process that can wait on a queue, we can use
> wake_up_process. According to Linus, it is safe to call wake_up_process
> on a process even if the process may be doing something else.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-writecache.c |   34 +++++++++++++++-------------------
>  1 file changed, 15 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-writecache.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-writecache.c	2018-06-05 22:54:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-writecache.c	2018-06-07 17:44:11.000000000 +0200
> @@ -1273,10 +1272,11 @@ static void writecache_writeback_endio(s
>  	struct dm_writecache *wc = wb->wc;
>  	unsigned long flags;
>  
> -	raw_spin_lock_irqsave(&wc->endio_thread_wait.lock, flags);
> +	raw_spin_lock_irqsave(&wc->endio_list_lock, flags);
> +	if (unlikely(list_empty(&wc->endio_list)))
> +		wake_up_process(wc->endio_thread);
>  	list_add_tail(&wb->endio_entry, &wc->endio_list);
> -	swake_up_locked(&wc->endio_thread_wait);
> -	raw_spin_unlock_irqrestore(&wc->endio_thread_wait.lock, flags);
> +	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
>  }

I'm not following the logic you're using for the above pattern of using
wake_up_process if the list is empty.. seems unintuitive.

Given you add to the list (be it endio here, or flush elsewhere), why
not just add to the list and then always wake_up_process()?

Mike
