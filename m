From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Avoid sleeping while holding the dm_bufio lock
Date: Thu, 17 Nov 2016 15:28:00 -0500
Message-ID: <20161117202800.GA30170@redhat.com>
References: <1479410660-31408-1-git-send-email-dianders@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479410660-31408-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Anderson <dianders@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, David Rientjes <rientjes@google.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Sonny Rao <sonnyrao@chromium.org>, linux@roeck-us.net, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Nov 17 2016 at  2:24pm -0500,
Douglas Anderson <dianders@chromium.org> wrote:

> We've seen in-field reports showing _lots_ (18 in one case, 41 in
> another) of tasks all sitting there blocked on:
> 
>   mutex_lock+0x4c/0x68
>   dm_bufio_shrink_count+0x38/0x78
>   shrink_slab.part.54.constprop.65+0x100/0x464
>   shrink_zone+0xa8/0x198
> 
> In the two cases analyzed, we see one task that looks like this:
> 
>   Workqueue: kverityd verity_prefetch_io
> 
>   __switch_to+0x9c/0xa8
>   __schedule+0x440/0x6d8
>   schedule+0x94/0xb4
>   schedule_timeout+0x204/0x27c
>   schedule_timeout_uninterruptible+0x44/0x50
>   wait_iff_congested+0x9c/0x1f0
>   shrink_inactive_list+0x3a0/0x4cc
>   shrink_lruvec+0x418/0x5cc
>   shrink_zone+0x88/0x198
>   try_to_free_pages+0x51c/0x588
>   __alloc_pages_nodemask+0x648/0xa88
>   __get_free_pages+0x34/0x7c
>   alloc_buffer+0xa4/0x144
>   __bufio_new+0x84/0x278
>   dm_bufio_prefetch+0x9c/0x154
>   verity_prefetch_io+0xe8/0x10c
>   process_one_work+0x240/0x424
>   worker_thread+0x2fc/0x424
>   kthread+0x10c/0x114
> 
> ...and that looks to be the one holding the mutex.
> 
> The problem has been reproduced on fairly easily:
> 0. Be running Chrome OS w/ verity enabled on the root filesystem
> 1. Pick test patch: http://crosreview.com/412360
> 2. Install launchBalloons.sh and balloon.arm from
>      http://crbug.com/468342
>    ...that's just a memory stress test app.
> 3. On a 4GB rk3399 machine, run
>      nice ./launchBalloons.sh 4 900 100000
>    ...that tries to eat 4 * 900 MB of memory and keep accessing.
> 4. Login to the Chrome web browser and restore many tabs
> 
> With that, I've seen printouts like:
>   DOUG: long bufio 90758 ms
> ...and stack trace always show's we're in dm_bufio_prefetch().
> 
> The problem is that we try to allocate memory with GFP_NOIO while
> we're holding the dm_bufio lock.  Instead we should be using
> GFP_NOWAIT.  Using GFP_NOIO can cause us to sleep while holding the
> lock and that causes the above problems.
> 
> The current behavior explained by David Rientjes:
> 
>   It will still try reclaim initially because __GFP_WAIT (or
>   __GFP_KSWAPD_RECLAIM) is set by GFP_NOIO.  This is the cause of
>   contention on dm_bufio_lock() that the thread holds.  You want to
>   pass GFP_NOWAIT instead of GFP_NOIO to alloc_buffer() when holding a
>   mutex that can be contended by a concurrent slab shrinker (if
>   count_objects didn't use a trylock, this pattern would trivially
>   deadlock).
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> Note that this change was developed and tested against the Chrome OS
> 4.4 kernel tree, not mainline.  Due to slight differences in verity
> between mainline and Chrome OS it became too difficult to reproduce my
> testing setup on mainline.  This patch still seems correct and
> relevant to upstream, so I'm posting it.  If this is not acceptible to
> you then please ignore this patch.
> 
> Also note that when I tested the Chrome OS 3.14 kernel tree I couldn't
> reproduce the long delays described in the patch.  Presumably
> something changed in either the kernel config or the memory management
> code between the two kernel versions that made this crop up.  In a
> similar vein, it is possible that problems described in this patch are
> no longer reproducible upstream.  However, the arguments made in this
> patch (that we don't want to block while holding the mutex) still
> apply so I think the patch may still have merit.
> 
>  drivers/md/dm-bufio.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index b3ba142e59a4..3c767399cc59 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -827,7 +827,8 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 * dm-bufio is resistant to allocation failures (it just keeps
>  	 * one buffer reserved in cases all the allocations fail).
>  	 * So set flags to not try too hard:
> -	 *	GFP_NOIO: don't recurse into the I/O layer
> +	 *	GFP_NOWAIT: don't wait; if we need to sleep we'll release our
> +	 *		    mutex and wait ourselves.
>  	 *	__GFP_NORETRY: don't retry and rather return failure
>  	 *	__GFP_NOMEMALLOC: don't use emergency reserves
>  	 *	__GFP_NOWARN: don't print a warning in case of failure
> @@ -837,7 +838,8 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 */
>  	while (1) {
>  		if (dm_bufio_cache_size_latch != 1) {
> -			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY |
> +					 __GFP_NOMEMALLOC | __GFP_NOWARN);
>  			if (b)
>  				return b;
>  		}
> -- 
> 2.8.0.rc3.226.g39d4020
> 

I have one report of a very low-memory system hitting issues with bufio
(in the context of DM-thinp, due to bufio shrinker) but nothing
implicating alloc_buffer().

In any case, I'm fine with your patch given that we'll just retry.  BUT
spinning in __alloc_buffer_wait_no_callback() doesn't really change the
fact that you're starved for memory.  It just makes this less visible
right?  Meaning that you won't see hung task timeouts?  Or were you
seeing these tasks manifest this back-pressure through other means?
