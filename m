From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-table: set non-zero q->limits.discard_granularity
Date: Thu, 24 Sep 2020 11:00:35 -0400
Message-ID: <20200924150034.GD13849@redhat.com>
References: <alpine.LRH.2.02.2009241032510.3485@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009241032510.3485@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2020 at 10:34am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi Mike
> 
> Could you send this to Linus before v5.9 is released?
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> If q->limits.discard_granularity is zero, the block core will warn in
> __blkdev_issue_discard. This patch sets it to a minimum - 512 bytes.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: b35fd7422c2f ("block: check queue's limits.discard_granularity in __blkdev_issue_discard()")
> Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
> Fixes: c52abf563049 ("loop: Better discard support for block devices")
> 
> ---
>  drivers/md/dm-table.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-table.c	2020-08-31 12:08:27.000000000 +0200
> +++ linux-2.6/drivers/md/dm-table.c	2020-09-24 16:23:55.000000000 +0200
> @@ -1858,8 +1858,11 @@ void dm_table_set_restrictions(struct dm
>  		q->limits.discard_granularity = 0;
>  		q->limits.discard_alignment = 0;
>  		q->limits.discard_misaligned = 0;
> -	} else
> +	} else {
>  		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
> +		if (q->limits.discard_granularity < 512)
> +			q->limits.discard_granularity = 512;
> +	}
>  
>  	if (dm_table_supports_secure_erase(t))
>  		blk_queue_flag_set(QUEUE_FLAG_SECERASE, q);

This patch is wrong, papers over something else.  Please identify what
that something else is.

block core has _always_ cheecked if discard_granularity is non-zero to
allow discards.

Why is q->limits.discard_granularity < 512 if discard is supported by
the DM table and targets?

That shouldn't ever be.

Mike
