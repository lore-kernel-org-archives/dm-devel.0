From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove -FAILBACK_IMMEDIATE from
	devices with no prio
Date: Mon,  1 Aug 2016 16:04:25 +0200
Message-ID: <1470060265-6636-1-git-send-email-xose.vazquez@gmail.com>
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

Changed to FAILBACK_UNDEF(manual).

Spotted by Hannes.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8c074f9..dfd84dc 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -31,7 +31,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	/*
@@ -110,7 +110,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "(MSA2[02]12fc|MSA2012i)",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 18,
 		.minio         = 100,
 	},
@@ -483,14 +483,14 @@ static struct hwentry default_hw[] = {
 		.vendor        = "AIX",
 		.product       = "VDASD",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
 		/* IBM 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
@@ -799,7 +799,7 @@ static struct hwentry default_hw[] = {
 		.product       = "FlashArray",
 		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = FAILBACK_UNDEF,
 		.fast_io_fail  = 10,
 		.dev_loss      = 60,
 	},
@@ -807,7 +807,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
 	 * Violin Memory
-- 
2.7.4
