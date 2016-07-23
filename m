From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/5] multipath-tools: use parentheses() to cover
	a regex with pipe|
Date: Sat, 23 Jul 2016 02:29:10 +0200
Message-ID: <1469233752-11708-3-git-send-email-xose.vazquez@gmail.com>
References: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
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

Easier to read, and maintain consistency with the rest.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6f9adc9..44fc309 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -93,7 +93,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
+		.product       = "(HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0)",
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -101,7 +101,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* HP MSA2000 family with old firmware */
 		.vendor        = "HP",
-		.product       = "MSA2[02]12fc|MSA2012i",
+		.product       = "(MSA2[02]12fc|MSA2012i)",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -109,7 +109,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* HP MSA2000 family with new firmware */
 		.vendor        = "HP",
-		.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
+		.product       = "(MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME)",
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -142,7 +142,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* HP P2000 family */
 		.vendor        = "HP",
-		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
+		.product       = "(P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI)",
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -172,7 +172,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* DGC CLARiiON CX/AX and EMC VNX */
 		.vendor        = "^DGC",
-		.product       = "^RAID|^DISK|^VRAID",
+		.product       = "^(RAID|DISK|VRAID)",
 		.bl_product    = "LUNZ",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
@@ -286,7 +286,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "IBM",
-		.product       = "^1745|^1746",
+		.product       = "^(1745|1746)",
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
@@ -469,7 +469,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* DELL MD32xx/MD36xx */
 		.vendor        = "DELL",
-		.product       = "MD32xx|MD36xx",
+		.product       = "(MD32xx|MD36xx)",
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
@@ -480,7 +480,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* DELL MD34xx/MD38xx */
 		.vendor        = "DELL",
-		.product       = "MD34xx|MD38xx",
+		.product       = "(MD34xx|MD38xx)",
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
@@ -748,7 +748,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		.vendor        = "TEGILE",
-		.product       = "ZEBI-(FC|ISCSI)|INTELLIFLASH",
+		.product       = "(ZEBI-(FC|ISCSI)|INTELLIFLASH)",
 		.hwhandler     = "1 alua",
 		.selector      = "round-robin 0",
 		.no_path_retry = 10,
-- 
2.7.4
