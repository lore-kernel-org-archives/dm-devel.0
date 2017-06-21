From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: sync third-party headers with
	3.13 upstream
Date: Wed, 21 Jun 2017 14:26:39 +0200
Message-ID: <20170621122639.6027-1-xose.vazquez@gmail.com>
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
 third-party/valgrind/drd.h      |   2 +-
 third-party/valgrind/valgrind.h | 556 ++--------------------------------------
 2 files changed, 21 insertions(+), 537 deletions(-)

diff --git a/third-party/valgrind/drd.h b/third-party/valgrind/drd.h
index 4615e5b..d63b3dd 100644
--- a/third-party/valgrind/drd.h
+++ b/third-party/valgrind/drd.h
@@ -12,7 +12,7 @@
   This file is part of DRD, a Valgrind tool for verification of
   multithreaded programs.
 
-  Copyright (C) 2006-2015 Bart Van Assche <bvanassche@acm.org>.
+  Copyright (C) 2006-2017 Bart Van Assche <bvanassche@acm.org>.
   All rights reserved.
 
   Redistribution and use in source and binary forms, with or without
diff --git a/third-party/valgrind/valgrind.h b/third-party/valgrind/valgrind.h
index 6892007..5aed0df 100644
--- a/third-party/valgrind/valgrind.h
+++ b/third-party/valgrind/valgrind.h
@@ -12,7 +12,7 @@
    This file is part of Valgrind, a dynamic binary instrumentation
    framework.
 
-   Copyright (C) 2000-2015 Julian Seward.  All rights reserved.
+   Copyright (C) 2000-2017 Julian Seward.  All rights reserved.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
@@ -89,7 +89,7 @@
         || (__VALGRIND_MAJOR__ == 3 && __VALGRIND_MINOR__ >= 6))
 */
 #define __VALGRIND_MAJOR__    3
-#define __VALGRIND_MINOR__    12
+#define __VALGRIND_MINOR__    13
 
 
 #include <stdarg.h>
@@ -122,7 +122,6 @@
 #undef PLAT_s390x_linux
 #undef PLAT_mips32_linux
 #undef PLAT_mips64_linux
-#undef PLAT_tilegx_linux
 #undef PLAT_x86_solaris
 #undef PLAT_amd64_solaris
 
@@ -160,8 +159,6 @@
 #  define PLAT_mips64_linux 1
 #elif defined(__linux__) && defined(__mips__) && (__mips!=64)
 #  define PLAT_mips32_linux 1
-#elif defined(__linux__) && defined(__tilegx__)
-#  define PLAT_tilegx_linux 1
 #elif defined(__sun) && defined(__i386__)
 #  define PLAT_x86_solaris 1
 #elif defined(__sun) && defined(__x86_64__)
@@ -1048,73 +1045,6 @@ typedef
 
 #endif /* PLAT_mips64_linux */
 
