From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: reformat maintainer info
Date: Sun,  1 Jul 2018 17:55:38 +0200
Message-ID: <20180701155538.5300-1-xose.vazquez@gmail.com>
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
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f012dea..478bf16 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -38,8 +38,7 @@
 	 *
 	 * COMPANY_NAME
 	 *
-	 * Maintainer : XXX
-	 * Mail : XXX
+	 * Maintainer: XXX <email>
 	 */
 	{
 		/* Product Name */
@@ -96,8 +95,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Apple
 	 *
-	 * Maintainer : Shyam Sundar
-	 * Mail : g.shyamsundar@yahoo.co.in
+	 * Maintainer: Shyam Sundar <g.shyamsundar@yahoo.co.in>
 	 */
 	{
 		/* Xserve RAID */
@@ -342,8 +340,7 @@ static struct hwentry default_hw[] = {
 		/*
 		 * SC Series, formerly Compellent
 		 *
-		 * Maintainer : Sean McGinnis
-		 * Mail : sean_mcginnis@dell.com
+		 * Maintainer: Sean McGinnis <sean_mcginnis@dell.com>
 		 */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
@@ -406,8 +403,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Hitachi Vantara
 	 *
-	 * Maintainer : Matthias Rudolph
-	 * Mail : Matthias.Rudolph@hitachivantara.com
+	 * Maintainer: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
 	 */
 	{
 		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families / HP XP */
@@ -433,8 +429,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * IBM
 	 *
-	 * Maintainer : Hannes Reinecke
-	 * Mail : hare@suse.de
+	 * Maintainer: Hannes Reinecke <hare@suse.de>
 	 */
 	{
 		/* ProFibre 4000R */
@@ -681,8 +676,7 @@ static struct hwentry default_hw[] = {
 		/*
 		 * IBM Power Virtual SCSI Devices
 		 *
-		 * Maintainer : Brian King
-		 * Mail : brking@linux.vnet.ibm.com
+		 * Maintainer: Brian King <brking@linux.vnet.ibm.com>
 		 */
 	{
 		/* AIX VDASD */
@@ -714,8 +708,7 @@ static struct hwentry default_hw[] = {
 		/*
 		 * ONTAP family
 		 *
-		 * Maintainer : Martin George
-		 * Mail : marting@netapp.com
+		 * Maintainer: Martin George <marting@netapp.com>
 		 */
 		.vendor        = "NETAPP",
 		.product       = "LUN",
@@ -731,8 +724,7 @@ static struct hwentry default_hw[] = {
 		/*
 		 * SANtricity(RDAC) family
 		 *
-		 * Maintainer : NetApp RDAC team
-		 * Mail : ng-eseries-upstream-maintainers@netapp.com
+		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
 		 */
 		.vendor        = "(NETAPP|LSI|ENGENIO)",
 		.product       = "INF-01-00",
@@ -749,8 +741,7 @@ static struct hwentry default_hw[] = {
 		/*
 		 * SolidFir family
 		 *
-		 * Maintainer : PJ Waskiewicz
-		 * Mail : pj.waskiewicz@netapp.com
+		 * Maintainer: PJ Waskiewicz <pj.waskiewicz@netapp.com>
 		 */
 		.vendor        = "SolidFir",
 		.product       = "SSD SAN",
@@ -771,8 +762,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Nexenta
 	 *
-	 * Maintainer : Yacine Kheddache
-	 * Mail : yacine@alyseo.com
+	 * Maintainer: Yacine Kheddache <yacine@alyseo.com>
 	 */
 	{
 		/* COMSTAR */
@@ -799,8 +789,7 @@ static struct hwentry default_hw[] = {
 		/*
 		 * Pillar Data / Oracle FS
 		 *
-		 * Maintainer : Srinivasan Ramani
-		 * Mail : srinivas.ramani@oracle.com
+		 * Maintainer: Srinivasan Ramani <srinivas.ramani@oracle.com>
 		 */
 	{
 		/* Axiom */
@@ -941,8 +930,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Pivot3
 	 *
-	 * Maintainer : Bart Brooks
-	 * Mail : bartb@pivot3.com
+	 * Maintainer: Bart Brooks <bartb@pivot3.com>
 	 */
 	{
 		/* Raige */
@@ -1039,8 +1027,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Infinidat
 	 *
-	 * Maintainer: Arnon Yaari
-	 * Mail: arnony@infinidat.com
+	 * Maintainer: Arnon Yaari <arnony@infinidat.com>
 	 */
 	{
 		/* InfiniBox */
-- 
2.17.1
