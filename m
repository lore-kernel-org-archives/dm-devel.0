From: John Dorminy <jdorminy@redhat.com>
Subject: [PATCH] dm-ebs: Fix incorrect checking for REQ_OP_FLUSH.
Date: Fri, 31 Jul 2020 18:46:45 -0400
Message-ID: <20200731224645.89483-1-jdorminy@redhat.com>
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
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: John Dorminy <jdorminy@redhat.com>
List-Id: dm-devel.ids

REQ_OP_FLUSH was being treated as a flag, but the operation
part of bio->bi_opf must be treated as a whole. Change to
accessing the operation part via bio_op(bio) and checking
for equality.

Signed-off-by: John Dorminy <jdorminy@redhat.com>
---
 drivers/md/dm-ebs-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 44451276f128..cb85610527c2 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -363,7 +363,7 @@ static int ebs_map(struct dm_target *ti, struct bio *bio)
 	bio_set_dev(bio, ec->dev->bdev);
 	bio->bi_iter.bi_sector = ec->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
 
-	if (unlikely(bio->bi_opf & REQ_OP_FLUSH))
+	if (unlikely(bio_op(bio) == REQ_OP_FLUSH))
 		return DM_MAPIO_REMAPPED;
 	/*
 	 * Only queue for bufio processing in case of partial or overlapping buffers
-- 
2.26.2
