From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH][next] dm zoned: fix memory leak of newly allocated zone
 on xa_insert failure
Date: Wed, 3 Jun 2020 14:18:45 -0400
Message-ID: <20200603181845.GA20491@redhat.com>
References: <20200603160254.142222-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200603160254.142222-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>, Hannes Reinecke <hare@suse.de>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 03 2020 at 12:02pm -0400,
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently if an xa_insert fails then there is a memory lead of the
> recently allocated zone object. Fix this by kfree'ing zone before
> returning on the error return path.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 1a311efa3916 ("dm zoned: convert to xarray")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index b23ff090c056..130b5a6d9f12 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -313,8 +313,10 @@ static struct dm_zone *dmz_insert(struct dmz_metadata *zmd,
>  	if (!zone)
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (xa_insert(&zmd->zones, zone_id, zone, GFP_KERNEL))
> +	if (xa_insert(&zmd->zones, zone_id, zone, GFP_KERNEL)) {
> +		kfree(zone);
>  		return ERR_PTR(-EBUSY);
> +	}
>  
>  	INIT_LIST_HEAD(&zone->link);
>  	atomic_set(&zone->refcount, 0);
> -- 
> 2.25.1
> 

Thanks, I folded this in.
