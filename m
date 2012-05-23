From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: Some device configuration changes for
	NetApp	LUNs
Date: Wed, 23 May 2012 16:42:20 -0500
Message-ID: <20120523214220.GH9924@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

NetApp has asked for these configuration changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: multipath-tools-120518/libmultipath/hwtable.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/hwtable.c
+++ multipath-tools-120518/libmultipath/hwtable.c
@@ -912,11 +912,12 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
-		.features      = "1 queue_if_no_path",
+		.features      = "3 queue_if_no_path pg_init_retries 50",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.flush_on_last_del = FLUSH_ENABLED,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
