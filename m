From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 17/27] dm: crypt: use bio_add_page()
Date: Tue,  5 Apr 2016 20:07:32 +0800
Message-ID: <1459858062-21075-3-git-send-email-tom.leiming@gmail.com>
References: <1459858062-21075-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459858062-21075-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm-crypt.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4f3cb35..a2805c1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -995,7 +995,6 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
 	unsigned i, len, remaining_size;
 	struct page *page;
-	struct bio_vec *bvec;
 
 retry:
 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
@@ -1020,12 +1019,7 @@ retry:
 
 		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
 
-		bvec = &clone->bi_io_vec[clone->bi_vcnt++];
-		bvec->bv_page = page;
-		bvec->bv_len = len;
-		bvec->bv_offset = 0;
-
-		clone->bi_iter.bi_size += len;
+		bio_add_page(clone, page, len, 0);
 
 		remaining_size -= len;
 	}
-- 
1.9.1
