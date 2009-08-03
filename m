From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/5] multipath-tools: uninstall libraries
	correctly
Date: Mon, 3 Aug 2009 17:01:33 -0500
Message-ID: <20090803220133.GT15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The unistall action for checker libraries doesn't work. Also, the uninstall
action for the prioritizer libraries runs the risk of uninstalling something
that we didn't install.  This patch changes them to correctly uninstall the
files listed in LIBS.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/Makefile     |    2 +-
 libmultipath/prioritizers/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: multipath-tools/libmultipath/checkers/Makefile
===================================================================
--- multipath-tools.orig/libmultipath/checkers/Makefile
+++ multipath-tools/libmultipath/checkers/Makefile
@@ -27,7 +27,7 @@ install:
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
 
 uninstall:
-	rm -f $(DESTDIR)$(libdir)/$(LIBS)
+	for file in $(LIBS); do rm -f $(DESTDIR)$(libdir)/$$file; done
 
 clean:
 	rm -f core *.a *.o *.gz *.so
Index: multipath-tools/libmultipath/prioritizers/Makefile
===================================================================
--- multipath-tools.orig/libmultipath/prioritizers/Makefile
+++ multipath-tools/libmultipath/prioritizers/Makefile
@@ -28,7 +28,7 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
 
 uninstall:
-	rm -f $(DESTDIR)$(libdir)/libprio*.so
+	for file in $(LIBS); do rm -f $(DESTDIR)$(libdir)/$$file; done
 
 clean:
 	rm -f core *.a *.o *.gz *.so
