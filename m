From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH] dm mpath: fix memory leak for
	attached_handler_name
Date: Sat, 27 Apr 2019 18:54:09 +0800
Message-ID: <20190427105409.36721-1-yuyufen@huawei.com>
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
To: snitzer@redhat.com, dm-devel@redhat.com
Cc: mpatocka@redhat.com, mwilck@suse.com, yuyufen@huawei.com
List-Id: dm-devel.ids

If multipath does not set flag MPATHF_RETAIN_ATTACHED_HW_HANDLER,
parse_path() would forget to free attached_handler_name when
successfully exit, resulting in memory leak.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/dm-mpath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 00e738c1222f..850a7c637a88 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -841,6 +841,8 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
 			m->hw_handler_name = *attached_handler_name;
 			*attached_handler_name = NULL;
 		}
+	} else {
+		kfree(*attached_handler_name);
 	}
 
 	if (m->hw_handler_name) {
-- 
2.16.2.dirty
