From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 10/12] block: Add bio_clone_kmalloc()
Date: Wed, 8 Aug 2012 16:15:52 -0700
Message-ID: <20120808231552.GJ6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-11-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1344290921-25154-11-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Mon, Aug 06, 2012 at 03:08:39PM -0700, Kent Overstreet wrote:

How about the following?

There was no API to kmalloc bio and clone and osdblk was using
explicit bio_kmalloc() + __bio_clone().  (my guess here) As this is
inconvenient and there will be more users of it in the future, add
bio_clone_kmalloc() and use it in osdblk.

> Acked-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/block/osdblk.c |    3 +--
>  fs/bio.c               |   13 +++++++++++++
>  fs/exofs/ore.c         |    5 ++---
>  include/linux/bio.h    |    1 +
>  4 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> index 87311eb..1bbc681 100644
> --- a/drivers/block/osdblk.c
> +++ b/drivers/block/osdblk.c
> @@ -266,11 +266,10 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
>  	struct bio *tmp, *new_chain = NULL, *tail = NULL;
>  
>  	while (old_chain) {
> -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
>  		if (!tmp)
>  			goto err_out;
>  
> -		__bio_clone(tmp, old_chain);
>  		tmp->bi_bdev = NULL;
>  		gfpmask &= ~__GFP_WAIT;
>  		tmp->bi_next = NULL;
> diff --git a/fs/bio.c b/fs/bio.c
> index f0c865b..77b9313 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -497,6 +497,19 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
>  }
>  EXPORT_SYMBOL(bio_clone);
>  

/**

PLEASE.

> +struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
> +{
> +	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);

Can't we use %NULL bioset as an indication to allocate from kmalloc
instead of duping interfaces like this?

Thanks.

-- 
tejun
