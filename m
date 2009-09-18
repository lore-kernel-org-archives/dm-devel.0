From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 3/3] dm: Add a remapping trace to request-based dm
Date: Sat, 19 Sep 2009 00:13:34 +0900
Message-ID: <4AB3A39E.9080908@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: j-nomura@ce.jp.nec.com, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Add a remapping trace to request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/md/dm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.31.work/drivers/md/dm.c
===================================================================
--- linux-2.6.31.work.orig/drivers/md/dm.c
+++ linux-2.6.31.work/drivers/md/dm.c
@@ -1503,6 +1503,8 @@ static void map_request(struct dm_target
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* The target has remapped the I/O so dispatch it */
+		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
+				     blk_rq_pos(tio->orig));
 		dm_dispatch_request(clone);
 		break;
 	case DM_MAPIO_REQUEUE:
