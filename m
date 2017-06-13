From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/4] kpartx: Improve portability of set_loop()
Date: Tue, 13 Jun 2017 09:33:36 -0700
Message-ID: <20170613163339.23005-2-bart.vanassche@sandisk.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170613163339.23005-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Because macros like __x86_64__ are not defined by the C standard
and because it is easy to convert the int2ptr() macro into
standard C, use (void*)(uintptr_t) instead of int2ptr(). Inline
this macro because it only has one user. This patch does not
change any functionality.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/lopart.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 70054459..f7ab91b5 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -21,6 +21,7 @@
 #include <fcntl.h>
 #include <errno.h>
 #include <stdlib.h>
+#include <stdint.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
@@ -37,13 +38,6 @@
 #define LOOP_CTL_GET_FREE       0x4C82
 #endif
 
-#if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
-	&& !defined (__s390x__)
-#define int2ptr(x)	((void *) ((int) x))
-#else
-#define int2ptr(x)	((void *) ((long) x))
-#endif
-
 static char *
 xstrdup (const char *s)
 {
@@ -249,7 +243,7 @@ int set_loop(const char *device, const char *file, int offset, int *loopro)
 	loopinfo.lo_encrypt_type = LO_CRYPT_NONE;
 	loopinfo.lo_encrypt_key_size = 0;
 
-	if (ioctl (fd, LOOP_SET_FD, int2ptr(ffd)) < 0) {
+	if (ioctl(fd, LOOP_SET_FD, (void*)(uintptr_t)(ffd)) < 0) {
 		perror ("ioctl: LOOP_SET_FD");
 		close (fd);
 		close (ffd);
-- 
2.12.2
