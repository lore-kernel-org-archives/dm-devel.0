From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 1/6] libmultipath: pull functions into util.c
Date: Wed, 20 Sep 2017 14:35:12 -0500
Message-ID: <1505936117-19547-2-git-send-email-bmarzins@redhat.com>
References: <1505936117-19547-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505936117-19547-1-git-send-email-bmarzins@redhat.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This patch just pulls safe_write out of rbd. and the persistent
reservation key parsing code out of dict.c and puts them in util.c,
so that other functions can make use of them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/rbd.c | 16 +---------------
 libmultipath/dict.c         | 26 +++++---------------------
 libmultipath/util.c         | 33 +++++++++++++++++++++++++++++++++
 libmultipath/util.h         |  4 ++++
 4 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 9ea0572..2c18009 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -28,6 +28,7 @@
 #include "../libmultipath/debug.h"
 #include "../libmultipath/util.h"
 #include "../libmultipath/time-util.h"
+#include "../libmultipath/util.h"
 
 struct rbd_checker_context;
 typedef int (thread_fn)(struct rbd_checker_context *ct, char *msg);
@@ -356,21 +357,6 @@ static int rbd_check(struct rbd_checker_context *ct, char *msg)
 	return PATH_UP;
 }
 
-static int safe_write(int fd, const void *buf, size_t count)
-{
-	while (count > 0) {
-		ssize_t r = write(fd, buf, count);
-		if (r < 0) {
-			if (errno == EINTR)
-				continue;
-			return -errno;
-		}
-		count -= r;
-		buf = (char *)buf + r;
-	}
-	return 0;
-}
-
 static int sysfs_write_rbd_bus(const char *which, const char *buf,
 			       size_t buf_len)
 {
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 9dc1090..680b2c5 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -19,6 +19,7 @@
 #include "blacklist.h"
 #include "defaults.h"
 #include "prio.h"
+#include "util.h"
 #include <errno.h>
 #include <inttypes.h>
 #include "mpath_cmd.h"
@@ -963,32 +964,15 @@ set_reservation_key(vector strvec, void *ptr)
 {
 	unsigned char **uchar_ptr = (unsigned char **)ptr;
 	char *buff;
-	char *tbuff;
-	int j, k;
-	int len;
+	int j;
 	uint64_t prkey;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	tbuff = buff;
-
-	if (!memcmp("0x",buff, 2))
-		buff = buff + 2;
-
-	len = strlen(buff);
-
-	k = strspn(buff, "0123456789aAbBcCdDeEfF");
-
-	if (len != k) {
-		FREE(tbuff);
-		return 1;
-	}
-
-	if (1 != sscanf (buff, "%" SCNx64 "", &prkey))
-	{
-		FREE(tbuff);
+	if (parse_prkey(buff, &prkey) != 0) {
+		FREE(buff);
 		return 1;
 	}
 
@@ -1002,7 +986,7 @@ set_reservation_key(vector strvec, void *ptr)
 		prkey >>= 8;
 	}
 
-	FREE(tbuff);
+	FREE(buff);
 	return 0;
 }
 
diff --git a/libmultipath/util.c b/libmultipath/util.c
index dff2ed3..0800da5 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -11,6 +11,7 @@
 #include <unistd.h>
 #include <errno.h>
 
+#include "util.h"
 #include "debug.h"
 #include "memory.h"
 #include "checkers.h"
@@ -416,3 +417,35 @@ int get_linux_version_code(void)
 	pthread_once(&_lvc_initialized, _set_linux_version_code);
 	return _linux_version_code;
 }
+
+int parse_prkey(char *ptr, uint64_t *prkey)
+{
+	if (!ptr)
+		return 1;
+	if (*ptr == '0')
+		ptr++;
+	if (*ptr == 'x' || *ptr == 'X')
+		ptr++;
+	if (*ptr == '\0' || strlen(ptr) > 16)
+		return 1;
+	if (strlen(ptr) != strspn(ptr, "0123456789aAbBcCdDeEfF"))
+		return 1;
+	if (sscanf(ptr, "%" SCNx64 "", prkey) != 1)
+		return 1;
+	return 0;
+}
+
+int safe_write(int fd, const void *buf, size_t count)
+{
+	while (count > 0) {
+		ssize_t r = write(fd, buf, count);
+		if (r < 0) {
+			if (errno == EINTR)
+				continue;
+			return -errno;
+		}
+		count -= r;
+		buf = (char *)buf + r;
+	}
+	return 0;
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 45291be..3dc048e 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -2,6 +2,7 @@
 #define _UTIL_H
 
 #include <sys/types.h>
+#include <inttypes.h>
 
 size_t strchop(char *);
 int basenamecpy (const char * src, char * dst, int);
@@ -16,6 +17,9 @@ char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 int systemd_service_enabled(const char *dev);
 int get_linux_version_code(void);
+int parse_prkey(char *ptr, uint64_t *prkey);
+int safe_write(int fd, const void *buf, size_t count);
+
 #define KERNEL_VERSION(maj, min, ptc) ((((maj) * 256) + (min)) * 256 + (ptc))
 
 #define safe_sprintf(var, format, args...)	\
-- 
2.7.4
