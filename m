From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] dm transaction manager: handle space map
	checker failure
Date: Wed, 20 Jun 2012 17:20:10 -0400
Message-ID: <20120620212010.GK22599@redhat.com>
References: <1340220299-17771-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1340220299-17771-1-git-send-email-snitzer@redhat.com>
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

On Wed, Jun 20, 2012 at 03:24:59PM -0400, Mike Snitzer wrote:
> If CONFIG_DM_DEBUG_SPACE_MAPS is enabled and dm_sm_checker_create()
> fails, dm_tm_create_internal() would still return success even though it
> cleaned up all resources it was supposed to have created.
> 
> Fix the space map checker code to return an appropriate ERR_PTR and have
> dm_tm_create_internal() check for it with IS_ERR.
> 

I tested the patch and it works. It fails gracefully instead of segfaulting.

device-mapper: reload ioctl failed: Cannot allocate memory

I still do get waring though about large memory allocation. That's a
separate issue though.

Thanks
Vivek

> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/persistent-data/dm-space-map-checker.c  |   24 ++++++++++----------
>  .../md/persistent-data/dm-transaction-manager.c    |    8 +++++-
>  2 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md/persistent-data/dm-space-map-checker.c
> index 50ed53b..6d7c832 100644
> --- a/drivers/md/persistent-data/dm-space-map-checker.c
> +++ b/drivers/md/persistent-data/dm-space-map-checker.c
> @@ -343,25 +343,25 @@ struct dm_space_map *dm_sm_checker_create(struct dm_space_map *sm)
>  	int r;
>  	struct sm_checker *smc;
>  
> -	if (!sm)
> -		return NULL;
> +	if (IS_ERR_OR_NULL(sm))
> +		return ERR_PTR(-EINVAL);
>  
>  	smc = kmalloc(sizeof(*smc), GFP_KERNEL);
>  	if (!smc)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	memcpy(&smc->sm, &ops_, sizeof(smc->sm));
>  	r = ca_create(&smc->old_counts, sm);
>  	if (r) {
>  		kfree(smc);
> -		return NULL;
> +		return ERR_PTR(r);
>  	}
>  
>  	r = ca_create(&smc->counts, sm);
>  	if (r) {
>  		ca_destroy(&smc->old_counts);
>  		kfree(smc);
> -		return NULL;
> +		return ERR_PTR(r);
>  	}
>  
>  	smc->real_sm = sm;
> @@ -371,7 +371,7 @@ struct dm_space_map *dm_sm_checker_create(struct dm_space_map *sm)
>  		ca_destroy(&smc->counts);
>  		ca_destroy(&smc->old_counts);
>  		kfree(smc);
> -		return NULL;
> +		return ERR_PTR(r);
>  	}
>  
>  	r = ca_commit(&smc->old_counts, &smc->counts);
> @@ -379,7 +379,7 @@ struct dm_space_map *dm_sm_checker_create(struct dm_space_map *sm)
>  		ca_destroy(&smc->counts);
>  		ca_destroy(&smc->old_counts);
>  		kfree(smc);
> -		return NULL;
> +		return ERR_PTR(r);
>  	}
>  
>  	return &smc->sm;
> @@ -391,25 +391,25 @@ struct dm_space_map *dm_sm_checker_create_fresh(struct dm_space_map *sm)
>  	int r;
>  	struct sm_checker *smc;
>  
> -	if (!sm)
> -		return NULL;
> +	if (IS_ERR_OR_NULL(sm))
> +		return ERR_PTR(-EINVAL);
>  
>  	smc = kmalloc(sizeof(*smc), GFP_KERNEL);
>  	if (!smc)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	memcpy(&smc->sm, &ops_, sizeof(smc->sm));
>  	r = ca_create(&smc->old_counts, sm);
>  	if (r) {
>  		kfree(smc);
> -		return NULL;
> +		return ERR_PTR(r);
>  	}
>  
>  	r = ca_create(&smc->counts, sm);
>  	if (r) {
>  		ca_destroy(&smc->old_counts);
>  		kfree(smc);
> -		return NULL;
> +		return ERR_PTR(r);
>  	}
>  
>  	smc->real_sm = sm;
> diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
> index 02bf78e..e5604b3 100644
> --- a/drivers/md/persistent-data/dm-transaction-manager.c
> +++ b/drivers/md/persistent-data/dm-transaction-manager.c
> @@ -347,8 +347,10 @@ static int dm_tm_create_internal(struct dm_block_manager *bm,
>  		}
>  
>  		*sm = dm_sm_checker_create(inner);
> -		if (!*sm)
> +		if (IS_ERR(*sm)) {
> +			r = PTR_ERR(*sm);
>  			goto bad2;
> +		}
>  
>  	} else {
>  		r = dm_bm_write_lock(dm_tm_get_bm(*tm), sb_location,
> @@ -367,8 +369,10 @@ static int dm_tm_create_internal(struct dm_block_manager *bm,
>  		}
>  
>  		*sm = dm_sm_checker_create(inner);
> -		if (!*sm)
> +		if (IS_ERR(*sm)) {
> +			r = PTR_ERR(*sm);
>  			goto bad2;
> +		}
>  	}
>  
>  	return 0;
> -- 
> 1.7.4.4
