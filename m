From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: merge emc and dell
Date: Fri, 16 Sep 2016 19:37:20 +0200
Message-ID: <1474047440-3221-1-git-send-email-xose.vazquez@gmail.com>
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

There can be only one.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index aaf7480..b8b5bb7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -150,7 +150,7 @@ static struct hwentry default_hw[] = {
 		.product       = "SAN DataDirector",
 	},
 	/*
-	 * EMC
+	 * Dell EMC
 	 */
 	{
 		/* Symmetrix / DMX / VMAX */
@@ -181,9 +181,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "XtremIO",
 		.product       = "XtremApp",
 	},
-	/*
-	 * DELL
-	 */
 	{
 		/*
 		 * Dell SC Series, formerly Compellent
-- 
2.7.4
