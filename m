From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH 08/22] block: Immutable bio vecs
Date: Wed,  7 Aug 2013 14:54:17 -0700
Message-ID: <1375912471-5106-9-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1375912471-5106-1-git-send-email-kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, neilb-l3A5Bk7waGM@public.gmane.org, Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: dm-devel.ids

This adds a mechanism by which we can advance a bio by an arbitrary
number of bytes without modifying the biovec: bio->bi_iter.bi_bvec_done
indicates the number of bytes completed in the current bvec.

Various driver code still needs to be updated to not refer to the bvec
directly before we can use this for interesting things, like efficient
bio splitting.

Signed-off-by: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Cc: Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>
Cc: drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Cc: nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
---
 drivers/block/drbd/drbd_main.c |  4 +--
 drivers/block/nbd.c            |  2 +-
 fs/bio.c                       | 27 ++------------
 include/linux/bio.h            | 81 +++++++++++++++++++++++++++++++++++++-----
 include/linux/blk_types.h      |  2 ++
 include/linux/blkdev.h         |  4 +--
 6 files changed, 82 insertions(+), 38 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1589ea4..fee8b51 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1546,7 +1546,7 @@ static int _drbd_send_bio(struct drbd_conf *mdev, struct bio *bio)
 
 		err = _drbd_no_send_page(mdev, bvec.bv_page,
 					 bvec.bv_offset, bvec.bv_len,
-					 bio_iter_last(bio, iter)
+					 bio_iter_last(bvec, iter)
 					 ? 0 : MSG_MORE);
 		if (err)
 			return err;
@@ -1565,7 +1565,7 @@ static int _drbd_send_zc_bio(struct drbd_conf *mdev, struct bio *bio)
 
 		err = _drbd_send_page(mdev, bvec.bv_page,
 				      bvec.bv_offset, bvec.bv_len,
-				      bio_iter_last(bio, iter) ? 0 : MSG_MORE);
+				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
 			return err;
 	}
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index aa362f4..55298db 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -278,7 +278,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 		 */
 		rq_for_each_segment(bvec, req, iter) {
 			flags = 0;
-			if (!rq_iter_last(req, iter))
+			if (!rq_iter_last(bvec, iter))
 				flags = MSG_MORE;
 			dprintk(DBG_TX, "%s: request %p: sending %d bytes data\n",
 					nbd->disk->disk_name, req, bvec.bv_len);
diff --git a/fs/bio.c b/fs/bio.c
index 805befd..1c10ccc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -532,13 +532,11 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	 * most users will be overriding ->bi_bdev with a new target,
 	 * so we don't set nor calculate new physical/hw segment counts here
 	 */
-	bio->bi_iter.bi_sector = bio_src->bi_iter.bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
-	bio->bi_iter.bi_size = bio_src->bi_iter.bi_size;
-	bio->bi_iter.bi_idx = bio_src->bi_iter.bi_idx;
+	bio->bi_iter = bio_src->bi_iter;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -808,28 +806,7 @@ void bio_advance(struct bio *bio, unsigned bytes)
 	if (bio_integrity(bio))
 		bio_integrity_advance(bio, bytes);
 
-	bio->bi_iter.bi_sector += bytes >> 9;
-	bio->bi_iter.bi_size -= bytes;
-
-	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
-		return;
-
-	while (bytes) {
-		if (unlikely(bio->bi_iter.bi_idx >= bio->bi_vcnt)) {
-			WARN_ONCE(1, "bio idx %d >= vcnt %d\n",
-				  bio->bi_iter.bi_idx, bio->bi_vcnt);
-			break;
-		}
-
-		if (bytes >= bio_iovec(bio).bv_len) {
-			bytes -= bio_iovec(bio).bv_len;
-			bio->bi_iter.bi_idx++;
-		} else {
-			bio_iovec(bio).bv_len -= bytes;
-			bio_iovec(bio).bv_offset += bytes;
-			bytes = 0;
-		}
-	}
+	bio_advance_iter(bio, &bio->bi_iter, bytes);
 }
 EXPORT_SYMBOL(bio_advance);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5724feb..151868e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -64,11 +64,38 @@
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
 #define __bio_iovec(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
 
