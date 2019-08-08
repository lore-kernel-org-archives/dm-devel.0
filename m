From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm bufio: fix deadlock with loop device"
Date: Thu, 8 Aug 2019 10:40:56 -0400
Message-ID: <20190808144056.GA13168@redhat.com>
References: <alpine.LRH.2.02.1908080537540.15519@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1908080537540.15519@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: honglei.wang@oracle.com, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, junxiao.bi@oracle.com
List-Id: dm-devel.ids

On Thu, Aug 08 2019 at  5:40am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Revert the patch bd293d071ffe65e645b4d8104f9d8fe15ea13862. A proper fix
> should be not to use GFP_KERNEL in the function do_blockdev_direct_IO.

Matthew Wilcox pointed out that the "proper fix" is loop should be using
memalloc_noio_{save,restore}

> Note that the patch bd293d071ffe doesn't really prevent the deadlock from
> occuring - if we look at the stacktrace reported by Junxiao Bi, we see
> that it hangs in bit_wait_io and not on the mutex - i.e. it has already
> successfully taken the mutex. Changing the mutex from mutex_lock to
> mutex_trylock won't help with deadlocks that happen afterwards.
> 
> PID: 474    TASK: ffff8813e11f4600  CPU: 10  COMMAND: "kswapd0"
>    #0 [ffff8813dedfb938] __schedule at ffffffff8173f405
>    #1 [ffff8813dedfb990] schedule at ffffffff8173fa27
>    #2 [ffff8813dedfb9b0] schedule_timeout at ffffffff81742fec
>    #3 [ffff8813dedfba60] io_schedule_timeout at ffffffff8173f186
>    #4 [ffff8813dedfbaa0] bit_wait_io at ffffffff8174034f
>    #5 [ffff8813dedfbac0] __wait_on_bit at ffffffff8173fec8
>    #6 [ffff8813dedfbb10] out_of_line_wait_on_bit at ffffffff8173ff81
>    #7 [ffff8813dedfbb90] __make_buffer_clean at ffffffffa038736f [dm_bufio]
>    #8 [ffff8813dedfbbb0] __try_evict_buffer at ffffffffa0387bb8 [dm_bufio]
>    #9 [ffff8813dedfbbd0] dm_bufio_shrink_scan at ffffffffa0387cc3 [dm_bufio]
>   #10 [ffff8813dedfbc40] shrink_slab at ffffffff811a87ce
>   #11 [ffff8813dedfbd30] shrink_zone at ffffffff811ad778
>   #12 [ffff8813dedfbdc0] kswapd at ffffffff811ae92f
>   #13 [ffff8813dedfbec0] kthread at ffffffff810a8428
>   #14 [ffff8813dedfbf50] ret_from_fork at ffffffff81745242

The above stack trace doesn't tell the entire story though.  Yes, one
process will have already gotten the the lock and is left waiting on
IO.  But that IO isn't able to complete because it is blocked on mm's
reclaim also trying to evict via same shrinker... so another thread will
be blocked waiting on the mutex (e.g. PID 14127 in your recent patch
header).

Please re-read the header for commit bd293d071ffe -- I think that fix is
good.  But, I could still be wrong... ;)

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: bd293d071ffe ("dm bufio: fix deadlock with loop device")
> 
> ---
>  drivers/md/dm-bufio.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-bufio.c	2019-08-02 08:52:35.000000000 +0200
> +++ linux-2.6/drivers/md/dm-bufio.c	2019-08-08 11:19:13.000000000 +0200
> @@ -1604,7 +1604,9 @@ dm_bufio_shrink_scan(struct shrinker *sh
>  	unsigned long freed;
>  
>  	c = container_of(shrink, struct dm_bufio_client, shrinker);
> -	if (!dm_bufio_trylock(c))
> +	if (sc->gfp_mask & __GFP_FS)
> +		dm_bufio_lock(c);
> +	else if (!dm_bufio_trylock(c))
>  		return SHRINK_STOP;
>  
>  	freed  = __scan(c, sc->nr_to_scan, sc->gfp_mask);

I don't see the performance win of micro-optimizing to not use
dm_bufio_trylock() worth it.  BUT on the flip side, dm_bufio_lock()
_was_ the canary in the coal mine here: meaning it caught that loop
isn't properly using memalloc_noio_{save,restore}...

I'm just not liking the prospect of bufio being the smoking gun for
future deadlocks.  But I could go either way with this...

But if we do revert, this patch header needs to:

Depends-on: XXXXXXXXX ("loop: use memalloc_noio_{save,restore}")

Mike
