From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block, dm: don't copy bios for request clones
Date: Fri, 24 Apr 2015 20:15:24 -0400
Message-ID: <20150425001524.GB18601@redhat.com>
References: <1429904020-16363-1-git-send-email-hch@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1429904020-16363-1-git-send-email-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 24 2015 at  3:33pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Currently dm-multipath has to clone the bios for every request sent
> to the lower devices, which wastes cpu cycles and ties down memory.
> 
> This patch instead adds a new REQ_CLONE flag that instructs req_bio_endio
> to not complete bios attached to a request, which we set on clone
> requests similar to bios in a flush sequence.  With this change I/O
> errors on a path failure only get propagated to dm-multipath, which
> can then either resubmit the I/O or complete the bios on the original
> request.
> 
> I've done some basic testing of this on a Linux target with ALUA support,
> and it survives path failures during I/O nicely.

Thanks for working on this (it slipped in priority on my TODO list).
Will be great to get this reviewed/tested/staged for 4.2.

But your patch needs rebasing against latest upstream code.  I'd imagine
this means you also haven't tested with "use_blk_mq" enabled (from
commit 17e149b8f).

I'll do a much more careful review once you rebase but I noticed one
thing worth mentioning now:

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 6554d91..4ac0a47 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -941,23 +941,30 @@ bool dm_table_mq_request_based(struct dm_table *t)
>  
>  static int dm_table_alloc_md_mempools(struct dm_table *t)
>  {
> -	unsigned type = dm_table_get_type(t);
> +	int type = dm_table_get_type(t);
>  	unsigned per_bio_data_size = 0;
> -	struct dm_target *tgt;
>  	unsigned i;
>  
> -	if (unlikely(type == DM_TYPE_NONE)) {
> +	switch (type) {

You're missing a case statement here for DM_TYPE_BIO_BASED:

> +		for (i = 0; i < t->num_targets; i++) {
> +			struct dm_target *tgt = t->targets + i;
> +
> +			per_bio_data_size = max(per_bio_data_size,
> +						tgt->per_bio_data_size);
> +		}
> +
> +		t->mempools = dm_alloc_bio_mempools(t->integrity_supported,
> +				per_bio_data_size);
> +		break;
> +	case DM_TYPE_REQUEST_BASED:
> +	case DM_TYPE_MQ_REQUEST_BASED:
> +		t->mempools = dm_alloc_rq_mempools(type);
> +		break;
> +	default:
>  		DMWARN("no table type is set, can't allocate mempools");
>  		return -EINVAL;
>  	}
>  
> -	if (type == DM_TYPE_BIO_BASED)
> -		for (i = 0; i < t->num_targets; i++) {
> -			tgt = t->targets + i;
> -			per_bio_data_size = max(per_bio_data_size, tgt->per_bio_data_size);
> -		}
> -
> -	t->mempools = dm_alloc_md_mempools(type, t->integrity_supported, per_bio_data_size);
>  	if (!t->mempools)
>  		return -ENOMEM;
>  
