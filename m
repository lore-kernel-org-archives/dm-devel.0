From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] The internal debug memory leak printout has
	output jumbled.
Date: Tue, 16 Dec 2008 10:54:55 -0500
Message-ID: <1229442897-3765-4-git-send-email-konrad@virtualiron.com>
References: <1229442897-3765-1-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-2-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-3-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1229442897-3765-3-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

 When using the internal memory leak the function that call realloc get a
 confused output. The fix puts the list of operation in the right
 order.

---
 libmultipath/memory.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmultipath/memory.c b/libmultipath/memory.c
index 71dfe40..bd6ae5e 100644
--- a/libmultipath/memory.c
+++ b/libmultipath/memory.c
@@ -459,9 +459,8 @@ dbg_realloc(void *buffer, unsigned long size, char *file, char *function,
 	if (debug & 1)
 		printf("realloc [%3d:%3d] %p, %4ld %s %d %s -> %p %4ld %s %d %s\n",
 		       i, number_alloc_list, alloc_list[i].ptr,
-		       alloc_list[i].size, file, line, function, buf, size,
-		       alloc_list[i].file, alloc_list[i].line,
-		       alloc_list[i].func);
+		       alloc_list[i].size, alloc_list[i].file, alloc_list[i].line, alloc_list[i].func,
+		       buf, size, file, line, function);
 
 	alloc_list[i].ptr = buf;
 	alloc_list[i].size = size;
-- 
1.5.4.1
