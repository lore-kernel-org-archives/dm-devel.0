From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 03/18] multipath-tools: reorganize NetApp devices
Date: Sat, 30 Jul 2016 02:28:11 +0200
Message-ID: <1469838506-15689-3-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <sean.stewart@netapp.com>
List-Id: dm-devel.ids

Cc: Martin George <marting@netapp.com>
Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 73ba4ee..3952b42 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -494,12 +494,15 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * NetApp ONTAP family
-	 *
-	 * Maintainer : Martin George
-	 * Mail : marting@netapp.com
+	 * NetApp
 	 */
 	{
+		/*
+		 * ONTAP family
+		 *
+		 * Maintainer : Martin George
+		 * Mail : marting@netapp.com
+		 */
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
 		.features      = "3 queue_if_no_path pg_init_retries 50",
@@ -508,12 +511,12 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
 	},
-	/* LSI/Engenio/NetApp RDAC family
-	 *
-	 * Maintainer : Sean Stewart
-	 * Mail : sean.stewart@netapp.com
-	 */
 	{
+		/* LSI/Engenio/NetApp RDAC family
+		 *
+		 * Maintainer : Sean Stewart
+		 * Mail : sean.stewart@netapp.com
+		 */
 		.vendor        = "(NETAPP|LSI|ENGENIO)",
 		.product       = "INF-01-00",
 		.bl_product    = "Universal Xport",
-- 
2.7.4
