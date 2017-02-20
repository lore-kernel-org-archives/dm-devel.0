From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: sync valgrind.h with 3.12
	upstream
Date: Mon, 20 Feb 2017 14:37:30 +0100
Message-ID: <20170220133730.3535-1-xose.vazquez@gmail.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 third-party/valgrind/valgrind.h | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/third-party/valgrind/valgrind.h b/third-party/valgrind/valgrind.h
index 4b8ef75..6892007 100644
--- a/third-party/valgrind/valgrind.h
+++ b/third-party/valgrind/valgrind.h
@@ -89,7 +89,7 @@
         || (__VALGRIND_MAJOR__ == 3 && __VALGRIND_MINOR__ >= 6))
 */
 #define __VALGRIND_MAJOR__    3
-#define __VALGRIND_MINOR__    11
+#define __VALGRIND_MINOR__    12
 
 
 #include <stdarg.h>
@@ -946,7 +946,7 @@ typedef
                      "move %0, $11\n\t"     /*result*/            \
                      : "=r" (_zzq_result)                         \
                      : "r" (_zzq_default), "r" (&_zzq_args[0])    \
-                     : "$11", "$12");                             \
+                     : "$11", "$12", "memory");                   \
     _zzq_result;                                                  \
   })
 
@@ -1017,7 +1017,7 @@ typedef
                          "move %0, $11\n\t"     /*result*/          \
                          : "=r" (_zzq_result)                       \
                          : "r" (_zzq_default), "r" (&_zzq_args[0])  \
-                         : "$11", "$12");                           \
+                         : "$11", "$12", "memory");                 \
     _zzq_result;                                                    \
   })
 
@@ -6759,6 +6759,7 @@ __inline
 VALGRIND_PRINTF(const char *format, ...)
 {
 #if defined(NVALGRIND)
+   if (format) *(volatile const char *)format;   /* avoid compiler warning */
    return 0;
 #else /* NVALGRIND */
 #if defined(_MSC_VER) || defined(__MINGW64__)
@@ -6797,6 +6798,7 @@ __inline
 VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
 {
 #if defined(NVALGRIND)
+   if (format) *(volatile const char *)format;   /* avoid compiler warning */
    return 0;
 #else /* NVALGRIND */
 #if defined(_MSC_VER) || defined(__MINGW64__)
@@ -7007,6 +7009,38 @@ VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
     VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__CREATE_MEMPOOL,   \
                                     pool, rzB, is_zeroed, 0, 0)
 
+/* Create a memory pool with some flags specifying extended behaviour.
+   When flags is zero, the behaviour is identical to VALGRIND_CREATE_MEMPOOL.
+   
+   The flag VALGRIND_MEMPOOL_METAPOOL specifies that the pieces of memory 
+   associated with the pool using VALGRIND_MEMPOOL_ALLOC  will be used
+   by the application as superblocks to dole out MALLOC_LIKE blocks using
+   VALGRIND_MALLOCLIKE_BLOCK. In other words, a meta pool is a "2 levels"
+   pool : first level is the blocks described by VALGRIND_MEMPOOL_ALLOC.
+   The second level blocks are described using VALGRIND_MALLOCLIKE_BLOCK.
+   Note that the association between the pool and the second level blocks
+   is implicit : second level blocks will be located inside first level
+   blocks. It is necessary to use the VALGRIND_MEMPOOL_METAPOOL flag
+   for such 2 levels pools, as otherwise valgrind will detect overlapping
+   memory blocks, and will abort execution (e.g. during leak search).
+
+   Such a meta pool can also be marked as an 'auto free' pool using the flag
+   VALGRIND_MEMPOOL_AUTO_FREE, which must be OR-ed together with the
+   VALGRIND_MEMPOOL_METAPOOL. For an 'auto free' pool, VALGRIND_MEMPOOL_FREE
+   will automatically free the second level blocks that are contained
+   inside the first level block freed with VALGRIND_MEMPOOL_FREE.
+   In other words, calling VALGRIND_MEMPOOL_FREE will cause implicit calls
+   to VALGRIND_FREELIKE_BLOCK for all the second level blocks included
+   in the first level block.
+   Note: it is an error to use the VALGRIND_MEMPOOL_AUTO_FREE flag
+   without the VALGRIND_MEMPOOL_METAPOOL flag.
+*/
+#define VALGRIND_MEMPOOL_AUTO_FREE  1
+#define VALGRIND_MEMPOOL_METAPOOL   2
+#define VALGRIND_CREATE_MEMPOOL_EXT(pool, rzB, is_zeroed, flags)        \
+   VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__CREATE_MEMPOOL,          \
+                                   pool, rzB, is_zeroed, flags, 0)
+
 /* Destroy a memory pool. */
 #define VALGRIND_DESTROY_MEMPOOL(pool)                            \
     VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__DESTROY_MEMPOOL,  \
-- 
2.11.1
