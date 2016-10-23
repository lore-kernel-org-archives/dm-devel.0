From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: identify more arrays in hwtable
Date: Sun, 23 Oct 2016 23:51:02 +0200
Message-ID: <20161023215102.8890-1-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index de10ebf..d8e2c01 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -224,6 +224,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
+		/* MD Series */
 	{
 		.vendor        = "DELL",
 		.product       = "MD3000",
@@ -349,7 +350,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* DS3200 / DS3300 / DS3400 / Boot DS */
+		/* DS3000 / DS3200 / DS3300 / DS3400 / Boot DS */
 		.vendor        = "IBM",
 		.product       = "^1726",
 		.bl_product    = "Universal Xport",
@@ -473,7 +474,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* DS6000 */
+		/* DS6000 / DS6800 */
 		.vendor        = "IBM",
 		.product       = "^1750500",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -482,7 +483,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* DS8000 */
+		/* DS8000 family */
 		.vendor        = "IBM",
 		.product       = "^2107900",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -653,6 +654,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
+		/* Total Performance family */
 		.vendor        = "SGI",
 		.product       = "TP9[3457]00",
 		.bl_product    = "Universal Xport",
@@ -665,7 +667,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* InfiniteStorage ??? */
+		/* InfiniteStorage family */
 		.vendor        = "SGI",
 		.product       = "IS",
 		.bl_product    = "Universal Xport",
@@ -972,6 +974,7 @@ static struct hwentry default_hw[] = {
 	 * Xiotech
 	 */
 	{
+		/* Intelligent Storage Elements family */
 		.vendor        = "(XIOTECH|XIOtech)",
 		.product       = "ISE",
 		.pgpolicy      = MULTIBUS,
@@ -981,7 +984,7 @@ static struct hwentry default_hw[] = {
 	 * Violin Memory
 	 */
 	{
-		/* V3000 / V6000 Series */
+		/* 3000 / 6000 Series */
 		.vendor        = "VIOLIN",
 		.product       = "SAN ARRAY$",
 		.pgpolicy      = GROUP_BY_SERIAL,
-- 
2.10.1
