From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] Merge Dell MD3XXX hardware table entries
Date: Mon, 30 Mar 2015 08:23:23 +0200
Message-ID: <1427696603-15184-2-git-send-email-hare@suse.de>
References: <1427696603-15184-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1427696603-15184-1-git-send-email-hare@suse.de>
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

Remove duplicate entries and merge MD36xxi/MD36xxf into a single
one.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c | 53 ++++----------------------------------------------
 1 file changed, 4 insertions(+), 49 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fa4b20f..f83f3e7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -728,7 +728,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* DELL MD3000 */
+		/* DELL MD3000/MD3000i */
 		.vendor        = "DELL",
 		.product       = "MD3000",
 		.bl_product    = "Universal Xport",
@@ -743,22 +743,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* DELL MD3000i */
-		.vendor        = "DELL",
-		.product       = "MD3000i",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
-	},
-	{
-		/* DELL MD32xx */
+		/* DELL MD32xx/MD32xxi */
 		.vendor        = "DELL",
 		.product       = "MD32xx",
 		.bl_product    = "Universal Xport",
@@ -773,39 +758,9 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* DELL MD32xxi */
-		.vendor        = "DELL",
-		.product       = "MD32xxi",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
-	},
-	{
-		/* DELL MD36xxi */
-		.vendor        = "DELL",
-		.product       = "MD36xxi",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
-	},
-	{
-		/* DELL MD36xxf */
+		/* DELL MD36xxi/MD36xxf */
 		.vendor        = "DELL",
-		.product       = "MD36xxf",
+		.product       = "MD36xx(i|f)",
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-- 
1.8.4.5
