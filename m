From: Joe Thornber <thornber@redhat.com>
Subject: Re: [patch] dm space map metadata: fix sm_bootstrap_get_nr_blocks()
Date: Mon, 1 Dec 2014 13:56:12 +0000
Message-ID: <20141201135611.GA3151@debian>
References: <20141129125021.GD27251@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141129125021.GD27251@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, =?iso-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

Ack, thanks.

On Sat, Nov 29, 2014 at 03:50:21PM +0300, Dan Carpenter wrote:
> This function isn't right and it causes a static checker warning:
> 
> 	drivers/md/dm-thin.c:3016 maybe_resize_data_dev()
> 	error: potentially using uninitialized 'sb_data_size'.
> 
> It should set "*count" and return zero on success the same as the
> sm_metadata_get_nr_blocks() function does earlier.
> 
> Fixes: 3241b1d3e0aa ('dm: add persistent data library')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker stuff.  Not tested.
> 
> diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
> index 786b689..f4e22bc 100644
> --- a/drivers/md/persistent-data/dm-space-map-metadata.c
> +++ b/drivers/md/persistent-data/dm-space-map-metadata.c
> @@ -564,7 +564,9 @@ static int sm_bootstrap_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count
>  {
>  	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
>  
> -	return smm->ll.nr_blocks;
> +	*count = smm->ll.nr_blocks;
> +
> +	return 0;
>  }
>  
>  static int sm_bootstrap_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
