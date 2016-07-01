From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/5] multipath-tools: replace ln with a variable
	in makefiles
Date: Fri,  1 Jul 2016 19:17:30 +0200
Message-ID: <1467393452-1032-4-git-send-email-xose.vazquez@gmail.com>
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
 Makefile.inc             | 1 +
 libmpathcmd/Makefile     | 4 ++--
 libmpathpersist/Makefile | 4 ++--
 libmultipath/Makefile    | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index e5d8704..01d743c 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -57,6 +57,7 @@ mpathcmddir = $(TOPDIR)/libmpathcmd
 
 GZIP        = gzip -9 -c
 RM          = rm -f
+LN          = ln -sf
 INSTALL_PROGRAM = install
 
 OPTFLAGS     = -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 92cdd82..44c221d 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -12,12 +12,12 @@ all: $(LIBS)
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
-	ln -sf $@ $(DEVLIB)
+	$(LN) $@ $(DEVLIB)
 
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
-	ln -sf $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(incdir)
 	$(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR)$(incdir)
 
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 6afd3a8..d22bcdd 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -22,7 +22,7 @@ all: $(LIBS)
 $(LIBS):
 	$(CC) -Wall -fPIC -c $(CFLAGS) *.c
 	$(CC)  -shared $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
-	ln -s $(LIBS) $(DEVLIB)
+	$(LN) $(LIBS) $(DEVLIB)
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
 	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
 
@@ -32,7 +32,7 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(incdir)
-	ln -sf $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(LN) $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 644 mpath_persist.h $(DESTDIR)$(incdir)
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index ba1cfa7..de13e47 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -57,7 +57,7 @@ all: $(LIBS)
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
-	ln -sf $@ $(DEVLIB)
+	$(LN) $@ $(DEVLIB)
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
-- 
2.7.4
