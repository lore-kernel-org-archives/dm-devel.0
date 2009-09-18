From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 2/3] dm: Use blk_queue_copy_limits()
Date: Sat, 19 Sep 2009 01:26:32 +0900
Message-ID: <4AB3B4B8.10300@ce.jp.nec.com>
References: <4AB3B43D.9000802@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AB3B43D.9000802@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Use new blk_queue_copy_limits() so that invalid limits
(max_sectors == 0) are fixed up appropriately when copied to the queue.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Reported-by: David Strand <dpstrand@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/md/dm-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31.work/drivers/md/dm-table.c
===================================================================
--- linux-2.6.31.work.orig/drivers/md/dm-table.c
+++ linux-2.6.31.work/drivers/md/dm-table.c
@@ -1090,7 +1090,7 @@ void dm_table_set_restrictions(struct dm
 	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
-	q->limits = *limits;
+	blk_queue_copy_limits(q, limits);

 	if (limits->no_cluster)
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
