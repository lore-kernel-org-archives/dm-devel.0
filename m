From: heinzm@sourceware.org
Subject: dmraid ./dmraid.spec tools/commands.c tools/co ...
Date: 12 Jan 2010 12:21:10 -0000
Message-ID: <20100112122110.2505.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-01-12 12:21:10

Modified files:
	.              : dmraid.spec 
	tools          : commands.c commands.h 

Log message:
	add changelog comment

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.h.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/dmraid.spec	2010/01/12 12:15:58	1.10
+++ dmraid/dmraid.spec	2010/01/12 12:21:09	1.11
@@ -142,6 +142,7 @@
 %changelog
 * Tue Jan 12 2010  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-3
 - Add logwatch files and move pattern file to /var/cache
+- Fix multiple options (eg. "-ccc") not recognized properly
 
 * Mon Nov 2 2009  Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-2
 - Fix manual path in specfile
--- dmraid/tools/commands.c	2010/01/12 12:15:59	1.5
+++ dmraid/tools/commands.c	2010/01/12 12:21:10	1.6
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004-2008  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * Copyright (C) 2007   Intel Corporation. All rights reserved.
--- dmraid/tools/commands.h	2010/01/12 12:15:59	1.4
+++ dmraid/tools/commands.h	2010/01/12 12:21:10	1.5
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
+ * Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH.
  *                          All rights reserved.
  *
  * Copyright (C) 2007   Intel Corporation. All rights reserved.
