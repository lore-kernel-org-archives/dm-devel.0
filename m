From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: Makefiles housekeeping
Date: Mon, 29 Aug 2016 00:10:42 +0200
Message-ID: <1472422242-9343-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

replace mandir with man8dir and put KRNL variables in place.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile              | 5 ++---
 Makefile.inc          | 2 +-
 kpartx/Makefile       | 6 +++---
 mpathpersist/Makefile | 6 +++---
 multipath/Makefile    | 6 +++---
 multipathd/Makefile   | 6 +++---
 6 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 95c7dfb..228d9ac 100644
--- a/Makefile
+++ b/Makefile
@@ -14,6 +14,8 @@ ifeq ($(KRNLSRC),)
 		KRNLSRC = $(KRNLLIB)/build
 		KRNLOBJ = $(KRNLLIB)/build
 	endif
+	export KRNLSRC
+	export KRNLOBJ
 endif
 
 ifeq ($(MULTIPATH_VERSION),)
@@ -22,9 +24,6 @@ else
 	VERSION = $(MULTIPATH_VERSION)
 endif
 
-export KRNLSRC
-export KRNLOBJ
-
 BUILDDIRS = \
 	libmpathcmd \
 	libmultipath \
diff --git a/Makefile.inc b/Makefile.inc
index 0808e64..56705c4 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -45,7 +45,7 @@ bindir		= $(exec_prefix)/sbin
 libudevdir	= $(prefix)/$(SYSTEMDPATH)/udev
 udevrulesdir	= $(libudevdir)/rules.d
 multipathdir	= $(TOPDIR)/libmultipath
-mandir		= $(prefix)/usr/share/man/man8
+man8dir		= $(prefix)/usr/share/man/man8
 man5dir		= $(prefix)/usr/share/man/man5
 man3dir		= $(prefix)/usr/share/man/man3
 syslibdir	= $(prefix)/$(LIB)
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 853288f..e8a59f2 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -31,12 +31,12 @@ install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -m 755 kpartx_id $(DESTDIR)$(libudevdir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)/rules.d
 	$(INSTALL_PROGRAM) -m 644 kpartx.rules $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
-	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
-	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
 	$(RM) $(DESTDIR)$(libudevdir)/kpartx_id
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/67-kpartx-compat.rules
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 7921619..47043bb 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -18,12 +18,12 @@ $(EXEC): $(OBJS)
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
-	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
 
 clean:
 	$(RM) core *.o $(EXEC) *.gz
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
-	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
diff --git a/multipath/Makefile b/multipath/Makefile
index f296add..cad34bf 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -25,8 +25,8 @@ install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
-	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5.gz $(DESTDIR)$(man5dir)
 
@@ -34,7 +34,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
-	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
 	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
 
 clean:
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 8524efa..fd3d543 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -39,12 +39,12 @@ ifdef SYSTEMD
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DESTDIR)$(unitdir)
 endif
-	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
-	$(RM) $(DESTDIR)$(mandir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
-- 
2.7.4
