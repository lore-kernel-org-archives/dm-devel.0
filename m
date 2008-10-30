From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW include/lib.h includ ...
Date: 30 Oct 2008 15:11:18 -0000
Message-ID: <20081030151118.13541.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-10-30 15:11:17

Modified files:
	.              : WHATS_NEW 
	include        : lib.h 
Added files:
	include        : lvm-types.h 

Log message:
	Use lvm-types.h

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.253&r2=1.254
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/lvm-types.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/lib.h.diff?cvsroot=dm&r1=1.6&r2=1.7

--- device-mapper/WHATS_NEW	2008/10/07 19:08:46	1.253
+++ device-mapper/WHATS_NEW	2008/10/30 15:11:16	1.254
@@ -1,5 +1,6 @@
 Version 1.02.29 -
 =====================================
+  Use lvm-types.h.
   Add usrsbindir to configure.
 
 Version 1.02.28 - 18th September 2008
/cvs/dm/device-mapper/include/lvm-types.h,v  -->  standard output
revision 1.1
--- device-mapper/include/lvm-types.h
+++ -	2008-10-30 15:11:18.394804000 +0000
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of LVM2.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU Lesser General Public License v.2.1.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _LVM_TYPES_H
+#define _LVM_TYPES_H
+
+#include "list.h"
+
+#include <sys/types.h>
+#include <inttypes.h>
+
+/* Define some portable printing types */
+#define PRIsize_t "zu"
+#define PRIptrdiff_t "td"
+#define PRIpid_t PRId32
+
+struct str_list {
+	struct list list;
+	const char *str;
+};
+
+#endif
--- device-mapper/include/lib.h	2007/08/21 16:26:06	1.6
+++ device-mapper/include/lib.h	2008/10/30 15:11:17	1.7
@@ -27,16 +27,13 @@
 
 #include "log.h"
 #include "intl.h"
+#include "lvm-types.h"
 
 #include <stdio.h>
 #include <stdlib.h>
 #include <errno.h>
 #include <string.h>
 #include <unistd.h>
-#include <sys/types.h>
 #include <sys/stat.h>
 
-/* Define some portable printing types */
-#define PRIsize_t "zu"
-
 #endif
