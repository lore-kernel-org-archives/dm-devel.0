From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 04/14] block: Add bio_clone_kmalloc()
Date: Thu, 24 May 2012 14:59:19 -0400
Message-ID: <20120524185919.GE27550@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-5-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1337817771-25038-5-git-send-email-koverstreet@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, bharrosh@panasas.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Wed, May 23, 2012 at 05:02:41PM -0700, Kent Overstreet wrote:

[..]
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 013c7a5..5a953c6 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -729,7 +729,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  	}
>  
>  	while (old_chain && (total < len)) {
> -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
>  		if (!tmp)
>  			goto err_out;
>  
> @@ -751,13 +751,9 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  			if (!bp)
>  				goto err_out;
>  
> -			__bio_clone(tmp, &bp->bio1);
> -
>  			*next = &bp->bio2;

Is this code correct. Now original code might clone bio after split and
new code will clone the original bio itself and not the split one?

Thanks
Vivek
