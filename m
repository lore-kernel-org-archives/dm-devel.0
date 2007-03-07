From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath structs.h
Date: 7 Mar 2007 19:01:21 -0000
Message-ID: <20070307190121.6601.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-03-07 19:01:17

Modified files:
	libmultipath   : structs.h 

Log message:
	change wwid size to 128 to allow for devices with large WWIDS. Fixes bz #149406

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.3&r2=1.17.2.4

--- multipath-tools/libmultipath/structs.h	2006/12/01 23:45:18	1.17.2.3
+++ multipath-tools/libmultipath/structs.h	2007/03/07 19:01:17	1.17.2.4
@@ -1,7 +1,7 @@
 #ifndef _STRUCTS_H
 #define _STRUCTS_H
 
-#define WWID_SIZE		64
+#define WWID_SIZE		128
 #define SERIAL_SIZE		64
 #define NODE_NAME_SIZE		19
 #define PATH_STR_SIZE  		16
