From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 03/22] block: Convert bio_iovec() to bvec_iter
Date: Wed, 27 Mar 2013 10:39:33 -0700
Message-ID: <1364405992-28424-4-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>, Kent Overstreet <koverstreet@google.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, dm-devel@redhat.com, tj@kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

For immutable biovecs, we'll be introducing a new bio_iovec() that uses
our new bvec iterator to construct a biovec, taking into account
bvec_iter->bi_bvec_done - this patch updates existing users for the new
usage.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/block/aoe/aoecmd.c |  2 +-
 drivers/md/dm-verity.c     |  2 +-
 drivers/scsi/sd.c          |  2 +-
 fs/bio.c                   | 20 ++++++++++----------
 include/linux/bio.h        | 10 ++++++----
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 039ce17..80e5d65 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -927,7 +927,7 @@ bufinit(struct buf *buf, struct request *rq, struct bio *bio)
 	buf->resid = bio->bi_iter.bi_size;
 	buf->sector = bio->bi_iter.bi_sector;
 	bio_pageinc(bio);
-	buf->bv = bv = bio_iovec(bio);
+	buf->bv = bv = __bio_iovec(bio);
 	buf->bv_resid = bv->bv_len;
 	WARN_ON(buf->bv_resid == 0);
 }
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index b17233a..782ee42 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -496,7 +496,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 		io->io_vec = io->io_vec_inline;
 	else
 		io->io_vec = mempool_alloc(v->vec_mempool, GFP_NOIO);
-	memcpy(io->io_vec, bio_iovec(bio),
+	memcpy(io->io_vec, __bio_iovec(bio),
 	       io->io_vec_size * sizeof(struct bio_vec));
 
 	verity_prefetch_io(v, io);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..5e0d12c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -771,7 +771,7 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 	if (sdkp->device->no_write_same)
 		return BLKPREP_KILL;
 
-	BUG_ON(bio_offset(bio) || bio_iovec(bio)->bv_len != sdp->sector_size);
+	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
diff --git a/fs/bio.c b/fs/bio.c
index 85dcc10..8543f85 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -820,12 +820,12 @@ void bio_advance(struct bio *bio, unsigned bytes)
 			break;
 		}
 
-		if (bytes >= bio_iovec(bio)->bv_len) {
-			bytes -= bio_iovec(bio)->bv_len;
+		if (bytes >= bio_iovec(bio).bv_len) {
+			bytes -= bio_iovec(bio).bv_len;
 			bio->bi_iter.bi_idx++;
 		} else {
-			bio_iovec(bio)->bv_len -= bytes;
-			bio_iovec(bio)->bv_offset += bytes;
+			bio_iovec(bio).bv_len -= bytes;
+			bio_iovec(bio).bv_offset += bytes;
 			bytes = 0;
 		}
 	}
@@ -878,8 +878,8 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 	unsigned src_offset, dst_offset, bytes;
 	void *src_p, *dst_p;
 
-	src_bv = bio_iovec(src);
-	dst_bv = bio_iovec(dst);
+	src_bv = __bio_iovec(src);
+	dst_bv = __bio_iovec(dst);
 
 	src_offset = src_bv->bv_offset;
 	dst_offset = dst_bv->bv_offset;
@@ -892,7 +892,7 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 				if (!src)
 					break;
 
-				src_bv = bio_iovec(src);
+				src_bv = __bio_iovec(src);
 			}
 
 			src_offset = src_bv->bv_offset;
@@ -905,7 +905,7 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 				if (!dst)
 					break;
 
-				dst_bv = bio_iovec(dst);
+				dst_bv = __bio_iovec(dst);
 			}
 
 			dst_offset = dst_bv->bv_offset;
@@ -1767,8 +1767,8 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 	bp->bio1.bi_iter.bi_size = first_sectors << 9;
 
 	if (bi->bi_vcnt != 0) {
-		bp->bv1 = *bio_iovec(bi);
-		bp->bv2 = *bio_iovec(bi);
+		bp->bv1 = bio_iovec(bi);
+		bp->bv2 = bio_iovec(bi);
 
 		if (bio_is_rw(bi)) {
 			bp->bv2.bv_offset += first_sectors << 9;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d321e63..580c9ae 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -62,9 +62,11 @@
  * on highmem page vectors
  */
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
-#define bio_iovec(bio)		bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
-#define bio_page(bio)		bio_iovec((bio))->bv_page
-#define bio_offset(bio)		bio_iovec((bio))->bv_offset
+#define __bio_iovec(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
+#define bio_iovec(bio)		(*__bio_iovec(bio))
+
+#define bio_page(bio)		(bio_iovec((bio)).bv_page)
+#define bio_offset(bio)		(bio_iovec((bio)).bv_offset)
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
 #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
 #define bio_end_sector(bio)	((bio)->bi_iter.bi_sector + bio_sectors((bio)))
@@ -72,7 +74,7 @@
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
-		return bio_iovec(bio)->bv_len;
+		return bio_iovec(bio).bv_len;
 	else /* dataless requests such as discard */
 		return bio->bi_iter.bi_size;
 }
-- 
1.8.1.3
