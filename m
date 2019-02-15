From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V15 06/18] block: use bio_for_each_bvec() to
	compute multi-page bvec count
Date: Fri, 15 Feb 2019 19:13:12 +0800
Message-ID: <20190215111324.30129-7-ming.lei@redhat.com>
References: <20190215111324.30129-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190215111324.30129-1-ming.lei@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, David Sterba <dsterba@suse.com>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

First it is more efficient to use bio_for_each_bvec() in both
blk_bio_segment_split() and __blk_recalc_rq_segments() to compute how
many multi-page bvecs there are in the bio.

Secondly once bio_for_each_bvec() is used, the bvec may need to be
splitted because its length can be very longer than max segment size,
so we have to split the big bvec into several segments.

Thirdly when splitting multi-page bvec into segments, the max segment
limit may be reached, so the bio split need to be considered under
this situation too.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-merge.c | 103 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 83 insertions(+), 20 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index f85d878f313d..4ef56b2d2aa5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -161,6 +161,73 @@ static inline unsigned get_max_io_size(struct request_queue *q,
 	return sectors;
 }
 
+static unsigned get_max_segment_size(struct request_queue *q,
+				     unsigned offset)
+{
+	unsigned long mask = queue_segment_boundary(q);
+
+	/* default segment boundary mask means no boundary limit */
+	if (mask == BLK_SEG_BOUNDARY_MASK)
+		return queue_max_segment_size(q);
+
+	return min_t(unsigned long, mask - (mask & offset) + 1,
+		     queue_max_segment_size(q));
+}
+
+/*
+ * Split the bvec @bv into segments, and update all kinds of
+ * variables.
+ */
+static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
+		unsigned *nsegs, unsigned *last_seg_size,
+		unsigned *front_seg_size, unsigned *sectors)
+{
+	unsigned len = bv->bv_len;
+	unsigned total_len = 0;
+	unsigned new_nsegs = 0, seg_size = 0;
+
+	/*
+	 * Multi-page bvec may be too big to hold in one segment, so the
+	 * current bvec has to be splitted as multiple segments.
+	 */
+	while (len && new_nsegs + *nsegs < queue_max_segments(q)) {
+		seg_size = get_max_segment_size(q, bv->bv_offset + total_len);
+		seg_size = min(seg_size, len);
+
+		new_nsegs++;
+		total_len += seg_size;
+		len -= seg_size;
+
+		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
+			break;
+	}
+
+	if (!new_nsegs)
+		return !!len;
+
+	/* update front segment size */
+	if (!*nsegs) {
+		unsigned first_seg_size;
+
+		if (new_nsegs == 1)
+			first_seg_size = get_max_segment_size(q, bv->bv_offset);
+		else
+			first_seg_size = queue_max_segment_size(q);
+
+		if (*front_seg_size < first_seg_size)
+			*front_seg_size = first_seg_size;
+	}
+
+	/* update other varibles */
+	*last_seg_size = seg_size;
+	*nsegs += new_nsegs;
+	if (sectors)
+		*sectors += total_len >> 9;
+
+	/* split in the middle of the bvec if len != 0 */
+	return !!len;
+}
+
 static struct bio *blk_bio_segment_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
@@ -174,7 +241,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	struct bio *new = NULL;
 	const unsigned max_sectors = get_max_io_size(q, bio);
 
-	bio_for_each_segment(bv, bio, iter) {
+	bio_for_each_bvec(bv, bio, iter) {
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
@@ -189,8 +256,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 			 */
 			if (nsegs < queue_max_segments(q) &&
 			    sectors < max_sectors) {
-				nsegs++;
-				sectors = max_sectors;
+				/* split in the middle of bvec */
+				bv.bv_len = (max_sectors - sectors) << 9;
+				bvec_split_segs(q, &bv, &nsegs,
+						&seg_size,
+						&front_seg_size,
+						&sectors);
 			}
 			goto split;
 		}
@@ -212,14 +283,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 		if (nsegs == queue_max_segments(q))
 			goto split;
 
-		if (nsegs == 1 && seg_size > front_seg_size)
-			front_seg_size = seg_size;
-
-		nsegs++;
 		bvprv = bv;
 		bvprvp = &bvprv;
-		seg_size = bv.bv_len;
-		sectors += bv.bv_len >> 9;
+
+		if (bvec_split_segs(q, &bv, &nsegs, &seg_size,
+				    &front_seg_size, &sectors))
+			goto split;
 
 	}
 
@@ -233,8 +302,6 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 			bio = new;
 	}
 
-	if (nsegs == 1 && seg_size > front_seg_size)
-		front_seg_size = seg_size;
 	bio->bi_seg_front_size = front_seg_size;
 	if (seg_size > bio->bi_seg_back_size)
 		bio->bi_seg_back_size = seg_size;
@@ -297,6 +364,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	struct bio_vec bv, bvprv = { NULL };
 	int prev = 0;
 	unsigned int seg_size, nr_phys_segs;
+	unsigned front_seg_size = bio->bi_seg_front_size;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
 
@@ -316,7 +384,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	seg_size = 0;
 	nr_phys_segs = 0;
 	for_each_bio(bio) {
-		bio_for_each_segment(bv, bio, iter) {
+		bio_for_each_bvec(bv, bio, iter) {
 			/*
 			 * If SG merging is disabled, each bio vector is
 			 * a segment
@@ -336,20 +404,15 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 				continue;
 			}
 new_segment:
-			if (nr_phys_segs == 1 && seg_size >
-			    fbio->bi_seg_front_size)
-				fbio->bi_seg_front_size = seg_size;
-
-			nr_phys_segs++;
 			bvprv = bv;
 			prev = 1;
-			seg_size = bv.bv_len;
+			bvec_split_segs(q, &bv, &nr_phys_segs, &seg_size,
+					&front_seg_size, NULL);
 		}
 		bbio = bio;
 	}
 
-	if (nr_phys_segs == 1 && seg_size > fbio->bi_seg_front_size)
-		fbio->bi_seg_front_size = seg_size;
+	fbio->bi_seg_front_size = front_seg_size;
 	if (seg_size > bbio->bi_seg_back_size)
 		bbio->bi_seg_back_size = seg_size;
 
-- 
2.9.5
