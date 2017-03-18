From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: arrange compilation options for
	shared libs/objects
Date: Sat, 18 Mar 2017 18:45:00 +0100
Message-ID: <20170318174500.15268-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/Makefile                   | 2 +-
 libmpathcmd/Makefile               | 2 +-
 libmpathpersist/Makefile           | 2 +-
 libmultipath/Makefile              | 2 +-
 libmultipath/checkers/Makefile     | 6 +++---
 libmultipath/prioritizers/Makefile | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 082078a..8640bf6 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -23,7 +23,7 @@ LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthre
 all: $(LIBS) doc
 
 $(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS) -o $@
 	$(LN) $@ $(DEVLIB)
 
 install:
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index b8e29cb..b6c349a 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -9,7 +9,7 @@ OBJS = mpath_cmd.o
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS) -o $@
 	$(LN) $@ $(DEVLIB)
 
 install: $(LIBS)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 96da639..ee4a421 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -14,7 +14,7 @@ OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@ $(OBJS)
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS) -o $@
 	$(LN) $(LIBS) $(DEVLIB)
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
 	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 1f5ec25..c5f4052 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -47,7 +47,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) $(LIBDEPS) -Wl,-soname=$@ $(OBJS) -o $@
 	$(LN) $@ $(DEVLIB)
 
 install:
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 11ab76f..3b8e27c 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -19,13 +19,13 @@ LIBS= \
 all: $(LIBS)
 
 libcheckrbd.so: rbd.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^ -lrados -ludev
 
 libcheckdirectio.so: libsg.o directio.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^ -laio
 
 libcheck%.so: libsg.o %.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^
 
 install:
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 36b42e4..8a5561a 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -23,10 +23,10 @@ LIBS = \
 all: $(LIBS)
 
 libprioalua.so: alua.o alua_rtpg.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^
 
 libprio%.so: %.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+	$(CC) $(SHARED_FLAGS) $(LDFLAGS) -o $@ $^
 
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
-- 
2.12.0
