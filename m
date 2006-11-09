From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] [libmultipath] Update hardware table for HP
	HSV200
Date: Thu, 9 Nov 2006 22:16:21 +0000 (UTC)
Message-ID: <20061109221555.D899B73C90@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Date: Thu Nov 9 11:09:38 2006 +0100
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: dm-devel.ids

According to HP the behaviour of the HSV200 depends on the software
release; all revisions smaller or equal to '3000' have active/passive
support; all revisions above that have active/active support.
Translated it means that the older firmware uses the HP-style
'START_STOP_UNIT' command to switch paths, while the newer firmware
supports ALUA.
So we should update the hardware tables accordingly.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 libmultipath/hwtable.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

19c1285b869bfe42b3605c2fee73bb4b416c4c40
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b56c231..8c8699d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -91,7 +91,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "HP",
-		.product       = "(HSV2.*|A6189A)",
+		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -104,6 +104,53 @@ static struct hwentry default_hw[] = {
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = READSECTOR0,
 	},
+	{
+		.vendor        = "HP",
+		.product       = "HSV20.*",
+		.revision      = "[123].*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = HP_SW,
+	},
+	{
+		.vendor        = "HP",
+		.product       = "HSV20.*",
+		.revision      = "[^123].*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_PRIORITIES,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
+	{
+		.vendor        = "HP",
+		.product       = "HSV21.*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
 	/*
 	 * DDN controller family
 	 *
-- 
1.3.1


--------------040805080108070409060801--
