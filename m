From: zkabelac@sourceware.org
Subject: dmraid/tools relpath.awk
Date: 28 May 2010 12:32:48 -0000
Message-ID: <20100528123248.16659.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 12:32:48

Added files:
	tools          : relpath.awk 

Log message:
	Reused relpath.awk script for relative paths from lvm2

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/relpath.awk.diff?cvsroot=dm&r1=NONE&r2=1.1

/cvs/dm/dmraid/tools/relpath.awk,v  -->  standard output
revision 1.1
--- dmraid/tools/relpath.awk
+++ -	2010-05-28 12:32:48.876050000 +0000
@@ -0,0 +1,40 @@
+#!/usr/bin/awk -f
+#
+# Copyright (C) 2010 Red Hat, Inc. All rights reserved.
+#
+# This file is part of LVM2.
+#
+# This copyrighted material is made available to anyone wishing to use,
+# modify, copy, or redistribute it subject to the terms and conditions
+# of the GNU General Public License v.2.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software Foundation,
+# Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+# relpath.awk: Script is used to calculate relative path
+#	       between two real absolute paths.
+#
+# echo /a/b/c/d  /a/b/e/f | relpath.awk
+# -> ../../e/f/
+
+{
+	length_from = split($1, from, "/");
+	length_to = split($2, to, "/") ;
+	l = 1;
+	while (l <= length_from && l <= length_to && from[l] == to[l])
+		l++;
+	for (i = l; i <= length_from && length(from[i]); i++) {
+		if (i > l)
+			p = sprintf("%s/", p);
+		p = sprintf("%s..", p);
+	}
+	for (i = l; i <= length_to && length(to[i]); i++) {
+		if (length(p) > 0)
+			p = sprintf("%s/", p);
+		p = sprintf("%s%s", p, to[i]);
+	}
+	if (length(p))
+		p = sprintf("%s/", p);
+	print p
+}
