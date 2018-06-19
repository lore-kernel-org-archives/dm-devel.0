From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] block: remove bio_clone_kmalloc
Date: Tue, 19 Jun 2018 06:52:14 +0200
Message-ID: <20180619045216.21130-5-hch@lst.de>
References: <20180619045216.21130-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180619045216.21130-1-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bio.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index f08f5fe7bd08..430807f9f44b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -443,12 +443,6 @@ static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
 }
 
-static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
-{
-	return bio_clone_bioset(bio, gfp_mask, NULL);
-
-}
-
 extern blk_qc_t submit_bio(struct bio *);
 
 extern void bio_endio(struct bio *);
-- 
2.17.1