-/* ------------------------ tilegx-linux --------------- */
-#if defined(PLAT_tilegx_linux)
-
-typedef
-   struct {
-      unsigned long long int nraddr; /* where's the code? */
-   }
-   OrigFn;
-/*** special instruction sequence.
-     0:02b3c7ff91234fff { moveli zero, 4660 ; moveli zero, 22136 }
-     8:0091a7ff95678fff { moveli zero, 22136 ; moveli zero, 4660 }
-****/
-
-#define __SPECIAL_INSTRUCTION_PREAMBLE                             \
-   ".quad  0x02b3c7ff91234fff\n"                                   \
-   ".quad  0x0091a7ff95678fff\n"
-
-#define VALGRIND_DO_CLIENT_REQUEST_EXPR(                           \
-   _zzq_default, _zzq_request,                                      \
-   _zzq_arg1, _zzq_arg2, _zzq_arg3, _zzq_arg4, _zzq_arg5)          \
-   ({ volatile unsigned long long int _zzq_args[6];                \
-      volatile unsigned long long int _zzq_result;                 \
-      _zzq_args[0] = (unsigned long long int)(_zzq_request);       \
-      _zzq_args[1] = (unsigned long long int)(_zzq_arg1);          \
-      _zzq_args[2] = (unsigned long long int)(_zzq_arg2);          \
-      _zzq_args[3] = (unsigned long long int)(_zzq_arg3);          \
-      _zzq_args[4] = (unsigned long long int)(_zzq_arg4);          \
-      _zzq_args[5] = (unsigned long long int)(_zzq_arg5);          \
-      __asm__ volatile("move r11, %1\n\t" /*default*/              \
-                       "move r12, %2\n\t" /*ptr*/                  \
-                       __SPECIAL_INSTRUCTION_PREAMBLE              \
-                       /* r11 = client_request */                  \
-                       "or r13, r13, r13\n\t"                      \
-                       "move %0, r11\n\t"     /*result*/           \
-                       : "=r" (_zzq_result)                        \
-                       : "r" (_zzq_default), "r" (&_zzq_args[0])   \
-                       : "memory", "r11", "r12");                  \
-      _zzq_result;                                                 \
-   })
-
-#define VALGRIND_GET_NR_CONTEXT(_zzq_rlval)                        \
-   {  volatile OrigFn* _zzq_orig = &(_zzq_rlval);                  \
-      volatile unsigned long long int __addr;                      \
-      __asm__ volatile(__SPECIAL_INSTRUCTION_PREAMBLE              \
-                       /* r11 = guest_NRADDR */                    \
-                       "or r14, r14, r14\n"                        \
-                       "move %0, r11\n"                            \
-                       : "=r" (__addr)                             \
-                       :                                           \
-                       : "memory", "r11"                           \
-                       );                                          \
-      _zzq_orig->nraddr = __addr;                                  \
-   }
-
-#define VALGRIND_CALL_NOREDIR_R12                                  \
-   __SPECIAL_INSTRUCTION_PREAMBLE                                  \
-   "or r15, r15, r15\n\t"
-
-#define VALGRIND_VEX_INJECT_IR()                                   \
-   do {                                                            \
-      __asm__ volatile(__SPECIAL_INSTRUCTION_PREAMBLE              \
-                       "or r11, r11, r11\n\t"                      \
-                       );                                          \
-   } while (0)
-
-#endif /* PLAT_tilegx_linux */
-
 /* Insert assembly code for other platforms here... */
 
 #endif /* NVALGRIND */
@@ -2708,7 +2638,7 @@ typedef
 #define __CALLER_SAVED_REGS                                       \
    "lr", "ctr", "xer",                                            \
    "cr0", "cr1", "cr2", "cr3", "cr4", "cr5", "cr6", "cr7",        \
-   "r0", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10",   \
+   "r0", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10",         \
    "r11", "r12", "r13"
 
 /* Macros to save and align the stack before making a function
@@ -3264,7 +3194,7 @@ typedef
 #define __CALLER_SAVED_REGS                                       \
    "lr", "ctr", "xer",                                            \
    "cr0", "cr1", "cr2", "cr3", "cr4", "cr5", "cr6", "cr7",        \
-   "r0", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10",   \
+   "r0", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10",         \
    "r11", "r12", "r13"
 
 /* Macros to save and align the stack before making a function
@@ -6165,461 +6095,6 @@ typedef
 
 #endif /* PLAT_mips64_linux */
 
