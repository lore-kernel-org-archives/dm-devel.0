From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 18 Jun 2008 10:19:25 -0000
Message-ID: <20080618101925.31080.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2008-06-18 10:19:25

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	avoid compiler warning about cast in OFFSET_OF macro
	
	* dmsetup/dmsetup.c (OFFSET_OF): Use an equivalent definition
	that does not cast a pointer value to a narrower type.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.241&r2=1.242
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.108&r2=1.109

--- device-mapper/WHATS_NEW	2008/06/10 11:19:18	1.241
+++ device-mapper/WHATS_NEW	2008/06/18 10:19:25	1.242
@@ -1,5 +1,6 @@
 Version 1.02.27 -
 ===============================
+  Avoid compiler warning about cast in dmsetup.c's OFFSET_OF macro.
   Fix inverted no_flush debug message.
   Remove --enable-jobs from configure. (Set at runtime instead.)
   Bring configure.in and list.h into line with the lvm2 versions.
--- device-mapper/dmsetup/dmsetup.c	2008/06/06 18:53:08	1.108
+++ device-mapper/dmsetup/dmsetup.c	2008/06/18 10:19:25	1.109
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
  * Copyright (C) 2005-2007 NEC Corporation
  *
  * This file is part of the device-mapper userspace tools.
@@ -1927,7 +1927,7 @@
 };
 
 /* Column definitions */
-#define OFFSET_OF(strct, field) ((unsigned int) &((struct strct *)NULL)->field)
+#define OFFSET_OF(strct, field) (((char*)&((struct strct*)0)->field) - (char*)0)
 #define STR (DM_REPORT_FIELD_TYPE_STRING)
 #define NUM (DM_REPORT_FIELD_TYPE_NUMBER)
 #define FIELD_O(type, strct, sorttype, head, field, width, func, id, desc) {DR_ ## type, sorttype, OFFSET_OF(strct, field), width, id, head, &_ ## func ## _disp, desc},
