From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/4] dm: fix dm_wq_work() to only use
	__split_and_process_bio() if appropriate
Date: Sat, 19 Jan 2019 13:05:06 -0500
Message-ID: <20190119180506.1300-5-snitzer@redhat.com>
References: <20190119180506.1300-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190119180506.1300-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, NeilBrown <neilb@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Otherwise targets that don't support/expect IO splitting could resubmit
bios using code paths with unnecessary IO splitting complexity.

Depends-on: 24113d487843 ("dm: avoid indirect call in __dm_make_request")
Fixes: 978e51ba38e00 ("dm: optimize bio-based NVMe IO submission")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6e29c2d99b99..aa7e429646b3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1727,6 +1727,15 @@ static blk_qc_t __process_bio(struct mapped_device *md,
 	return ret;
 }
 
+static blk_qc_t dm_process_bio(struct mapped_device *md,
+			       struct dm_table *map, struct bio *bio)
+{
+	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
+		return __process_bio(md, map, bio);
+	else
+		return __split_and_process_bio(md, map, bio);
+}
+
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
@@ -1747,10 +1756,7 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 		return ret;
 	}
 
-	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
-		ret = __process_bio(md, map, bio);
-	else
-		ret = __split_and_process_bio(md, map, bio);
+	ret = dm_process_bio(md, map, bio);
 
 	dm_put_live_table(md, srcu_idx);
 	return ret;
@@ -2429,9 +2435,9 @@ static void dm_wq_work(struct work_struct *work)
 			break;
 
 		if (dm_request_based(md))
-			generic_make_request(c);
+			(void) generic_make_request(c);
 		else
-			__split_and_process_bio(md, map, c);
+			(void) dm_process_bio(md, map, c);
 	}
 
 	dm_put_live_table(md, srcu_idx);
-- 
2.15.0
