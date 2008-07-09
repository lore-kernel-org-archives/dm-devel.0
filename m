From: wysochanski@sourceware.org
Subject: multipath-tools/libmultipath print.c
Date: 9 Jul 2008 20:11:39 -0000
Message-ID: <20080709201139.24388.qmail@sourceware.org>
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
Changes by:	wysochanski@sourceware.org	2008-07-09 20:11:37

Modified files:
	libmultipath   : print.c 

Log message:
	Resolves rhbz#442000.  Fix whitespace in multipath -ll output.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/print.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2

--- multipath-tools/libmultipath/print.c	2007/01/10 20:08:08	1.5.2.1
+++ multipath-tools/libmultipath/print.c	2008/07/09 20:11:33	1.5.2.2
@@ -679,9 +679,9 @@
 	c += sprintf(c, "%%n");
 	
 	if (strncmp(mpp->alias, mpp->wwid, WWID_SIZE))
-		c += sprintf(c, " (%%w) ");
+		c += sprintf(c, " (%%w)");
 
-	c += sprintf(c, "%%d ");
+	c += sprintf(c, " %%d ");
 	c += snprint_vpr(c, 24, first_path(mpp));
 
 	fwd += snprint_multipath(buff + fwd, len - fwd, style, mpp);
