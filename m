From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/4] multipath-tools: replace queue_if_no_path
	with NO_PATH_RETRY_QUEUE
Date: Thu, 18 Aug 2016 19:58:13 +0200
Message-ID: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Besides man page states: "If both values are specified the order
of precedence is no_path_retry, queue_if_no_path, dev_loss_tmo."

Thus remove queue_if_no_path where no_path_retry already was defined.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 57be385..aa3ea9b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -55,7 +55,7 @@ static struct hwentry default_hw[] = {
 		/* RA8000 / ESA12000 */
 		.vendor        = "DEC",
 		.product       = "HSG80",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -74,7 +74,6 @@ static struct hwentry default_hw[] = {
 		/* MSA 1000/1500 and EVA 3000/5000, with old firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "(MSA|HSV)1[01]0",
-		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -178,7 +177,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "^DGC",
 		.product       = "^(RAID|DISK|VRAID)",
 		.bl_product    = "LUNZ",
-		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -265,7 +263,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "FUJITSU",
 		.product       = "ETERNUS_DX(H|L|M|400|8000)",
-		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 10,
@@ -295,7 +292,7 @@ static struct hwentry default_hw[] = {
 		/* AMS 2000 and HUS 100 families */
 		.vendor        = "HITACHI",
 		.product       = "^DF",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_HDS,
@@ -453,7 +450,7 @@ static struct hwentry default_hw[] = {
 		/* Enterprise Storage Server / Shark family */
 		.vendor        = "IBM",
 		.product       = "^2105",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
@@ -461,7 +458,7 @@ static struct hwentry default_hw[] = {
 		/* DS6000 */
 		.vendor        = "IBM",
 		.product       = "^1750500",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -470,7 +467,7 @@ static struct hwentry default_hw[] = {
 		/* DS8000 */
 		.vendor        = "IBM",
 		.product       = "^2107900",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
@@ -478,7 +475,7 @@ static struct hwentry default_hw[] = {
 		/* Storwize family / SAN Volume Controller / Flex System V7000 */
 		.vendor        = "IBM",
 		.product       = "^2145",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -488,7 +485,7 @@ static struct hwentry default_hw[] = {
 		.product       = "S/390 DASD ECKD",
 		.bl_product    = "S/390",
 		.uid_attribute = "ID_UID",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
@@ -497,7 +494,7 @@ static struct hwentry default_hw[] = {
 		.product       = "S/390 DASD FBA",
 		.bl_product    = "S/390",
 		.uid_attribute = "ID_UID",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
@@ -505,7 +502,7 @@ static struct hwentry default_hw[] = {
 		/* Power RAID */
 		.vendor        = "IBM",
 		.product       = "^IPR",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -524,7 +521,7 @@ static struct hwentry default_hw[] = {
 		/* XIV Storage System */
 		.vendor        = "IBM",
 		.product       = "2810XIV",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
@@ -569,7 +566,8 @@ static struct hwentry default_hw[] = {
 		 */
 		.vendor        = "NETAPP",
 		.product       = "LUN",
-		.features      = "3 queue_if_no_path pg_init_retries 50",
+		.features      = "2 pg_init_retries 50",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.flush_on_last_del = FLUSH_ENABLED,
@@ -603,7 +601,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "NEXENTA",
 		.product       = "COMSTAR",
-		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 30,
@@ -767,7 +764,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
-		.features      = "1 queue_if_no_path",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
-- 
2.7.4