-/* ------------------------ tilegx-linux ------------------------- */
-
-#if defined(PLAT_tilegx_linux)
-
-/* These regs are trashed by the hidden call. */
-#define __CALLER_SAVED_REGS "r0", "r1", "r2", "r3", "r4", "r5", \
-    "r6", "r7", "r8", "r9", "r10", "r11", "r12", "r13", "r14",  \
-    "r15", "r16", "r17", "r18", "r19", "r20", "r21", "r22",     \
-    "r23", "r24", "r25", "r26", "r27", "r28", "r29", "lr"
-
-/* These CALL_FN_ macros assume that on tilegx-linux, sizeof(unsigned
-   long) == 8. */
-
-#define CALL_FN_W_v(lval, orig)                          \
-   do {                                                  \
-      volatile OrigFn        _orig = (orig);             \
-      volatile unsigned long _argvec[1];                 \
-      volatile unsigned long _res;                       \
-      _argvec[0] = (unsigned long)_orig.nraddr;          \
-      __asm__ volatile(                                  \
-         "addi sp, sp, -8 \n\t"                          \
-         "st_add sp, lr, -8 \n\t"                        \
-         "ld r12, %1 \n\t"  /* target->r11 */            \
-         VALGRIND_CALL_NOREDIR_R12                       \
-         "addi   sp, sp, 8\n\t"                          \
-         "ld_add lr, sp, 8 \n\t"                         \
-         "move  %0, r0 \n"                               \
-         : /*out*/   "=r" (_res)                         \
-         : /*in*/    "r" (&_argvec[0])                   \
-         : /*trash*/  "memory", __CALLER_SAVED_REGS);    \
-                                                         \
-      lval = (__typeof__(lval)) _res;                    \
-   } while (0)
-
-#define CALL_FN_W_W(lval, orig, arg1)                   \
-   do {                                                 \
-      volatile OrigFn        _orig = (orig);            \
-      volatile unsigned long _argvec[2];                \
-      volatile unsigned long _res;                      \
-      _argvec[0] = (unsigned long)_orig.nraddr;         \
-      _argvec[1] = (unsigned long)(arg1);               \
-      __asm__ volatile(                                 \
-         "addi sp, sp, -8 \n\t"                         \
-         "st_add sp, lr, -8 \n\t"                       \
-         "move r29, %1 \n\t"                            \
-         "ld_add r12, r29, 8 \n\t"  /* target->r11 */   \
-         "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */       \
-         VALGRIND_CALL_NOREDIR_R12                      \
-         "addi   sp, sp, 8\n\t"                         \
-         "ld_add lr, sp, 8 \n\t"                        \
-         "move  %0, r0\n"                               \
-         : /*out*/   "=r" (_res)                        \
-         : /*in*/    "r" (&_argvec[0])                  \
-         : /*trash*/  "memory", __CALLER_SAVED_REGS);   \
-      lval = (__typeof__(lval)) _res;                   \
-   } while (0)
-
-#define CALL_FN_W_WW(lval, orig, arg1,arg2)             \
-   do {                                                 \
-      volatile OrigFn        _orig = (orig);            \
-      volatile unsigned long _argvec[3];                \
-      volatile unsigned long _res;                      \
-      _argvec[0] = (unsigned long)_orig.nraddr;         \
-      _argvec[1] = (unsigned long)(arg1);               \
-      _argvec[2] = (unsigned long)(arg2);               \
-      __asm__ volatile(                                 \
-         "addi sp, sp, -8 \n\t"                         \
-         "st_add sp, lr, -8 \n\t"                       \
-         "move r29, %1 \n\t"                            \
-         "ld_add r12, r29, 8 \n\t"  /* target->r11 */   \
-         "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */       \
-         "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */       \
-         VALGRIND_CALL_NOREDIR_R12                      \
-         "addi   sp, sp, 8\n\t"                         \
-         "ld_add lr, sp, 8 \n\t"                        \
-         "move  %0, r0\n"                               \
-         : /*out*/   "=r" (_res)                        \
-         : /*in*/    "r" (&_argvec[0])                  \
-         : /*trash*/  "memory", __CALLER_SAVED_REGS);   \
-      lval = (__typeof__(lval)) _res;                   \
-   } while (0)
-
-#define CALL_FN_W_WWW(lval, orig, arg1,arg2,arg3)       \
-   do {                                                 \
-     volatile OrigFn        _orig = (orig);             \
-     volatile unsigned long _argvec[4];                 \
-     volatile unsigned long _res;                       \
-     _argvec[0] = (unsigned long)_orig.nraddr;          \
-     _argvec[1] = (unsigned long)(arg1);                \
-     _argvec[2] = (unsigned long)(arg2);                \
-     _argvec[3] = (unsigned long)(arg3);                \
-     __asm__ volatile(                                  \
-        "addi sp, sp, -8 \n\t"                          \
-        "st_add sp, lr, -8 \n\t"                        \
-        "move r29, %1 \n\t"                             \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */    \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */        \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */        \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */        \
-        VALGRIND_CALL_NOREDIR_R12                       \
-        "addi   sp, sp, 8 \n\t"                         \
-        "ld_add lr, sp, 8 \n\t"                         \
-        "move  %0, r0\n"                                \
-        : /*out*/   "=r" (_res)                         \
-        : /*in*/    "r" (&_argvec[0])                   \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);    \
-     lval = (__typeof__(lval)) _res;                    \
-   } while (0)
-
-#define CALL_FN_W_WWWW(lval, orig, arg1,arg2,arg3,arg4) \
-   do {                                                 \
-      volatile OrigFn        _orig = (orig);            \
-      volatile unsigned long _argvec[5];                \
-      volatile unsigned long _res;                      \
-      _argvec[0] = (unsigned long)_orig.nraddr;         \
-      _argvec[1] = (unsigned long)(arg1);               \
-      _argvec[2] = (unsigned long)(arg2);               \
-      _argvec[3] = (unsigned long)(arg3);               \
-      _argvec[4] = (unsigned long)(arg4);               \
-      __asm__ volatile(                                 \
-         "addi sp, sp, -8 \n\t"                         \
-         "st_add sp, lr, -8 \n\t"                       \
-         "move r29, %1 \n\t"                            \
-         "ld_add r12, r29, 8 \n\t"  /* target->r11 */   \
-         "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */       \
-         "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */       \
-         "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */       \
-         "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */       \
-         VALGRIND_CALL_NOREDIR_R12                      \
-         "addi   sp, sp, 8\n\t"                         \
-         "ld_add lr, sp, 8 \n\t"                        \
-         "move  %0, r0\n"                               \
-         : /*out*/   "=r" (_res)                        \
-         : /*in*/    "r" (&_argvec[0])                  \
-         : /*trash*/  "memory", __CALLER_SAVED_REGS);   \
-      lval = (__typeof__(lval)) _res;                   \
-   } while (0)
-
-#define CALL_FN_W_5W(lval, orig, arg1,arg2,arg3,arg4,arg5)      \
-   do {                                                         \
-      volatile OrigFn        _orig = (orig);                    \
-      volatile unsigned long _argvec[6];                        \
-      volatile unsigned long _res;                              \
-      _argvec[0] = (unsigned long)_orig.nraddr;                 \
-      _argvec[1] = (unsigned long)(arg1);                       \
-      _argvec[2] = (unsigned long)(arg2);                       \
-      _argvec[3] = (unsigned long)(arg3);                       \
-      _argvec[4] = (unsigned long)(arg4);                       \
-      _argvec[5] = (unsigned long)(arg5);                       \
-      __asm__ volatile(                                         \
-         "addi sp, sp, -8 \n\t"                                 \
-         "st_add sp, lr, -8 \n\t"                               \
-         "move r29, %1 \n\t"                                    \
-         "ld_add r12, r29, 8 \n\t"  /* target->r11 */           \
-         "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */               \
-         "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */               \
-         "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */               \
-         "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */               \
-         "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */               \
-         VALGRIND_CALL_NOREDIR_R12                              \
-         "addi   sp, sp, 8\n\t"                                 \
-         "ld_add lr, sp, 8 \n\t"                                \
-         "move  %0, r0\n"                                       \
-         : /*out*/   "=r" (_res)                                \
-         : /*in*/    "r" (&_argvec[0])                          \
-         : /*trash*/  "memory", __CALLER_SAVED_REGS);           \
-      lval = (__typeof__(lval)) _res;                           \
-   } while (0)
-#define CALL_FN_W_6W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6) \
-   do {                                                         \
-      volatile OrigFn        _orig = (orig);                    \
-      volatile unsigned long _argvec[7];                        \
-      volatile unsigned long _res;                              \
-      _argvec[0] = (unsigned long)_orig.nraddr;                 \
-      _argvec[1] = (unsigned long)(arg1);                       \
-      _argvec[2] = (unsigned long)(arg2);                       \
-      _argvec[3] = (unsigned long)(arg3);                       \
-      _argvec[4] = (unsigned long)(arg4);                       \
-      _argvec[5] = (unsigned long)(arg5);                       \
-      _argvec[6] = (unsigned long)(arg6);                       \
-      __asm__ volatile(                                         \
-        "addi sp, sp, -8 \n\t"                                  \
-        "st_add sp, lr, -8 \n\t"                                \
-        "move r29, %1 \n\t"                                     \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */            \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */                \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */                \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */                \
-        "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */                \
-        "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */                \
-        "ld_add r5, r29, 8 \n\t" /*arg6 -> r5 */                \
-        VALGRIND_CALL_NOREDIR_R12                               \
-        "addi   sp, sp, 8\n\t"                                  \
-        "ld_add lr, sp, 8 \n\t"                                 \
-        "move  %0, r0\n"                                        \
-        : /*out*/   "=r" (_res)                                 \
-        : /*in*/    "r" (&_argvec[0])                           \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);            \
-      lval = (__typeof__(lval)) _res;                           \
-   } while (0)
-
-#define CALL_FN_W_7W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6, \
-                     arg7)                                      \
-   do {                                                         \
-      volatile OrigFn        _orig = (orig);                    \
-      volatile unsigned long _argvec[8];                        \
-      volatile unsigned long _res;                              \
-      _argvec[0] = (unsigned long)_orig.nraddr;                 \
-      _argvec[1] = (unsigned long)(arg1);                       \
-      _argvec[2] = (unsigned long)(arg2);                       \
-      _argvec[3] = (unsigned long)(arg3);                       \
-      _argvec[4] = (unsigned long)(arg4);                       \
-      _argvec[5] = (unsigned long)(arg5);                       \
-      _argvec[6] = (unsigned long)(arg6);                       \
-      _argvec[7] = (unsigned long)(arg7);                       \
-      __asm__ volatile(                                         \
-        "addi sp, sp, -8 \n\t"                                  \
-        "st_add sp, lr, -8 \n\t"                                \
-        "move r29, %1 \n\t"                                     \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */            \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */                \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */                \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */                \
-        "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */                \
-        "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */                \
-        "ld_add r5, r29, 8 \n\t" /*arg6 -> r5 */                \
-        "ld_add r6, r29, 8 \n\t" /*arg7 -> r6 */                \
-        VALGRIND_CALL_NOREDIR_R12                               \
-        "addi   sp, sp, 8\n\t"                                  \
-        "ld_add lr, sp, 8 \n\t"                                 \
-        "move  %0, r0\n"                                        \
-        : /*out*/   "=r" (_res)                                 \
-        : /*in*/    "r" (&_argvec[0])                           \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);            \
-      lval = (__typeof__(lval)) _res;                           \
-   } while (0)
-
-#define CALL_FN_W_8W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6, \
-                     arg7,arg8)                                 \
-   do {                                                         \
-      volatile OrigFn        _orig = (orig);                    \
-      volatile unsigned long _argvec[9];                        \
-      volatile unsigned long _res;                              \
-      _argvec[0] = (unsigned long)_orig.nraddr;                 \
-      _argvec[1] = (unsigned long)(arg1);                       \
-      _argvec[2] = (unsigned long)(arg2);                       \
-      _argvec[3] = (unsigned long)(arg3);                       \
-      _argvec[4] = (unsigned long)(arg4);                       \
-      _argvec[5] = (unsigned long)(arg5);                       \
-      _argvec[6] = (unsigned long)(arg6);                       \
-      _argvec[7] = (unsigned long)(arg7);                       \
-      _argvec[8] = (unsigned long)(arg8);                       \
-      __asm__ volatile(                                         \
-        "addi sp, sp, -8 \n\t"                                  \
-        "st_add sp, lr, -8 \n\t"                                \
-        "move r29, %1 \n\t"                                     \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */            \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */                \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */                \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */                \
-        "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */                \
-        "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */                \
-        "ld_add r5, r29, 8 \n\t" /*arg6 -> r5 */                \
-        "ld_add r6, r29, 8 \n\t" /*arg7 -> r6 */                \
-        "ld_add r7, r29, 8 \n\t" /*arg8 -> r7 */                \
-        VALGRIND_CALL_NOREDIR_R12                               \
-        "addi   sp, sp, 8\n\t"                                  \
-        "ld_add lr, sp, 8 \n\t"                                 \
-        "move  %0, r0\n"                                        \
-        : /*out*/   "=r" (_res)                                 \
-        : /*in*/    "r" (&_argvec[0])                           \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);            \
-      lval = (__typeof__(lval)) _res;                           \
-   } while (0)
-
-#define CALL_FN_W_9W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6, \
-                     arg7,arg8,arg9)                            \
-   do {                                                         \
-      volatile OrigFn        _orig = (orig);                    \
-      volatile unsigned long _argvec[10];                       \
-      volatile unsigned long _res;                              \
-      _argvec[0] = (unsigned long)_orig.nraddr;                 \
-      _argvec[1] = (unsigned long)(arg1);                       \
-      _argvec[2] = (unsigned long)(arg2);                       \
-      _argvec[3] = (unsigned long)(arg3);                       \
-      _argvec[4] = (unsigned long)(arg4);                       \
-      _argvec[5] = (unsigned long)(arg5);                       \
-      _argvec[6] = (unsigned long)(arg6);                       \
-      _argvec[7] = (unsigned long)(arg7);                       \
-      _argvec[8] = (unsigned long)(arg8);                       \
-      _argvec[9] = (unsigned long)(arg9);                       \
-      __asm__ volatile(                                         \
-        "addi sp, sp, -8 \n\t"                                  \
-        "st_add sp, lr, -8 \n\t"                                \
-        "move r29, %1 \n\t"                                     \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */            \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */                \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */                \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */                \
-        "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */                \
-        "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */                \
-        "ld_add r5, r29, 8 \n\t" /*arg6 -> r5 */                \
-        "ld_add r6, r29, 8 \n\t" /*arg7 -> r6 */                \
-        "ld_add r7, r29, 8 \n\t" /*arg8 -> r7 */                \
-        "ld_add r8, r29, 8 \n\t" /*arg9 -> r8 */                \
-        VALGRIND_CALL_NOREDIR_R12                               \
-        "addi   sp, sp, 8\n\t"                                  \
-        "ld_add lr, sp, 8 \n\t"                                 \
-        "move  %0, r0\n"                                        \
-        : /*out*/   "=r" (_res)                                 \
-        : /*in*/    "r" (&_argvec[0])                           \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);            \
-      lval = (__typeof__(lval)) _res;                           \
-   } while (0)
-
-#define CALL_FN_W_10W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,        \
-                      arg7,arg8,arg9,arg10)                             \
-   do {                                                                 \
-      volatile OrigFn        _orig = (orig);                            \
-      volatile unsigned long _argvec[11];                               \
-      volatile unsigned long _res;                                      \
-      _argvec[0] = (unsigned long)_orig.nraddr;                         \
-      _argvec[1] = (unsigned long)(arg1);                               \
-      _argvec[2] = (unsigned long)(arg2);                               \
-      _argvec[3] = (unsigned long)(arg3);                               \
-      _argvec[4] = (unsigned long)(arg4);                               \
-      _argvec[5] = (unsigned long)(arg5);                               \
-      _argvec[6] = (unsigned long)(arg6);                               \
-      _argvec[7] = (unsigned long)(arg7);                               \
-      _argvec[8] = (unsigned long)(arg8);                               \
-      _argvec[9] = (unsigned long)(arg9);                               \
-      _argvec[10] = (unsigned long)(arg10);                             \
-      __asm__ volatile(                                                 \
-        "addi sp, sp, -8 \n\t"                                          \
-        "st_add sp, lr, -8 \n\t"                                        \
-        "move r29, %1 \n\t"                                             \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */                    \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */                        \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */                        \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */                        \
-        "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */                        \
-        "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */                        \
-        "ld_add r5, r29, 8 \n\t" /*arg6 -> r5 */                        \
-        "ld_add r6, r29, 8 \n\t" /*arg7 -> r6 */                        \
-        "ld_add r7, r29, 8 \n\t" /*arg8 -> r7 */                        \
-        "ld_add r8, r29, 8 \n\t" /*arg9 -> r8 */                        \
-        "ld_add r9, r29, 8 \n\t" /*arg10 -> r9 */                       \
-        VALGRIND_CALL_NOREDIR_R12                                       \
-        "addi   sp, sp, 8\n\t"                                          \
-        "ld_add lr, sp, 8 \n\t"                                         \
-        "move  %0, r0\n"                                                \
-        : /*out*/   "=r" (_res)                                         \
-        : /*in*/    "r" (&_argvec[0])                                   \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);                    \
-      lval = (__typeof__(lval)) _res;                                   \
-   } while (0)
-
-#define CALL_FN_W_11W(lval, orig, arg1,arg2,arg3,arg4,arg5,     \
-                      arg6,arg7,arg8,arg9,arg10,                \
-                      arg11)                                    \
-   do {                                                         \
-      volatile OrigFn        _orig = (orig);                    \
-      volatile unsigned long _argvec[12];                       \
-      volatile unsigned long _res;                              \
-      _argvec[0] = (unsigned long)_orig.nraddr;                 \
-      _argvec[1] = (unsigned long)(arg1);                       \
-      _argvec[2] = (unsigned long)(arg2);                       \
-      _argvec[3] = (unsigned long)(arg3);                       \
-      _argvec[4] = (unsigned long)(arg4);                       \
-      _argvec[5] = (unsigned long)(arg5);                       \
-      _argvec[6] = (unsigned long)(arg6);                       \
-      _argvec[7] = (unsigned long)(arg7);                       \
-      _argvec[8] = (unsigned long)(arg8);                       \
-      _argvec[9] = (unsigned long)(arg9);                       \
-      _argvec[10] = (unsigned long)(arg10);                     \
-      _argvec[11] = (unsigned long)(arg11);                     \
-      __asm__ volatile(                                         \
-        "addi sp, sp, -8 \n\t"                                  \
-        "st_add sp, lr, -8 \n\t"                                \
-        "move r29, %1 \n\t"                                     \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */            \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */                \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */                \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */                \
-        "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */                \
-        "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */                \
-        "ld_add r5, r29, 8 \n\t" /*arg6 -> r5 */                \
-        "ld_add r6, r29, 8 \n\t" /*arg7 -> r6 */                \
-        "ld_add r7, r29, 8 \n\t" /*arg8 -> r7 */                \
-        "ld_add r8, r29, 8 \n\t" /*arg9 -> r8 */                \
-        "ld_add r9, r29, 8 \n\t" /*arg10 -> r9 */               \
-        "ld     r10, r29 \n\t"                                  \
-        "st_add sp, r10, -16 \n\t"                              \
-        VALGRIND_CALL_NOREDIR_R12                               \
-        "addi   sp, sp, 24 \n\t"                                \
-        "ld_add lr, sp, 8 \n\t"                                 \
-        "move  %0, r0\n"                                        \
-        : /*out*/   "=r" (_res)                                 \
-        : /*in*/    "r" (&_argvec[0])                           \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);            \
-      lval = (__typeof__(lval)) _res;                           \
-   } while (0)
-
-#define CALL_FN_W_12W(lval, orig, arg1,arg2,arg3,arg4,arg5,     \
-                      arg6,arg7,arg8,arg9,arg10,                \
-                      arg11,arg12)                              \
-   do {                                                         \
-      volatile OrigFn        _orig = (orig);                    \
-      volatile unsigned long _argvec[13];                       \
-      volatile unsigned long _res;                              \
-      _argvec[0] = (unsigned long)_orig.nraddr;                 \
-      _argvec[1] = (unsigned long)(arg1);                       \
-      _argvec[2] = (unsigned long)(arg2);                       \
-      _argvec[3] = (unsigned long)(arg3);                       \
-      _argvec[4] = (unsigned long)(arg4);                       \
-      _argvec[5] = (unsigned long)(arg5);                       \
-      _argvec[6] = (unsigned long)(arg6);                       \
-      _argvec[7] = (unsigned long)(arg7);                       \
-      _argvec[8] = (unsigned long)(arg8);                       \
-      _argvec[9] = (unsigned long)(arg9);                       \
-      _argvec[10] = (unsigned long)(arg10);                     \
-      _argvec[11] = (unsigned long)(arg11);                     \
-      _argvec[12] = (unsigned long)(arg12);                     \
-      __asm__ volatile(                                         \
-        "addi sp, sp, -8 \n\t"                                  \
-        "st_add sp, lr, -8 \n\t"                                \
-        "move r29, %1 \n\t"                                     \
-        "ld_add r12, r29, 8 \n\t"  /* target->r11 */            \
-        "ld_add r0, r29, 8 \n\t" /*arg1 -> r0 */                \
-        "ld_add r1, r29, 8 \n\t" /*arg2 -> r1 */                \
-        "ld_add r2, r29, 8 \n\t" /*arg3 -> r2 */                \
-        "ld_add r3, r29, 8 \n\t" /*arg4 -> r3 */                \
-        "ld_add r4, r29, 8 \n\t" /*arg5 -> r4 */                \
-        "ld_add r5, r29, 8 \n\t" /*arg6 -> r5 */                \
-        "ld_add r6, r29, 8 \n\t" /*arg7 -> r6 */                \
-        "ld_add r7, r29, 8 \n\t" /*arg8 -> r7 */                \
-        "ld_add r8, r29, 8 \n\t" /*arg9 -> r8 */                \
-        "ld_add r9, r29, 8 \n\t" /*arg10 -> r9 */               \
-        "addi r28, sp, -8 \n\t"                                 \
-        "addi sp,  sp, -24 \n\t"                                \
-        "ld_add r10, r29, 8 \n\t"                               \
-        "ld     r11, r29 \n\t"                                  \
-        "st_add r28, r10, 8 \n\t"                               \
-        "st     r28, r11 \n\t"                                  \
-        VALGRIND_CALL_NOREDIR_R12                               \
-        "addi   sp, sp, 32 \n\t"                                \
-        "ld_add lr, sp, 8 \n\t"                                 \
-        "move  %0, r0\n"                                        \
-        : /*out*/   "=r" (_res)                                 \
-        : /*in*/    "r" (&_argvec[0])                           \
-        : /*trash*/  "memory", __CALLER_SAVED_REGS);            \
-      lval = (__typeof__(lval)) _res;                           \
-   } while (0)
-#endif  /* PLAT_tilegx_linux */
-
 /* ------------------------------------------------------------------ */
 /* ARCHITECTURE INDEPENDENT MACROS for CLIENT REQUESTS.               */
 /*                                                                    */
