From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix some comments in hwtable
Date: Thu,  4 Aug 2016 19:25:59 +0200
Message-ID: <1470331559-10560-1-git-send-email-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 79e9637..dacc9a3 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -49,7 +49,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 	},
 	{
-		/* RA8000/ESA12000 HSG80 */
+		/* RA8000 / ESA12000 */
 		.vendor        = "DEC",
 		.product       = "HSG80",
 		.features      = "1 queue_if_no_path",
@@ -168,9 +168,9 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
-	 * EMC/DELL
+	 * EMC
 	 *
-	 * Maintainer : Edward Goggin, EMC
+	 * Maintainer : Edward Goggin
 	 * Mail : egoggin@emc.com
 	 */
 	{
@@ -294,8 +294,8 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
-		/* AMS 2000 and HUS 100 families */
 	{
+		/* AMS 2000 and HUS 100 families */
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
 		.features      = "1 queue_if_no_path",
@@ -306,7 +306,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * IBM
 	 *
-	 * Maintainer : Hannes Reinecke, SuSE
+	 * Maintainer : Hannes Reinecke
 	 * Mail : hare@suse.de
 	 */
 	{
@@ -526,7 +526,7 @@ static struct hwentry default_hw[] = {
 		/*
 		 * IBM Power Virtual SCSI Devices
 		 *
-		 * Maintainer : Brian King, IBM
+		 * Maintainer : Brian King
 		 * Mail : brking@linux.vnet.ibm.com
 		 */
 	{
@@ -654,7 +654,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/*
-		 * Pillar Data / Oracle FS
+		 * Pillar Data
 		 *
 		 * Maintainer : Srinivasan Ramani
 		 * Mail : srinivas.ramani@oracle.com
@@ -740,7 +740,7 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Pivot3
 	 *
-	 * Maintainer : Bart Brooks, Pivot3
+	 * Maintainer : Bart Brooks
 	 * Mail : bartb@pivot3.com
 	 */
 	{
-- 
2.7.4
