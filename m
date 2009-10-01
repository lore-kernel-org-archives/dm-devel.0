From: bmarzins@sourceware.org
Subject: multipath-tools devmap_name/devmap_name.c kpar ...
Date: 1 Oct 2009 22:53:13 -0000
Message-ID: <20091001225313.17761.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-10-01 22:53:11

Modified files:
	devmap_name    : devmap_name.c 
	kpartx         : devmapper.c devmapper.h kpartx.c 

Log message:
	Fix for bz #526550.  Fix kpartx MAKEDEV macro so it can deal with more than 256
	minor numbers.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/devmap_name/devmap_name.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.8.2.1&r2=1.8.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9.2.2&r2=1.9.2.3

--- multipath-tools/devmap_name/devmap_name.c	2005/11/16 20:24:57	1.3
+++ multipath-tools/devmap_name/devmap_name.c	2009/10/01 22:53:10	1.3.4.1
@@ -6,7 +6,6 @@
 #include <string.h>
 #include <ctype.h>
 #include <unistd.h>
-#include <linux/kdev_t.h>
 #include <libdevmapper.h>
 
 static void usage(char * progname) {
--- multipath-tools/kpartx/devmapper.c	2008/08/25 20:59:06	1.8.2.1
+++ multipath-tools/kpartx/devmapper.c	2009/10/01 22:53:11	1.8.2.2
@@ -7,7 +7,6 @@
 #include <stdint.h>
 #include <libdevmapper.h>
 #include <ctype.h>
-#include <linux/kdev_t.h>
 #include <errno.h>
 #include "devmapper.h"
 
--- multipath-tools/kpartx/devmapper.h	2008/08/25 20:59:06	1.5.2.1
+++ multipath-tools/kpartx/devmapper.h	2009/10/01 22:53:11	1.5.2.2
@@ -1,5 +1,9 @@
 #include <stdint.h>
 
+#define MAJOR(dev)      ((dev & 0xfff00) >> 8)
+#define MINOR(dev)      ((dev & 0xff) | ((dev >> 12) & 0xfff00))
+#define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
+
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
--- multipath-tools/kpartx/kpartx.c	2008/08/26 03:50:28	1.9.2.2
+++ multipath-tools/kpartx/kpartx.c	2009/10/01 22:53:11	1.9.2.3
@@ -30,7 +30,6 @@
 #include <sys/types.h>
 #include <ctype.h>
 #include <libdevmapper.h>
-#include <linux/kdev_t.h>
 
 #include "devmapper.h"
 #include "crc32.h"
