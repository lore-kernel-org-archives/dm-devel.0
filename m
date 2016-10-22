From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add missing options and fix
	comments in hwtable's TEMPLATE
Date: Sat, 22 Oct 2016 14:25:54 +0200
Message-ID: <20161022122554.2827-1-xose.vazquez@gmail.com>
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

and replace prio with its variable.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 98da295..de10ebf 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1029,10 +1029,9 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Copy this TEMPLATE to add new hardware.
 	 *
-	 * Keep only mandatory and modified attributes.
+	 * Keep only mandatory(.vendor and .product) and modified attributes.
 	 * Attributes with default values must be removed.
-	 * Only .vendor and .product are mandatory, all other are optional.
-	 * .vendor, .product, .revision and .bl_product are POSIX Extended regex
+	 * .vendor, .product, .revision and .bl_product are POSIX Extended regex.
 	 *
 	 * COMPANY_NAME
 	 *
@@ -1049,9 +1048,10 @@ static struct hwentry default_hw[] = {
 		.uid_attribute = "ID_SERIAL",
 		.selector      = "service-time 0",
 		.checker_name  = TUR,
+		.alias_prefix  = "mpath",
 		.features      = "0",
 		.hwhandler     = "0",
-		.prio_name     = "const",
+		.prio_name     = PRIO_CONST,
 		.prio_args     = "",
 		.pgfailback    = -FAILBACK_MANUAL,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -1059,6 +1059,7 @@ static struct hwentry default_hw[] = {
 		.minio         = 1000,
 		.minio_rq      = 1,
 		.flush_on_last_del = FLUSH_DISABLED,
+		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 		.fast_io_fail  = 5,
 		.dev_loss      = 600,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
-- 
2.10.1
