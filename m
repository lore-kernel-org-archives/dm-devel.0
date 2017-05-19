From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace 64bit archs macros by
	__LP64__
Date: Fri, 19 May 2017 03:38:18 +0200
Message-ID: <20170519013818.15130-1-xose.vazquez@gmail.com>
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

Rationale: https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html

__LP64__
_LP64
 These macros are defined, with value 1, if (and only if) the compilation is
 for a target where long int and pointer both use 64-bits and int uses 32-bit.


Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/lopart.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 4e6dab4..3c16eb0 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -38,11 +38,10 @@
 #define LOOP_CTL_GET_FREE       0x4C82
 #endif
 
-#if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
-	&& !defined (__s390x__)
-#define int2ptr(x)	((void *) ((int) x))
-#else
+#if defined (__LP64__)
 #define int2ptr(x)	((void *) ((long) x))
+#else
+#define int2ptr(x)	((void *) ((int) x))
 #endif
 
 static char *
-- 
2.13.0
