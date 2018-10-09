From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: sync third-party headers with
	valgrind-3.14
Date: Wed, 10 Oct 2018 00:37:14 +0200
Message-ID: <20181009223714.9675-1-xose.vazquez@gmail.com>
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
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 third-party/valgrind/valgrind.h | 269 ++++++++++++++++----------------
 1 file changed, 136 insertions(+), 133 deletions(-)

diff --git a/third-party/valgrind/valgrind.h b/third-party/valgrind/valgrind.h
index 5aed0df..577c8f0 100644
--- a/third-party/valgrind/valgrind.h
+++ b/third-party/valgrind/valgrind.h
@@ -89,7 +89,7 @@
         || (__VALGRIND_MAJOR__ == 3 && __VALGRIND_MINOR__ >= 6))
 */
 #define __VALGRIND_MAJOR__    3
-#define __VALGRIND_MINOR__    13
+#define __VALGRIND_MINOR__    14
 
 
 #include <stdarg.h>
@@ -5687,15 +5687,17 @@ typedef
 "$7", "$8", "$9", "$10", "$11", "$12", "$13", "$14", "$15", "$24", \
 "$25", "$31"
 
-/* These CALL_FN_ macros assume that on mips-linux, sizeof(unsigned
-   long) == 4. */
+/* These CALL_FN_ macros assume that on mips64-linux,
+   sizeof(long long) == 8. */
+
+#define MIPS64_LONG2REG_CAST(x) ((long long)(long)x)
 
 #define CALL_FN_W_v(lval, orig)                                   \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[1];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
+      volatile unsigned long long _argvec[1];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
       __asm__ volatile(                                           \
          "ld $25, 0(%1)\n\t"  /* target->t9 */                    \
          VALGRIND_CALL_NOREDIR_T9                                 \
@@ -5704,16 +5706,16 @@ typedef
          : /*in*/    "0" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_W(lval, orig, arg1)                             \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[2];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
+      volatile unsigned long long _argvec[2];                     \
+      volatile unsigned long long  _res;                          \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"   /* arg1*/                           \
          "ld $25, 0(%1)\n\t"  /* target->t9 */                    \
@@ -5723,17 +5725,17 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_WW(lval, orig, arg1,arg2)                       \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[3];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
+      volatile unsigned long long _argvec[3];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = _orig.nraddr;                                  \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"                                       \
          "ld $5, 16(%1)\n\t"                                      \
@@ -5744,18 +5746,19 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
+
 #define CALL_FN_W_WWW(lval, orig, arg1,arg2,arg3)                 \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[4];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
+      volatile unsigned long long _argvec[4];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = _orig.nraddr;                                  \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"                                       \
          "ld $5, 16(%1)\n\t"                                      \
@@ -5767,19 +5770,19 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_WWWW(lval, orig, arg1,arg2,arg3,arg4)           \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[5];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
+      volatile unsigned long long _argvec[5];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"                                       \
          "ld $5, 16(%1)\n\t"                                      \
@@ -5792,20 +5795,20 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_5W(lval, orig, arg1,arg2,arg3,arg4,arg5)        \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[6];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
+      volatile unsigned long long _argvec[6];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"                                       \
          "ld $5, 16(%1)\n\t"                                      \
@@ -5819,21 +5822,21 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_6W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6)   \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[7];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
-      _argvec[6] = (unsigned long)(arg6);                         \
+      volatile unsigned long long _argvec[7];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
+      _argvec[6] = MIPS64_LONG2REG_CAST(arg6);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"                                       \
          "ld $5, 16(%1)\n\t"                                      \
@@ -5848,23 +5851,23 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_7W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
                                  arg7)                            \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[8];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
-      _argvec[6] = (unsigned long)(arg6);                         \
-      _argvec[7] = (unsigned long)(arg7);                         \
+      volatile unsigned long long _argvec[8];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
+      _argvec[6] = MIPS64_LONG2REG_CAST(arg6);                    \
+      _argvec[7] = MIPS64_LONG2REG_CAST(arg7);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"                                       \
          "ld $5, 16(%1)\n\t"                                      \
@@ -5880,24 +5883,24 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_8W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
                                  arg7,arg8)                       \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[9];                          \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
-      _argvec[6] = (unsigned long)(arg6);                         \
-      _argvec[7] = (unsigned long)(arg7);                         \
-      _argvec[8] = (unsigned long)(arg8);                         \
+      volatile unsigned long long _argvec[9];                     \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
+      _argvec[6] = MIPS64_LONG2REG_CAST(arg6);                    \
+      _argvec[7] = MIPS64_LONG2REG_CAST(arg7);                    \
+      _argvec[8] = MIPS64_LONG2REG_CAST(arg8);                    \
       __asm__ volatile(                                           \
          "ld $4, 8(%1)\n\t"                                       \
          "ld $5, 16(%1)\n\t"                                      \
@@ -5914,25 +5917,25 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_9W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
                                  arg7,arg8,arg9)                  \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[10];                         \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
-      _argvec[6] = (unsigned long)(arg6);                         \
-      _argvec[7] = (unsigned long)(arg7);                         \
-      _argvec[8] = (unsigned long)(arg8);                         \
-      _argvec[9] = (unsigned long)(arg9);                         \
+      volatile unsigned long long _argvec[10];                    \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
+      _argvec[6] = MIPS64_LONG2REG_CAST(arg6);                    \
+      _argvec[7] = MIPS64_LONG2REG_CAST(arg7);                    \
+      _argvec[8] = MIPS64_LONG2REG_CAST(arg8);                    \
+      _argvec[9] = MIPS64_LONG2REG_CAST(arg9);                    \
       __asm__ volatile(                                           \
          "dsubu $29, $29, 8\n\t"                                  \
          "ld $4, 72(%1)\n\t"                                      \
@@ -5953,26 +5956,26 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_10W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,  \
                                   arg7,arg8,arg9,arg10)           \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[11];                         \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
