From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: reorder vendor in hwtable
Date: Fri, 26 Jul 2019 21:19:30 +0200
Message-ID: <20190726191930.23630-3-xose.vazquez@gmail.com>
References: <20190726191930.23630-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190726191930.23630-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Yacine Kheddache <yacine@alyseo.com>, DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Nexenta was acquired by DDN.

Cc: Yacine Kheddache <yacine@alyseo.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 96e8b25..a06872e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -300,6 +300,17 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
+	{
+		/*
+		 * Nexenta COMSTAR
+		 *
+		 * Maintainer: Yacine Kheddache <yacine@alyseo.com>
+		 */
+		.vendor        = "NEXENTA",
+		.product       = "COMSTAR",
+		.pgpolicy      = GROUP_BY_SERIAL,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Dell EMC
 	 */
@@ -780,18 +791,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
-	/*
-	 * Nexenta
-	 *
-	 * Maintainer: Yacine Kheddache <yacine@alyseo.com>
-	 */
-	{
-		/* COMSTAR */
-		.vendor        = "NEXENTA",
-		.product       = "COMSTAR",
-		.pgpolicy      = GROUP_BY_SERIAL,
-		.no_path_retry = 30,
-	},
 	/*
 	 * NEC
 	 */
-- 
2.21.0
