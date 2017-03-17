From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: build objects for libdmmp and
	libmpathpersist independently
Date: Fri, 17 Mar 2017 16:21:46 +0100
Message-ID: <20170317152146.10884-1-xose.vazquez@gmail.com>
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

libdmmp:
cc -c -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath -I../libmpathpersist -I../libmpathcmd *.c
new:
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath -I../libmpathpersist -I../libmpathcmd -c -o mpath_persist.o mpath_persist.c
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath -I../libmpathpersist -I../libmpathcmd -c -o mpath_updatepr.o mpath_updatepr.c
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath -I../libmpathpersist -I../libmpathcmd -c -o mpath_pr_ioctl.o mpath_pr_ioctl.c

libmpathpersist:
cc -c -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c *.c
new:
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp.o libdmmp.c
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_mp.o libdmmp_mp.c
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_pg.o libdmmp_pg.c
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_path.o libdmmp_path.c
cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -fvisibility=hidden -I../libdmmp -I../libmpathcmd -I/usr/include/json-c -c -o libdmmp_misc.o libdmmp_misc.c

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/Makefile         | 3 +--
 libmpathpersist/Makefile | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index c7db054..082078a 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -22,8 +22,7 @@ LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthre
 
 all: $(LIBS) doc
 
-$(LIBS):
-	$(CC) -c $(CFLAGS) *.c
+$(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
 	$(LN) $@ $(DEVLIB)
 
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 6ef5bab..96da639 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -13,8 +13,7 @@ OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
 all: $(LIBS)
 
-$(LIBS):
-	$(CC) -c $(CFLAGS) *.c
+$(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@ $(OBJS)
 	$(LN) $(LIBS) $(DEVLIB)
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
-- 
2.12.0
