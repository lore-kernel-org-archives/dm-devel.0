From: mwilck@suse.com
Subject: [PATCH 07/11] multipath-tools Makefiles: separate rules
	for .so and man pages
Date: Thu, 24 Sep 2020 15:36:40 +0200
Message-ID: <20200924133644.14034-8-mwilck@suse.com>
References: <20200924133644.14034-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Rely more on "make" functionality than on sequential command execution.
---
 libmpathcmd/Makefile     |  8 +++++---
 libmpathpersist/Makefile | 10 +++++++---
 libmultipath/Makefile    |  8 +++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 0f6b816..08ccb81 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -8,13 +8,15 @@ CFLAGS += $(LIB_CFLAGS)
 
 OBJS = mpath_cmd.o
 
-all: $(LIBS)
+all:	$(DEVLIB)
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
-	$(LN) $@ $(DEVLIB)
 
-install: $(LIBS)
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 21fdad8..9e869fd 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -11,15 +11,19 @@ LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
 
 OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
-all: $(LIBS)
+all: $(DEVLIB) man
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@ $(OBJS)
-	$(LN) $(LIBS) $(DEVLIB)
+
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+man:
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
 	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
 
-install: $(LIBS)
+install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index e5dac5e..af5bb77 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -50,7 +50,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o \
 	libsg.o valid.o
 
-all: $(LIBS)
+all:	$(DEVLIB)
 
 nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
 	$(CC) $(CFLAGS) -Wno-unused-function -c -o $@ $<
@@ -70,9 +70,11 @@ nvme-ioctl.h: nvme/nvme-ioctl.h
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
-	$(LN) $@ $(DEVLIB)
 
-install:
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
-- 
2.28.0
