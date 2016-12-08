From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] dm: Refuse to load an sq table on an mq device
Date: Wed, 7 Dec 2016 16:56:06 -0800
Message-ID: <d6cb4e39-41ea-18e1-3347-398f17ba6e8d@sandisk.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch avoids that the following call trace can be triggered:

------------[ cut here ]------------
WARNING: CPU: 10 PID: 19102 at drivers/md/dm-mpath.c:543 __multipath_map.isra.17+0x23a/0x370 [dm_multipath]
CPU: 10 PID: 19102 Comm: mkfs.ext4 Not tainted 4.9.0-rc8-dbg+ #4
Call Trace:
 [<ffffffff81329cd5>] dump_stack+0x68/0x93
 [<ffffffff810650e6>] __warn+0xc6/0xe0
 [<ffffffff810651b8>] warn_slowpath_null+0x18/0x20
 [<ffffffffa004603a>] __multipath_map.isra.17+0x23a/0x370 [dm_multipath]
 [<ffffffffa0046188>] multipath_clone_and_map+0x18/0x20 [dm_multipath]
 [<ffffffffa002a54d>] map_request+0xed/0x300 [dm_mod]
 [<ffffffffa002a807>] dm_mq_queue_rq+0x77/0x110 [dm_mod]
 [<ffffffff81310fbf>] blk_mq_process_rq_list+0x23f/0x340
 [<ffffffff813111e2>] __blk_mq_run_hw_queue+0x122/0x1c0
 [<ffffffff81310d5f>] blk_mq_run_hw_queue+0x9f/0xc0
 [<ffffffff81311ef5>] blk_mq_insert_requests+0x245/0x320
 [<ffffffff813133f5>] blk_mq_flush_plug_list+0x125/0x140
 [<ffffffff81306b12>] blk_flush_plug_list+0xa2/0x210
 [<ffffffff81307157>] blk_finish_plug+0x27/0x40
 [<ffffffff8116c119>] __do_page_cache_readahead+0x279/0x2f0
 [<ffffffff8116c728>] force_page_cache_readahead+0xa8/0x100
 [<ffffffff8116c7b9>] page_cache_sync_readahead+0x39/0x40
 [<ffffffff8115c964>] generic_file_read_iter+0x234/0x780
 [<ffffffff8121f8e0>] blkdev_read_iter+0x30/0x40
 [<ffffffff811dd2db>] __vfs_read+0xbb/0x130
 [<ffffffff811de341>] vfs_read+0x91/0x130
 [<ffffffff811df6e4>] SyS_read+0x44/0xa0
 [<ffffffff816401aa>] entry_SYSCALL_64_fastpath+0x18/0xad
---[ end trace c5c6591c32eae6dd ]---

after having inserted the following code in __multipath_map():

	WARN_ON_ONCE(clone && q->mq_ops);
	WARN_ON_ONCE(!clone && !q->mq_ops);

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c72a77048b73..918e8b363015 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1322,6 +1322,11 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		DMWARN("can't change device type after initial table load.");
 		r = -EINVAL;
 		goto err_unlock_md_type;
+	} else if (dm_get_md_type(md) == DM_TYPE_MQ_REQUEST_BASED &&
+		   !dm_table_all_blk_mq_devices(t)) {
+		DMWARN("can't load a sq table on a blk-mq dm device.");
+		r = -EINVAL;
+		goto err_unlock_md_type;
 	}
 
 	dm_unlock_md_type(md);
-- 
2.11.0
