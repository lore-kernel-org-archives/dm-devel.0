From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V11 15/19] block: enable multipage bvecs
Date: Wed, 21 Nov 2018 11:23:23 +0800
Message-ID: <20181121032327.8434-16-ming.lei@redhat.com>
References: <20181121032327.8434-1-ming.lei@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20181121032327.8434-1-ming.lei@redhat.com>
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

This patch pulls the trigger for multi-page bvecs.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c       | 32 +++++++++++++++++++++++++++-----
 fs/iomap.c        |  2 +-
 fs/xfs/xfs_aops.c |  2 +-
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0f1635b9ec50..854676edc438 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -823,7 +823,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * @len: length of the data to add
  * @off: offset of the data in @page
  *
- * Try to add the data at @page + @off to the last bvec of @bio.  This is a
+ * Try to add the data at @page + @off to the last page of @bio.  This is a
  * a useful optimisation for file systems with a block size smaller than the
  * page size.
  *
@@ -836,10 +836,13 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 		return false;
 
 	if (bio->bi_vcnt > 0) {
-		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+		struct bio_vec bv;
+		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
-			bv->bv_len += len;
+		bvec_last_segment(seg, &bv);
+
+		if (page == bv.bv_page && off == bv.bv_offset + bv.bv_len) {
+			seg->bv_len += len;
 			bio->bi_iter.bi_size += len;
 			return true;
 		}
@@ -848,6 +851,25 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 }
 EXPORT_SYMBOL_GPL(__bio_try_merge_page);
 
+static bool bio_try_merge_segment(struct bio *bio, struct page *page,
+				  unsigned int len, unsigned int off)
+{
+	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
+		return false;
+
+	if (bio->bi_vcnt > 0) {
+		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		if (page_to_phys(seg->bv_page) + seg->bv_offset + seg->bv_len ==
+		    page_to_phys(page) + off) {
+			seg->bv_len += len;
+			bio->bi_iter.bi_size += len;
+			return true;
+		}
+	}
+	return false;
+}
+
 /**
  * __bio_add_page - add page to a bio in a new segment
  * @bio: destination bio
@@ -888,7 +910,7 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
 int bio_add_page(struct bio *bio, struct page *page,
 		 unsigned int len, unsigned int offset)
 {
-	if (!__bio_try_merge_page(bio, page, len, offset)) {
+	if (!bio_try_merge_segment(bio, page, len, offset)) {
 		if (bio_full(bio))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
diff --git a/fs/iomap.c b/fs/iomap.c
index f5fb8bf75cc8..ccc2ba115f4d 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -344,7 +344,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		ctx->bio->bi_end_io = iomap_read_end_io;
 	}
 
-	__bio_add_page(ctx->bio, page, plen, poff);
+	bio_add_page(ctx->bio, page, plen, poff);
 done:
 	/*
 	 * Move the caller beyond our range so that it keeps making progress.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1f1829e506e8..5c2190216614 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -621,7 +621,7 @@ xfs_add_to_ioend(
 			atomic_inc(&iop->write_count);
 		if (bio_full(wpc->ioend->io_bio))
 			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
-		__bio_add_page(wpc->ioend->io_bio, page, len, poff);
+		bio_add_page(wpc->ioend->io_bio, page, len, poff);
 	}
 
 	wpc->ioend->io_size += len;
-- 
2.9.5
