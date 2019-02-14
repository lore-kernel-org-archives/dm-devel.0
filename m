From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH] dm: clear BIO_SEG_VALID in clone_bio
Date: Thu, 14 Feb 2019 17:19:30 +0800
Message-ID: <20190214091930.121952-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: yangerkun@huawei.com, miaoxie@huawei.com, dm-devel@redhat.com, houtao1@huawei.com
List-Id: dm-devel.ids

Since 57c36519e4("dm: fix clone_bio() to trigger blk_recount_segments()")
has been reverted by fa8db494("dm: don't use bio_trim() afterall"), the
problem that clone bio won't trigger blk_recount_segments will exits
again. So just clean the flag in clone_bio.

Fixes: fa8db4948f522("dm: don't use bio_trim() afterall")
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/md/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 515e6af..b22ac04 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1336,6 +1336,7 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
 			return r;
 	}
 
+	bio_clear_flag(clone, BIO_SEG_VALID);
 	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
 	clone->bi_iter.bi_size = to_bytes(len);
 
-- 
2.9.5
