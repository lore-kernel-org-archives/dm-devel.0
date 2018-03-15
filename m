From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove DF arrays from HP
Date: Thu, 15 Mar 2018 18:43:22 +0100
Message-ID: <20180315174322.30108-1-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Matthias did confirm that there are no such devices.

Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fe71d14..570811e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -404,7 +404,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* AMS 2000 and HUS 100 families */
-		.vendor        = "(HITACHI|HP)",
+		.vendor        = "HITACHI",
 		.product       = "^DF",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.14.3
