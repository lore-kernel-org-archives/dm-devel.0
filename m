From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath devmapper.h
Date: 26 Aug 2008 22:25:08 -0000
Message-ID: <20080826222508.31307.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-08-26 22:25:07

Modified files:
	libmultipath   : devmapper.h 

Log message:
	Removed a warning caused by the file attributes commit.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.3&r2=1.11.2.4

--- multipath-tools/libmultipath/devmapper.h	2008/08/25 20:59:06	1.11.2.3
+++ multipath-tools/libmultipath/devmapper.h	2008/08/26 22:25:07	1.11.2.4
@@ -1,3 +1,7 @@
+#ifndef _DEVMAPPER_H
+#define _DEVMAPPER_H
+#include "structs.h"
+
 void dm_init(void);
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
@@ -24,3 +28,5 @@
 int dm_get_info (char * mapname, struct dm_info ** dmi);
 int dm_rename (char * old, char * new);
 int dm_get_name(char * uuid, char * type, char * name);
+
+#endif /* _DEVMAPPER_H */
