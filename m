From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] Remove duplicate hwtable entry for XtremIO
Date: Mon, 30 Mar 2015 08:23:22 +0200
Message-ID: <1427696603-15184-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Commit b47e607408e1edce3a03744b4aefa292723c7fc6 introduced a new
hwtable entry for EMC XtremIO instead of updating the existing
one.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 13611fe..fa4b20f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -294,11 +294,11 @@ static struct hwentry default_hw[] = {
 		.product       = "XtremApp",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 5,
 		.checker_name  = TUR,
+		.fast_io_fail  = 5,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -1166,19 +1166,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
-	{
-		.vendor        = "XtremIO",
-		.product       = "XtremApp",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
-		.selector      = "queue-length 0",
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.checker_name  = DIRECTIO,
-		.fast_io_fail  = 15,
-		.prio_name     = DEFAULT_PRIO,
-		.prio_args     = NULL,
-	},
 	/*
 	 * EOL
 	 */
-- 
1.8.4.5
