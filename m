From: Martin George <marting@netapp.com>
Subject: [PATCH] multipath-tools: Remove NetApp IBM Nseries code
Date: Mon, 11 Jul 2016 01:55:36 +0530
Message-ID: <2927779.USFptljH3X@marting-ubuntu>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Remove the NetApp IBM Nseries code due to the following reasons:

1) The NetApp IBM Nseries product is obsolete now.

2) Even earlier, the NetApp IBM Nseries product line never used a
VID/PID of "IBM" & "Nseries" respectively. Instead, it always
used the same VID/PID of "NETAPP" & "LUN" itself, similar to the
ONTAP product line. So this piece of code was redundant from the
beginning itself.

Signed-off-by: Martin George <marting@netapp.com>
---
 libmultipath/hwtable.c     | 14 --------------
 multipath/multipath.conf.5 |  2 +-
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a89ea87..140e802 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -770,20 +770,6 @@ static struct hwentry default_hw[] = {
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 		.detect_prio   = DETECT_PRIO_ON,
 	},
-	{
-		/* IBM NSeries */
-		.vendor        = "IBM",
-		.product       = "Nseries.*",
-		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = 128,
-		.prio_name     = PRIO_ONTAP,
-		.prio_args     = NULL,
-	},
 	/*
 	 * NEXENTA
 	 *
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 709ab3c..0b4d366 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -224,7 +224,7 @@ accepts the optional prio_arg \fIexclusive_pref_bit\fR.
 .TP
 .I ontap
 (Hardware-dependent)
-Generate the path priority for NetApp ONTAP class and OEM arrays as IBM NSeries.
+Generate the path priority for NetApp ONTAP class arrays.
 .TP
 .I rdac
 (Hardware-dependent)
-- 
1.9.1
