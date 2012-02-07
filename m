From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/11] [dm-thin] Commit every second to
 prevent too much of a position building up.
Date: Tue, 7 Feb 2012 11:53:25 -0500
Message-ID: <20120207165319.GA27715@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
	<1328200754-13642-8-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1328200754-13642-8-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 02 2012 at 11:39am -0500,
Joe Thornber <ejt@redhat.com> wrote:

> ---
>  drivers/md/dm-thin.c |   28 ++++++++++++++++++++++++++--
>  1 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 6ef03a2..19de11a 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -23,6 +23,7 @@
>  #define DEFERRED_SET_SIZE 64
>  #define MAPPING_POOL_SIZE 1024
>  #define PRISON_CELLS 1024
> +#define COMMIT_PERIOD HZ
>  
>  /*
>   * The block size of the device holding pool data must be
> @@ -498,8 +499,10 @@ struct pool {
>  
>  	struct workqueue_struct *wq;
>  	struct work_struct worker;
> +	struct delayed_work waker;
>  
>  	unsigned ref_count;
> +	unsigned long last_commit_jiffies;
>  
>  	spinlock_t lock;
>  	struct bio_list deferred_bios;
> @@ -1256,6 +1259,12 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
>  	}
>  }
>  
> +static int need_commit_due_to_time(struct pool *pool)
> +{
> +	return jiffies < pool->last_commit_jiffies ||
> +	       jiffies > pool->last_commit_jiffies + COMMIT_PERIOD;
> +}
> +
>  static void process_deferred_bios(struct pool *pool)
>  {
>  	unsigned long flags;
> @@ -1297,7 +1306,7 @@ static void process_deferred_bios(struct pool *pool)
>  	bio_list_init(&pool->deferred_flush_bios);
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  
> -	if (bio_list_empty(&bios))
> +	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
>  		return;

Shouldn't this be:

	if (bio_list_empty(&bios) || !need_commit_due_to_time(pool))
		return;

?

Also, should we make the commit interval tunable (akin to ext[34]'s
'commit' mount option)?  Or did you defer doing so until it proves
worthwhile?

Mike
