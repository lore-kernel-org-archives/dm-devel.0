From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace hidden tabs by spaces
	in .vendor
Date: Sat, 20 May 2017 15:29:52 +0200
Message-ID: <20170520132952.2732-1-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 54309ef..59a6055 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -827,7 +827,7 @@ static struct hwentry default_hw[] = {
 	 * Intel
 	 */
 	{
-		.vendor	       = "(Intel|INTEL)",
+		.vendor        = "(Intel|INTEL)",
 		.product       = "Multi-Flex",
 		.bl_product    = "VTrak V-LUN",
 		.hwhandler     = "1 alua",
@@ -840,7 +840,7 @@ static struct hwentry default_hw[] = {
 	 * Linux-IO Target
 	 */
 	{
-		.vendor	       = "(LIO-ORG|SUSE)",
+		.vendor        = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -852,7 +852,7 @@ static struct hwentry default_hw[] = {
 	 * DataCore
 	 */
 	{
-		.vendor	       = "DataCore",
+		.vendor        = "DataCore",
 		.product       = "SANmelody",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -861,7 +861,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* SANsymphony */
-		.vendor	       = "DataCore",
+		.vendor        = "DataCore",
 		.product       = "Virtual Disk",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1053,7 +1053,7 @@ static struct hwentry default_hw[] = {
 	 * Generic NVMe devices
 	 */
 	{
-		.vendor	       = "NVME",
+		.vendor        = "NVME",
 		.product       = ".*",
 		.uid_attribute = "ID_WWN",
 		.checker_name  = DIRECTIO,
-- 
2.13.0
