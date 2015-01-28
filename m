From: Joe Thornber <thornber@redhat.com>
Subject: Re: [patch] dm cache: fix up IS_ERR vs NULL confusion
Date: Wed, 28 Jan 2015 10:53:12 +0000
Message-ID: <20150128105311.GA21433@debian>
References: <20150128064609.GD30893@mwanda>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150128064609.GD30893@mwanda>
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
Cc: linux-raid@vger.kernel.org, Joe Thornber <ejt@redhat.com>, kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Dan,

Thanks.  I hate errptrs so my natural inclination is just return NULLs.  I'll fix up and retest.

- Joe

On Wed, Jan 28, 2015 at 09:46:09AM +0300, Dan Carpenter wrote:
> It used to be that this code used ERR_PTRs consistently, but a recent
> change mixed it up.  The code sometimes returns NULL, sometimes an
> ERR_PTR, some code assumes everything is an ERR_PTR and some assumes it
> returns NULL on error.  I've changed it back so that now everything is
> an ERR_PTR again.
> 
> These new bugs were caught by static checking:
> 
> drivers/md/dm-cache-target.c:2409 cache_create() warn: 'cmd' isn't an ERR_PTR
> drivers/md/dm-cache-metadata.c:754 lookup_or_open() error: 'cmd' dereferencing possible ERR_PTR()
> drivers/md/dm-cache-metadata.c:757 lookup_or_open() error: 'cmd' dereferencing possible ERR_PTR()
> 
> I also reversed some tests for failure so that it was more clear and had
> fewer indent levels.
> 
> Fixes: 9b1cc9f251af ('dm cache: share cache-metadata object across inactive and active DM tables')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> The one question I have is that I made dm_cache_metadata_open() either
> preserve the error code or return -EINVAL.  I haven't tested this so I
> guess review carefully.  This patch should probably be back ported to
> stable or folded into Joe's.
> 
> diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
> index 21b1562..3b08cdf 100644
> --- a/drivers/md/dm-cache-metadata.c
> +++ b/drivers/md/dm-cache-metadata.c
> @@ -681,10 +681,8 @@ static struct dm_cache_metadata *metadata_open(struct block_device *bdev,
>  	struct dm_cache_metadata *cmd;
>  
>  	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> -	if (!cmd) {
> -		DMERR("could not allocate metadata struct");
> -		return NULL;
> -	}
> +	if (!cmd)
> +		return ERR_PTR(-ENOMEM);
>  
>  	atomic_set(&cmd->ref_count, 1);
>  	init_rwsem(&cmd->root_lock);
> @@ -745,18 +743,19 @@ static struct dm_cache_metadata *lookup_or_open(struct block_device *bdev,
>  		return cmd;
>  
>  	cmd = metadata_open(bdev, data_block_size, may_format_device, policy_hint_size);
> -	if (cmd) {
> -		mutex_lock(&table_lock);
> -		cmd2 = lookup(bdev);
> -		if (cmd2) {
> -			mutex_unlock(&table_lock);
> -			__destroy_persistent_data_objects(cmd);
> -			kfree(cmd);
> -			return cmd2;
> -		}
> -		list_add(&cmd->list, &table);
> +	if (IS_ERR(cmd))
> +		return cmd;
> +
> +	mutex_lock(&table_lock);
> +	cmd2 = lookup(bdev);
> +	if (cmd2) {
>  		mutex_unlock(&table_lock);
> +		__destroy_persistent_data_objects(cmd);
> +		kfree(cmd);
> +		return cmd2;
>  	}
> +	list_add(&cmd->list, &table);
> +	mutex_unlock(&table_lock);
>  
>  	return cmd;
>  }
> @@ -778,11 +777,16 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
>  						 bool may_format_device,
>  						 size_t policy_hint_size)
>  {
> -	struct dm_cache_metadata *cmd = lookup_or_open(bdev, data_block_size,
> -						       may_format_device, policy_hint_size);
> -	if (cmd && !same_params(cmd, data_block_size)) {
> +	struct dm_cache_metadata *cmd;
> +
> +	cmd = lookup_or_open(bdev, data_block_size,
> +			     may_format_device, policy_hint_size);
> +	if (IS_ERR(cmd))
> +		return cmd;
> +
> +	if (!same_params(cmd, data_block_size)) {
>  		dm_cache_metadata_close(cmd);
> -		return NULL;
> +		return ERR_PTR(-EINVAL);
>  	}
>  
>  	return cmd;
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
