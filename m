From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: clean up libdmmp/Makefile
Date: Mon, 13 Mar 2017 17:47:31 +0100
Message-ID: <20170313164731.2437-1-xose.vazquez@gmail.com>
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
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Replace LDFLAGS with LIBDEPS, build libdmmp shared library without CFLAGS

Cc: Gris Ge <fge@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index c98ae67..aaff285 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -9,21 +9,22 @@ LIBDMMP_VERSION=0.1.0
 SONAME=$(LIBDMMP_VERSION)
 DEVLIB = libdmmp.so
 LIBS = $(DEVLIB).$(SONAME)
-LIBDEPS = -pthread
 PKGFILE = libdmmp.pc
 EXTRA_MAN_FILES = libdmmp.h.3
 HEADERS = libdmmp/libdmmp.h
+
 OBJS = libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
 
 CFLAGS += -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
 	  $(shell pkg-config --cflags json-c)
-LDFLAGS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd
+
+LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd -pthread
 
 all: $(LIBS) doc
 
-$(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) \
-	-Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
+$(LIBS):
+	$(CC) -c $(CFLAGS) *.c
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
 	$(LN) $@ $(DEVLIB)
 
 install:
-- 
2.12.0
