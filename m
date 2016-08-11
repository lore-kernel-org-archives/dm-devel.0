From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 05/11] multipath-tools: delete IBM/1745 ghost
	array
Date: Thu, 11 Aug 2016 20:32:21 +0200
Message-ID: <1470940345-4441-5-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

There is no references nowhere.
Confirmed by the original manufacturer(NetApp), and Google shows no results.

Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7d1f85e..063535c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -358,7 +358,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* DS3500 / DS3512 / DS3524 */
 		.vendor        = "IBM",
-		.product       = "^(1745|1746)",
+		.product       = "^1746",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
-- 
2.7.4
