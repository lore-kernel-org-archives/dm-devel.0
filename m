From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/9] rqdm core: map_request() takes clone instead
	of orig
Date: Fri, 16 Oct 2009 13:57:15 +0900
Message-ID: <4AD7FD2B.3020800@ct.jp.nec.com>
References: <4AD7FC11.7030009@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AD7FC11.7030009@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch changes the argument of map_request() to clone request
from original request.  No functional change.

This patch is a preparation for PATCH 9, which needs to use
map_request() for clones sharing an original barrier request.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: 2.6.32-rc4/drivers/md/dm.c
===================================================================
--- 2.6.32-rc4.orig/drivers/md/dm.c
+++ 2.6.32-rc4/drivers/md/dm.c
@@ -1493,11 +1493,10 @@ static int dm_prep_fn(struct request_que
 	return BLKPREP_OK;
 }
 
-static void map_request(struct dm_target *ti, struct request *rq,
+static void map_request(struct dm_target *ti, struct request *clone,
 			struct mapped_device *md)
 {
 	int r;
-	struct request *clone = rq->special;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	/*
@@ -1576,7 +1575,7 @@ static void dm_request_fn(struct request
 
 		blk_start_request(rq);
 		spin_unlock(q->queue_lock);
-		map_request(ti, rq, md);
+		map_request(ti, rq->special, md);
 		spin_lock_irq(q->queue_lock);
 	}
 
