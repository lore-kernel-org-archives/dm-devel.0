From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 37/54] dm-crypt: convert to bio_for_each_segment_all_sp()
Date: Wed, 28 Dec 2016 00:04:46 +0800
Message-ID: <1482854706-14128-6-git-send-email-tom.leiming@gmail.com>
References: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm-crypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 593cdf88bf5f..c6932fb85418 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1038,8 +1038,9 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 {
 	unsigned int i;
 	struct bio_vec *bv;
+	struct bvec_iter_all bia;
 
-	bio_for_each_segment_all(bv, clone, i) {
+	bio_for_each_segment_all_sp(bv, clone, i, bia) {
 		BUG_ON(!bv->bv_page);
 		mempool_free(bv->bv_page, cc->page_pool);
 	}
-- 
2.7.4
