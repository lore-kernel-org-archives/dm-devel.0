From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: limit the number of allocated pages
Date: Sun, 13 Aug 2017 22:45:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Tom Yan <tom.ty89@gmail.com>, hch@lst.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

dm-crypt consumes excessive amount memory when the user attempts to zero
a dm-crypt device with "blkdiscard -z". The command "blkdiscard -z" calls
the BLKZEROOUT ioctl, it goes to the function __blkdev_issue_zeroout,
__blkdev_issue_zeroout sends large amount of write bios that contain the
zero page as their payload.

For each incoming page, dm-crypt allocates another page that holds the
encrypted data, so when processing "blkdiscard -z", dm-crypt tries to
allocate the amount of memory that is equal to the size of the device.
This can trigger OOM killer or cause system crash.

This patch fixes the bug by limiting the amount of memory that dm-crypt
allocates to 2% of total system memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-crypt.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -148,6 +148,8 @@ struct crypt_config {
 	mempool_t *tag_pool;
 	unsigned tag_pool_max_sectors;
 
+	struct percpu_counter n_allocated_pages;
+
 	struct bio_set *bs;
 	struct mutex bio_alloc_lock;
 
@@ -219,6 +221,12 @@ struct crypt_config {
 #define MAX_TAG_SIZE	480
 #define POOL_ENTRY_SIZE	512
 
+static DEFINE_SPINLOCK(dm_crypt_clients_lock);
+static unsigned dm_crypt_clients_n = 0;
+static volatile unsigned long dm_crypt_pages_per_client;
+#define DM_CRYPT_MEMORY_PERCENT			2
+#define DM_CRYPT_MIN_PAGES_PER_CLIENT		(BIO_MAX_PAGES * 16)
+
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
@@ -2158,6 +2166,37 @@ static int crypt_wipe_key(struct crypt_c
 	return r;
 }
 
+static void crypt_calculate_pages_per_client(void)
+{
+	unsigned long pages = (totalram_pages - totalhigh_pages) * DM_CRYPT_MEMORY_PERCENT / 100;
+	if (!dm_crypt_clients_n)
+		return;
+	pages /= dm_crypt_clients_n;
+	if (pages < DM_CRYPT_MIN_PAGES_PER_CLIENT)
+		pages = DM_CRYPT_MIN_PAGES_PER_CLIENT;
+	dm_crypt_pages_per_client = pages;
+}
+
+static void *crypt_page_alloc(gfp_t gfp_mask, void *pool_data)
+{
+	struct crypt_config *cc = pool_data;
+	struct page *page;
+	if (unlikely(percpu_counter_compare(&cc->n_allocated_pages, dm_crypt_pages_per_client) >= 0) &&
+	    likely(gfp_mask & __GFP_NORETRY))
+		return NULL;
+	page = alloc_page(gfp_mask);
+	if (likely(page != NULL))
+		percpu_counter_add(&cc->n_allocated_pages, 1);
+	return page;
+}
+
+static void crypt_page_free(void *page, void *pool_data)
+{
+	struct crypt_config *cc = pool_data;
+	__free_page(page);
+	percpu_counter_sub(&cc->n_allocated_pages, 1);
+}
+
 static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc = ti->private;
@@ -2184,6 +2223,10 @@ static void crypt_dtr(struct dm_target *
 	mempool_destroy(cc->req_pool);
 	mempool_destroy(cc->tag_pool);
 
+	if (cc->page_pool)
+		WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) != 0);
+	percpu_counter_destroy(&cc->n_allocated_pages);
+
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
 
@@ -2198,6 +2241,12 @@ static void crypt_dtr(struct dm_target *
 
 	/* Must zero key material before freeing */
 	kzfree(cc);
+
+	spin_lock(&dm_crypt_clients_lock);
+	WARN_ON(!dm_crypt_clients_n);
+	dm_crypt_clients_n--;
+	crypt_calculate_pages_per_client();
+	spin_unlock(&dm_crypt_clients_lock);
 }
 
 static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
@@ -2636,6 +2685,15 @@ static int crypt_ctr(struct dm_target *t
 
 	ti->private = cc;
 
+	spin_lock(&dm_crypt_clients_lock);
+	dm_crypt_clients_n++;
+	crypt_calculate_pages_per_client();
+	spin_unlock(&dm_crypt_clients_lock);
+
+	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
+	if (ret < 0)
+		goto bad;
+
 	/* Optional parameters need to be read before cipher constructor */
 	if (argc > 5) {
 		ret = crypt_ctr_optional(ti, argc - 5, &argv[5]);
@@ -2690,7 +2748,7 @@ static int crypt_ctr(struct dm_target *t
 		ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start + additional_req_size,
 		      ARCH_KMALLOC_MINALIGN);
 
-	cc->page_pool = mempool_create_page_pool(BIO_MAX_PAGES, 0);
+	cc->page_pool = mempool_create(BIO_MAX_PAGES, crypt_page_alloc, crypt_page_free, cc);
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
 		goto bad;
