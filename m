From: zkabelac@sourceware.org
Subject: dmraid/man Makefile.in
Date: 28 May 2010 08:40:53 -0000
Message-ID: <20100528084053.11661.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 08:40:52

Modified files:
	man            : Makefile.in 

Log message:
	Fix usage of top_builddir
	Install man pages properly from top_srcdir
	Use vpath instead of VPATH

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/Makefile.in.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/man/Makefile.in	2010/03/16 16:02:16	1.3
+++ dmraid/man/Makefile.in	2010/05/28 08:40:52	1.4
@@ -1,30 +1,27 @@
 #
-# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+# Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
 
 srcdir = @srcdir@
 top_srcdir = @top_srcdir@
-VPATH = @srcdir@
+top_builddir = @top_builddir@
+vpath %.8 $(srcdir)
 
 MAN8=dmraid.8 dmevent_tool.8
 MAN8DIR=${mandir}/man8
 
-include $(top_srcdir)/make.tmpl
+include $(top_builddir)/make.tmpl
 
-.PHONY:	install_dmraid_man remove_dmraid_man
+.PHONY: install_dmraid_man remove_dmraid_man
 
-install_dmraid_man:
-	@echo "Installing $(MAN8) in $(DESTDIR)$(MAN8DIR)"; \
-	mkdir -p $(DESTDIR)$(MAN8DIR); \
-	for f in $(MAN8); \
-	do \
-	   $(RM) $(DESTDIR)$(MAN8DIR)/$$f; \
-	   @INSTALL@ -D -m 444 $$f $(DESTDIR)$(MAN8DIR)/$$f; \
-	done
+%_install: %.8
+	$(INSTALL_DATA) -D $< $(DESTDIR)$(MAN8DIR)/$(<F)
+
+install_dmraid_man: $(MAN8:.8=_install)
 
-install:	install_dmraid_man
+install: install_dmraid_man
 
 remove_dmraid_man:
 	@echo "Removing $(MAN8) in $(DESTDIR)$(MAN8DIR)"; \
@@ -33,4 +30,4 @@
 	   $(RM) $(DESTDIR)$(MAN8DIR)/$$f; \
 	done
 
-remove:	remove_dmraid_man
+remove: remove_dmraid_man
