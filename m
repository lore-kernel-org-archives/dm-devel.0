From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/5] multipath: fix up position independent code
Date: Mon, 24 Apr 2017 17:39:27 -0500
Message-ID: <1493073570-17167-3-git-send-email-bmarzins@redhat.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

The multipath binaries were not being compiled as position independent
executables (PIE).  This code fixes that, and makes other minor code
hardening tweaks to make hardening-check happier.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc                       | 6 +++++-
 kpartx/Makefile                    | 3 ++-
 libdmmp/Makefile                   | 2 +-
 libmpathcmd/Makefile               | 2 ++
 libmpathpersist/Makefile           | 2 +-
 libmultipath/Makefile              | 2 +-
 libmultipath/checkers/Makefile     | 2 +-
 libmultipath/prioritizers/Makefile | 2 +-
 mpathpersist/Makefile              | 3 ++-
 multipath/Makefile                 | 4 ++--
 multipathd/Makefile                | 6 +++---
 11 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 8361e6c..9f2f963 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -75,8 +75,12 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong \
 		  --param=ssp-buffer-size=4
 
-CFLAGS		= $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
+CFLAGS		= $(OPTFLAGS) -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
+BIN_CFLAGS	= -fPIE -DPIE
+LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
+LDFLAGS		= -Wl,-z,relro -Wl,-z,now
+BIN_LDFLAGS	= -pie
 
 # Check whether a function with name $1 has been declared in header file $2.
 check_func =								       \
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 9441a2b..7b75032 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -3,7 +3,8 @@
 #
 include ../Makefile.inc
 
-CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+CFLAGS += $(BIN_CFLAGS) -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+LDFLAGS += $(BIN_LDFLAGS)
 
 LIBDEPS += -ldevmapper
 
diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 1c5329a..a260871 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -15,7 +15,7 @@ HEADERS = libdmmp/libdmmp.h
 
 OBJS = libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
 
-CFLAGS += -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
+CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
 	  $(shell pkg-config --cflags json-c)
 
 LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 9cda94c..4f32101 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -4,6 +4,8 @@ SONAME = 0
 DEVLIB = libmpathcmd.so
 LIBS = $(DEVLIB).$(SONAME)
 
+CFLAGS += $(LIB_CFLAGS)
+
 OBJS = mpath_cmd.o
 
 all: $(LIBS)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 857c8d8..1b4ec16 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -4,7 +4,7 @@ SONAME = 0
 DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
 
-CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
+CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 
 LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
 	   -L$(mpathcmddir) -lmpathcmd
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 1f5ec25..b3244fc 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -7,7 +7,7 @@ SONAME = 0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 
-CFLAGS += -I$(mpathcmddir)
+CFLAGS += $(LIB_CFLAGS) -I$(mpathcmddir)
 
 LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu
 
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 4970fc0..732ca9d 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -3,7 +3,7 @@
 #
 include ../../Makefile.inc
 
-CFLAGS += -I..
+CFLAGS += $(LIB_CFLAGS) -I..
 
 # If you add or remove a checker also update multipath/multipath.conf.5
 LIBS= \
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 36b42e4..cf6811c 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -3,7 +3,7 @@
 #
 include ../../Makefile.inc
 
-CFLAGS += -I..
+CFLAGS += $(LIB_CFLAGS) -I..
 
 # If you add or remove a prioritizer also update multipath/multipath.conf.5
 LIBS = \
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 47043bb..bd1c0df 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -1,6 +1,7 @@
 include ../Makefile.inc
 
-CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
+CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir)
+LDFLAGS += $(BIN_LDFLAGS)
 
 LIBDEPS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
 	   -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
diff --git a/multipath/Makefile b/multipath/Makefile
index cad34bf..c85314e 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -3,8 +3,8 @@
 #
 include ../Makefile.inc
 
-CFLAGS += -I$(multipathdir) -I$(mpathcmddir)
-
+CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
+LDFLAGS += $(BIN_LDFLAGS)
 LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev \
 	   -L$(mpathcmddir) -lmpathcmd
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index d57f6d5..d5782a1 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -6,9 +6,9 @@ include ../Makefile.inc
 #CFLAGS += -DLCKDBG
 #CFLAGS += -D_DEBUG_
 #CFLAGS += -DLOGDBG
-CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir) \
-	  -I$(thirdpartydir)
-
+CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) \
+	  -I$(mpathcmddir) -I$(thirdpartydir)
+LDFLAGS += $(BIN_LDFLAGS)
 LIBDEPS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir) \
 	   -lmpathpersist -L$(mpathcmddir) -lmpathcmd -lurcu -lpthread \
 	   -ldevmapper -lreadline
-- 
1.8.3.1
