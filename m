From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 10/10] libmultipath: hwtable: add Lenovo DE
	series
Date: Mon, 18 Mar 2019 12:24:45 +0100
Message-ID: <20190318112445.6636-11-mwilck@suse.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, dm-devel@redhat.com, xose.vazquez@gmail.com, Martin Wilck <mwilck@suse.com>, Steve.Schremmer@netapp.com
List-Id: dm-devel.ids

I got this from Steven.

Cc: Steve.Schremmer@netapp.com
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: xose.vazquez@gmail.com
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/hwtable.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d3a8d9ba..b8285818 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -701,6 +701,26 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.prio_name     = PRIO_ALUA,
 	},
+        /*
+         * Lenovo
+         */
+        {
+                /*
+		 * DE Series
+		 *
+		 * Maintainer: ng-eseries-upstream-maintainers@netapp.com
+		 */
+                .vendor        = "LENOVO",
+                .product       = "DE_Series",
+                .bl_product    = "Universal Xport",
+                .pgpolicy      = GROUP_BY_PRIO,
+                .checker_name  = RDAC,
+                .features      = "2 pg_init_retries 50",
+                .hwhandler     = "1 rdac",
+                .prio_name     = PRIO_RDAC,
+                .pgfailback    = -FAILBACK_IMMEDIATE,
+                .no_path_retry = 30,
+        },
 	/*
 	 * NetApp
 	 */
-- 
2.21.0
