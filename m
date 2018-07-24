From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] bcache: don't clone bio in bch_data_verify
Date: Tue, 24 Jul 2018 09:52:30 +0200
Message-ID: <20180724075234.26861-2-hch@lst.de>
References: <20180724075234.26861-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180724075234.26861-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

We immediately overwrite the biovec array, so instead just allocate
a new bio and copy over the disk, setor and size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/debug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index d030ce3025a6..04d146711950 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -110,11 +110,15 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	struct bio_vec bv, cbv;
 	struct bvec_iter iter, citer = { 0 };
 
-	check = bio_clone_kmalloc(bio, GFP_NOIO);
+	check = bio_kmalloc(GFP_NOIO, bio_segments(bio));
 	if (!check)
 		return;
+	check->bi_disk = bio->bi_disk;
 	check->bi_opf = REQ_OP_READ;
+	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
+	check->bi_iter.bi_size = bio->bi_iter.bi_size;
 
+	bch_bio_map(check, NULL);
 	if (bch_bio_alloc_pages(check, GFP_NOIO))
 		goto out_put;
 
-- 
2.18.0
