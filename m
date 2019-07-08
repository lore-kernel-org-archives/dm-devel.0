From: Petr Vorel <petr.vorel@gmail.com>
Subject: [PATCH 1/1] kpartx: Use __kernel_daddr_t for
	solaris_x86_slice.s_start
Date: Mon,  8 Jul 2019 23:35:51 +0200
Message-ID: <20190708213551.26349-1-petr.vorel@gmail.com>
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
Cc: Petr Vorel <petr.vorel@gmail.com>
List-Id: dm-devel.ids

It was meant to be used daddr_t (which is mostly int, only sparc and
mips have it defined as int), but instead used long.
But musl libc does not define daddr_t as it's deprecated, therefore
use __kernel_daddr_t from <linux/types.h>.

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
---
 kpartx/solaris.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kpartx/solaris.c b/kpartx/solaris.c
index 8c1a971b..e7826c62 100644
--- a/kpartx/solaris.c
+++ b/kpartx/solaris.c
@@ -1,17 +1,15 @@
 #include "kpartx.h"
 #include <stdio.h>
-#include <sys/types.h>
+#include <linux/types.h>
 #include <time.h>		/* time_t */
 
 #define SOLARIS_X86_NUMSLICE	8
 #define SOLARIS_X86_VTOC_SANE	(0x600DDEEEUL)
 
-//typedef int daddr_t;		/* or long - check */
-
 struct solaris_x86_slice {
 	unsigned short	s_tag;		/* ID tag of partition */
 	unsigned short	s_flag;		/* permission flags */
-	long		s_start;	/* start sector no of partition */
+	__kernel_daddr_t s_start;	/* start sector no of partition */
 	long		s_size;		/* # of blocks in partition */
 };
 
-- 
2.20.1
