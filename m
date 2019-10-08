From: Petr Vorel <pvorel@suse.cz>
Subject: [RFC PATCH 1/1] kpartx: Use solaris_x86_slice definition
	from kernel
Date: Tue,  8 Oct 2019 09:57:19 +0200
Message-ID: <20191008075719.30926-1-pvorel@suse.cz>
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

solaris_x86_slice defined in kernel uses byte order fixed types.
As we already use kernel headers in kpart sources and we're not able
to find original 32-bit x86 Solaris sources, it's better to stick with
struct definition from kernel.

129e6fe6 used __kernel_daddr_t instead of one of these: long / int / daddr_t,
which is IMHO wrong and tried to address only s_start struct member.

Fixes: 129e6fe6 ("kpartx: Use __kernel_daddr_t for solaris_x86_slice.s_start")

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Baruch Even <baruch@ev-en.org>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
 kpartx/solaris.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kpartx/solaris.c b/kpartx/solaris.c
index e7826c62..7e3db9c6 100644
--- a/kpartx/solaris.c
+++ b/kpartx/solaris.c
@@ -7,10 +7,10 @@
 #define SOLARIS_X86_VTOC_SANE	(0x600DDEEEUL)
 
 struct solaris_x86_slice {
-	unsigned short	s_tag;		/* ID tag of partition */
-	unsigned short	s_flag;		/* permission flags */
-	__kernel_daddr_t s_start;	/* start sector no of partition */
-	long		s_size;		/* # of blocks in partition */
+	__le16 s_tag;		/* ID tag of partition */
+	__le16 s_flag;		/* permission flags */
+	__le32 s_start;		/* start sector no of partition */
+	__le32 s_size;		/* # of blocks in partition */
 };
 
 struct solaris_x86_vtoc {
-- 
2.23.0
