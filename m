From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 7/9] dm crypt: remove io_pool
Date: Fri, 28 Mar 2014 16:11:14 -0400
Message-ID: <1396037476-26595-8-git-send-email-snitzer@redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Remove io_pool and _crypt_io_pool because they are unused.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d7d7023..8f91531 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
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
@@ -1060,8 +1057,6 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 
 	if (io->ctx.req)
 		crypt_free_req(cc, io->ctx.req, base_bio);
-	if (io != dm_per_bio_data(base_bio, cc->per_bio_data_size))
-		mempool_free(io, cc->io_pool);
 
 	bio_endio(base_bio, error);
 }
@@ -1449,8 +1444,6 @@ static void crypt_dtr(struct dm_target *ti)
 		mempool_destroy(cc->page_pool);
 	if (cc->req_pool)
 		mempool_destroy(cc->req_pool);
-	if (cc->io_pool)
-		mempool_destroy(cc->io_pool);
 
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
@@ -1663,19 +1656,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
 	cc->dmreq_start = ALIGN(cc->dmreq_start, crypto_tfm_ctx_alignment());
 	cc->dmreq_start += crypto_ablkcipher_alignmask(any_tfm(cc)) &
 			   ~(crypto_tfm_ctx_alignment() - 1);
 
+	ret = -ENOMEM;
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
 			sizeof(struct dm_crypt_request) + cc->iv_size);
 	if (!cc->req_pool) {
@@ -1937,14 +1924,9 @@ static int __init dm_crypt_init(void)
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
@@ -1953,7 +1935,6 @@ static int __init dm_crypt_init(void)
 static void __exit dm_crypt_exit(void)
 {
 	dm_unregister_target(&crypt_target);
-	kmem_cache_destroy(_crypt_io_pool);
 }
 
 module_init(dm_crypt_init);
-- 
1.8.1.4
