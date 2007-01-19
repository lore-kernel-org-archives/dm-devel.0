From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW ./configure ./config ...
Date: 19 Jan 2007 15:53:02 -0000
Message-ID: <20070119155302.27598.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-19 15:53:01

Modified files:
	.              : WHATS_NEW configure configure.in 
	include        : configure.h.in 
Added files:
	lib            : libdm-common.h 
Removed files:
	lib            : libdm-common.h.in 

Log message:
	Add DM_LIB_VERSION definition to configure.h.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.153&r2=1.154
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.40&r2=1.41
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.42&r2=1.43
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/configure.h.in.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.h.in.diff?cvsroot=dm&r1=1.13&r2=NONE

--- device-mapper/WHATS_NEW	2007/01/18 22:15:04	1.153
+++ device-mapper/WHATS_NEW	2007/01/19 15:53:00	1.154
@@ -1,5 +1,6 @@
 Version 1.02.16 -
 ===================================
+  Add DM_LIB_VERSION definition to configure.h.
   Suppress 'Unrecognised field' error if report field is 'help'.
   Add --separator and --sort to dmsetup (unused).
   Make alignment flag optional when specifying report fields.
--- device-mapper/configure	2007/01/15 19:06:59	1.40
+++ device-mapper/configure	2007/01/19 15:53:00	1.41
@@ -6038,6 +6038,11 @@
 fi
 
 
+cat >>confdefs.h <<_ACEOF
+#define DM_LIB_VERSION $DM_LIB_VERSION
+_ACEOF
+
+
 ################################################################################
 
 
@@ -6115,7 +6120,7 @@
 
 
 ################################################################################
-                                                                                                                        ac_config_files="$ac_config_files Makefile make.tmpl include/Makefile dmsetup/Makefile lib/Makefile lib/libdevmapper.pc lib/libdm-common.h dmeventd/Makefile dmeventd/libdevmapper-event.pc kernel/Makefile man/Makefile po/Makefile"
+                                                                                                              ac_config_files="$ac_config_files Makefile make.tmpl include/Makefile dmsetup/Makefile lib/Makefile lib/libdevmapper.pc dmeventd/Makefile dmeventd/libdevmapper-event.pc kernel/Makefile man/Makefile po/Makefile"
 cat >confcache <<\_ACEOF
 # This file is a shell script that caches the results of configure
 # tests run on this system so they can be shared between configure
@@ -6647,7 +6652,6 @@
   "dmsetup/Makefile" ) CONFIG_FILES="$CONFIG_FILES dmsetup/Makefile" ;;
   "lib/Makefile" ) CONFIG_FILES="$CONFIG_FILES lib/Makefile" ;;
   "lib/libdevmapper.pc" ) CONFIG_FILES="$CONFIG_FILES lib/libdevmapper.pc" ;;
-  "lib/libdm-common.h" ) CONFIG_FILES="$CONFIG_FILES lib/libdm-common.h" ;;
   "dmeventd/Makefile" ) CONFIG_FILES="$CONFIG_FILES dmeventd/Makefile" ;;
   "dmeventd/libdevmapper-event.pc" ) CONFIG_FILES="$CONFIG_FILES dmeventd/libdevmapper-event.pc" ;;
   "kernel/Makefile" ) CONFIG_FILES="$CONFIG_FILES kernel/Makefile" ;;
--- device-mapper/configure.in	2007/01/15 19:06:59	1.42
+++ device-mapper/configure.in	2007/01/19 15:53:01	1.43
@@ -357,6 +357,7 @@
   DM_LIB_VERSION="Unknown version ($interface)"
 fi
 
+AC_DEFINE_UNQUOTED(DM_LIB_VERSION, $DM_LIB_VERSION, [Library version])
 
 ################################################################################
 dnl -- dmeventd pidfile and executable path
@@ -423,7 +424,6 @@
 dmsetup/Makefile							\
 lib/Makefile							 	\
 lib/libdevmapper.pc							\
-lib/libdm-common.h						 	\
 dmeventd/Makefile						 	\
 dmeventd/libdevmapper-event.pc						\
 kernel/Makefile								\
--- device-mapper/include/configure.h.in	2007/01/15 19:06:59	1.4
+++ device-mapper/include/configure.h.in	2007/01/19 15:53:01	1.5
@@ -9,6 +9,9 @@
 /* Path to dmeventd pidfile. */
 #undef DMEVENTD_PIDFILE
 
+/* Library version */
+#undef DM_LIB_VERSION
+
 /* Define to 1 if canonicalize_file_name is available. */
 #undef HAVE_CANONICALIZE_FILE_NAME
 
@@ -174,11 +177,9 @@
 /* Define to empty if `const' does not conform to ANSI C. */
 #undef const
 
-/* Define to `__inline__' or `__inline' if that's what the C compiler
-   calls it, or to nothing if 'inline' is not supported under any name.  */
-#ifndef __cplusplus
+/* Define as `__inline' if that's what the C compiler calls it, or to nothing
+   if it is not supported. */
 #undef inline
-#endif
 
 /* Define to rpl_malloc if the replacement function should be used. */
 #undef malloc
--- device-mapper/lib/libdm-common.h	2002/01/17 14:13:25	1.2
+++ device-mapper/lib/libdm-common.h	2007/01/19 15:53:01	1.3
@@ -1,16 +1,31 @@
 /*
- * Copyright (C) 2001 Sistina Software (UK) Limited.
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
+ * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
  *
- * This file is released under the LGPL.
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU Lesser General Public License v.2.1.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-extern dm_log_fn _log;
-#define log(msg, x...) _log(1, __FILE__, __LINE__, msg, ## x)
+#ifndef LIB_DMCOMMON_H
+#define LIB_DMCOMMON_H
+
+#include "libdevmapper.h"
 
-extern struct target *create_target(uint64_t start,
-                                     uint64_t len,
-                                     const char *type, const char *params);
+struct target *create_target(uint64_t start,
+			     uint64_t len,
+			     const char *type, const char *params);
 
-int add_dev_node(const char *dev_name, dev_t dev);
+int add_dev_node(const char *dev_name, uint32_t minor, uint32_t major,
+		 uid_t uid, gid_t gid, mode_t mode);
 int rm_dev_node(const char *dev_name);
+int rename_dev_node(const char *old_name, const char *new_name);
+void update_devs(void);
 
+#endif
