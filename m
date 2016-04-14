From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 18/27] dm: dm-io.c: use bio_get_base_vec()
Date: Thu, 14 Apr 2016 20:02:36 +0800
Message-ID: <1460635375-28282-19-git-send-email-tom.leiming@gmail.com>
References: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 06d426e..6b0e466 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -221,7 +221,12 @@ static void bio_dp_init(struct dpages *dp, struct bio *bio)
 {
 	dp->get_page = bio_get_page;
 	dp->next_page = bio_next_page;
-	dp->context_ptr = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+
+	/*
+	 * need to fix both bio_get_page() and bio_next_page()
+	 * before multipage bvecs
+	 */
+	dp->context_ptr = bio_get_base_vec(bio);
 	dp->context_u = bio->bi_iter.bi_bvec_done;
 }
 
-- 
1.9.1
