From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: arrange compilation options for
	binaries
Date: Fri, 17 Mar 2017 23:40:02 +0100
Message-ID: <20170317224002.8967-1-xose.vazquez@gmail.com>
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
 kpartx/Makefile       | 2 +-
 mpathpersist/Makefile | 2 +-
 multipath/Makefile    | 2 +-
 multipathd/Makefile   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 9441a2b..2e81284 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -19,7 +19,7 @@ EXEC = kpartx
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
+	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install: $(EXEC) $(EXEC).8
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 47043bb..27e921e 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -12,7 +12,7 @@ OBJS = main.o
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
+	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install:
diff --git a/multipath/Makefile b/multipath/Makefile
index cad34bf..421490c 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -15,7 +15,7 @@ OBJS = main.o
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
+	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 	$(GZIP) $(EXEC).conf.5 > $(EXEC).conf.5.gz
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index d57f6d5..a3fad61 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -29,7 +29,7 @@ EXEC = multipathd
 all : $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
+	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install:
-- 
2.12.0
