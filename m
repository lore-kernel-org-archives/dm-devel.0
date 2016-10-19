From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add DDN and rebranded arrays to
	hwtable
Date: Wed, 19 Oct 2016 23:55:31 +0200
Message-ID: <20161019215531.3199-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e34032d..7f499db 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -163,6 +163,20 @@ static struct hwentry default_hw[] = {
 		.product       = "SAN DataDirector",
 		.pgpolicy      = MULTIBUS,
 	},
+	{
+		.vendor        = "DDN",
+		.product       = "^EF3010",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
+	{
+		.vendor        = "DDN",
+		.product       = "^(EF3015|S2A|SFA)",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Dell EMC
 	 */
@@ -532,6 +546,15 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_FAIL,
 		.pgpolicy      = MULTIBUS,
 	},
+	{
+		/* DDN */
+		.vendor        = "IBM",
+		.product       = "^(DCS9900|2851)",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 		/*
 		 * IBM Power Virtual SCSI Devices
 		 *
@@ -654,6 +677,15 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		/* DDN */
+		.vendor        = "SGI",
+		.product       = "^DD[46]A-",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 	/*
 	 * NEC
 	 */
-- 
2.10.1
