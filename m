From: Anton Blanchard <anton@samba.org>
Subject: Vendor/product comparisons are too broad
Date: Wed, 9 Nov 2011 14:34:04 +1100
Message-ID: <20111109143404.47ada651@kryten>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: hare@suse.de, christophe.varoqui@opensvc.com, Brian King <bjking1@us.ibm.com>, Haren Myneni <hbabu@us.ibm.com>, Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi,

We have a POWER machine with a broken multipath setup. Analysis shows
that the RDAC driver is being used even though it shouldn't.

The vendor/product is:

IBM,IPR-0   65C61818

There is an entry for this device:

                /* IBM IPR */
                .vendor        = "IBM",
                .product       = "IPR.*",

Unfortunately it looks like a previous entry is matching against this
(since we do a regex match):

            /* IBM DS5000 */
                .vendor        = "IBM",
                .product       = "1818",

There are a number of IBM entries that have this issue. The following
patch ensures we match against the entire product ID.

Anton

--- libmultipath/hwtable.c~	2011-11-09 13:49:13.525044347 +1100
+++ libmultipath/hwtable.c	2011-11-09 14:32:39.347777922 +1100
@@ -415,7 +415,7 @@
 	{
 		/* IBM FAStT 1722-600 */
 		.vendor        = "IBM",
-		.product       = "1722-600",
+		.product       = "^1722-600",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
@@ -432,7 +432,7 @@
 	{
 		/* IBM DS4100 */
 		.vendor        = "IBM",
-		.product       = "1724",
+		.product       = "^1724",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
@@ -449,7 +449,7 @@
 	{
 		/* IBM DS3200 / DS3300 / DS3400 */
 		.vendor        = "IBM",
-		.product       = "1726",
+		.product       = "^1726",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
@@ -466,7 +466,7 @@
 	{
 		/* IBM DS4400 / DS4500 / FAStT700 */
 		.vendor        = "IBM",
-		.product       = "1742",
+		.product       = "^1742",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
@@ -482,7 +482,7 @@
 	},
 	{
 		.vendor        = "IBM",
-		.product       = "1745|1746",
+		.product       = "^1745|^1746",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
@@ -499,7 +499,7 @@
 	{
 	    /* IBM DS4700 */
 		.vendor        = "IBM",
-		.product       = "1814",
+		.product       = "^1814",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
@@ -516,7 +516,7 @@
 	{
 	    /* IBM DS4800 */
 		.vendor        = "IBM",
-		.product       = "1815",
+		.product       = "^1815",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
@@ -533,7 +533,7 @@
 	{
 	    /* IBM DS5000 */
 		.vendor        = "IBM",
-		.product       = "1818",
+		.product       = "^1818",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
@@ -550,7 +550,7 @@
 	{
 		/* IBM Netfinity Fibre Channel RAID Controller Unit */
 		.vendor        = "IBM",
-		.product       = "3526",
+		.product       = "^3526",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
@@ -567,7 +567,7 @@
 	{
 		/* IBM DS4200 / FAStT200 */
 		.vendor        = "IBM",
-		.product       = "3542",
+		.product       = "^3542",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -584,7 +584,7 @@
 	{
 		/* IBM ESS F20 aka Shark */
 		.vendor        = "IBM",
-		.product       = "2105800",
+		.product       = "^2105800",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -601,7 +601,7 @@
 	{
 		/* IBM ESS F20 aka Shark */
 		.vendor        = "IBM",
-		.product       = "2105F20",
+		.product       = "^2105F20",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -618,7 +618,7 @@
 	{
 		/* IBM DS6000 */
 		.vendor        = "IBM",
-		.product       = "1750500",
+		.product       = "^1750500",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -635,7 +635,7 @@
 	{
 		/* IBM DS8000 */
 		.vendor        = "IBM",
-		.product       = "2107900",
+		.product       = "^2107900",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -652,7 +652,7 @@
 	{
 		/* IBM SAN Volume Controller */
 		.vendor        = "IBM",
-		.product       = "2145",
+		.product       = "^2145",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -705,7 +705,7 @@
 	{
 		/* IBM IPR */
 		.vendor        = "IBM",
-		.product       = "IPR.*",
+		.product       = "^IPR.*",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 alua",
