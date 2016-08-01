From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: update comments for ibm devices
	at hwtable
Date: Mon,  1 Aug 2016 22:28:47 +0200
Message-ID: <1470083327-4280-1-git-send-email-xose.vazquez@gmail.com>
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

Identify devices and remove redundant label.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 81ed437..baf2892 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -316,7 +316,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM FAStT 1722-600 */
+		/* DS4300 / FAStT600 */
 		.vendor        = "IBM",
 		.product       = "^1722-600",
 		.bl_product    = "Universal Xport",
@@ -329,7 +329,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4100 */
+		/* DS4100 / FAStT100 */
 		.vendor        = "IBM",
 		.product       = "^1724",
 		.bl_product    = "Universal Xport",
@@ -342,7 +342,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS3200 / DS3300 / DS3400 */
+		/* DS3200 / DS3300 / DS3400 / Boot DS */
 		.vendor        = "IBM",
 		.product       = "^1726",
 		.bl_product    = "Universal Xport",
@@ -355,7 +355,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4400 / DS4500 / FAStT700 */
+		/* DS4400 / DS4500 / FAStT700 / FAStT900 */
 		.vendor        = "IBM",
 		.product       = "^1742",
 		.bl_product    = "Universal Xport",
@@ -367,6 +367,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
+		/* DS3500 / DS3512 / DS3524 */
 		.vendor        = "IBM",
 		.product       = "^(1745|1746)",
 		.bl_product    = "Universal Xport",
@@ -379,7 +380,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4700 */
+		/* DS3950 / DS4200 / DS4700 / DS5020 */
 		.vendor        = "IBM",
 		.product       = "^1814",
 		.bl_product    = "Universal Xport",
@@ -391,7 +392,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4800 */
+		/* DS4800 */
 		.vendor        = "IBM",
 		.product       = "^1815",
 		.bl_product    = "Universal Xport",
@@ -403,7 +404,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS5000 */
+		/* DS5000 / DS5100 / DS5300 / DCS3700 */
 		.vendor        = "IBM",
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
@@ -415,7 +416,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM Netfinity Fibre Channel RAID Controller Unit */
+		/* Netfinity Fibre Channel RAID Controller Unit */
 		.vendor        = "IBM",
 		.product       = "^3526",
 		.bl_product    = "Universal Xport",
@@ -427,14 +428,14 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4200 / FAStT200 */
+		/* DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "^3542",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM ESS F20 aka Shark */
+		/* Enterprise Storage Server / Shark 800 */
 		.vendor        = "IBM",
 		.product       = "^2105800",
 		.features      = "1 queue_if_no_path",
@@ -442,7 +443,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM ESS F20 aka Shark */
+		/* Enterprise Storage Server / Shark F20 */
 		.vendor        = "IBM",
 		.product       = "^2105F20",
 		.features      = "1 queue_if_no_path",
@@ -450,7 +451,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM DS6000 */
+		/* DS6000 */
 		.vendor        = "IBM",
 		.product       = "^1750500",
 		.features      = "1 queue_if_no_path",
@@ -459,7 +460,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM DS8000 */
+		/* DS8000 */
 		.vendor        = "IBM",
 		.product       = "^2107900",
 		.features      = "1 queue_if_no_path",
@@ -467,7 +468,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM SAN Volume Controller */
+		/* SAN Volume Controller / Storwize */
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.features      = "1 queue_if_no_path",
@@ -476,7 +477,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM S/390 ECKD DASD */
+		/* S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
 		.bl_product    = "S/390.*",
@@ -486,7 +487,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM S/390 FBA DASD */
+		/* S/390 FBA DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
 		.bl_product    = "S/390.*",
@@ -496,7 +497,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM IPR */
+		/* Power RAID */
 		.vendor        = "IBM",
 		.product       = "^IPR.*",
 		.features      = "1 queue_if_no_path",
@@ -506,7 +507,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM RSSM */
+		/* SAS RAID Controller Module (RSSM) */
 		.vendor        = "IBM",
 		.product       = "1820N00",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -516,7 +517,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM XIV Storage System */
+		/* XIV Storage System */
 		.vendor        = "IBM",
 		.product       = "2810XIV",
 		.features      = "1 queue_if_no_path",
@@ -539,7 +540,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
-		/* IBM 3303 NVDISK */
+		/* 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
 		.pgfailback    = FAILBACK_UNDEF,
-- 
2.7.4
