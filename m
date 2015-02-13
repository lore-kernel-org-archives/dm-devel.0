From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/7] dm-crypt: remove io_pool
Date: Fri, 13 Feb 2015 08:25:26 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502130824500.6449@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Remove io_pool and _crypt_io_pool because they are unused.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

Index: linux-3.18-rc1/drivers/md/dm-crypt.c
===================================================================
--- linux-3.18-rc1.orig/drivers/md/dm-crypt.c	2014-10-21 00:49:34.000000000 +0200
+++ linux-3.18-rc1/drivers/md/dm-crypt.c	2014-10-21 00:49:37.000000000 +0200
@@ -120,7 +120,6 @@ struct crypt_config {
 	 * pool for per bio private data, crypto requests and
 	 * encryption requeusts/buffer pages
 	 */
-	mempool_t *io_pool;
 	mempool_t *req_pool;
 	mempool_t *page_pool;
 	struct bio_set *bs;
@@ -173,8 +172,6 @@ struct crypt_config {
 
 #define MIN_IOS        16
 
-static struct kmem_cache *_crypt_io_pool;
-
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
@@ -1056,8 +1053,6 @@ static void crypt_dec_pending(struct dm_
 
 	if (io->ctx.req)
 		crypt_free_req(cc, io->ctx.req, base_bio);
-	if (io != dm_per_bio_data(base_bio, cc->per_bio_data_size))
-		mempool_free(io, cc->io_pool);
 
 	bio_endio(base_bio, error);
 }
@@ -1445,8 +1440,6 @@ static void crypt_dtr(struct dm_target *
 		mempool_destroy(cc->page_pool);
 	if (cc->req_pool)
 		mempool_destroy(cc->req_pool);
-	if (cc->io_pool)
-		mempool_destroy(cc->io_pool);
 
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
@@ -1660,13 +1653,6 @@ static int crypt_ctr(struct dm_target *t
 	if (ret < 0)
 		goto bad;
 
-	ret = -ENOMEM;
-	cc->io_pool = mempool_create_slab_pool(MIN_IOS, _crypt_io_pool);
-	if (!cc->io_pool) {
-		ti->error = "Cannot allocate crypt io mempool";
-		goto bad;
-	}
-
 	cc->dmreq_start = sizeof(struct ablkcipher_request);
 	cc->dmreq_start += crypto_ablkcipher_reqsize(any_tfm(cc));
 	cc->dmreq_start = ALIGN(cc->dmreq_start, __alignof__(struct dm_crypt_request));
@@ -1684,6 +1670,7 @@ static int crypt_ctr(struct dm_target *t
 		iv_size_padding = crypto_ablkcipher_alignmask(any_tfm(cc));
 	}
 
+	ret = -ENOMEM;
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
 			sizeof(struct dm_crypt_request) + iv_size_padding + cc->iv_size);
 	if (!cc->req_pool) {
@@ -1946,14 +1933,9 @@ static int __init dm_crypt_init(void)
 {
 	int r;
 
-	_crypt_io_pool = KMEM_CACHE(dm_crypt_io, 0);
-	if (!_crypt_io_pool)
-		return -ENOMEM;
-
 	r = dm_register_target(&crypt_target);
 	if (r < 0) {
 		DMERR("register failed %d", r);
-		kmem_cache_destroy(_crypt_io_pool);
 	}
 
 	return r;
@@ -1962,7 +1944,6 @@ static int __init dm_crypt_init(void)
 static void __exit dm_crypt_exit(void)
 {
 	dm_unregister_target(&crypt_target);
-	kmem_cache_destroy(_crypt_io_pool);
 }
 
 module_init(dm_crypt_init);
