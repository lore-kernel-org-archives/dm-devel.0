From: heinzm@sourceware.org
Subject: dmraid/lib internal.h
Date: 17 Dec 2009 14:23:35 -0000
Message-ID: <20091217142335.23474.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-12-17 14:23:35

Modified files:
	lib            : internal.h 

Log message:
	make min/max macros safe

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/internal.h.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/lib/internal.h	2009/09/16 11:45:12	1.4
+++ dmraid/lib/internal.h	2009/12/17 14:23:35	1.5
@@ -50,8 +50,8 @@
 #define	u_int64_t	uint64_t
 #endif
 
-#define min(a, b) (a) < (b) ? (a) : (b)
-#define max(a, b) (a) > (b) ? (a) : (b)
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#define max(a, b) ((a) > (b) ? (a) : (b))
 #define ARRAY_SIZE(a)   (sizeof(a) / sizeof(*a))
 #define ARRAY_END(a)   (a + ARRAY_SIZE(a))
 
