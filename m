From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW include/intl.h inclu ...
Date: 27 Apr 2007 19:07:44 -0000
Message-ID: <20070427190744.1183.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-04-27 20:07:43

Modified files:
	.              : WHATS_NEW 
	include        : intl.h kdev_t.h lib.h list.h log.h 
	lib/datastruct : bitset.h hash.h 
	lib/mm         : dbg_malloc.h pool.h 

Log message:
	Standardise protective include file #defines.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.180&r2=1.181
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/intl.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/kdev_t.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/lib.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/list.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/log.h.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/bitset.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/datastruct/hash.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/dbg_malloc.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/pool.h.diff?cvsroot=dm&r1=1.1&r2=1.2

--- device-mapper/WHATS_NEW	2007/04/27 18:40:23	1.180
+++ device-mapper/WHATS_NEW	2007/04/27 19:07:42	1.181
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Standardise protective include file #defines.
   Add regex functions to library.
   Avoid trailing separator in reports when there are hidden sort fields.
   Fix segfault in 'dmsetup status' without --showkeys against crypt target.
--- device-mapper/include/intl.h	2005/01/06 18:22:43	1.1
+++ device-mapper/include/intl.h	2007/04/27 19:07:42	1.2
@@ -13,8 +13,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LVM_INTL_H
-#define _LVM_INTL_H
+#ifndef _DM_INTL_H
+#define _DM_INTL_H
 
 #ifdef INTL_PACKAGE
 #  include <libintl.h>
--- device-mapper/include/kdev_t.h	2004/07/01 15:14:28	1.1
+++ device-mapper/include/kdev_t.h	2007/04/27 19:07:43	1.2
@@ -12,8 +12,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LVM_KDEV_H
-#define _LVM_KDEV_H
+#ifndef _DM_KDEV_H
+#define _DM_KDEV_H
 
 #define MAJOR(dev)      ((dev & 0xfff00) >> 8)
 #define MINOR(dev)      ((dev & 0xff) | ((dev >> 12) & 0xfff00))
--- device-mapper/include/lib.h	2006/05/10 19:38:25	1.4
+++ device-mapper/include/lib.h	2007/04/27 19:07:43	1.5
@@ -16,8 +16,8 @@
 /*
  * This file must be included first by every library source file.
  */
-#ifndef _LVM_LIB_H
-#define _LVM_LIB_H
+#ifndef _DM_LIB_H
+#define _DM_LIB_H
 
 #define _REENTRANT
 #define _GNU_SOURCE
--- device-mapper/include/list.h	2005/09/22 12:06:35	1.4
+++ device-mapper/include/list.h	2007/04/27 19:07:43	1.5
@@ -13,8 +13,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LVM_LIST_H
-#define _LVM_LIST_H
+#ifndef _DM_LIST_H
+#define _DM_LIST_H
 
 #include <assert.h>
 #include <stdio.h>
--- device-mapper/include/log.h	2007/04/27 18:40:23	1.7
+++ device-mapper/include/log.h	2007/04/27 19:07:43	1.8
@@ -13,8 +13,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef LIB_DMLOG_H
-#define LIB_DMLOG_H
+#ifndef _DM_LOG_H
+#define _DM_LOG_H
 
 #include "libdevmapper.h"
 
--- device-mapper/lib/datastruct/bitset.h	2005/10/16 14:33:22	1.1
+++ device-mapper/lib/datastruct/bitset.h	2007/04/27 19:07:43	1.2
@@ -13,8 +13,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LVM_BITSET_H
-#define _LVM_BITSET_H
+#ifndef _DM_BITSET_H
+#define _DM_BITSET_H
 
 #include "pool.h"
 
--- device-mapper/lib/datastruct/hash.h	2005/10/16 14:33:22	1.1
+++ device-mapper/lib/datastruct/hash.h	2007/04/27 19:07:43	1.2
@@ -13,8 +13,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LVM_HASH_H
-#define _LVM_HASH_H
+#ifndef _DM_HASH_H
+#define _DM_HASH_H
 
 struct hash_table;
 struct hash_node;
--- device-mapper/lib/mm/dbg_malloc.h	2005/10/16 22:57:20	1.2
+++ device-mapper/lib/mm/dbg_malloc.h	2007/04/27 19:07:43	1.3
@@ -13,8 +13,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LVM_DBG_MALLOC_H
-#define _LVM_DBG_MALLOC_H
+#ifndef _DM_DBG_MALLOC_H
+#define _DM_DBG_MALLOC_H
 
 #include <stdlib.h>
 #include <string.h>
--- device-mapper/lib/mm/pool.h	2005/10/16 14:33:22	1.1
+++ device-mapper/lib/mm/pool.h	2007/04/27 19:07:43	1.2
@@ -13,8 +13,8 @@
  * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LVM_POOL_H
-#define _LVM_POOL_H
+#ifndef _DM_POOL_H
+#define _DM_POOL_H
 
 #include <string.h>
 #include <stdlib.h>
