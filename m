From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: add memory barrier before waitqueue_active
Date: Tue, 5 Feb 2019 12:19:01 -0500
Message-ID: <20190205171901.GA12214@redhat.com>
References: <alpine.LRH.2.02.1902050506470.12231@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1902050506470.12231@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: axboe@kernel.dk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 05 2019 at  5:09am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> Please submit patch this to Linus before 5.0 is released.
> 
> Mikulas
> 
> 
> 
> waitqueue_active without preceding barrier is unsafe, see the comment
> before waitqueue_active definition in include/linux/wait.h.
> 
> This patch changes it to wq_has_sleeper.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: 6f75723190d8 ("dm: remove the pending IO accounting")
> 
> ---
>  drivers/md/dm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2019-02-04 20:18:03.000000000 +0100
> +++ linux-2.6/drivers/md/dm.c	2019-02-04 20:18:03.000000000 +0100
> @@ -699,7 +699,7 @@ static void end_io_acct(struct dm_io *io
>  				    true, duration, &io->stats_aux);
>  
>  	/* nudge anyone waiting on suspend queue */
> -	if (unlikely(waitqueue_active(&md->wait)))
> +	if (unlikely(wq_has_sleeper(&md->wait)))
>  		wake_up(&md->wait);
>  }
>  

This could be applicable to dm-rq.c:rq_completed() too...

but I'm not following where you think we benefit from adding the
smp_mb() to end_io_acct() please be explicit about your concern.

Focusing on bio-based DM, your concern is end_io_acct()'s wake_up() will
race with its, or some other cpus', preceding generic_end_io_acct()
percpu accounting?
- and so dm_wait_for_completion()'s !md_in_flight() condition will
  incorrectly determine there is outstanding IO due to end_io_acct()'s
  missing smp_mb()?
- SO dm_wait_for_completion() would go back to top its loop and may
  never get woken up again via wake_up(&md->wait)?

The thing is in both callers that use this pattern:
    
    if (unlikely(waitqueue_active(&md->wait)))
		wake_up(&md->wait);

the condition (namely IO accounting) will have already been updated via
generic_end_io_acct() (in terms of part_dec_in_flight() percpu updates).
So to me, using smp_mb() here is fairly pointless when you consider the
condition that the waiter (dm_wait_for_completion) will be using is
_not_ the byproduct of a single store.

Again, for bio-based DM, block core is performing atomic percpu updates
across N cpus.  And the dm_wait_for_completion() waiter is doing percpu
totalling via md_in_flight_bios().

Could be there is still an issue here.. but I'm not quite seeing it.
Cc'ing Jens to get his thoughts.

Thanks,
Mike
