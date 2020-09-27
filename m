From: Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [RFC] dm: fix imposition of queue_limits in dm_wq_work()
	thread
Date: Sun, 27 Sep 2020 20:04:35 +0800
Message-ID: <20200927120435.44118-1-jefflexu@linux.alibaba.com>
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
To: snitzer@redhat.com
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike, would you mind further expalin why bio processed by dm_wq_work()
always gets a previous ->submit_bio. Considering the following call graph:

->submit_bio, that is, dm_submit_bio
  DMF_BLOCK_IO_FOR_SUSPEND set, thus queue_io()

then worker thread dm_wq_work()
  dm_process_bio  // at this point. the input bio is the original bio
                     submitted to dm device

Please let me know if I missed something.

Thanks.
Jeffle


Original commit log:
dm_process_bio() can be called by dm_wq_work(), and if the currently
processing bio is the very beginning bio submitted to the dm device,
that is it has not been handled by previous ->submit_bio, then we also
need to impose the queue_limits when it's in thread (dm_wq_work()).

Fixes: cf9c37865557 ("dm: fix comment in dm_process_bio()")
Fixes: 568c73a355e0 ("dm: update dm_process_bio() to split bio if in ->make_request_fn()")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6ed05ca65a0f..54471c75ddef 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1744,17 +1744,13 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 	}
 
 	/*
-	 * If in ->submit_bio we need to use blk_queue_split(), otherwise
-	 * queue_limits for abnormal requests (e.g. discard, writesame, etc)
-	 * won't be imposed.
-	 * If called from dm_wq_work() for deferred bio processing, bio
-	 * was already handled by following code with previous ->submit_bio.
+	 * Call blk_queue_split() so that queue_limits for abnormal requests
+	 * (e.g. discard, writesame, etc) are ensured to be imposed, while
+	 * it's not needed for regular IO, since regular IO will be split by
+	 * following __split_and_process_bio.
 	 */
-	if (current->bio_list) {
-		if (is_abnormal_io(bio))
-			blk_queue_split(&bio);
-		/* regular IO is split by __split_and_process_bio */
-	}
+	if (is_abnormal_io(bio))
+		blk_queue_split(&bio);
 
 	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
 		return __process_bio(md, map, bio, ti);
-- 
2.27.0
