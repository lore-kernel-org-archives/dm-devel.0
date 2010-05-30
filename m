From: zkabelac@sourceware.org
Subject: dmraid Makefile.in
Date: 30 May 2010 17:36:20 -0000
Message-ID: <20100530173620.30371.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 17:36:18

Modified files:
	.              : Makefile.in 

Log message:
	Don't use tools/dmraid as target
	Force deps through all:
	Add DISTCLEAN_TARGETS definition

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/Makefile.in.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/Makefile.in	2008/02/22 16:50:38	1.1
+++ dmraid/Makefile.in	2010/05/30 17:36:18	1.2
@@ -1,16 +1,17 @@
 #
-# Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+# Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
 
 srcdir = @srcdir@
 top_srcdir = @top_srcdir@
-VPATH = @srcdir@
 
 SUBDIRS = include lib man tools
 
-TARGETS = tools/dmraid
+DISTCLEAN_TARGETS = make.tmpl core cscope.out config.cache config.log config.status
+
+all: tools
 
 include make.tmpl
 
