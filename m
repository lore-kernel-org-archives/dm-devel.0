From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/5] multipath-tools: replace rm with a variable
	in makefiles
Date: Fri,  1 Jul 2016 19:17:28 +0200
Message-ID: <1467393452-1032-2-git-send-email-xose.vazquez@gmail.com>
References: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc                       |  1 +
 kpartx/Makefile                    | 12 ++++++------
 libmpathcmd/Makefile               |  8 ++++----
 libmpathpersist/Makefile           | 18 +++++++++---------
 libmultipath/Makefile              |  4 ++--
 libmultipath/checkers/Makefile     |  4 ++--
 libmultipath/prioritizers/Makefile |  4 ++--
 mpathpersist/Makefile              |  8 ++++----
 multipath/Makefile                 | 12 ++++++------
 multipathd/Makefile                | 10 +++++-----
 10 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 7adeb46..e5d8704 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -56,6 +56,7 @@ mpathpersistdir = $(TOPDIR)/libmpathpersist
 mpathcmddir = $(TOPDIR)/libmpathcmd
 
 GZIP        = gzip -9 -c
+RM          = rm -f
 INSTALL_PROGRAM = install
 
 OPTFLAGS     = -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 501b277..5476545 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -34,11 +34,11 @@ install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
 uninstall:
-	rm -f $(DESTDIR)$(bindir)/$(EXEC)
-	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
-	rm -f $(DESTDIR)$(libudevdir)/kpartx_id
-	rm -f $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
-	rm -f $(DESTDIR)$(libudevdir)/rules.d/67-kpartx-compat.rules
+	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
+	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(libudevdir)/kpartx_id
+	$(RM) $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
+	$(RM) $(DESTDIR)$(libudevdir)/rules.d/67-kpartx-compat.rules
 
 clean:
-	rm -f core *.o $(EXEC) *.gz
+	$(RM) core *.o $(EXEC) *.gz
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 6fca165..92cdd82 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -22,9 +22,9 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR)$(incdir)
 
 uninstall:
-	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
-	rm -f $(DESTDIR)$(syslibdir)/$(DEVLIB)
-	rm -f $(DESTDIR)$(incdir)/mpath_cmd.h
+	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(RM) $(DESTDIR)$(incdir)/mpath_cmd.h
 
 clean:
-	rm -f core *.a *.o *.gz *.so *.so.*
+	$(RM) core *.a *.o *.gz *.so *.so.*
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index e6a7eb8..09d196e 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -38,14 +38,14 @@ install: $(LIBS)
 	install -m 644 mpath_persist.h $(DESTDIR)$(incdir)
 
 uninstall:
-	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
-	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz
-	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz
-	rm -f $(DESTDIR)$(incdir)/mpath_persist.h
-	rm -f $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz
+	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz
+	$(RM) $(DESTDIR)$(incdir)/mpath_persist.h
+	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean:
-	rm -f core *.a *.o
-	rm -f libmpathpersist.so.0
-	rm -f libmpathpersist.so
-	rm -f mpath_persistent_reserve_in.3.gz mpath_persistent_reserve_out.3.gz
+	$(RM) core *.a *.o
+	$(RM) libmpathpersist.so.0
+	$(RM) libmpathpersist.so
+	$(RM) mpath_persistent_reserve_in.3.gz mpath_persistent_reserve_out.3.gz
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 1ee968e..ba1cfa7 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -65,7 +65,7 @@ install:
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
 
 uninstall:
-	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
 
 clean:
-	rm -f core *.a *.o *.gz *.so *.so.*
+	$(RM) core *.a *.o *.gz *.so *.so.*
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 4b1a108..fb8fff0 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -27,7 +27,7 @@ install:
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
 
 uninstall:
-	for file in $(LIBS); do rm -f $(DESTDIR)$(libdir)/$$file; done
+	for file in $(LIBS); do $(RM) $(DESTDIR)$(libdir)/$$file; done
 
 clean:
-	rm -f core *.a *.o *.gz *.so
+	$(RM) core *.a *.o *.gz *.so
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index ca7b85c..903a139 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -31,7 +31,7 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
 
 uninstall:
-	for file in $(LIBS); do rm -f $(DESTDIR)$(libdir)/$$file; done
+	for file in $(LIBS); do $(RM) $(DESTDIR)$(libdir)/$$file; done
 
 clean:
-	rm -f core *.a *.o *.gz *.so
+	$(RM) core *.a *.o *.gz *.so
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 42a0830..2cc625b 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -22,9 +22,9 @@ install:
 	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	
 clean:
-	rm -f *.o $(EXEC)
-	rm -f mpathpersist.8.gz
+	$(RM) *.o $(EXEC)
+	$(RM) mpathpersist.8.gz
 
 uninstall:
-	rm $(DESTDIR)$(bindir)/$(EXEC)
-	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
+	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
diff --git a/multipath/Makefile b/multipath/Makefile
index 3707235..9c57d3b 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -31,11 +31,11 @@ install:
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5.gz $(DESTDIR)$(man5dir)
 
 uninstall:
-	rm $(DESTDIR)$(bindir)/$(EXEC)
-	rm $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
-	rm $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
-	rm $(DESTDIR)$(mandir)/$(EXEC).8.gz
-	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
+	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
+	$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
+	$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
+	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
 
 clean:
-	rm -f core *.o $(EXEC) *.gz
+	$(RM) core *.o $(EXEC) *.gz
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 7fb1d3f..1caaca7 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -55,11 +55,11 @@ endif
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
 uninstall:
-	rm -f $(DESTDIR)$(bindir)/$(EXEC)
-	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
-	rm -f $(DESTDIR)$(unitdir)/$(EXEC).service
-	rm -f $(DESTDIR)$(unitdir)/$(EXEC).socket
+	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
+	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
+	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean:
-	rm -f core *.o $(EXEC) *.gz
+	$(RM) core *.o $(EXEC) *.gz
 
-- 
2.7.4
