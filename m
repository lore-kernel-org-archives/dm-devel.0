From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/7] dm io: use dm_get_reserved_bio_based_ios
 to size reserves
Date: Thu, 12 Sep 2013 18:48:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309121848030.31794@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-5-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379024698-10487-5-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

No need to tune it for bio based.

On Thu, 12 Sep 2013, Mike Snitzer wrote:

> Switch dm-io over to sizing its mempool and bioset using DM core's
> configurable 'reserved_bio_based_ios'.
> 
> Export dm_get_reserved_bio_based_ios() for use by DM targets and core
> code.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-io.c |  7 +++----
>  drivers/md/dm.c    | 12 ++++++++++++
>  drivers/md/dm.h    |  2 ++
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index ea49834..2a20986 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -19,8 +19,6 @@
>  #define DM_MSG_PREFIX "io"
>  
>  #define DM_IO_MAX_REGIONS	BITS_PER_LONG
> -#define MIN_IOS		16
> -#define MIN_BIOS	16
>  
>  struct dm_io_client {
>  	mempool_t *pool;
> @@ -50,16 +48,17 @@ static struct kmem_cache *_dm_io_cache;
>  struct dm_io_client *dm_io_client_create(void)
>  {
>  	struct dm_io_client *client;
> +	unsigned min_ios = dm_get_reserved_bio_based_ios();
>  
>  	client = kmalloc(sizeof(*client), GFP_KERNEL);
>  	if (!client)
>  		return ERR_PTR(-ENOMEM);
>  
> -	client->pool = mempool_create_slab_pool(MIN_IOS, _dm_io_cache);
> +	client->pool = mempool_create_slab_pool(min_ios, _dm_io_cache);
>  	if (!client->pool)
>  		goto bad;
>  
> -	client->bios = bioset_create(MIN_BIOS, 0);
> +	client->bios = bioset_create(min_ios, 0);
>  	if (!client->bios)
>  		goto bad;
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index b44ae19..3f96c86 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -259,6 +259,18 @@ static void __reserved_bio_based_ios_refresh(void)
>  	}
>  }
>  
> +unsigned dm_get_reserved_bio_based_ios(void)
> +{
> +	unsigned ios;
> +
> +	mutex_lock(&dm_mempools_lock);
> +	ios = reserved_bio_based_ios_latch;
> +	mutex_unlock(&dm_mempools_lock);
> +
> +	return (ios ? : RESERVED_BIO_BASED_IOS);
> +}
> +EXPORT_SYMBOL_GPL(dm_get_reserved_bio_based_ios);
> +
>  static void __reserved_request_based_ios_refresh(void)
>  {
>  	BUG_ON(!mutex_is_locked(&dm_mempools_lock));
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 5e604cc..e1982eb 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -184,6 +184,8 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
>  /*
>   * Helpers that are used by DM core
>   */
> +unsigned dm_get_reserved_bio_based_ios(void);
> +
>  static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen)
>  {
>  	return !maxlen || strlen(result) + 1 >= maxlen;
> -- 
> 1.8.1.4
> 
