From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/7] kpartx: Fix a compiler warning
Date: Wed, 17 May 2017 08:43:08 -0700
Message-ID: <20170517154309.17787-7-bart.vanassche@sandisk.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517154309.17787-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Avoid that building against glibc >= 2.25 triggers the following
compiler warning:

lopart.c: In function 'is_loop_device':
lopart.c:93:13: warning: In the GNU C Library, "major" is defined
 by <sys/sysmacros.h>. For historical compatibility, it is
 currently defined by <sys/types.h> as well, but we plan to
 remove this soon. To use "major", include <sys/sysmacros.h>
 directly. If you did not intend to use a system-defined macro
 "major", you should undefine it after including <sys/types.h>.
   major(statbuf.st_rdev) == loopmajor);

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 kpartx/Makefile    | 4 ++++
 kpartx/sysmacros.h | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 9441a2ba..2d2a249e 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -10,6 +10,10 @@ LIBDEPS += -ldevmapper
 ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
+ifneq ($(call check_func,major,/usr/include/sys/sysmacros.h),0)
+	CFLAGS += -DHAVE_SYS_SYSMACROS_H
+endif
+
 
 OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
 	gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
diff --git a/kpartx/sysmacros.h b/kpartx/sysmacros.h
index 171b33d4..dc5077ec 100644
--- a/kpartx/sysmacros.h
+++ b/kpartx/sysmacros.h
@@ -1,5 +1,10 @@
 /* versions to be used with > 16-bit dev_t - leave unused for now */
 
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#else
+#include <sys/types.h>
+
 #ifndef major
 #define major(dev)	((dev) >> 8)
 #endif
@@ -7,3 +12,4 @@
 #ifndef minor
 #define minor(dev)	((dev) & 0xff)
 #endif
+#endif
-- 
2.12.2
