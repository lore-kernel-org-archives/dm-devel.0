From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V13 12/19] block: loop: pass multi-page bvec
	to iov_iter
Date: Fri, 11 Jan 2019 19:01:20 +0800
Message-ID: <20190111110127.21664-13-ming.lei@redhat.com>
References: <20190111110127.21664-1-ming.lei@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20190111110127.21664-1-ming.lei@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

iov_iter is implemented on bvec itererator helpers, so it is safe to pass
multi-page bvec to it, and this way is much more efficient than passing one
page in each bvec.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b8a0720d3653..28dd22c6f83f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -511,21 +511,22 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		     loff_t pos, bool rw)
 {
 	struct iov_iter iter;
+	struct req_iterator rq_iter;
 	struct bio_vec *bvec;
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	struct bio *bio = rq->bio;
 	struct file *file = lo->lo_backing_file;
+	struct bio_vec tmp;
 	unsigned int offset;
-	int segments = 0;
+	int nr_bvec = 0;
 	int ret;
 
+	rq_for_each_bvec(tmp, rq, rq_iter)
+		nr_bvec++;
+
 	if (rq->bio != rq->biotail) {
-		struct req_iterator iter;
-		struct bio_vec tmp;
 
-		__rq_for_each_bio(bio, rq)
-			segments += bio_segments(bio);
-		bvec = kmalloc_array(segments, sizeof(struct bio_vec),
+		bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec),
 				     GFP_NOIO);
 		if (!bvec)
 			return -EIO;
@@ -534,10 +535,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		/*
 		 * The bios of the request may be started from the middle of
 		 * the 'bvec' because of bio splitting, so we can't directly
-		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_segment
+		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_bvec
 		 * API will take care of all details for us.
 		 */
-		rq_for_each_segment(tmp, rq, iter) {
+		rq_for_each_bvec(tmp, rq, rq_iter) {
 			*bvec = tmp;
 			bvec++;
 		}
@@ -551,11 +552,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		 */
 		offset = bio->bi_iter.bi_bvec_done;
 		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-		segments = bio_segments(bio);
 	}
 	atomic_set(&cmd->ref, 2);
 
-	iov_iter_bvec(&iter, rw, bvec, segments, blk_rq_bytes(rq));
+	iov_iter_bvec(&iter, rw, bvec, nr_bvec, blk_rq_bytes(rq));
 	iter.iov_offset = offset;
 
 	cmd->iocb.ki_pos = pos;
-- 
2.9.5
