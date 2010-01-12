From: heinzm@sourceware.org
Subject: dmraid lib/version.h tools/VERSION
Date: 12 Jan 2010 12:23:26 -0000
Message-ID: <20100112122326.4037.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2010-01-12 12:23:26

Modified files:
	lib            : version.h 
	tools          : VERSION 

Log message:
	Adjust version strings

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=1.8&r2=1.9

--- dmraid/lib/version.h	2009/09/16 11:45:12	1.8
+++ dmraid/lib/version.h	2010/01/12 12:23:26	1.9
@@ -1,12 +1,12 @@
 #ifndef	DMRAID_LIB_VERSION
 
-#define	DMRAID_LIB_VERSION		"1.0.0.rc16"
+#define	DMRAID_LIB_VERSION		"1.0.0.rc16-3"
 
 #define	DMRAID_LIB_MAJOR_VERSION	1
 #define	DMRAID_LIB_MINOR_VERSION	0
 #define	DMRAID_LIB_SUBMINOR_VERSION	0
-#define	DMRAID_LIB_VERSION_SUFFIX	"rc16"
+#define	DMRAID_LIB_VERSION_SUFFIX	"rc16-3"
 
-#define	DMRAID_LIB_DATE			"(2009.09.16)"
+#define	DMRAID_LIB_DATE			"(2010.01.12)"
 
 #endif
--- dmraid/tools/VERSION	2009/09/16 11:45:18	1.8
+++ dmraid/tools/VERSION	2010/01/12 12:23:26	1.9
@@ -1 +1 @@
-1.0.0.rc16 (2009.09.16)
+1.0.0.rc16-3 (2010.01.12)
