From: zkabelac@sourceware.org
Subject: dmraid/include Makefile.in
Date: 28 May 2010 08:44:59 -0000
Message-ID: <20100528084459.12477.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 08:44:58

Modified files:
	include        : Makefile.in 

Log message:
	Fix install from buildir - use srcdir for headers

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/Makefile.in.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/include/Makefile.in	2010/05/27 19:45:07	1.3
+++ dmraid/include/Makefile.in	2010/05/28 08:44:58	1.4
@@ -8,7 +8,7 @@
 top_srcdir = @top_srcdir@
 top_builddir = @top_builddir@
 
-HEADERS=$(wildcard dmraid/*.h)
+HEADERS=$(wildcard $(top_srcdir)/include/dmraid/*.h)
 
 all:
 
@@ -18,7 +18,7 @@
 
 install_dmraid_headers: $(HEADERS)
 	$(INSTALL_DIR) $(DESTDIR)$(includedir)/dmraid
-	$(INSTALL_DATA) $(HEADERS) $(DESTDIR)$(includedir)/dmraid
+	$(INSTALL_DATA) $(HEADERS) $(DESTDIR)$(includedir)/dmraid/
 
 install: install_dmraid_headers
 
