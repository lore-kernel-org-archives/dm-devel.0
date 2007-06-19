From: Guido Guenther <agx@sigxcpu.org>
Subject: [multipath] Ease installation of unstripped binaries
Date: Tue, 19 Jun 2007 09:15:19 +0200
Message-ID: <20070619071519.GA7240@bogon.ms20.nix>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Introduce INSTALL_PROGRAM for installing binaries, so that:

make install INSTALL_PROGRAM=install

doesn't stip binaries on installation. The default is to still strip
binaries. Can be very handy for debugging builds.

Signed-off-by: Guido Guenther <agx@sigxcpu.org>
---
 Makefile.inc                            |    2 ++
 kpartx/Makefile                         |    2 +-
 multipath/Makefile                      |    2 +-
 multipathd/Makefile                     |    2 +-
 path_priority/pp_balance_units/Makefile |    2 +-
 path_priority/pp_emc/Makefile           |    2 +-
 path_priority/pp_hds_modular/Makefile   |    2 +-
 path_priority/pp_netapp/Makefile        |    2 +-
 path_priority/pp_random/Makefile        |    2 +-
 path_priority/pp_tpc/Makefile           |    2 +-
 10 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 6a9dcc1..7e2d4e6 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -34,6 +34,8 @@ GZIP        = /bin/gzip -9 -c
 CHECKERSLIB = $(checkersdir)/libcheckers
 MULTIPATHLIB = $(multipathdir)/libmultipath
 
+INSTALL_PROGRAM = install -s
+
 OPTFLAGS     = -pipe -g -Wall -Wunused -Wstrict-prototypes
 CFLAGS	     = $(OPTFLAGS)
 
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 082d15f..f3d629d 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -38,7 +38,7 @@ $(MULTIPATHLIB)-$(BUILD).a:
 
 install: $(EXEC) $(EXEC).8
 	install -d $(DESTDIR)$(bindir)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	install -d $(DESTDIR)$(libudevdir)
 	install -m 755 kpartx_id $(DESTDIR)$(libudevdir)
 	install -d $(DESTDIR)/etc/udev/rules.d
diff --git a/multipath/Makefile b/multipath/Makefile
index 3768802..4923b2f 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -40,7 +40,7 @@ $(MULTIPATHLIB)-$(BUILD).a:
 
 install:
 	install -d $(DESTDIR)$(bindir)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	install -d $(DESTDIR)/etc/udev/rules.d
 	install -m 644 multipath.rules $(DESTDIR)/etc/udev/rules.d/
 	install -d $(DESTDIR)$(mandir)
diff --git a/multipathd/Makefile b/multipathd/Makefile
index fc4a96d..b430b94 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -45,7 +45,7 @@ $(MULTIPATHLIB)-glibc.a:
 
 install:
 	install -d $(DESTDIR)$(bindir)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	install -d $(DESTDIR)$(rcdir)
 	install -d $(DESTDIR)$(mandir)
 	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
diff --git a/path_priority/pp_balance_units/Makefile b/path_priority/pp_balance_units/Makefile
index bed7fb0..cb1e6c6 100644
--- a/path_priority/pp_balance_units/Makefile
+++ b/path_priority/pp_balance_units/Makefile
@@ -35,7 +35,7 @@ $(MULTIPATHLIB)-$(BUILD).a:
 
 install:
 	install -d $(DESTDIR)$(bindir)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
diff --git a/path_priority/pp_emc/Makefile b/path_priority/pp_emc/Makefile
index 651bdcd..93e6075 100644
--- a/path_priority/pp_emc/Makefile
+++ b/path_priority/pp_emc/Makefile
@@ -14,7 +14,7 @@ klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
diff --git a/path_priority/pp_hds_modular/Makefile b/path_priority/pp_hds_modular/Makefile
index a0249a5..ca00ca7 100644
--- a/path_priority/pp_hds_modular/Makefile
+++ b/path_priority/pp_hds_modular/Makefile
@@ -14,7 +14,7 @@ klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
diff --git a/path_priority/pp_netapp/Makefile b/path_priority/pp_netapp/Makefile
index 9e7d3a3..b29d002 100644
--- a/path_priority/pp_netapp/Makefile
+++ b/path_priority/pp_netapp/Makefile
@@ -14,7 +14,7 @@ klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
diff --git a/path_priority/pp_random/Makefile b/path_priority/pp_random/Makefile
index 85f42a2..85d7c2f 100644
--- a/path_priority/pp_random/Makefile
+++ b/path_priority/pp_random/Makefile
@@ -14,7 +14,7 @@ klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
diff --git a/path_priority/pp_tpc/Makefile b/path_priority/pp_tpc/Makefile
index 86841dd..c03e4c4 100644
--- a/path_priority/pp_tpc/Makefile
+++ b/path_priority/pp_tpc/Makefile
@@ -14,7 +14,7 @@ klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
 install: $(EXEC)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 
 uninstall:
 	rm $(DESTDIR)$(bindir)/$(EXEC)
-- 
1.5.2.1
