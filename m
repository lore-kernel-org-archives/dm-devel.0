From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 07/12] dm: use bvec iterator helpers to implement .get_page and .next_page
Date: Fri, 11 Nov 2016 20:05:35 +0800
Message-ID: <1478865957-25252-8-git-send-email-tom.leiming@gmail.com>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Firstly we have mature bvec/bio iterator helper for iterate each
page in one bio, not necessary to reinvent a wheel to do that.

Secondly the coming multipage bvecs requires this patch.

Also add comments about the direct access to bvec table.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm-io.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 0bf1a12e35fe..2ef573c220fc 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -162,7 +162,10 @@ struct dpages {
 			 struct page **p, unsigned long *len, unsigned *offset);
 	void (*next_page)(struct dpages *dp);
 
-	unsigned context_u;
+	union {
+		unsigned context_u;
+		struct bvec_iter context_bi;
+	};
 	void *context_ptr;
 
 	void *vma_invalidate_address;
@@ -204,25 +207,36 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned offse
 static void bio_get_page(struct dpages *dp, struct page **p,
 			 unsigned long *len, unsigned *offset)
 {
-	struct bio_vec *bvec = dp->context_ptr;
-	*p = bvec->bv_page;
-	*len = bvec->bv_len - dp->context_u;
-	*offset = bvec->bv_offset + dp->context_u;
+	struct bio_vec bv = bvec_iter_bvec((struct bio_vec *)dp->context_ptr,
+			dp->context_bi);
+
+	*p = bv.bv_page;
+	*len = bv.bv_len;
+	*offset = bv.bv_offset;
+
+	/* avoid to figure out it in bio_next_page() again */
+	dp->context_bi.bi_sector = (sector_t)bv.bv_len;
 }
 
 static void bio_next_page(struct dpages *dp)
 {
-	struct bio_vec *bvec = dp->context_ptr;
-	dp->context_ptr = bvec + 1;
-	dp->context_u = 0;
+	unsigned int len = (unsigned int)dp->context_bi.bi_sector;
+
+	bvec_iter_advance((struct bio_vec *)dp->context_ptr,
+			&dp->context_bi, len);
 }
 
 static void bio_dp_init(struct dpages *dp, struct bio *bio)
 {
 	dp->get_page = bio_get_page;
 	dp->next_page = bio_next_page;
-	dp->context_ptr = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-	dp->context_u = bio->bi_iter.bi_bvec_done;
+
+	/*
+	 * We just use bvec iterator to retrieve pages, so it is ok to
+	 * access the bvec table directly here
+	 */
+	dp->context_ptr = bio->bi_io_vec;
+	dp->context_bi = bio->bi_iter;
 }
 
 /*
-- 
2.7.4

