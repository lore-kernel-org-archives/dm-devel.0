From: NeilBrown <neilb@suse.com>
Subject: [PATCH 1/2] block: simple improvements for bio->flags
Date: Fri, 07 Apr 2017 11:10:44 +1000
Message-ID: <149152744444.17489.7959643077115840287.stgit@noble>
References: <149152735878.17489.16036848644242802943.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <149152735878.17489.16036848644242802943.stgit@noble>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

The comment for the 'flags' field of 'bio' mentions
"command" which is no longer stored there, and doesn't
mention the bvec pool number, which is.

BIO_RESET_BITS is set in such a way that it would need to be
updated if new bits were added, which is easy to miss.

BVEC_POOL_BITS is larger than needed.  The BVEC_POOL_IDX()
ranges from 0 to 6, so 3 bits are sufficient.

This patch make improvements in each of these areas.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 include/linux/blk_types.h |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d703acb55d0f..ff07d891f38f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -29,7 +29,7 @@ struct bio {
 						 * top bits REQ_OP. Use
 						 * accessors.
 						 */
-	unsigned short		bi_flags;	/* status, command, etc */
+	unsigned short		bi_flags;	/* status, etc and bvec pool number */
 	unsigned short		bi_ioprio;
 
 	struct bvec_iter	bi_iter;
@@ -102,12 +102,7 @@ struct bio {
 #define BIO_REFFED	8	/* bio has elevated ->bi_cnt */
 #define BIO_THROTTLED	9	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */
-
-/*
- * Flags starting here get preserved by bio_reset() - this includes
- * BVEC_POOL_IDX()
- */
-#define BIO_RESET_BITS	10
+/* See BVEC_POOL_OFFSET below before adding new flags */
 
 /*
  * We support 6 different bvec pools, the last one is magic in that it
@@ -117,13 +112,22 @@ struct bio {
 #define BVEC_POOL_MAX		(BVEC_POOL_NR - 1)
 
 /*
- * Top 4 bits of bio flags indicate the pool the bvecs came from.  We add
+ * Top 3 bits of bio flags indicate the pool the bvecs came from.  We add
  * 1 to the actual index so that 0 indicates that there are no bvecs to be
  * freed.
  */
-#define BVEC_POOL_BITS		(4)
+#define BVEC_POOL_BITS		(3)
 #define BVEC_POOL_OFFSET	(16 - BVEC_POOL_BITS)
 #define BVEC_POOL_IDX(bio)	((bio)->bi_flags >> BVEC_POOL_OFFSET)
+#if (1<< BVEC_POOL_BITS) < (BVEC_POOL_NR+1)
+# error "BVEC_POOL_BITS is too small"
+#endif
+
+/*
+ * Flags starting here get preserved by bio_reset() - this includes
+ * only BVEC_POOL_IDX()
+ */
+#define BIO_RESET_BITS	BVEC_POOL_OFFSET
 
 /*
  * Operations and flags common to the bio and request structures.
