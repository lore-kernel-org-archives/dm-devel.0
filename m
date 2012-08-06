From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v5 02/12] dm: Use bioset's front_pad for
	dm_rq_clone_bio_info
Date: Mon,  6 Aug 2012 15:08:31 -0700
Message-ID: <1344290921-25154-3-git-send-email-koverstreet@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1344290921-25154-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, mpatocka@redhat.com, vgoyal@redhat.com, yehuda@hq.newdream.net, tj@kernel.org, sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: dm-devel.ids

Previously, dm_rq_clone_bio_info needed to be freed by the bio's
destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
This gets rid of a memory allocation and means we can kill
dm_rq_bio_destructor.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/dm.c |   31 +++++--------------------------
 1 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 40b7735..4014696 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -92,6 +92,7 @@ struct dm_rq_target_io {
 struct dm_rq_clone_bio_info {
 	struct bio *orig;
 	struct dm_rq_target_io *tio;
+	struct bio clone;
 };
 
 union map_info *dm_get_mapinfo(struct bio *bio)
@@ -467,16 +468,6 @@ static void free_rq_tio(struct dm_rq_target_io *tio)
 	mempool_free(tio, tio->md->tio_pool);
 }
 
-static struct dm_rq_clone_bio_info *alloc_bio_info(struct mapped_device *md)
-{
-	return mempool_alloc(md->io_pool, GFP_ATOMIC);
-}
-
-static void free_bio_info(struct dm_rq_clone_bio_info *info)
-{
-	mempool_free(info, info->tio->md->io_pool);
-}
-
 static int md_in_flight(struct mapped_device *md)
 {
 	return atomic_read(&md->pending[READ]) +
@@ -1438,30 +1429,17 @@ void dm_dispatch_request(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(dm_dispatch_request);
 
-static void dm_rq_bio_destructor(struct bio *bio)
-{
-	struct dm_rq_clone_bio_info *info = bio->bi_private;
-	struct mapped_device *md = info->tio->md;
-
-	free_bio_info(info);
-	bio_free(bio, md->bs);
-}
-
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 				 void *data)
 {
 	struct dm_rq_target_io *tio = data;
-	struct mapped_device *md = tio->md;
-	struct dm_rq_clone_bio_info *info = alloc_bio_info(md);
-
-	if (!info)
-		return -ENOMEM;
+	struct dm_rq_clone_bio_info *info =
+		container_of(bio, struct dm_rq_clone_bio_info, clone);
 
 	info->orig = bio_orig;
 	info->tio = tio;
 	bio->bi_end_io = end_clone_bio;
 	bio->bi_private = info;
-	bio->bi_destructor = dm_rq_bio_destructor;
 
 	return 0;
 }
@@ -2696,7 +2674,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
 	if (!pools->tio_pool)
 		goto free_io_pool_and_out;
 
-	pools->bs = bioset_create(pool_size, 0);
+	pools->bs = bioset_create(pool_size,
+				  offsetof(struct dm_rq_clone_bio_info, orig));
 	if (!pools->bs)
 		goto free_tio_pool_and_out;
 
-- 
1.7.7.3
