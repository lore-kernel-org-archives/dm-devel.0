From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm thin: fix list_add corruption in
 process_discard
Date: Sat, 21 Apr 2012 12:12:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1204211210190.3269@file.rdu.redhat.com>
References: <1334946823-9692-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids



On Fri, 20 Apr 2012, Mike Snitzer wrote:

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

BTW. you can use list_splice to join two lists, you don't have to walk one 
list and insert entries to the other list one-by-one.

Mikulas

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
> 
