From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add missing group of options in
	Makefiles
Date: Fri, 12 Aug 2016 19:12:07 +0200
Message-ID: <1471021927-8662-1-git-send-email-xose.vazquez@gmail.com>
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

And remove "-g", it's already in OPTFLAG

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/Makefile          | 2 +-
 libmpathpersist/Makefile | 2 +-
 mpathpersist/Makefile    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 75b7606..6f32680 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -21,7 +21,7 @@ EXEC = kpartx
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
+	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install: $(EXEC) $(EXEC).8
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 1c4b2e1..6e43427 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -15,7 +15,7 @@ all: $(LIBS)
 
 $(LIBS):
 	$(CC) -c $(CFLAGS) *.c
-	$(CC) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
 	$(LN) $(LIBS) $(DEVLIB)
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
 	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index d545514..b6ab730 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -12,7 +12,7 @@ OBJS = main.o
 all: $(EXEC)
 
 $(EXEC): $(OBJS)
-	$(CC) -g $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
+	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install:
-- 
2.7.4
