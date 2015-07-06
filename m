From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/7] dm-thin: use dm_kvmalloc
Date: Mon, 6 Jul 2015 09:48:17 -0400
Message-ID: <20150706134817.GA31517@redhat.com>
References: <alpine.LRH.2.02.1507031700000.28837@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1507031700000.28837@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 03 2015 at  5:00pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Make dm-thin use dm_kvmalloc instead of kmalloc because there was a
> reported allocation failure - see
> https://bugzilla.redhat.com/show_bug.cgi?id=1225370
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-thin.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-4.1/drivers/md/dm-thin.c
> ===================================================================
> --- linux-4.1.orig/drivers/md/dm-thin.c	2015-07-02 18:57:59.000000000 +0200
> +++ linux-4.1/drivers/md/dm-thin.c	2015-07-02 19:00:19.000000000 +0200
> @@ -2513,7 +2513,7 @@ static void __pool_destroy(struct pool *
>  	mempool_destroy(pool->mapping_pool);
>  	dm_deferred_set_destroy(pool->shared_read_ds);
>  	dm_deferred_set_destroy(pool->all_io_ds);
> -	kfree(pool);
> +	kvfree(pool);
>  }
>  
>  static struct kmem_cache *_new_mapping_cache;
> @@ -2535,7 +2535,7 @@ static struct pool *pool_create(struct m
>  		return (struct pool *)pmd;
>  	}
>  
> -	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
> +	pool = dm_kvmalloc(sizeof(*pool), GFP_KERNEL);
>  	if (!pool) {
>  		*error = "Error allocating memory for pool";
>  		err_p = ERR_PTR(-ENOMEM);
> @@ -2630,7 +2630,7 @@ bad_wq:
>  bad_kcopyd_client:
>  	dm_bio_prison_destroy(pool->prison);
>  bad_prison:
> -	kfree(pool);
> +	kvfree(pool);
>  bad_pool:
>  	if (dm_pool_metadata_close(pmd))
>  		DMWARN("%s: dm_pool_metadata_close() failed.", __func__);

Also, this patchset is entirely too much interface churn to act as a
minimalist fix for BZ 1225370.  I've staged this fix for 4.2-rcX:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=a822c83e47d97cdef38c4352e1ef62d9f46cfe98

We'll need to rebase to use your kvmalloc() for 4.3.
