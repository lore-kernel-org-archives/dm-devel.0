From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 36/54] dm-crypt: don't clear bvec->bv_page in crypt_free_buffer_pages()
Date: Wed, 28 Dec 2016 00:04:45 +0800
Message-ID: <1482854706-14128-5-git-send-email-tom.leiming@gmail.com>
References: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

The bio is always freed after running crypt_free_buffer_pages(),
so it isn't necessary to clear the bv->bv_page.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm-crypt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7c6c57216bf2..593cdf88bf5f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1042,7 +1042,6 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 	bio_for_each_segment_all(bv, clone, i) {
 		BUG_ON(!bv->bv_page);
 		mempool_free(bv->bv_page, cc->page_pool);
-		bv->bv_page = NULL;
 	}
 }
 
-- 
2.7.4
