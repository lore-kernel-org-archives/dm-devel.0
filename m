From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/13] gfs2: remove the unused sd_log_error field
Date: Fri, 26 May 2017 11:56:10 +0300
Message-ID: <20170526085620.3113-4-hch@lst.de>
References: <20170526085620.3113-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170526085620.3113-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
---
 fs/gfs2/incore.h | 1 -
 fs/gfs2/lops.c   | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b7cf65d13561..aa3d44527fa2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -815,7 +815,6 @@ struct gfs2_sbd {
 	atomic_t sd_log_in_flight;
 	struct bio *sd_log_bio;
 	wait_queue_head_t sd_log_flush_wait;
-	int sd_log_error;
 
 	atomic_t sd_reserving_log;
 	wait_queue_head_t sd_reserving_log_wait;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index b1f9144b42c7..13ebf15a4db0 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -209,10 +209,8 @@ static void gfs2_end_log_write(struct bio *bio)
 	struct page *page;
 	int i;
 
-	if (bio->bi_error) {
-		sdp->sd_log_error = bio->bi_error;
+	if (bio->bi_error)
 		fs_err(sdp, "Error %d writing to log\n", bio->bi_error);
-	}
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		page = bvec->bv_page;
-- 
2.11.0
