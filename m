From: mwilck@suse.com
Subject: [PATCH] libmultipath: add device to hwtable.c
Date: Tue,  7 Jul 2020 14:54:09 +0200
Message-ID: <20200707125409.24844-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Steve Schremmer <steve.schremmer@netapp.com>
List-Id: dm-devel.ids

From: Steve Schremmer <steve.schremmer@netapp.com>

Add FUJITSU ETERNUS_AHB defaults.

Signed-off-by: Steve Schremmer <steve.schremmer@netapp.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/hwtable.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

(MW: resending with format error fixed)


diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d1fcfdb..d680bdf 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -428,6 +428,22 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 10,
 	},
+	{
+		/*
+		 * ETERNUS AB/HB
+		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
+		 */
+		.vendor        = "FUJITSU",
+		.product       = "ETERNUS_AHB",
+		.bl_product    = "Universal Xport",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.checker_name  = RDAC,
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.prio_name     = PRIO_RDAC,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Hitachi Vantara
 	 *
-- 
2.26.2
