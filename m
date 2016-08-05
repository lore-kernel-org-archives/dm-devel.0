From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add vendors' names as they are
	registered at T10
Date: Fri,  5 Aug 2016 22:09:52 +0200
Message-ID: <1470427792-4897-1-git-send-email-xose.vazquez@gmail.com>
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

For the record.

- Unregistered:
AIX
LIO-ORG
NEXENTA
TEGILE

- Registered at T10 with a different spelling/label:
EUROLOGC
HUAWEI
Intel

Real ones are:
"EuroLogc" - Eurologic Systems Limited (now part of PMC Sierra)
"HUASY"    - Huawei Symantec Technologies Co., Ltd.
"INTEL"    - Intel Corporation


HUASY has already been included in a previous patch.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 797ea45..09131bc 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -276,7 +276,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* FibreCAT S80 */
-		.vendor        = "EUROLOGC",
+		.vendor        = "(EUROLOGC|EuroLogc)",
 		.product       = "FC2502",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -755,7 +755,7 @@ static struct hwentry default_hw[] = {
 	 * Intel
 	 */
 	{
-		.vendor	       = "Intel",
+		.vendor	       = "(Intel|INTEL)",
 		.product       = "Multi-Flex",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.7.4
