From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 05/10] multipath-tools: unreachable
	controllers maintainers
Date: Fri, 17 Jun 2016 16:52:43 +0200
Message-ID: <1466175169-16684-5-git-send-email-xose.vazquez@gmail.com>
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

Delete 3 unreachable controllers maintainers, their emails are bounced.

Compellent Technologies, Inc.: Jim Lester <jim.lester@compellent.com>
NETAPP controller family: Dave Wysochanski <davidw@netapp.com>
IBM NSeries (NETAPP) controller family: Dave Wysochanski <davidw@netapp.com>

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 46aa9cd..54d5320 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -19,9 +19,6 @@
 static struct hwentry default_hw[] = {
 	/*
 	 * Compellent Technologies, Inc.
-	 *
-	 * Maintainer : Jim Lester, Compellent
-	 * Mail : jim.lester@compellent.com
 	 */
 	{
 		.vendor        = "COMPELNT",
@@ -780,9 +777,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * NETAPP controller family
-	 *
-	 * Maintainer : Dave Wysochanski
-	 * Mail : davidw@netapp.com
 	 */
 	{
 		.vendor        = "NETAPP",
@@ -825,9 +819,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * IBM NSeries (NETAPP) controller family
-	 *
-	 * Maintainer : Dave Wysochanski
-	 * Mail : davidw@netapp.com
 	 */
 	{
 		.vendor        = "IBM",
-- 
2.5.5
