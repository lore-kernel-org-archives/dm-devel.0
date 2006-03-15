From: David Wysochanski <davidw@netapp.com>
Subject: PATCH - change netapp maintainer in hwtable.c
Date: Tue, 14 Mar 2006 19:15:05 -0500
Message-ID: <44175C89.5020707@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090500020906030600020701"
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

This is a multi-part message in MIME format.
--------------090500020906030600020701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------090500020906030600020701
Content-Type: text/x-patch;
 name="change-netapp-maintainer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="change-netapp-maintainer.patch"

--- multipath-tools-0.4.7/libmultipath/hwtable.c	2006-03-13 06:07:45.000000000 -0500
+++ multipath-tools-0.4.7/libmultipath/hwtable.c.new	2006-03-14 19:14:51.141547000 -0500
@@ -318,8 +318,8 @@ static struct hwentry default_hw[] = {
 	/*
 	 * NETAPP controler family
 	 *
-	 * Maintainer : Igor Feoktistov
-	 * Mail : igorf@netapp.com
+	 * Maintainer : Dave Wysochanski
+	 * Mail : davidw@netapp.com
 	 */
 	{
 		.vendor        = "NETAPP",

--------------090500020906030600020701
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090500020906030600020701--
