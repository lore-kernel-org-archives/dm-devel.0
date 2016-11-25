From: peng.liang5@zte.com.cn
Subject: [PATCH] libmultipath: ensure dev_loss_tmo will be update
	to MAX_DEV_LOSS_TMO if no_path_retry set to queue
Date: Fri, 25 Nov 2016 14:36:04 +0800
Message-ID: <1480055764-11124-1-git-send-email-peng.liang5@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, PengLiang <peng.liang5@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: PengLiang <peng.liang5@zte.com.cn>

If no_path_retry set to queue, we should make sure dev_loss_tmo update to MAX_DEV_LOSS_TMO.
But, it will be limit to 600 if fast_io_fail_tmo set to off or 0 meanwhile.

Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
---
 libmultipath/discovery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index aaa915c..05b0842 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -608,7 +608,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 				goto out;
 			}
 		}
-	} else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO) {
+	} else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO &&
+		mpp->no_path_retry != NO_PATH_RETRY_QUEUE) {
 		condlog(3, "%s: limiting dev_loss_tmo to %d, since "
 			"fast_io_fail is not set",
 			rport_id, DEFAULT_DEV_LOSS_TMO);
-- 
2.8.1.windows.1
