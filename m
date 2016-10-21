From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 04/15] libmultipath: Move setup_thread_attr()
 from uevent.c into util.c
Date: Fri, 21 Oct 2016 11:42:42 -0700
Message-ID: <d7c6dfd0-f5d3-7b28-e491-77ece248fa5f@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The setup_thread_attr() is not called by any code in source file
uevent.c. Hence move that function to source file util.c.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/rbd.c |  2 +-
 libmultipath/checkers/tur.c |  2 +-
 libmultipath/uevent.c       | 25 -------------------------
 libmultipath/uevent.h       |  1 -
 libmultipath/util.c         | 25 +++++++++++++++++++++++--
 libmultipath/util.h         |  1 +
 6 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index c920cbb..f60914e 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -26,7 +26,7 @@
 #include "checkers.h"
 
 #include "../libmultipath/debug.h"
-#include "../libmultipath/uevent.h"
+#include "../libmultipath/util.h"
 #include "../libmultipath/time-util.h"
 
 struct rbd_checker_context;
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 81206e4..92200aa 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -19,7 +19,7 @@
 
 #include "../libmultipath/debug.h"
 #include "../libmultipath/sg_include.h"
-#include "../libmultipath/uevent.h"
+#include "../libmultipath/util.h"
 #include "../libmultipath/time-util.h"
 #include "../libmultipath/util.h"
 
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index f844294..7bc5837 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -37,7 +37,6 @@
 #include <linux/types.h>
 #include <linux/netlink.h>
 #include <pthread.h>
-#include <limits.h>
 #include <sys/mman.h>
 #include <libudev.h>
 #include <errno.h>
@@ -81,30 +80,6 @@ struct uevent * alloc_uevent (void)
 }
 
 void
-setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
-{
-	if (pthread_attr_init(attr)) {
-		fprintf(stderr, "can't initialize thread attr: %s\n",
-			strerror(errno));
-		exit(1);
-	}
-	if (stacksize < PTHREAD_STACK_MIN)
-		stacksize = PTHREAD_STACK_MIN;
-
-	if (pthread_attr_setstacksize(attr, stacksize)) {
-		fprintf(stderr, "can't set thread stack size to %lu: %s\n",
-			(unsigned long)stacksize, strerror(errno));
-		exit(1);
-	}
-	if (detached && pthread_attr_setdetachstate(attr,
-						    PTHREAD_CREATE_DETACHED)) {
-		fprintf(stderr, "can't set thread to detached: %s\n",
-			strerror(errno));
-		exit(1);
-	}
-}
-
-void
 service_uevq(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index e5fdfcc..9d22dcd 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -27,7 +27,6 @@ struct uevent {
 };
 
 int is_uevent_busy(void);
-void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 
 int uevent_listen(struct udev *udev);
 int uevent_dispatch(int (*store_uev)(struct uevent *, void * trigger_data),
diff --git a/libmultipath/util.c b/libmultipath/util.c
index ac0d1b2..0a136b4 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -1,7 +1,10 @@
-#include <string.h>
+#include <assert.h>
 #include <ctype.h>
-#include <sys/types.h>
+#include <limits.h>
+#include <pthread.h>
+#include <string.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 #include <unistd.h>
 
 #include "debug.h"
@@ -258,3 +261,21 @@ dev_t parse_devt(const char *dev_t)
 
 	return makedev(maj, min);
 }
+
+void
+setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
+{
+	int ret;
+
+	ret = pthread_attr_init(attr);
+	assert(ret == 0);
+	if (stacksize < PTHREAD_STACK_MIN)
+		stacksize = PTHREAD_STACK_MIN;
+	ret = pthread_attr_setstacksize(attr, stacksize);
+	assert(ret == 0);
+	if (detached) {
+		ret = pthread_attr_setdetachstate(attr,
+						  PTHREAD_CREATE_DETACHED);
+		assert(ret == 0);
+	}
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 8861085..f3b37ee 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -12,6 +12,7 @@ size_t strlcat(char *dst, const char *src, size_t size);
 int devt2devname (char *, int, char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
+void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
-- 
2.10.1
