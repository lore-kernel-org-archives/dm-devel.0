From: zkabelac@sourceware.org
Subject: dmraid/man Makefile.in
Date: 30 May 2010 17:11:31 -0000
Message-ID: <20100530171131.24491.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 17:11:30

Modified files:
	man            : Makefile.in 

Log message:
	Simplify, keep all executed commands visible

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/Makefile.in.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/man/Makefile.in	2010/05/28 08:40:52	1.4
+++ dmraid/man/Makefile.in	2010/05/30 17:11:30	1.5
@@ -14,20 +14,13 @@
 
 include $(top_builddir)/make.tmpl
 
-.PHONY: install_dmraid_man remove_dmraid_man
+.PHONY: install_dmraid_man8
 
-%_install: %.8
-	$(INSTALL_DATA) -D $< $(DESTDIR)$(MAN8DIR)/$(<F)
+install_dmraid_man8: $(MAN8)
+	$(INSTALL_DIR) $(DESTDIR)$(MAN8DIR)
+	$(INSTALL_DATA) $? $(DESTDIR)$(MAN8DIR)
 
-install_dmraid_man: $(MAN8:.8=_install)
+install: install_dmraid_man8
 
-install: install_dmraid_man
-
-remove_dmraid_man:
-	@echo "Removing $(MAN8) in $(DESTDIR)$(MAN8DIR)"; \
-	for f in $(MAN8); \
-	do \
-	   $(RM) $(DESTDIR)$(MAN8DIR)/$$f; \
-	done
-
-remove: remove_dmraid_man
+remove:
+	$(RM) $(addprefix $(DESTDIR)$(MAN8DIR)/,$(MAN8))
