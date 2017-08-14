From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Mon, 14 Aug 2017 16:19:50 -0400
Message-ID: <22930.1510.64868.411152@quad.stoffel.home>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Tom Yan <tom.ty89@gmail.com>, dm-devel@redhat.com, Ondrej Kozina <okozina@redhat.com>, hch@lst.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> dm-crypt consumes excessive amount memory when the user attempts to zero
Mikulas> a dm-crypt device with "blkdiscard -z". The command "blkdiscard -z" calls
Mikulas> the BLKZEROOUT ioctl, it goes to the function __blkdev_issue_zeroout,
Mikulas> __blkdev_issue_zeroout sends large amount of write bios that contain the
Mikulas> zero page as their payload.

Mikulas> For each incoming page, dm-crypt allocates another page that holds the
Mikulas> encrypted data, so when processing "blkdiscard -z", dm-crypt tries to
Mikulas> allocate the amount of memory that is equal to the size of the device.
Mikulas> This can trigger OOM killer or cause system crash.

Mikulas> This patch fixes the bug by limiting the amount of memory that dm-crypt
Mikulas> allocates to 2% of total system memory.

Is this limit per-device or system wide?  it's not clear to me if the
minimum is just one page, or more so it might be nice to clarify
that.

Also, for large memory systems, that's still alot of pages.  Maybe it
should be more exponential in it's clamping as memory sizes go up?  2%
of 2T is 4G, which is pretty darn big...


Mikulas> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Mikulas> Cc: stable@vger.kernel.org

Mikulas> ---
Mikulas>  drivers/md/dm-crypt.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++-
Mikulas>  1 file changed, 59 insertions(+), 1 deletion(-)

