From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/5] multipath-tools: replace LDFLAGS with
	LIBDEPS for groups of libraries in Makefiles
Date: Tue, 16 Aug 2016 14:38:50 +0200
Message-ID: <1471351133-7892-2-git-send-email-xose.vazquez@gmail.com>
References: <1471351133-7892-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471351133-7892-1-git-send-email-xose.vazquez@gmail.com>
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
 kpartx/Makefile       | 4 ++--
 mpathpersist/Makefile | 4 ++--
 multipath/Makefile    | 4 ++--
 multipathd/Makefile   | 8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 8af0dc6..853288f 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -5,7 +5,7 @@ include ../Makefile.inc
 
 CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 
-LDFLAGS += -ldevmapper
+LIBDEPS += -ldevmapper
 
 LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie' /usr/include/libdevmapper.h)
 
@@ -21,7 +21,7 @@ EXEC = kpartx
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)
+	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install: $(EXEC) $(EXEC).8
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index b6ab730..7921619 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -2,7 +2,7 @@ include ../Makefile.inc
 
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
 
-LDFLAGS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
+LIBDEPS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
 	   -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
 
 EXEC = mpathpersist
@@ -12,7 +12,7 @@ OBJS = main.o
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
+	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install:
diff --git a/multipath/Makefile b/multipath/Makefile
index b125ae3..f296add 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -5,7 +5,7 @@ include ../Makefile.inc
 
 CFLAGS += -I$(multipathdir) -I$(mpathcmddir)
 
-LDFLAGS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev \
+LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev \
 	   -L$(mpathcmddir) -lmpathcmd
 
 EXEC = multipath
@@ -15,7 +15,7 @@ OBJS = main.o
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)
+	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 	$(GZIP) $(EXEC).conf.5 > $(EXEC).conf.5.gz
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 03d7815..8524efa 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -8,16 +8,16 @@ include ../Makefile.inc
 #CFLAGS += -DLOGDBG
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 
-LDFLAGS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir) \
+LIBDEPS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir) \
 	   -lmpathpersist -L$(mpathcmddir) -lmpathcmd -lurcu -lpthread \
 	   -ldevmapper -lreadline
 
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
 	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
-		LDFLAGS += -lsystemd
+		LIBDEPS += -lsystemd
 	else
-		LDFLAGS += -lsystemd-daemon
+		LIBDEPS += -lsystemd-daemon
 	endif
 endif
 
@@ -28,7 +28,7 @@ EXEC = multipathd
 all : $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC)
+	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install:
-- 
2.7.4
