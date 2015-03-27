From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 73/78] multipathd: push down lock in
	checkerloop()
Date: Thu, 26 Mar 2015 23:21:43 -0500
Message-ID: <20150327042143.GT29132@octiron.msp.redhat.com>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-74-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1426509425-15978-74-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 01:37:00PM +0100, Hannes Reinecke wrote:
> Instead of grabbing the lock at the start of the checkerloop
> and releasing it at the end we should be holding it only
> during the time when we actually need it.

the vecs lock is designed to protect the vecs vectors (and conf), so
checking vecs->pathvec and vecs->mpvec outside of the vecs lock doesn't
guarantee us that they will still be there once we've grabbed the lock.
I don't think this could actually cause a memory issue, since all the
vecs code already checks if the vector is NULL, and the check before
locking will probably be right most of the time.  But perhaps we should
check again after we do the locking, or at least add a comment saying
that we know that the pre-lock check isn't guaranteed to be correct,
so as not to confuse people.

-Ben


> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipathd/main.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f876258..9e7bf4f 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1399,32 +1399,40 @@ checkerloop (void *ap)
>  
>  		if (gettimeofday(&start_time, NULL) != 0)
>  			start_time.tv_sec = 0;
> -		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -		lock(vecs->lock);
> -		pthread_testcancel();
>  		condlog(4, "tick");
>  #ifdef USE_SYSTEMD
>  		if (use_watchdog)
>  			sd_notify(0, "WATCHDOG=1");
>  #endif
>  		if (vecs->pathvec) {
> +			pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +			lock(vecs->lock);
> +			pthread_testcancel();
>  			vector_foreach_slot (vecs->pathvec, pp, i) {
>  				num_paths += check_path(vecs, pp);
>  			}
> +			lock_cleanup_pop(vecs->lock);
>  		}
>  		if (vecs->mpvec) {
> +			pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +			lock(vecs->lock);
> +			pthread_testcancel();
>  			defered_failback_tick(vecs->mpvec);
>  			retry_count_tick(vecs->mpvec);
> +			lock_cleanup_pop(vecs->lock);
>  		}
>  		if (count)
>  			count--;
>  		else {
> +			pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +			lock(vecs->lock);
> +			pthread_testcancel();
>  			condlog(4, "map garbage collection");
>  			mpvec_garbage_collector(vecs);
>  			count = MAPGCINT;
> +			lock_cleanup_pop(vecs->lock);
>  		}
>  
> -		lock_cleanup_pop(vecs->lock);
>  		if (start_time.tv_sec &&
>  		    gettimeofday(&end_time, NULL) == 0 &&
>  		    num_paths) {
> -- 
> 1.8.4.5
