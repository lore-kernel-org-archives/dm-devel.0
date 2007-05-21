From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 14/21] [hwtable] Update entries for HP arrays
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.949A9D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


I finally figured out the different versions of HP storage
arrays. Thanks to Stephen Reilly of HP for this.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c |   54 ++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 5e04d95..2a5f2d5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -63,11 +63,11 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DEC",
 		.product       = "HSG80",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
-		.features      = DEFAULT_FEATURES,
+		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
+		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
@@ -75,61 +75,62 @@ static struct hwentry default_hw[] = {
 		.checker_name  = HP_SW,
 	},
 	{
-		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.*",
+		.vendor        = "HP",
+		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = "1 hp_sw",
+		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = HP_SW,
+		.checker_name  = READSECTOR0,
 	},
 	{
-		.vendor        = "HP",
-		.product       = "A6189A",
+		/* MSA 1000/MSA1500 EVA 3000/5000 with old firmware */
+		.vendor        = "(COMPAQ|HP)",
+		.product       = "(MSA|HSV)1.0.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = HP_SW,
 	},
 	{
+		/* MSA 1000/1500 with new firmware */
 		.vendor        = "HP",
-		.product       = "HSV20.*",
-		.revision      = "[123].*",
+		.product       = "MSA VOLUME",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = HP_SW,
+		.checker_name  = TUR,
 	},
 	{
-		.vendor        = "HP",
-		.product       = "HSV20.*",
-		.revision      = "[^123].*",
+		/* EVA 3000/5000 with new firmware */
+		.vendor        = "(COMPAQ|HP)",
+		.product       = "(MSA|HSV)1.1.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
@@ -137,15 +138,16 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	{
+		/* EVA 4000/6000/8000 */
 		.vendor        = "HP",
-		.product       = "HSV21.*",
+		.product       = "HSV2.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-- 
1.4.3.4