@@ -6642,8 +6117,9 @@ typedef
 
 /* !! ABIWARNING !! ABIWARNING !! ABIWARNING !! ABIWARNING !! 
    This enum comprises an ABI exported by Valgrind to programs
-   which use client requests.  DO NOT CHANGE THE ORDER OF THESE
-   ENTRIES, NOR DELETE ANY -- add new ones at the end. */
+   which use client requests.  DO NOT CHANGE THE NUMERIC VALUES OF THESE
+   ENTRIES, NOR DELETE ANY -- add new ones at the end of the most
+   relevant group. */
 typedef
    enum { VG_USERREQ__RUNNING_ON_VALGRIND  = 0x1001,
           VG_USERREQ__DISCARD_TRANSLATIONS = 0x1002,
@@ -6713,8 +6189,13 @@ typedef
              Other values are not allowed. */
           VG_USERREQ__CHANGE_ERR_DISABLEMENT = 0x1801,
 
+          /* Some requests used for Valgrind internal, such as
+             self-test or self-hosting. */
           /* Initialise IR injection */
-          VG_USERREQ__VEX_INIT_FOR_IRI = 0x1901
+          VG_USERREQ__VEX_INIT_FOR_IRI = 0x1901,
+          /* Used by Inner Valgrind to inform Outer Valgrind where to
+             find the list of inner guest threads */
+          VG_USERREQ__INNER_THREADS    = 0x1902
    } Vg_ClientRequest;
 
 #if !defined(__GNUC__)
