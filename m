From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] dm verity: remove unused mempool
Date: Mon, 29 Jun 2015 14:14:00 +0100
Message-ID: <20150629131400.GA18829@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Since commit 003b5c5719f159f4f4bf97511c4702a0638313dd, vec_mempool in
struct dm-verity is no longer used. Remove it and related definitions.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

--
 drivers/md/dm-verity.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index bb9c6a0..3adb332 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -26,8 +26,6 @@
 #define DM_VERITY_ENV_LENGTH		42
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
-#define DM_VERITY_IO_VEC_INLINE		16
-#define DM_VERITY_MEMPOOL_SIZE		4
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
 
 #define DM_VERITY_MAX_LEVELS		63
@@ -76,8 +74,6 @@ struct dm_verity {
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
 
-	mempool_t *vec_mempool;	/* mempool of bio vector */
-
 	struct workqueue_struct *verify_wq;
 
 	/* starting blocks for each tree level. 0 is the lowest level. */
@@ -691,9 +687,6 @@ static void verity_dtr(struct dm_target *ti)
 	if (v->verify_wq)
 		destroy_workqueue(v->verify_wq);
 
-	if (v->vec_mempool)
-		mempool_destroy(v->vec_mempool);
-
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
@@ -962,14 +955,6 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	ti->per_bio_data_size = roundup(sizeof(struct dm_verity_io) + v->shash_descsize + v->digest_size * 2, __alignof__(struct dm_verity_io));
 
-	v->vec_mempool = mempool_create_kmalloc_pool(DM_VERITY_MEMPOOL_SIZE,
-					BIO_MAX_PAGES * sizeof(struct bio_vec));
-	if (!v->vec_mempool) {
-		ti->error = "Cannot allocate vector mempool";
-		r = -ENOMEM;
-		goto bad;
-	}
-
 	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
 	v->verify_wq = alloc_workqueue("kverityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!v->verify_wq) {
