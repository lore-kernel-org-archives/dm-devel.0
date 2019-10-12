From: Petr Vorel <pvorel@suse.cz>
Subject: [RFC PATCH v2 1/2] kpartx: Use fixed size types in
	struct solaris_x86_slice
Date: Sat, 12 Oct 2019 21:29:37 +0200
Message-ID: <20191012192938.17652-1-pvorel@suse.cz>
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
To: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Petr Vorel <pvorel@suse.cz>, Baruch Even <baruch@ev-en.org>
List-Id: dm-devel.ids

struct solaris_x86_slice defined in kernel uses fixed size types
(with specified byte order). We're not able to find original 32-bit
x86 Solaris sources, but expect struct definition in kernel is correct,
therefore use it as a source of size of struct items. (just don't use
original kernel byte order fixed types __le{16,32}, but normal user
space fixed size types)

129e6fe6 used __kernel_daddr_t instead of one of these: long / int / daddr_t,
which is IMHO wrong and tried to address only s_start struct member.

Fixes: 129e6fe6 ("kpartx: Use __kernel_daddr_t for solaris_x86_slice.s_start")

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Baruch Even <baruch@ev-en.org>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
changes v1->v2:
* use user space types __le{16,32} => uint{16,32}_t

 kpartx/solaris.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kpartx/solaris.c b/kpartx/solaris.c
index e7826c62..0fda10ad 100644
--- a/kpartx/solaris.c
+++ b/kpartx/solaris.c
@@ -1,16 +1,16 @@
 #include "kpartx.h"
+#include <stdint.h>
 #include <stdio.h>
-#include <linux/types.h>
 #include <time.h>		/* time_t */
 
 #define SOLARIS_X86_NUMSLICE	8
 #define SOLARIS_X86_VTOC_SANE	(0x600DDEEEUL)
 
 struct solaris_x86_slice {
-	unsigned short	s_tag;		/* ID tag of partition */
-	unsigned short	s_flag;		/* permission flags */
-	__kernel_daddr_t s_start;	/* start sector no of partition */
-	long		s_size;		/* # of blocks in partition */
+	uint16_t s_tag;		/* ID tag of partition */
+	uint16_t s_flag;	/* permission flags */
+	uint32_t s_start;	/* start sector no of partition */
+	uint32_t s_size;	/* # of blocks in partition */
 };
 
 struct solaris_x86_vtoc {
-- 
2.23.0
