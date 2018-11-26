From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V12 08/20] block: introduce
	bio_for_each_bvec() and rq_for_each_bvec()
Date: Mon, 26 Nov 2018 10:17:08 +0800
Message-ID: <20181126021720.19471-9-ming.lei@redhat.com>
References: <20181126021720.19471-1-ming.lei@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, Omar Sandoval <osandov@fb.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

bio_for_each_bvec() is used for iterating over multi-page bvec for bio
split & merge code.

rq_for_each_bvec() can be used for drivers which may handle the
multi-page bvec directly, so far loop is one perfect use case.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bio.h    | 10 ++++++++++
 include/linux/blkdev.h |  4 ++++
 include/linux/bvec.h   |  7 +++++++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6a0ff02f4d1c..46fd0e03233b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -156,6 +156,16 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 #define bio_for_each_segment(bvl, bio, iter)				\
 	__bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
 
+#define __bio_for_each_bvec(bvl, bio, iter, start)		\
+	for (iter = (start);						\
+	     (iter).bi_size &&						\
+		((bvl = bvec_iter_bvec((bio)->bi_io_vec, (iter))), 1); \
+	     bio_advance_iter((bio), &(iter), (bvl).bv_len))
+
+/* iterate over multi-page bvec */
+#define bio_for_each_bvec(bvl, bio, iter)			\
+	__bio_for_each_bvec(bvl, bio, iter, (bio)->bi_iter)
+
 #define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
 static inline unsigned bio_segments(struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 399a7a415609..fa263de3f1d1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -799,6 +799,10 @@ struct req_iterator {
 	__rq_for_each_bio(_iter.bio, _rq)			\
 		bio_for_each_segment(bvl, _iter.bio, _iter.iter)
 
+#define rq_for_each_bvec(bvl, _rq, _iter)			\
+	__rq_for_each_bio(_iter.bio, _rq)			\
+		bio_for_each_bvec(bvl, _iter.bio, _iter.iter)
+
 #define rq_iter_last(bvec, _iter)				\
 		(_iter.bio->bi_next == NULL &&			\
 		 bio_iter_last(bvec, _iter.iter))
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index babc6316c117..d441486db605 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -65,6 +65,13 @@ struct bvec_iter {
 #define bvec_iter_page_idx(bvec, iter)			\
 	(bvec_iter_offset((bvec), (iter)) / PAGE_SIZE)
 
+#define bvec_iter_bvec(bvec, iter)				\
+((struct bio_vec) {						\
+	.bv_page	= bvec_iter_page((bvec), (iter)),	\
+	.bv_len		= bvec_iter_len((bvec), (iter)),	\
+	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
+})
+
 /* For building single-page bvec(segment) in flight */
  #define segment_iter_offset(bvec, iter)				\
 	(bvec_iter_offset((bvec), (iter)) % PAGE_SIZE)
-- 
2.9.5
