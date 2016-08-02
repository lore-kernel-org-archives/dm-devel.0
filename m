From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH optional] multipath-tools: remove superfluous
	comments
Date: Tue,  2 Aug 2016 19:59:55 +0200
Message-ID: <1470160795-6450-1-git-send-email-xose.vazquez@gmail.com>
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

They are implicit in the attributes.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fbbe9e0..c67647c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -214,7 +214,6 @@ static struct hwentry default_hw[] = {
 	 * DELL
 	 */
 	{
-		/* Compellent family */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = MULTIBUS,
@@ -222,7 +221,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
-		/* MD3000 */
 		.vendor        = "DELL",
 		.product       = "MD3000",
 		.bl_product    = "Universal Xport",
@@ -235,7 +233,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* MD32xx/MD36xx */
 		.vendor        = "DELL",
 		.product       = "(MD32xx|MD36xx)",
 		.bl_product    = "Universal Xport",
@@ -248,7 +245,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* MD34xx/MD38xx */
 		.vendor        = "DELL",
 		.product       = "(MD34xx|MD38xx)",
 		.bl_product    = "Universal Xport",
@@ -481,7 +477,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
 		.bl_product    = "S/390.*",
@@ -491,7 +486,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* S/390 FBA DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
 		.bl_product    = "S/390.*",
@@ -536,7 +530,6 @@ static struct hwentry default_hw[] = {
 	 * Mail : brking@linux.vnet.ibm.com
 	 */
 	{
-		/* AIX VDASD */
 		.vendor        = "AIX",
 		.product       = "VDASD",
 		.pgpolicy      = MULTIBUS,
@@ -544,14 +537,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
-		/* 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
 		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
-		/* AIX NVDISK */
 		.vendor        = "AIX",
 		.product       = "NVDISK",
 		.hwhandler     = "1 alua",
@@ -674,7 +665,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
 	},
-		/* StorageTek */
 	{
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
@@ -696,7 +686,6 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-		/* SUN */
 	{
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
-- 
2.7.4
