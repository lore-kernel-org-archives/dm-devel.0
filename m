From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add NetApp/SolidFir to hwtable
Date: Wed,  5 Oct 2016 16:45:22 +0200
Message-ID: <20161005144522.8739-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, PJ Waskiewicz <pj.waskiewicz@netapp.com>
List-Id: dm-devel.ids

Cc: PJ Waskiewicz <pj.waskiewicz@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bfd8d66..8ecaffb 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -573,6 +573,18 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		/*
+		 * SolidFir family
+		 *
+		 * Maintainer : PJ Waskiewicz
+		 * Mail : pj.waskiewicz@netapp.com
+		 */
+		.vendor        = "SolidFir",
+		.product       = "SSD SAN",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 24,
+	},
 	/*
 	 * Nexenta
 	 *
-- 
2.10.0
