From: tang.junhui@zte.com.cn
Subject: [PATCH] libmultipath: fix memory API logic error
Date: Mon, 15 Aug 2016 18:59:09 +0800
Message-ID: <1471258749-12176-1-git-send-email-tang.junhui@zte.com.cn>
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

Memroy API use mem_allocated to record the total size of used memory,
however, it's wrong to use size(p) as the length of freed memory in xfree(),
and memory may also be allocated by STRDUP() or REALLOC(), which is
not calculated into mem_allocated, so the total size of used memory is
not correctly. For these reasons, we removed these incorrectly code to keep
the code clean.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmpathpersist/mpath_updatepr.c |  1 -
 libmultipath/memory.c            | 31 -------------------------------
 libmultipath/memory.h            | 13 ++-----------
 3 files changed, 2 insertions(+), 43 deletions(-)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 9ff4b30..5af2e03 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -16,7 +16,6 @@
 #include "uxsock.h"
 #include "memory.h"
 
-unsigned long mem_allocated;    /* Total memory used in Bytes */
 
 int update_prflag(char * arg1, char * arg2, int noisy)
 {
diff --git a/libmultipath/memory.c b/libmultipath/memory.c
index 1366f45..5441e6a 100644
--- a/libmultipath/memory.c
+++ b/libmultipath/memory.c
@@ -22,37 +22,6 @@
 
 #include "memory.h"
 
-/* Global var */
-unsigned long mem_allocated;	/* Total memory used in Bytes */
-
-void *
-xalloc(unsigned long size)
-{
-	void *mem;
-	if ((mem = malloc(size)))
-		mem_allocated += size;
-	return mem;
-}
-
-void *
-zalloc(unsigned long size)
-{
-	void *mem;
-	if ((mem = malloc(size))) {
-		memset(mem, 0, size);
-		mem_allocated += size;
-	}
-	return mem;
-}
-
-void
-xfree(void *p)
-{
-	mem_allocated -= sizeof (p);
-	free(p);
-	p = NULL;
-}
-
 /*
  * Memory management. in debug mode,
  * help finding eventual memory leak.
diff --git a/libmultipath/memory.h b/libmultipath/memory.h
index 8573f6f..99937b2 100644
--- a/libmultipath/memory.h
+++ b/libmultipath/memory.h
@@ -29,15 +29,6 @@
 #include <string.h>
 #include <assert.h>
 
-/* extern types */
-extern unsigned long mem_allocated;
-extern void *xalloc(unsigned long size);
-extern void *zalloc(unsigned long size);
-extern void xfree(void *p);
-
-/* Global alloc macro */
-#define ALLOC(n) (xalloc(n))
-
 /* Local defines */
 #ifdef _DEBUG_
 
@@ -63,8 +54,8 @@ extern void dbg_free_final(char *);
 
 #else
 
-#define MALLOC(n)    (zalloc(n))
-#define FREE(p)      (xfree(p))
+#define MALLOC(n)    (calloc(1,(n)))
+#define FREE(p)      (free(p))
 #define REALLOC(p,n) (realloc((p),(n)))
 #define STRDUP(n)    (strdup(n))
 
-- 
2.8.1.windows.1
