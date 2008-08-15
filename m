From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/1] multipath_tools: Add IBM IPR to hwtable
Date: Thu, 14 Aug 2008 23:53:24 -0700
Message-ID: <1218783204-16115-1-git-send-email-andmike@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com, Wayne Boyer <wayneb@linux.vnet.ibm.com>
List-Id: dm-devel.ids

From: Wayne Boyer <wayneb@linux.vnet.ibm.com>

Add IBM IPR to hwtable.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 libmultipath/hwtable.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0a94f10..e3f80b0 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -514,6 +514,22 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.prio_name     = DEFAULT_PRIO,
 	},
+	{
+		/* IBM IPR */
+		.vendor        = "IBM",
+		.product       = "IPR.*",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 alua",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
+	},
 	/*
 	 * NETAPP controller family
 	 *
-- 
1.5.6.4
