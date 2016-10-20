From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: DF arrays were sold also under
	HP mark
Date: Thu, 20 Oct 2016 15:21:41 +0200
Message-ID: <20161020132141.5111-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Matthias Rudolph <matthias.rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Matthias Rudolph <matthias.rudolph@hds.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 223dc08..d67b217 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -304,7 +304,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* AMS 2000 and HUS 100 families */
-		.vendor        = "HITACHI",
+		.vendor        = "(HITACHI|HP)",
 		.product       = "^DF",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.10.1
