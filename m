From: mwilck@suse.com
Subject: [PATCH 1/2] libmultipath: move libsg into libmultipath
Date: Tue, 12 May 2020 22:38:21 +0200
Message-ID: <20200512203822.18910-2-mwilck@suse.com>
References: <20200512203822.18910-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200512203822.18910-1-mwilck@suse.com>
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

sg_read() is called from readsector0 and emc_clariion. Move it
to libmultipath/, where all common code resides.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile               | 3 ++-
 libmultipath/checkers/Makefile      | 6 +++---
 libmultipath/{checkers => }/libsg.c | 0
 libmultipath/{checkers => }/libsg.h | 0
 libmultipath/prioritizers/Makefile  | 2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)
 rename libmultipath/{checkers => }/libsg.c (100%)
 rename libmultipath/{checkers => }/libsg.h (100%)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index ad690a49..f19b7ad2 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -47,7 +47,8 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
-	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o
+	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o \
+	libsg.o
 
 all: $(LIBS)
 
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 02caea64..01c04510 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -17,10 +17,10 @@ LIBS= \
 
 all: $(LIBS)
 
-libcheckdirectio.so: libsg.o directio.o
+libcheckdirectio.so: directio.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
 
-libcheck%.so: libsg.o %.o
+libcheck%.so: %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
 install:
@@ -32,7 +32,7 @@ uninstall:
 clean: dep_clean
 	$(RM) core *.a *.o *.gz *.so
 
-OBJS := $(LIBS:libcheck%.so=%.o) libsg.o directio.o
+OBJS := $(LIBS:libcheck%.so=%.o)
 .SECONDARY: $(OBJS)
 
 include $(wildcard $(OBJS:.o=.d))
diff --git a/libmultipath/checkers/libsg.c b/libmultipath/libsg.c
similarity index 100%
rename from libmultipath/checkers/libsg.c
rename to libmultipath/libsg.c
diff --git a/libmultipath/checkers/libsg.h b/libmultipath/libsg.h
similarity index 100%
rename from libmultipath/checkers/libsg.h
rename to libmultipath/libsg.h
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 9d0fe03c..fc6e0e0c 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -28,7 +28,7 @@ endif
 
 all: $(LIBS)
 
-libpriopath_latency.so: path_latency.o  ../checkers/libsg.o
+libpriopath_latency.so: path_latency.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm
 
 libprio%.so: %.o
-- 
2.26.2
