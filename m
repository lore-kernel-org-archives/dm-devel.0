From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: DESTDIR makefiles cleanup
Date: Wed, 11 Jun 2008 13:46:16 -0500
Message-ID: <20080611184616.GJ3117@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
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
To: dm-devel@redhat.com
Cc: cristophe.varoqui@free.fr
List-Id: dm-devel.ids


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch makes the $(DESTDIR) makefile option for multipath-tools more
useful. First, it makes sure that everything that's installed uses it.
Second, it removes the forced root installs, so that you can can install
to any $(DESTDIR) that you have permissions for, even if you aren't
root.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

---
Makefile              |    6 +++---
checkers/Makefile     |    4 ++--
prioritizers/Makefile |    4 ++--
3 files changed, 7 insertions(+), 7 deletions(-)


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="makefiles_fix.patch"

Index: multipath-tools-080519/libmultipath/Makefile
===================================================================
--- multipath-tools-080519.orig/libmultipath/Makefile
+++ multipath-tools-080519/libmultipath/Makefile
@@ -26,11 +26,11 @@ $(LIBS): $(OBJS)
 	$(CC) $(SHARED_FLAGS) $(CFLAGS) -o $@ $(OBJS)
 
 install:
-	$(INSTALL_PROGRAM) -o root -g root -m 755 -d $(libdir)
-	$(INSTALL_PROGRAM) -o root -g root -m 755 $(LIBS) $(libdir)/$(LIBS)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)/$(LIBS)
 
 uninstall:
-	rm -f $(libdir)/$(LIBS)
+	rm -f $(DESTDIR)$(libdir)/$(LIBS)
 
 clean:
 	rm -f core *.a *.o *.gz *.so
Index: multipath-tools-080519/libmultipath/checkers/Makefile
===================================================================
--- multipath-tools-080519.orig/libmultipath/checkers/Makefile
+++ multipath-tools-080519/libmultipath/checkers/Makefile
@@ -21,10 +21,10 @@ libcheck%.so: libsg.o %.o
 	$(CC) $(SHARED_FLAGS) -o $@ $^
 
 install:
-	$(INSTALL_PROGRAM) -o root -g root -m 755 $(LIBS) $(libdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
 
 uninstall:
-	rm -f $(libdir)/$(LIBS)
+	rm -f $(DESTDIR)$(libdir)/$(LIBS)
 
 clean:
 	rm -f core *.a *.o *.gz *.so
Index: multipath-tools-080519/libmultipath/prioritizers/Makefile
===================================================================
--- multipath-tools-080519.orig/libmultipath/prioritizers/Makefile
+++ multipath-tools-080519/libmultipath/prioritizers/Makefile
@@ -25,10 +25,10 @@ libprio%.so: %.o
 	$(CC) $(SHARED_FLAGS) -o $@ $^
 
 install: $(LIBS)
-	install -m 755 libprio*.so $(libdir)
+	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
 
 uninstall:
-	rm -f $(libdir)/libprio*.so
+	rm -f $(DESTDIR)$(libdir)/libprio*.so
 
 clean:
 	rm -f core *.a *.o *.gz *.so

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--ew6BAiZeqk4r7MaW--
