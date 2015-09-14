From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 12/39] dm: drop null test before destroy
 functions
Date: Mon, 14 Sep 2015 09:46:43 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1509140932400.7970@file01.intranet.prod.int.rdu2.redhat.com>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr> <1442146532-9100-13-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442146532-9100-13-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, sergey.senozhatsky@gmail.com
List-Id: dm-devel.ids



On Sun, 13 Sep 2015, Julia Lawall wrote:

> Remove unneeded NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@ expression x; @@
> -if (x != NULL)
>   \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/md/dm-bufio.c              |    3 +--
>  drivers/md/dm-cache-target.c       |    3 +--
>  drivers/md/dm-crypt.c              |    6 ++----
>  drivers/md/dm-io.c                 |    3 +--
>  drivers/md/dm-log-userspace-base.c |    3 +--
>  drivers/md/dm-region-hash.c        |    4 +---
>  drivers/md/dm.c                    |   13 ++++---------
>  7 files changed, 11 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 83cc52e..8ad39b6 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -1864,8 +1864,7 @@ static void __exit dm_bufio_exit(void)
>  	for (i = 0; i < ARRAY_SIZE(dm_bufio_caches); i++) {
>  		struct kmem_cache *kc = dm_bufio_caches[i];
>  
> -		if (kc)
> -			kmem_cache_destroy(kc);
> +		kmem_cache_destroy(kc);
>  	}

The variable here can be NULL. I don't know how did you conclude that it 
cannot. It seems that you didn't test the patch, if you did, you'd hit 
NULL pointer dereference here.

>  	for (i = 0; i < ARRAY_SIZE(dm_bufio_cache_names); i++)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 6264781..163de31 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2220,10 +2220,8 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  		destroy_workqueue(md->wq);
>  	if (md->kworker_task)
>  		kthread_stop(md->kworker_task);
> -	if (md->io_pool)
> -		mempool_destroy(md->io_pool);
> -	if (md->rq_pool)
> -		mempool_destroy(md->rq_pool);
> +	mempool_destroy(md->io_pool);
> +	mempool_destroy(md->rq_pool);

Likewise, these variables can be NULL.

>  	if (md->bs)
>  		bioset_free(md->bs);
>  
> @@ -3508,11 +3506,8 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
>  	if (!pools)
>  		return;
>  
> -	if (pools->io_pool)
> -		mempool_destroy(pools->io_pool);
> -
> -	if (pools->rq_pool)
> -		mempool_destroy(pools->rq_pool);
> +	mempool_destroy(pools->io_pool);
> +	mempool_destroy(pools->rq_pool);
>  
>  	if (pools->bs)
>  		bioset_free(pools->bs);

Likewise, it can be NULL, see for example this code path:
                pools->io_pool = mempool_create_slab_pool(pool_size, cachep);
                if (!pools->io_pool)
                        goto out;
out:
        dm_free_md_mempools(pools);
dm_free_md_mempools:
        if (pools->io_pool)
                mempool_destroy(pools->io_pool);

It seems that you set up the cocinelle tool incorrectly, so that it 
produces many bogus suggestions.

Mikulas

> diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
> index 058256d..53b7b06 100644
> --- a/drivers/md/dm-log-userspace-base.c
> +++ b/drivers/md/dm-log-userspace-base.c
> @@ -313,8 +313,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
>  out:
>  	kfree(devices_rdata);
>  	if (r) {
> -		if (lc->flush_entry_pool)
> -			mempool_destroy(lc->flush_entry_pool);
> +		mempool_destroy(lc->flush_entry_pool);
>  		kfree(lc);
>  		kfree(ctr_str);
>  	} else {
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index 6f8e83b..81c5e1a 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -65,8 +65,7 @@ struct dm_io_client *dm_io_client_create(void)
>  	return client;
>  
>     bad:
> -	if (client->pool)
> -		mempool_destroy(client->pool);
> +	mempool_destroy(client->pool);
>  	kfree(client);
>  	return ERR_PTR(-ENOMEM);
>  }
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index dd90d12..2fd4c82 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2309,8 +2309,7 @@ static void destroy(struct cache *cache)
>  {
>  	unsigned i;
>  
> -	if (cache->migration_pool)
> -		mempool_destroy(cache->migration_pool);
> +	mempool_destroy(cache->migration_pool);
>  
>  	if (cache->all_io_ds)
>  		dm_deferred_set_destroy(cache->all_io_ds);
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index d60c88d..cf91a96 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1543,10 +1543,8 @@ static void crypt_dtr(struct dm_target *ti)
>  	if (cc->bs)
>  		bioset_free(cc->bs);
>  
> -	if (cc->page_pool)
> -		mempool_destroy(cc->page_pool);
> -	if (cc->req_pool)
> -		mempool_destroy(cc->req_pool);
> +	mempool_destroy(cc->page_pool);
> +	mempool_destroy(cc->req_pool);
>  
>  	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
>  		cc->iv_gen_ops->dtr(cc);
> diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> index b929fd5..f3d608b 100644
> --- a/drivers/md/dm-region-hash.c
> +++ b/drivers/md/dm-region-hash.c
> @@ -249,9 +249,7 @@ void dm_region_hash_destroy(struct dm_region_hash *rh)
>  	if (rh->log)
>  		dm_dirty_log_destroy(rh->log);
>  
> -	if (rh->region_pool)
> -		mempool_destroy(rh->region_pool);
> -
> +	mempool_destroy(rh->region_pool);
>  	vfree(rh->buckets);
>  	kfree(rh);
>  }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
