From: Raghavendra Shenoy <shenoy@netapp.com>
Subject: PATCH - change netapp maintainer in hwtable.c
Date: Thu, 31 Aug 2006 00:07:01 +0530
Message-ID: <44F5DACD.9010603@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Raghavendra Shenoy <shenoy@netapp.com>
Acked-by: David Wysochanski <davidw@netapp.com>
Index: multipath-tools/libmultipath/hwtable.c
===================================================================
--- multipath-tools.orig/libmultipath/hwtable.c
+++ multipath-tools/libmultipath/hwtable.c
@@ -339,8 +339,8 @@ static struct hwentry default_hw[] = {
      /*
       * NETAPP controller family
       *
-        * Maintainer : Dave Wysochanski
-        * Mail : davidw@netapp.com
+        * Maintainer : Raghavendra Shenoy
+        * Mail : shenoy@netapp.com
       */
      {                      .vendor        = "NETAPP",
@@ -360,8 +360,8 @@ static struct hwentry default_hw[] = {
      /*
       * IBM NSeries (NETAPP) controller family
       *
-        * Maintainer : Dave Wysochanski
-        * Mail : davidw@netapp.com
+        * Maintainer : Raghavendra Shenoy
+        * Mail : shenoy@netapp.com
       */
      {                      .vendor        = "IBM",