@@ -6740,6 +6221,10 @@ typedef
     VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__DISCARD_TRANSLATIONS,  \
                                     _qzz_addr, _qzz_len, 0, 0, 0)
 
+#define VALGRIND_INNER_THREADS(_qzz_addr)                               \
+   VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__INNER_THREADS,           \
+                                   _qzz_addr, 0, 0, 0, 0)
+
 
 /* These requests are for getting Valgrind itself to print something.
    Possibly with a backtrace.  This is a really ugly hack.  The return value
@@ -6759,7 +6244,7 @@ __inline
 VALGRIND_PRINTF(const char *format, ...)
 {
 #if defined(NVALGRIND)
-   if (format) *(volatile const char *)format;   /* avoid compiler warning */
+   (void)format;
    return 0;
 #else /* NVALGRIND */
 #if defined(_MSC_VER) || defined(__MINGW64__)
@@ -6798,7 +6283,7 @@ __inline
 VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
 {
 #if defined(NVALGRIND)
-   if (format) *(volatile const char *)format;   /* avoid compiler warning */
+   (void)format;
    return 0;
 #else /* NVALGRIND */
 #if defined(_MSC_VER) || defined(__MINGW64__)
@@ -6828,7 +6313,7 @@ VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
 
 
 /* These requests allow control to move from the simulated CPU to the
-   real CPU, calling an arbitary function.
+   real CPU, calling an arbitrary function.
    
    Note that the current ThreadId is inserted as the first argument.
    So this call:
@@ -7153,7 +6638,6 @@ VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
 #undef PLAT_s390x_linux
 #undef PLAT_mips32_linux
 #undef PLAT_mips64_linux
-#undef PLAT_tilegx_linux
 #undef PLAT_x86_solaris
 #undef PLAT_amd64_solaris
 
-- 
2.13.1
