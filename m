From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: indent IBM Power Virtual
Date: Wed,  3 Aug 2016 16:25:41 +0200
Message-ID: <1470234341-6120-1-git-send-email-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c67647c..79e9637 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -523,12 +523,12 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = 15,
 		.minio         = 15,
 	},
-	/*
-	 * IBM Power Virtual SCSI Devices
-	 *
-	 * Maintainer : Brian King, IBM
-	 * Mail : brking@linux.vnet.ibm.com
-	 */
+		/*
+		 * IBM Power Virtual SCSI Devices
+		 *
+		 * Maintainer : Brian King, IBM
+		 * Mail : brking@linux.vnet.ibm.com
+		 */
 	{
 		.vendor        = "AIX",
 		.product       = "VDASD",
-- 
2.7.4