Mikulas> Index: linux-2.6/drivers/md/dm-crypt.c
Mikulas> ===================================================================
Mikulas> --- linux-2.6.orig/drivers/md/dm-crypt.c
Mikulas> +++ linux-2.6/drivers/md/dm-crypt.c
Mikulas> @@ -148,6 +148,8 @@ struct crypt_config {
Mikulas>  	mempool_t *tag_pool;
Mikulas>  	unsigned tag_pool_max_sectors;
 
Mikulas> +	struct percpu_counter n_allocated_pages;
Mikulas> +
Mikulas>  	struct bio_set *bs;
Mikulas>  	struct mutex bio_alloc_lock;
 
Mikulas> @@ -219,6 +221,12 @@ struct crypt_config {
Mikulas>  #define MAX_TAG_SIZE	480
Mikulas>  #define POOL_ENTRY_SIZE	512
 
Mikulas> +static DEFINE_SPINLOCK(dm_crypt_clients_lock);
Mikulas> +static unsigned dm_crypt_clients_n = 0;
Mikulas> +static volatile unsigned long dm_crypt_pages_per_client;
Mikulas> +#define DM_CRYPT_MEMORY_PERCENT			2
Mikulas> +#define DM_CRYPT_MIN_PAGES_PER_CLIENT		(BIO_MAX_PAGES * 16)
Mikulas> +
Mikulas>  static void clone_init(struct dm_crypt_io *, struct bio *);
Mikulas>  static void kcryptd_queue_crypt(struct dm_crypt_io *io);
Mikulas>  static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
Mikulas> @@ -2158,6 +2166,37 @@ static int crypt_wipe_key(struct crypt_c
Mikulas>  	return r;
Mikulas>  }
 
Mikulas> +static void crypt_calculate_pages_per_client(void)
Mikulas> +{
Mikulas> +	unsigned long pages = (totalram_pages - totalhigh_pages) * DM_CRYPT_MEMORY_PERCENT / 100;
Mikulas> +	if (!dm_crypt_clients_n)
Mikulas> +		return;
Mikulas> +	pages /= dm_crypt_clients_n;

Would it make sense to use a shift here, or does this only run once on
setup?  And shouldn't you return a value here, if only to make it
clear what you're defaulting to?  

Mikulas> +	if (pages < DM_CRYPT_MIN_PAGES_PER_CLIENT)
Mikulas> +		pages = DM_CRYPT_MIN_PAGES_PER_CLIENT;
Mikulas> +	dm_crypt_pages_per_client = pages;
Mikulas> +}
Mikulas> +
Mikulas> +static void *crypt_page_alloc(gfp_t gfp_mask, void *pool_data)
Mikulas> +{
Mikulas> +	struct crypt_config *cc = pool_data;
Mikulas> +	struct page *page;
Mikulas> +	if (unlikely(percpu_counter_compare(&cc->n_allocated_pages, dm_crypt_pages_per_client) >= 0) &&
Mikulas> +	    likely(gfp_mask & __GFP_NORETRY))
Mikulas> +		return NULL;
Mikulas> +	page = alloc_page(gfp_mask);
Mikulas> +	if (likely(page != NULL))
Mikulas> +		percpu_counter_add(&cc->n_allocated_pages, 1);
Mikulas> +	return page;
Mikulas> +}
Mikulas> +
Mikulas> +static void crypt_page_free(void *page, void *pool_data)
Mikulas> +{
Mikulas> +	struct crypt_config *cc = pool_data;
Mikulas> +	__free_page(page);
Mikulas> +	percpu_counter_sub(&cc->n_allocated_pages, 1);
Mikulas> +}
Mikulas> +
Mikulas>  static void crypt_dtr(struct dm_target *ti)
Mikulas>  {
Mikulas>  	struct crypt_config *cc = ti->private;
Mikulas> @@ -2184,6 +2223,10 @@ static void crypt_dtr(struct dm_target *
Mikulas>  	mempool_destroy(cc->req_pool);
Mikulas>  	mempool_destroy(cc->tag_pool);
 
Mikulas> +	if (cc->page_pool)
Mikulas> +		WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) != 0);
Mikulas> +	percpu_counter_destroy(&cc->n_allocated_pages);
Mikulas> +
Mikulas>  	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
cc-> iv_gen_ops->dtr(cc);
 
Mikulas> @@ -2198,6 +2241,12 @@ static void crypt_dtr(struct dm_target *
 
Mikulas>  	/* Must zero key material before freeing */
Mikulas>  	kzfree(cc);
Mikulas> +
Mikulas> +	spin_lock(&dm_crypt_clients_lock);
Mikulas> +	WARN_ON(!dm_crypt_clients_n);
Mikulas> +	dm_crypt_clients_n--;
Mikulas> +	crypt_calculate_pages_per_client();
Mikulas> +	spin_unlock(&dm_crypt_clients_lock);
Mikulas>  }
 
Mikulas>  static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
Mikulas> @@ -2636,6 +2685,15 @@ static int crypt_ctr(struct dm_target *t
 
ti-> private = cc;
 
Mikulas> +	spin_lock(&dm_crypt_clients_lock);
Mikulas> +	dm_crypt_clients_n++;
Mikulas> +	crypt_calculate_pages_per_client();
Mikulas> +	spin_unlock(&dm_crypt_clients_lock);
Mikulas> +
Mikulas> +	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
Mikulas> +	if (ret < 0)
Mikulas> +		goto bad;
Mikulas> +
Mikulas>  	/* Optional parameters need to be read before cipher constructor */
Mikulas>  	if (argc > 5) {
Mikulas>  		ret = crypt_ctr_optional(ti, argc - 5, &argv[5]);
Mikulas> @@ -2690,7 +2748,7 @@ static int crypt_ctr(struct dm_target *t
Mikulas>  		ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start + additional_req_size,
Mikulas>  		      ARCH_KMALLOC_MINALIGN);
 
Mikulas> -	cc->page_pool = mempool_create_page_pool(BIO_MAX_PAGES, 0);
Mikulas> +	cc->page_pool = mempool_create(BIO_MAX_PAGES, crypt_page_alloc, crypt_page_free, cc);
Mikulas>  	if (!cc->page_pool) {
ti-> error = "Cannot allocate page mempool";
Mikulas>  		goto bad;

Mikulas> --
Mikulas> dm-devel mailing list
Mikulas> dm-devel@redhat.com
Mikulas> https://www.redhat.com/mailman/listinfo/dm-devel
