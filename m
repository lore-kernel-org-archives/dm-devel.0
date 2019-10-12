From: Petr Vorel <pvorel@suse.cz>
Subject: [RFC PATCH v2 2/2] kpartx: Use fixed size types in
	struct solaris_x86_vtoc
Date: Sat, 12 Oct 2019 21:29:38 +0200
Message-ID: <20191012192938.17652-2-pvorel@suse.cz>
References: <20191012192938.17652-1-pvorel@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012192938.17652-1-pvorel@suse.cz>
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

Some of the items in struct solaris_x86_vtoc defined in kernel uses
fixed size types (with specified byte order). We're not able to find
original 32-bit x86 Solaris sources, but expect struct definition in
kernel is correct, therefore use it as a source of size of struct items.

With one exception: keep timestamp[SOLARIS_X86_NUMSLICE] as time_t
(kernel uses unsigned int).

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Baruch Even <baruch@ev-en.org>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
changes v1->v2:
new commit.

 kpartx/solaris.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kpartx/solaris.c b/kpartx/solaris.c
index 0fda10ad..6b1795d8 100644
--- a/kpartx/solaris.c
+++ b/kpartx/solaris.c
@@ -14,13 +14,13 @@ struct solaris_x86_slice {
 };
 
 struct solaris_x86_vtoc {
-	unsigned long v_bootinfo[3];	/* info for mboot */
-	unsigned long v_sanity;		/* to verify vtoc sanity */
-	unsigned long v_version;	/* layout version */
+	unsigned int v_bootinfo[3];	/* info for mboot */
+	uint32_t v_sanity;		/* to verify vtoc sanity */
+	uint32_t v_version;		/* layout version */
 	char	v_volume[8];		/* volume name */
-	unsigned short	v_sectorsz;	/* sector size in bytes */
-	unsigned short	v_nparts;	/* number of partitions */
-	unsigned long v_reserved[10];	/* free space */
+	uint16_t	v_sectorsz;	/* sector size in bytes */
+	uint16_t	v_nparts;	/* number of partitions */
+	unsigned int v_reserved[10];	/* free space */
 	struct solaris_x86_slice
 		v_slice[SOLARIS_X86_NUMSLICE];   /* slice headers */
 	time_t	timestamp[SOLARIS_X86_NUMSLICE]; /* timestamp */
@@ -44,7 +44,7 @@ read_solaris_pt(int fd, struct slice all, struct slice *sp, int ns) {
 		return -1;
 
 	if(v->v_version != 1) {
-		fprintf(stderr, "Cannot handle solaris version %ld vtoc\n",
+		fprintf(stderr, "Cannot handle solaris version %d vtoc\n",
 		       v->v_version);
 		return 0;
 	}
-- 
2.23.0