-#define bio_iter_iovec(bio, iter) ((bio)->bi_io_vec[(iter).bi_idx])
+#define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
-#define bio_page(bio)		(bio_iovec((bio)).bv_page)
-#define bio_offset(bio)		(bio_iovec((bio)).bv_offset)
-#define bio_iovec(bio)		(*__bio_iovec(bio))
+#define bvec_iter_page(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+
+#define bvec_iter_len(bvec, iter)				\
+	min((iter).bi_size,					\
+	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
+
+#define bvec_iter_offset(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
+
+#define bvec_iter_bvec(bvec, iter)				\
+((struct bio_vec) {						\
+	.bv_page	= bvec_iter_page((bvec), (iter)),	\
+	.bv_len		= bvec_iter_len((bvec), (iter)),	\
+	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
+})
+
+#define bio_iter_iovec(bio, iter)				\
+	bvec_iter_bvec((bio)->bi_io_vec, (iter))
+
+#define bio_iter_page(bio, iter)				\
+	bvec_iter_page((bio)->bi_io_vec, (iter))
+#define bio_iter_len(bio, iter)					\
+	bvec_iter_len((bio)->bi_io_vec, (iter))
+#define bio_iter_offset(bio, iter)				\
+	bvec_iter_offset((bio)->bi_io_vec, (iter))
+
+#define bio_page(bio)		bio_iter_page((bio), (bio)->bi_iter)
+#define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
+#define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
 
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
 #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
@@ -145,16 +172,54 @@ static inline void *bio_data(struct bio *bio)
 	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
 	     i++)
 
+static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
+				     unsigned bytes)
+{
+	WARN_ONCE(bytes > iter->bi_size,
+		  "Attempted to advance past end of bvec iter\n");
+
+	while (bytes) {
+		unsigned len = min(bytes, bvec_iter_len(bv, *iter));
+
+		bytes -= len;
+		iter->bi_size -= len;
+		iter->bi_bvec_done += len;
+
+		if (iter->bi_bvec_done == __bvec_iter_bvec(bv, *iter)->bv_len) {
+			iter->bi_bvec_done = 0;
+			iter->bi_idx++;
+		}
+	}
+}
+
+#define for_each_bvec(bvl, bio_vec, iter, start)			\
+	for ((iter) = start;						\
+	     (bvl) = bvec_iter_bvec((bio_vec), (iter)),			\
+		(iter).bi_size;						\
+	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
+
+
+static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
+				    unsigned bytes)
+{
+	iter->bi_sector += bytes >> 9;
+
+	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
+		iter->bi_size -= bytes;
+	else
+		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
+}
+
 #define __bio_for_each_segment(bvl, bio, iter, start)			\
 	for (iter = (start);						\
-	     bvl = bio_iter_iovec((bio), (iter)),			\
-	     (iter).bi_idx < (bio)->bi_vcnt;				\
-	     (iter).bi_idx++)
+	     (iter).bi_size &&						\
+		((bvl = bio_iter_iovec((bio), (iter))), 1);		\
+	     bio_advance_iter((bio), &(iter), (bvl).bv_len))
 
 #define bio_for_each_segment(bvl, bio, iter)				\
 	__bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
 
-#define bio_iter_last(bio, iter) ((iter).bi_idx == (bio)->bi_vcnt - 1)
+#define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d46e8a6..72f1274 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -34,6 +34,8 @@ struct bvec_iter {
 	unsigned int		bi_size;	/* residual I/O count */
 
 	unsigned int		bi_idx;		/* current index into bvl_vec */
+
+	unsigned int            bi_bvec_done;
 };
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b9d47b..2a16de2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -714,9 +714,9 @@ struct req_iterator {
 	__rq_for_each_bio(_iter.bio, _rq)			\
 		bio_for_each_segment(bvl, _iter.bio, _iter.iter)
 
-#define rq_iter_last(rq, _iter)					\
+#define rq_iter_last(bvec, _iter)				\
 		(_iter.bio->bi_next == NULL &&			\
-		 bio_iter_last(_iter.bio, _iter.iter))
+		 bio_iter_last(bvec, _iter.iter))
 
 #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
 # error	"You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform"
-- 
1.8.4.rc1


------------------------------------------------------------------------------
Get 100% visibility into Java/.NET code with AppDynamics Lite!
It's a free troubleshooting tool designed for production.
Get down to code-level detail for bottlenecks, with <2% overhead. 
Download for free and get started troubleshooting in minutes. 
http://pubads.g.doubleclick.net/gampad/clk?id=48897031&iu=/4140/ostg.clktrk
