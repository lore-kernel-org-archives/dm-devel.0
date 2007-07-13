From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath config.c
Date: 13 Jul 2007 18:30:24 -0000
Message-ID: <20070713183024.21423.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-07-13 18:30:24

Modified files:
	libmultipath   : config.c 

Log message:
	Pull in fix from upstream

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.1&r2=1.19.2.2

--- multipath-tools/libmultipath/config.c	2007/01/10 20:08:08	1.19.2.1
+++ multipath-tools/libmultipath/config.c	2007/07/13 18:30:24	1.19.2.2
@@ -58,9 +58,11 @@
 		if ((!hwe->vendor || !regexec(&vre, vendor, 0, NULL, 0)) &&
 		    (!hwe->product || !regexec(&pre, product, 0, NULL, 0)))
 			ret = hwe;
-		
-		regfree(&pre);
-		regfree(&vre);
+
+		if (hwe->product)
+			regfree(&pre);
+		if (hwe->vendor)
+			regfree(&vre);
 
 		if (ret)
 			break;
