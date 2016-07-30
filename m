From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 13/18] multipath-tools: delete nearly all
	attribute of last member(NULL) in hwtable
Date: Sat, 30 Jul 2016 02:28:21 +0200
Message-ID: <1469838506-15689-13-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

They are "useless".
Leave only mandatory attributes.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 822f7ff..ebad919 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -910,29 +910,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = NULL,
 		.product       = NULL,
-		.revision      = NULL,
-		.bl_product    = NULL,
-		.pgpolicy      = 0,
-		.uid_attribute = NULL,
-		.selector      = NULL,
-		.checker_name  = NULL,
-		.features      = NULL,
-		.hwhandler     = NULL,
-		.prio_name     = NULL,
-		.prio_args     = NULL,
-		.pgfailback    = 0,
-		.rr_weight     = 0,
-		.no_path_retry = 0,
-		.minio         = 0,
-		.minio_rq      = 0,
-		.flush_on_last_del = 0,
-		.fast_io_fail  = 0,
-		.dev_loss      = 0,
-		.retain_hwhandler = NULL,
-		.detect_prio   = NULL,
-		.deferred_remove = NULL,
-		.delay_watch_checks = 0,
-		.delay_wait_checks = 0,
 	},
 };
 
-- 
2.7.4
