From: zkabelac@sourceware.org
Subject: dmraid Makefile.in
Date: 13 Jul 2010 20:23:34 -0000
Message-ID: <20100713202334.25145.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:23:33

Modified files:
	.              : Makefile.in 

Log message:
	Add make tags  target

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/Makefile.in.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/Makefile.in	2010/07/13 19:09:04	1.3
+++ dmraid/Makefile.in	2010/07/13 20:23:33	1.4
@@ -10,7 +10,7 @@
 SUBDIRS = include lib man tools
 
 DISTCLEAN_TARGETS = autom4te.cache make.tmpl core cscope.out \
- config.cache config.log config.status
+ config.cache config.log config.status tags
 
 all: tools
 
@@ -23,3 +23,12 @@
 
 srpm:
 	rpmbuild -bs dmraid.spec
+
+ifneq ($(shell which ctags),)
+.PHONY: tags
+all: tags
+tags:
+	$(RM) -f tags
+	find $(top_srcdir) -type f \( -name '*.c' -o -name '*.h' \) | xargs ctags -a
+endif
+
