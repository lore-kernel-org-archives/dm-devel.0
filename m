From: Christian Hesse <mail@eworm.de>
Subject: [PATCH 1/1] fix build, replace GZIP with GZIPCMD
Date: Tue,  9 Sep 2014 10:28:00 +0200
Message-ID: <1410251280-16898-1-git-send-email-mail@eworm.de>
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
To: christophe.varoqui@opensvc.com
Cc: Christian Hesse <mail@eworm.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Files are compressed by gzip. In Makefiles the variable GZIP is
used, this evaluates to 'gzip gzip' on my system.

From man gzip:
> The environment variable GZIP can hold a set of
> default options for gzip. These options are interpreted first and can
> be overwritten by explicit command line parameters.

So using any other variable name fixes this.
---
 Makefile.inc             | 2 +-
 kpartx/Makefile          | 2 +-
 libmpathpersist/Makefile | 4 ++--
 mpathpersist/Makefile    | 2 +-
 multipathd/Makefile      | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 20ae23e..662b1a2 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -42,7 +42,7 @@ libdir	    = $(prefix)/$(LIB)/multipath
 unitdir     = $(prefix)/usr/lib/systemd/system
 mpathpersistdir = $(TOPDIR)/libmpathpersist
 
-GZIP        = gzip -9 -c
+GZIPCMD        = gzip -9 -c
 INSTALL_PROGRAM = install
 
 ifndef RPM_OPT_FLAGS
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 4ba38ba..d533c9e 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -21,7 +21,7 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	$(GZIPCMD) $(EXEC).8 > $(EXEC).8.gz
 
 install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index c4ec1c5..323465e 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -22,8 +22,8 @@ $(LIBS):
 	$(CC) -Wall -fPIC -c $(CFLAGS) *.c 
 	$(CC)  -shared $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
 	ln -s $(LIBS) $(DEVLIB)
-	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz	
-	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz	
+	$(GZIPCMD) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
+	$(GZIPCMD) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
 
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index ad8e607..0f4965f 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -13,7 +13,7 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS)
 	$(CC) -g $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	$(GZIPCMD) $(EXEC).8 > $(EXEC).8.gz
 	
 install:
 	install -d $(DESTDIR)$(bindir)
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 901d1e4..b405036 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -40,7 +40,7 @@ all : $(EXEC)
 
 $(EXEC): $(OBJS)
 	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	$(GZIPCMD) $(EXEC).8 > $(EXEC).8.gz
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
-- 
2.1.0
