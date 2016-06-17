From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 04/10] multipath-tools: remove current maintainer
	from orphan array families.
Date: Fri, 17 Jun 2016 16:52:42 +0200
Message-ID: <1466175169-16684-4-git-send-email-xose.vazquez@gmail.com>
References: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
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

Redundant.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d882f31..46aa9cd 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -57,9 +57,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * StorageWorks controller family
-	 *
-	 * Maintainer : Christophe Varoqui
-	 * Mail : christophe.varoqui@opensvc.com
 	 */
 	{
 		.vendor        = "3PARdata",
@@ -238,9 +235,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * DDN controller family
-	 *
-	 * Maintainer : Christophe Varoqui
-	 * Mail : christophe.varoqui@opensvc.com
 	 */
 	{
 		.vendor        = "DDN",
@@ -319,9 +313,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * Fujitsu controller family
-	 *
-	 * Maintainer : Christophe Varoqui
-	 * Mail : christophe.varoqui@opensvc.com
 	 */
 	{
 		.vendor        = "FSC",
@@ -874,9 +865,6 @@ static struct hwentry default_hw[] = {
 
 	/*
 	 * SGI arrays
-	 *
-	 * Maintainer : Christophe Varoqui
-	 * Mail : christophe.varoqui@opensvc.com
 	 */
 	{
 		.vendor        = "SGI",
@@ -935,9 +923,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * STK arrays
-	 *
-	 * Maintainer : Christophe Varoqui
-	 * Mail : christophe.varoqui@opensvc.com
 	 */
 	{
 		.vendor        = "STK",
@@ -955,9 +940,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * SUN arrays
-	 *
-	 * Maintainer : Christophe Varoqui
-	 * Mail : christophe.varoqui@opensvc.com
 	 */
 	{
 		.vendor        = "SUN",
-- 
2.5.5