-      _argvec[6] = (unsigned long)(arg6);                         \
-      _argvec[7] = (unsigned long)(arg7);                         \
-      _argvec[8] = (unsigned long)(arg8);                         \
-      _argvec[9] = (unsigned long)(arg9);                         \
-      _argvec[10] = (unsigned long)(arg10);                       \
+      volatile unsigned long long _argvec[11];                    \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
+      _argvec[6] = MIPS64_LONG2REG_CAST(arg6);                    \
+      _argvec[7] = MIPS64_LONG2REG_CAST(arg7);                    \
+      _argvec[8] = MIPS64_LONG2REG_CAST(arg8);                    \
+      _argvec[9] = MIPS64_LONG2REG_CAST(arg9);                    \
+      _argvec[10] = MIPS64_LONG2REG_CAST(arg10);                  \
       __asm__ volatile(                                           \
          "dsubu $29, $29, 16\n\t"                                 \
          "ld $4, 72(%1)\n\t"                                      \
@@ -5995,7 +5998,7 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_11W(lval, orig, arg1,arg2,arg3,arg4,arg5,       \
@@ -6003,20 +6006,20 @@ typedef
                                   arg11)                          \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[12];                         \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
-      _argvec[6] = (unsigned long)(arg6);                         \
-      _argvec[7] = (unsigned long)(arg7);                         \
-      _argvec[8] = (unsigned long)(arg8);                         \
-      _argvec[9] = (unsigned long)(arg9);                         \
-      _argvec[10] = (unsigned long)(arg10);                       \
-      _argvec[11] = (unsigned long)(arg11);                       \
+      volatile unsigned long long _argvec[12];                    \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
+      _argvec[6] = MIPS64_LONG2REG_CAST(arg6);                    \
+      _argvec[7] = MIPS64_LONG2REG_CAST(arg7);                    \
+      _argvec[8] = MIPS64_LONG2REG_CAST(arg8);                    \
+      _argvec[9] = MIPS64_LONG2REG_CAST(arg9);                    \
+      _argvec[10] = MIPS64_LONG2REG_CAST(arg10);                  \
+      _argvec[11] = MIPS64_LONG2REG_CAST(arg11);                  \
       __asm__ volatile(                                           \
          "dsubu $29, $29, 24\n\t"                                 \
          "ld $4, 72(%1)\n\t"                                      \
@@ -6041,7 +6044,7 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #define CALL_FN_W_12W(lval, orig, arg1,arg2,arg3,arg4,arg5,       \
@@ -6049,21 +6052,21 @@ typedef
                                   arg11,arg12)                    \
    do {                                                           \
       volatile OrigFn        _orig = (orig);                      \
-      volatile unsigned long _argvec[13];                         \
-      volatile unsigned long _res;                                \
-      _argvec[0] = (unsigned long)_orig.nraddr;                   \
-      _argvec[1] = (unsigned long)(arg1);                         \
-      _argvec[2] = (unsigned long)(arg2);                         \
-      _argvec[3] = (unsigned long)(arg3);                         \
-      _argvec[4] = (unsigned long)(arg4);                         \
-      _argvec[5] = (unsigned long)(arg5);                         \
-      _argvec[6] = (unsigned long)(arg6);                         \
-      _argvec[7] = (unsigned long)(arg7);                         \
-      _argvec[8] = (unsigned long)(arg8);                         \
-      _argvec[9] = (unsigned long)(arg9);                         \
-      _argvec[10] = (unsigned long)(arg10);                       \
-      _argvec[11] = (unsigned long)(arg11);                       \
-      _argvec[12] = (unsigned long)(arg12);                       \
+      volatile unsigned long long _argvec[13];                    \
+      volatile unsigned long long _res;                           \
+      _argvec[0] = MIPS64_LONG2REG_CAST(_orig.nraddr);            \
+      _argvec[1] = MIPS64_LONG2REG_CAST(arg1);                    \
+      _argvec[2] = MIPS64_LONG2REG_CAST(arg2);                    \
+      _argvec[3] = MIPS64_LONG2REG_CAST(arg3);                    \
+      _argvec[4] = MIPS64_LONG2REG_CAST(arg4);                    \
+      _argvec[5] = MIPS64_LONG2REG_CAST(arg5);                    \
+      _argvec[6] = MIPS64_LONG2REG_CAST(arg6);                    \
+      _argvec[7] = MIPS64_LONG2REG_CAST(arg7);                    \
+      _argvec[8] = MIPS64_LONG2REG_CAST(arg8);                    \
+      _argvec[9] = MIPS64_LONG2REG_CAST(arg9);                    \
+      _argvec[10] = MIPS64_LONG2REG_CAST(arg10);                  \
+      _argvec[11] = MIPS64_LONG2REG_CAST(arg11);                  \
+      _argvec[12] = MIPS64_LONG2REG_CAST(arg12);                  \
       __asm__ volatile(                                           \
          "dsubu $29, $29, 32\n\t"                                 \
          "ld $4, 72(%1)\n\t"                                      \
@@ -6090,7 +6093,7 @@ typedef
          : /*in*/    "r" (&_argvec[0])                            \
          : /*trash*/ "memory", __CALLER_SAVED_REGS                \
       );                                                          \
-      lval = (__typeof__(lval)) _res;                             \
+      lval = (__typeof__(lval)) (long)_res;                       \
    } while (0)
 
 #endif /* PLAT_mips64_linux */
-- 
2.19.1
