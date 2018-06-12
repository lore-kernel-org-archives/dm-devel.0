From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Tue, 12 Jun 2018 17:20:07 -0400
Message-ID: <20180612212007.GA22717@redhat.com>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Xia <jing.xia.mail@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jun 12 2018 at  4:03am -0400,
Jing Xia <jing.xia.mail@gmail.com> wrote:

> Performance test in android reports that the phone sometimes gets
> hanged and shows black screen for about several minutes.The sysdump shows:
> 1. kswapd and other tasks who enter the direct-reclaim path are waiting
> on the dm_bufio_lock;

Do you have an understanding of where they are waiting?  Is it in
dm_bufio_shrink_scan()?

> 2. the task who gets the dm_bufio_lock is stalled for IO completions,
> the relevant stack trace as :
> 
> PID: 22920  TASK: ffffffc0120f1a00  CPU: 1   COMMAND: "kworker/u8:2"
>  #0 [ffffffc0282af3d0] __switch_to at ffffff8008085e48
>  #1 [ffffffc0282af3f0] __schedule at ffffff8008850cc8
>  #2 [ffffffc0282af450] schedule at ffffff8008850f4c
>  #3 [ffffffc0282af470] schedule_timeout at ffffff8008853a0c
>  #4 [ffffffc0282af520] schedule_timeout_uninterruptible at ffffff8008853aa8
>  #5 [ffffffc0282af530] wait_iff_congested at ffffff8008181b40
>  #6 [ffffffc0282af5b0] shrink_inactive_list at ffffff8008177c80
>  #7 [ffffffc0282af680] shrink_lruvec at ffffff8008178510
>  #8 [ffffffc0282af790] mem_cgroup_shrink_node_zone at ffffff80081793bc
>  #9 [ffffffc0282af840] mem_cgroup_soft_limit_reclaim at ffffff80081b6040

Understanding the root cause for why the IO isn't completing quick
enough would be nice.  Is the backing storage just overwhelmed?

> This patch aims to reduce the dm_bufio_lock contention when multiple
> tasks do shrink_slab() at the same time.It is acceptable that task
> will be allowed to reclaim from other shrinkers or reclaim from dm-bufio
> next time, rather than stalled for the dm_bufio_lock.

Your patch just looks to be papering over the issue.  Like you're
treating the symptom rather than the problem.

> Signed-off-by: Jing Xia <jing.xia@unisoc.com>
> Signed-off-by: Jing Xia <jing.xia.mail@gmail.com>

You only need one Signed-off-by.

> ---
>  drivers/md/dm-bufio.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index c546b56..402a028 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -1647,10 +1647,19 @@ static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
>  static unsigned long
>  dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>  {
> +	unsigned long count;
> +	unsigned long retain_target;
> +
>  	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
> -	unsigned long count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
> +
> +	if (!dm_bufio_trylock(c))
> +		return 0;
> +
> +	count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
>  			      READ_ONCE(c->n_buffers[LIST_DIRTY]);
> -	unsigned long retain_target = get_retain_buffers(c);
> +	retain_target = get_retain_buffers(c);
> +
> +	dm_bufio_unlock(c);
>  
>  	return (count < retain_target) ? 0 : (count - retain_target);
>  }
> -- 
> 1.9.1
> 

The reality of your patch is, on a heavily used bufio-backed volume,
you're effectively disabling the ability to reclaim bufio memory via the
shrinker.

Because chances are the bufio lock will always be contended for a
heavily used bufio client.

But after a quick look, I'm left wondering why dm_bufio_shrink_scan()'s
dm_bufio_trylock() isn't sufficient to short-circuit the shrinker for
your use-case?
Maybe __GFP_FS is set so dm_bufio_shrink_scan() only ever uses
dm_bufio_lock()?

Is a shrinker able to be reentered by the VM subsystem
(e.g. shrink_slab() calls down into same shrinker from multiple tasks
that hit direct reclaim)?
If so, a better fix could be to add a flag to the bufio client so we can
know if the same client is being re-entered via the shrinker (though
it'd likely be a bug for the shrinker to do that!).. and have
dm_bufio_shrink_scan() check that flag and return SHRINK_STOP if set.

That said, it could be that other parts of dm-bufio are monopolizing the
lock as part of issuing normal IO (to your potentially slow
backend).. in which case just taking the lock from the shrinker even
once will block like you've reported.

It does seem like additional analysis is needed to pinpoint exactly what
is occuring.  Or some additional clarification needed (e.g. are the
multiple tasks waiting for the bufio lock, as you reported with "1"
above, waiting for the same exact shrinker's ability to get the same
bufio lock?)

But Mikulas, please have a look at this reported issue and let us know
your thoughts.

Thanks,
Mike
