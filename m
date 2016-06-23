From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: new ONTAP maintainer
Date: Thu, 23 Jun 2016 17:06:40 +0200
Message-ID: <1466694400-7044-1-git-send-email-xose.vazquez@gmail.com>
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

Martin George is in charge of the ONTAP family.

Cc: Martin George <marting@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 38487c1..c845547 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -783,7 +783,10 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * NETAPP
+	 * NETAPP ONTAP family
+	 *
+	 * Maintainer : Martin George
+	 * Mail : marting@netapp.com
 	 */
 	{
 		.vendor        = "NETAPP",
@@ -803,10 +806,8 @@ static struct hwentry default_hw[] = {
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 		.detect_prio   = DETECT_PRIO_ON,
 	},
-	/*
-	 * IBM NSeries (NETAPP)
-	 */
 	{
+		/* IBM NSeries */
 		.vendor        = "IBM",
 		.product       = "Nseries.*",
 		.features      = "1 queue_if_no_path",
-- 
2.5.5
