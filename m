From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: identify devices at hwtable
Date: Tue,  2 Aug 2016 18:57:14 +0200
Message-ID: <1470157034-4599-1-git-send-email-xose.vazquez@gmail.com>
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

And also correct some of them.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6f7270b..fbbe9e0 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -68,7 +68,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 	},
 	{
-		/* MSA 1000/MSA1500 EVA 3000/5000 with old firmware */
+		/* MSA 1000/1500 and EVA 3000/5000, with old firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "(MSA|HSV)1.0.*",
 		.features      = "1 queue_if_no_path",
@@ -174,6 +174,7 @@ static struct hwentry default_hw[] = {
 	 * Mail : egoggin@emc.com
 	 */
 	{
+		/* Symmetrix / DMX / VMAX */
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
 		.pgpolicy      = MULTIBUS,
@@ -194,6 +195,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_EMC,
 	},
 	{
+		/* Invista / VPLEX */
 		.vendor        = "EMC",
 		.product       = "Invista",
 		.bl_product    = "LUNZ",
@@ -290,11 +292,13 @@ static struct hwentry default_hw[] = {
 	 * Mail : matthias.rudolph@hds.com
 	 */
 	{
+		/* USP-V, HUS VM, VSP, VSP G1000 and VSP GX00 families */
 		.vendor        = "(HITACHI|HP)",
 		.product       = "OPEN-.*",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
+		/* AMS 2000 and HUS 100 families */
 	{
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
@@ -578,7 +582,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/*
-		 * RDAC family
+		 * SANtricity(RDAC) family
 		 *
 		 * Maintainer : Sean Stewart
 		 * Mail : sean.stewart@netapp.com
@@ -630,7 +634,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* InfiniteStorage */
+		/* InfiniteStorage ??? */
 		.vendor        = "SGI",
 		.product       = "IS.*",
 		.bl_product    = "Universal Xport",
@@ -722,7 +726,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* 2510 / 2540 / 2530 / 2540 */
+		/* 2510 / 2530 / 2540 */
 		.vendor        = "SUN",
 		.product       = "LCSM100_[IEFS]",
 		.bl_product    = "Universal Xport",
-- 
2.7.4
