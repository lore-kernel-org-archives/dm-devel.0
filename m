From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: remove pointless ".*" at
	the end of a regex
Date: Thu,  4 Aug 2016 19:31:40 +0200
Message-ID: <1470331901-10846-1-git-send-email-xose.vazquez@gmail.com>
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

At your option, they can be preserved to indicate "maybe anything could appear".

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index dacc9a3..6180751 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -31,7 +31,7 @@ static struct hwentry default_hw[] = {
 	 * Mail : g.shyamsundar@yahoo.co.in
 	 */
 	{
-		.vendor        = "APPLE.*",
+		.vendor        = "APPLE",
 		.product       = "Xserve RAID",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -70,7 +70,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* MSA 1000/1500 and EVA 3000/5000, with old firmware */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.0.*",
+		.product       = "(MSA|HSV)1.0",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -143,7 +143,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* Smart Array */
 		.vendor        = "HP",
-		.product       = "LOGICAL VOLUME.*",
+		.product       = "LOGICAL VOLUME",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 12,
@@ -290,14 +290,14 @@ static struct hwentry default_hw[] = {
 	{
 		/* USP-V, HUS VM, VSP, VSP G1000 and VSP GX00 families */
 		.vendor        = "(HITACHI|HP)",
-		.product       = "OPEN-.*",
+		.product       = "OPEN-",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* AMS 2000 and HUS 100 families */
 		.vendor        = "HITACHI",
-		.product       = "DF.*",
+		.product       = "DF",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -479,7 +479,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
-		.bl_product    = "S/390.*",
+		.bl_product    = "S/390",
 		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
@@ -488,7 +488,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
-		.bl_product    = "S/390.*",
+		.bl_product    = "S/390",
 		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
@@ -497,7 +497,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* Power RAID */
 		.vendor        = "IBM",
-		.product       = "^IPR.*",
+		.product       = "^IPR",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -562,7 +562,7 @@ static struct hwentry default_hw[] = {
 		 * Mail : marting@netapp.com
 		 */
 		.vendor        = "NETAPP",
-		.product       = "LUN.*",
+		.product       = "LUN",
 		.features      = "3 queue_if_no_path pg_init_retries 50",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -627,7 +627,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* InfiniteStorage ??? */
 		.vendor        = "SGI",
-		.product       = "IS.*",
+		.product       = "IS",
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
@@ -660,7 +660,7 @@ static struct hwentry default_hw[] = {
 		 * Mail : srinivas.ramani@oracle.com
 		 */
 		.vendor        = "Pillar",
-		.product       = "Axiom.*",
+		.product       = "Axiom",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -836,7 +836,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		.vendor        = "NFINIDAT",
-		.product       = "InfiniBox.*",
+		.product       = "InfiniBox",
 		.prio_name     = PRIO_ALUA,
 		.selector      = "round-robin 0",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.7.4
