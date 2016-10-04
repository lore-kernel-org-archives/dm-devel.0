From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add IBM/3552 (FAStT500) array
Date: Tue,  4 Oct 2016 23:39:02 +0200
Message-ID: <20161004213902.2982-1-xose.vazquez@gmail.com>
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

Vendor doc: https://www.redbooks.ibm.com/redbooks/pdfs/sg246246.pdf
This also confirms that IBM/3542 (FAStT200) is really a RDAC device.
Both of them run the same firmware.

DS4200 tag is wrong.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b8d9196..bfd8d66 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -422,9 +422,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* DS4200 / FAStT200 */
+		/* FAStT200 and FAStT500 */
 		.vendor        = "IBM",
-		.product       = "^3542",
+		.product       = "^(3542|3552)",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
-- 
2.10.1
