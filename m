From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove CFLAGS from shared libs
	compilation options
Date: Mon,  5 Dec 2016 23:39:08 +0100
Message-ID: <20161205223908.5486-1-xose.vazquez@gmail.com>
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
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Changed from:
cc  -shared -Wl,-soname=libmpathcmd.so.0 -O2 -g -pipe -Wall -Wextra -Wformat=2 -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -o libmpathcmd.so.0 mpath_cmd.o
cc  -shared -Wl,-soname=libmultipath.so.0 -O2 -g -pipe -Wall -Wextra -Wformat=2 -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmpathcmd -DUSE_SYSTEMD=231 -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DLIBDM_API_DEFERRED -o libmultipath.so.0 memory.o parser.o vector.o devmapper.o callout.o hwtable.o blacklist.o util.o dmparser.o config.o structs.o discovery.o propsel.o dict.o pgpolicies.o debug.o defaults.o uevent.o time-util.o switchgroup.o uxsock.o print.o alias.o log_pthread.o log.o configure.o structs_vec.o sysfs.o prio.o checkers.o lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o -lpthread -ldl -ldevmapper -ludev -L../libm
 pathcmd -lmpathcmd -lsystemd
cc  -shared -lpthread -ldevmapper -ldl -L../libmultipath -lmultipath -L../libmpathcmd -lmpathcmd -Wl,-soname=libmpathpersist.so.0 -O2 -g -pipe -Wall -Wextra -Wformat=2 -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath -I../libmpathpersist -I../libmpathcmd -o libmpathpersist.so.0 mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o

To:
cc  -shared -Wl,-soname=libmpathcmd.so.0 -o libmpathcmd.so.0 mpath_cmd.o
cc  -shared -Wl,-soname=libmultipath.so.0 -o libmultipath.so.0 memory.o parser.o vector.o devmapper.o callout.o hwtable.o blacklist.o util.o dmparser.o config.o structs.o discovery.o propsel.o dict.o pgpolicies.o debug.o defaults.o uevent.o time-util.o switchgroup.o uxsock.o print.o alias.o log_pthread.o log.o configure.o structs_vec.o sysfs.o prio.o checkers.o lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o -lpthread -ldl -ldevmapper -ludev -L../libmpathcmd -lmpathcmd -lsystemd
cc  -shared -lpthread -ldevmapper -ldl -L../libmultipath -lmultipath -L../libmpathcmd -lmpathcmd -Wl,-soname=libmpathpersist.so.0 -o libmpathpersist.so.0 mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o


Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathcmd/Makefile     | 2 +-
 libmpathpersist/Makefile | 2 +-
 libmultipath/Makefile    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 457c4ca..b8e29cb 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -9,7 +9,7 @@ OBJS = mpath_cmd.o
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
 	$(LN) $@ $(DEVLIB)
 
 install: $(LIBS)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 6e43427..6ef5bab 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -15,7 +15,7 @@ all: $(LIBS)
 
 $(LIBS):
 	$(CC) -c $(CFLAGS) *.c
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@ $(OBJS)
 	$(LN) $(LIBS) $(DEVLIB)
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
 	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index a11e483..b5d54d8 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -47,7 +47,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
 	$(LN) $@ $(DEVLIB)
 
 install:
-- 
2.11.0
