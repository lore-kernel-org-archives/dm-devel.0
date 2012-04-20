From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: fix list_add corruption in process_discard
Date: Fri, 20 Apr 2012 16:41:25 -0400
Message-ID: <20120420204124.GA9765@redhat.com>
References: <1334946823-9692-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1334946823-9692-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Here is an updated header with more detail:

Use pool->lock to protect pool's prepared_discards list.

Thinp's discard support (introduced via commit 104655fd4dce "dm thin:
support discards") will not work reliably without this fix because
thin_endio() can race with process_discard(), leading to concurrent
list_add() that results in the processes locking up and an initial error
like the following:

WARNING: at lib/list_debug.c:32 __list_add+0x8f/0xa0()
...
list_add corruption. next->prev should be prev (ffff880323b96140), but was ffff8801d2c48440. (next=ffff8801d2c485c0).
...
Pid: 17205, comm: kworker/u:1 Tainted: G        W  O 3.4.0-rc3.snitm+ #1
Call Trace:
 [<ffffffff8103ca1f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8103cb16>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa04f6ce6>] ? bio_detain+0xc6/0x210 [dm_thin_pool]
 [<ffffffff8124ff3f>] __list_add+0x8f/0xa0
 [<ffffffffa04f70d2>] process_discard+0x2a2/0x2d0 [dm_thin_pool]
 [<ffffffffa04f6a78>] ? remap_and_issue+0x38/0x50 [dm_thin_pool]
 [<ffffffffa04f7c3b>] process_deferred_bios+0x7b/0x230 [dm_thin_pool]
 [<ffffffffa04f7df0>] ? process_deferred_bios+0x230/0x230 [dm_thin_pool]
 [<ffffffffa04f7e42>] do_worker+0x52/0x60 [dm_thin_pool]
 [<ffffffff81056fa9>] process_one_work+0x129/0x450
 [<ffffffff81059b9c>] worker_thread+0x17c/0x3c0
 [<ffffffff81059a20>] ? manage_workers+0x120/0x120
 [<ffffffff8105eabe>] kthread+0x9e/0xb0
 [<ffffffff814ceda4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105ea20>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814ceda0>] ? gs_change+0x13/0x13
---[ end trace 7e0a523bc5e52692 ]---

Signed-off-by: Mike Snitzer <snitzer@redhat.com>



On Fri, Apr 20 2012 at  2:33pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Use pool->lock to protect pool's prepared_discards list.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-thin.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 7218882..7297eb7 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1181,6 +1181,7 @@ static void no_space(struct cell *cell)
>  static void process_discard(struct thin_c *tc, struct bio *bio)
>  {
>  	int r;
> +	unsigned long flags;
>  	struct pool *pool = tc->pool;
>  	struct cell *cell, *cell2;
>  	struct cell_key key, key2;
> @@ -1222,7 +1223,9 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
>  			m->bio = bio;
>  
>  			if (!ds_add_work(&pool->all_io_ds, &m->list)) {
> +				spin_lock_irqsave(&pool->lock, flags);
>  				list_add(&m->list, &pool->prepared_discards);
> +				spin_unlock_irqrestore(&pool->lock, flags);
>  				wake_worker(pool);
>  			}
>  		} else {
> @@ -2630,8 +2633,10 @@ static int thin_endio(struct dm_target *ti,
>  	if (h->all_io_entry) {
>  		INIT_LIST_HEAD(&work);
>  		ds_dec(h->all_io_entry, &work);
> +		spin_lock_irqsave(&pool->lock, flags);
>  		list_for_each_entry_safe(m, tmp, &work, list)
>  			list_add(&m->list, &pool->prepared_discards);
> +		spin_unlock_irqrestore(&pool->lock, flags);
>  	}
>  
>  	mempool_free(h, pool->endio_hook_pool);
> -- 
> 1.7.4.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
