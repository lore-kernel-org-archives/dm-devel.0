From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: delete nearly all attributes of
	the last member(NULL) in hwtable
Date: Mon,  1 Aug 2016 16:11:19 +0200
Message-ID: <1470060679-6993-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

They are "useless".
Leave only mandatory attributes.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index dfd84dc..d53cd34 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -901,18 +901,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = NULL,
 		.product       = NULL,
-		.features      = NULL,
-		.hwhandler     = NULL,
-		.selector      = NULL,
-		.pgpolicy      = 0,
-		.pgfailback    = 0,
-		.rr_weight     = 0,
-		.no_path_retry = 0,
-		.minio         = 0,
-		.minio_rq      = 0,
-		.checker_name  = NULL,
-		.prio_name     = NULL,
-		.prio_args     = NULL,
 	},
 };
 
-- 
2.7.4
