From: zkabelac@sourceware.org
Subject: dmraid/include Makefile.in
Date: 27 May 2010 19:45:08 -0000
Message-ID: <20100527194508.19351.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-27 19:45:08

Modified files:
	include        : Makefile.in 

Log message:
	Use top_builddir
	Use new INSTALL commands
	Remove dmraid dir for remove target

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/Makefile.in.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/include/Makefile.in	2010/03/16 16:02:16	1.2
+++ dmraid/include/Makefile.in	2010/05/27 19:45:07	1.3
@@ -1,31 +1,31 @@
 #
-# Copyright (C) 2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+# Copyright (C) 2005-2010  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
 
 srcdir = @srcdir@
 top_srcdir = @top_srcdir@
+top_builddir = @top_builddir@
 
 HEADERS=$(wildcard dmraid/*.h)
 
 all:
 
-include $(top_srcdir)/make.tmpl
+include $(top_builddir)/make.tmpl
 
 .PHONY: install_dmraid_headers remove_dmraid_headers
 
 install_dmraid_headers: $(HEADERS)
-	@echo "Installing $(HEADERS) in $(DESTDIR)$(includedir)/dmraid"
-	mkdir -p $(DESTDIR)$(includedir)/dmraid
-	$(INSTALL) $(STRIP) $(HEADERS) $(DESTDIR)$(includedir)/dmraid
+	$(INSTALL_DIR) $(DESTDIR)$(includedir)/dmraid
+	$(INSTALL_DATA) $(HEADERS) $(DESTDIR)$(includedir)/dmraid
 
 install: install_dmraid_headers
 
 remove_dmraid_headers:
-	@echo "Removing $(HEADERS) from $(DESTDIR)$(includedir)/dmraid"
-	rm -f $(DESTDIR)$(includedir)/dmraid
+	@echo "Removing $(DESTDIR)$(includedir)/dmraid"
+	$(RM) -r $(DESTDIR)$(includedir)/dmraid
 
-remove:        remove_dmraid_headers
+remove: remove_dmraid_headers
 
 clean:
