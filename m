From: zhou.guichun@zte.com.cn
Subject: [PATCH] libmultipath: I/O access overrun occured in
	mutipath device under the displayed capacity
Date: Wed, 26 Oct 2016 11:18:52 +0800
Message-ID: <1477451932-7756-1-git-send-email-zhou.guichun@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: tang.junhui@zte.com.cn, zhouguichun <zhou.guichun@zte.com.cn>, zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

From: zhouguichun <zhou.guichun@zte.com.cn>

I/O access overrun occured in mutipath device under
the displayed capacity since that the displayed
capacity is greater than the real capacity
(Eg. a 3456M disk display as 3.4G).

In this patch, we keep the displayed capacity three
decimals by abandoning the rest of decimals instead
of by rounding up(Eg. a 3.4567G disk display as
3.456G), so that the displayed capacity will not be
greater than the real capacity, and the error will
also be in a permissible range.

Signed-off-by: zhouguichun <zhou.guichun@zte.com.cn>
---
 libmultipath/print.c  | 8 ++++++--
 mpathpersist/Makefile | 2 +-
 multipath/Makefile    | 2 +-
 multipathd/Makefile   | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 9aa41ad..4635e5a 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <errno.h>
 #include <libudev.h>
+#include <math.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -72,16 +73,19 @@ snprint_uint (char * buff, size_t len, unsigned int val)
 static int
 snprint_size (char * buff, size_t len, unsigned long long size)
 {
-	float s = (float)(size >> 1); /* start with KB */
+	double s = (float)(size >> 1); /* start with KB */
 	char units[] = {'K','M','G','T','P'};
 	char *u = units;
+	double tmp = 0.0;
 
 	while (s >= 1024 && *u != 'P') {
 		s = s / 1024;
 		u++;
 	}
 
-	return snprintf(buff, len, "%.*f%c", s < 10, s, *u);
+	tmp = floor(s * 1000);
+	s = tmp / 1000;
+	return snprintf(buff, len, "%.3f%c", s, *u);
 }
 
 /*
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 47043bb..e9691b3 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -3,7 +3,7 @@ include ../Makefile.inc
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
 
 LIBDEPS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist \
-	   -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
+	   -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev -lm
 
 EXEC = mpathpersist
 
diff --git a/multipath/Makefile b/multipath/Makefile
index cad34bf..1f3f0ee 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -6,7 +6,7 @@ include ../Makefile.inc
 CFLAGS += -I$(multipathdir) -I$(mpathcmddir)
 
 LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev \
-	   -L$(mpathcmddir) -lmpathcmd
+	   -L$(mpathcmddir) -lmpathcmd -lm
 
 EXEC = multipath
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index ae06f9e..4db6397 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -11,7 +11,7 @@ CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir) \
 
 LIBDEPS += -ludev -ldl -L$(multipathdir) -lmultipath -L$(mpathpersistdir) \
 	   -lmpathpersist -L$(mpathcmddir) -lmpathcmd -lurcu -lpthread \
-	   -ldevmapper -lreadline
+	   -ldevmapper -lreadline -lm
 
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
-- 
2.8.1.windows.1
