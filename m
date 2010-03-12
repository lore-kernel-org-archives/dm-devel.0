From: heinzm@sourceware.org
Subject: dmraid include/dmraid/misc.h lib/format/atarai ...
Date: 12 Mar 2010 11:33:03 -0000
Message-ID: <20100312113303.15183.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-03-12 11:33:02

Modified files:
	include/dmraid : misc.h 
	lib/format/ataraid: isw.c 
	lib/format/ddf : ddf1.c 
	lib/misc       : misc.c 

Log message:
	Avoid spaces (and other special characters) in isw and ddf RAID set names

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/misc.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/isw.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/misc/misc.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/include/dmraid/misc.h	2009/09/16 11:45:12	1.3
+++ dmraid/include/dmraid/misc.h	2010/03/12 11:33:01	1.4
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * Copyright (C) 2007   Intel Corporation. All rights reserved.
@@ -18,6 +18,7 @@
 
 extern void sysfs_workaround(struct lib_context *lc);
 extern void mk_alpha(struct lib_context *lc, char *str, size_t len);
+extern void mk_alphanum(struct lib_context *lc, char *str, size_t len);
 extern char *get_basename(struct lib_context *lc, char *str);
 extern char *get_dirname(struct lib_context *lc, char *str);
 extern char *remove_white_space(struct lib_context *lc, char *str, size_t len);
--- dmraid/lib/format/ataraid/isw.c	2009/09/16 11:45:14	1.6
+++ dmraid/lib/format/ataraid/isw.c	2010/03/12 11:33:01	1.7
@@ -1,7 +1,7 @@
 /*
  * Intel Software RAID metadata format handler.
  *
- * Copyright (C) 2004-2009  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * Copyright (C) 2007,2009  Intel Corporation. All rights reserved.
@@ -169,6 +169,7 @@
 _name(struct lib_context *lc, struct isw *isw, char *str, size_t len,
       enum name_type nt, int num, struct isw_dev *dev, struct raid_dev *rd)
 {
+	int n;
 	struct {
 		const char *fmt, *what;
 	} formats[] = {
@@ -189,7 +190,13 @@
 			f += (is_raid10(dev) ? 1 : 0);
 	}
 
-	return snprintf(str, len, f->fmt, isw->family_num, f->what, num);
+	n = snprintf(str, len, f->fmt, isw->family_num, f->what, num);
+
+	/* As '->volume' could contain anything, we sanitise the name. */
+	if (n > 0)
+		mk_alphanum(lc, str, n);
+
+	return n;
 }
 
 static char *
--- dmraid/lib/format/ddf/ddf1.c	2009/11/02 13:20:41	1.6
+++ dmraid/lib/format/ddf/ddf1.c	2010/03/12 11:33:01	1.7
@@ -4,7 +4,7 @@
  * Copyright (C) 2005-2006 IBM, All rights reserved.
  * Written by Darrick Wong <djwong@us.ibm.com>
  *
- * Copyright (C) 2006-2008 Heinz Mauelshagen, Red Hat GmbH
+ * Copyright (C) 2006-2010 Heinz Mauelshagen, Red Hat GmbH
  *                         All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
@@ -689,6 +689,9 @@
 		i = prefix + 16;
 		while (!isgraph(buf[--i]));
 		buf[i + 1] = 0;
+
+		/* As buf could contain anything, we sanitise the name. */
+		mk_alphanum(lc, buf, i);
 	} else {
 		char *b;
 
--- dmraid/lib/misc/misc.c	2009/09/16 11:45:17	1.3
+++ dmraid/lib/misc/misc.c	2010/03/12 11:33:02	1.4
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * Copyright (C) 2007   Intel Corporation. All rights reserved.
@@ -66,6 +66,21 @@
 	}
 }
 
+/*
+ * Convert a string to only have alphanum or '-' or '_'. [Neil Brown]
+ * All others become '_'
+ */
+void
+mk_alphanum(struct lib_context *lc, char *str, size_t len)
+{
+	for (; len && *str; len--, str++) {
+		if (!isalnum(*str) &&
+		    *str != '-' &&
+		    *str != '_')
+			*str = '_';
+	}
+}
+
 /* Remove any whitespace from a string. */
 char *
 remove_white_space(struct lib_context *lc, char *str, size_t size)
