From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/5] block: reinstate early return of
	-EOPNOTSUPP from blkdev_issue_discard
Date: Thu,  5 May 2016 11:54:21 -0400
Message-ID: <1462463665-85312-2-git-send-email-snitzer@redhat.com>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Commit 38f25255330 ("block: add __blkdev_issue_discard") incorrectly
disallowed the early return of -EOPNOTSUPP if the device doesn't support
discard (or secure discard).  This early return of -EOPNOTSUPP has
always been part of blkdev_issue_discard() interface so there isn't a
good reason to break that behaviour -- especially when it can be easily
reinstated.

The nuance of allowing early return of -EOPNOTSUPP vs disallowing late
return of -EOPNOTSUPP is: if the overall device never advertised support
for discards and one is issued to the device it is beneficial to inform
the caller that discards are not supported via -EOPNOTSUPP.  But if a
device advertises discard support it means that at least a subset of the
device does have discard support -- but it could be that discards issued
to some regions of a stacked device will not be supported.  In that case
the late return of -EOPNOTSUPP must be disallowed.

Fixes: 38f25255330 ("block: add __blkdev_issue_discard")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-lib.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index ccbce2b..23d7f30 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -109,11 +109,14 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	blk_start_plug(&plug);
 	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, type,
 			&bio);
-	if (!ret && bio)
+	if (!ret && bio) {
 		ret = submit_bio_wait(type, bio);
+		if (ret == -EOPNOTSUPP)
+			ret = 0;
+	}
 	blk_finish_plug(&plug);
 
-	return ret != -EOPNOTSUPP ? ret : 0;
+	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
-- 
2.6.4 (Apple Git-63)
