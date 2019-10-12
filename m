From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 57/72] kpartx: use unsigned int for "ns" argument
	of ptreader
Date: Sat, 12 Oct 2019 21:28:48 +0000
Message-ID: <20191012212703.12989-58-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

ns, the number of slices, should be positive.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/bsd.c      | 4 ++--
 kpartx/dasd.c     | 2 +-
 kpartx/dos.c      | 4 ++--
 kpartx/gpt.c      | 4 ++--
 kpartx/gpt.h      | 2 +-
 kpartx/kpartx.h   | 4 ++--
 kpartx/mac.c      | 4 ++--
 kpartx/ps3.c      | 4 ++--
 kpartx/solaris.c  | 4 ++--
 kpartx/sun.c      | 4 ++--
 kpartx/unixware.c | 4 ++--
 11 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kpartx/bsd.c b/kpartx/bsd.c
index f87175e2..0e661fbc 100644
--- a/kpartx/bsd.c
+++ b/kpartx/bsd.c
@@ -47,13 +47,13 @@ struct bsd_disklabel {
 };
 
 int
-read_bsd_pt(int fd, struct slice all, struct slice *sp, int ns) {
+read_bsd_pt(int fd, struct slice all, struct slice *sp, unsigned int ns) {
 	struct bsd_disklabel *l;
 	struct bsd_partition *p;
 	unsigned int offset = all.start, end;
 	int max_partitions;
 	char *bp;
-	int n = 0, i, j;
+	unsigned int n = 0, i, j;
 
 	bp = getblock(fd, offset+1);    /* 1 sector suffices */
 	if (bp == NULL)
diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 4f3f744e..1486ccaa 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -66,7 +66,7 @@ typedef unsigned int __attribute__((__may_alias__)) label_ints_t;
  */
 int
 read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
-	     struct slice *sp, __attribute__((unused)) int ns)
+	     struct slice *sp, __attribute__((unused)) unsigned int ns)
 {
 	int retval = -1;
 	int blocksize;
diff --git a/kpartx/dos.c b/kpartx/dos.c
index 4985152c..0c706690 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -74,10 +74,10 @@ is_gpt(int type) {
 }
 
 int
-read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
+read_dos_pt(int fd, struct slice all, struct slice *sp, unsigned int ns) {
 	struct partition p;
 	unsigned long offset = all.start;
-	int i, n=4;
+	unsigned int i, n=4;
 	unsigned char *bp;
 	uint64_t  sector_size_mul = get_sector_size(fd)/512;
 
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index aa2a440c..785b34ea 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -602,11 +602,11 @@ fail:
  */
 int
 read_gpt_pt (int fd, __attribute__((unused)) struct slice all,
-	     struct slice *sp, int ns)
+	     struct slice *sp, unsigned int ns)
 {
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
-	uint32_t i;
+	unsigned int i;
 	int n = 0;
 	int last_used_index=-1;
 	int sector_size_mul = get_sector_size(fd)/512;
diff --git a/kpartx/gpt.h b/kpartx/gpt.h
index 7bb54b74..4e1b49aa 100644
--- a/kpartx/gpt.h
+++ b/kpartx/gpt.h
@@ -105,7 +105,7 @@ typedef struct _legacy_mbr {
 #define EFI_GPT_PRIMARY_PARTITION_TABLE_LBA 1
 
 /* Functions */
-int read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns);
+int read_gpt_pt (int fd, struct slice all, struct slice *sp, unsigned int ns);
 
 
 #endif
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 015dcab4..dfc66c5d 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -38,7 +38,7 @@ struct slice {
 };
 
 typedef int (ptreader)(int fd, struct slice all, struct slice *sp,
-		       int ns);
+		       unsigned int ns);
 
 extern int force_gpt;
 
@@ -54,7 +54,7 @@ extern ptreader read_ps3_pt;
 
 char *getblock(int fd, unsigned int secnr);
 
-static inline int
+static inline unsigned int
 four2int(unsigned char *p) {
 	return p[0] + (p[1]<<8) + (p[2]<<16) + (p[3]<<24);
 }
diff --git a/kpartx/mac.c b/kpartx/mac.c
index 6aeac4e9..c21ac702 100644
--- a/kpartx/mac.c
+++ b/kpartx/mac.c
@@ -6,12 +6,12 @@
 
 int
 read_mac_pt(int fd, __attribute__((unused)) struct slice all,
-	    struct slice *sp, int ns) {
+	    struct slice *sp, unsigned int ns) {
 	struct mac_driver_desc *md;
 	struct mac_partition *part;
 	unsigned secsize;
 	char *data;
-	int blk, blocks_in_map;
+	unsigned int blk, blocks_in_map;
 	int n = 0;
 
 	md = (struct mac_driver_desc *) getblock(fd, 0);
diff --git a/kpartx/ps3.c b/kpartx/ps3.c
index 2cf4ffa2..42551bcc 100644
--- a/kpartx/ps3.c
+++ b/kpartx/ps3.c
@@ -34,7 +34,7 @@ struct disklabel {
 static int
 read_disklabel(int fd, struct disklabel *label) {
 	unsigned char *data;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < sizeof(struct disklabel) / SECTOR_SIZE; i++) {
 		data = (unsigned char *) getblock(fd, i);
@@ -49,7 +49,7 @@ read_disklabel(int fd, struct disklabel *label) {
 
 int
 read_ps3_pt(int fd, __attribute__((unused)) struct slice all,
-	    struct slice *sp, __attribute__((unused)) int ns) {
+	    struct slice *sp, __attribute__((unused)) unsigned int ns) {
 	struct disklabel label;
 	int n = 0;
 	int i;
diff --git a/kpartx/solaris.c b/kpartx/solaris.c
index e7826c62..c2480b50 100644
--- a/kpartx/solaris.c
+++ b/kpartx/solaris.c
@@ -28,11 +28,11 @@ struct solaris_x86_vtoc {
 };
 
 int
-read_solaris_pt(int fd, struct slice all, struct slice *sp, int ns) {
+read_solaris_pt(int fd, struct slice all, struct slice *sp, unsigned int ns) {
 	struct solaris_x86_vtoc *v;
 	struct solaris_x86_slice *s;
 	unsigned int offset = all.start;
-	int i, n;
+	unsigned int i, n;
 	char *bp;
 
 	bp = getblock(fd, offset+1);	/* 1 sector suffices */
diff --git a/kpartx/sun.c b/kpartx/sun.c
index 276066d1..df630a7c 100644
--- a/kpartx/sun.c
+++ b/kpartx/sun.c
@@ -59,11 +59,11 @@ sun_verify_checksum (struct sun_disk_label *label)
 }
 
 int
-read_sun_pt(int fd, struct slice all, struct slice *sp, int ns) {
+read_sun_pt(int fd, struct slice all, struct slice *sp, unsigned int ns) {
 	struct sun_disk_label *l;
 	struct sun_raw_part *s;
 	unsigned int offset = all.start, end;
-	int i, j, n;
+	unsigned int i, j, n;
 	char *bp;
 
 	bp = getblock(fd, offset);
diff --git a/kpartx/unixware.c b/kpartx/unixware.c
index c7b9786e..2f663af0 100644
--- a/kpartx/unixware.c
+++ b/kpartx/unixware.c
@@ -48,12 +48,12 @@ struct unixware_disklabel {
 };  /* 408 */
 
 int
-read_unixware_pt(int fd, struct slice all, struct slice *sp, int ns) {
+read_unixware_pt(int fd, struct slice all, struct slice *sp, unsigned int ns) {
 	struct unixware_disklabel *l;
 	struct unixware_slice *p;
 	unsigned int offset = all.start;
 	char *bp;
-	int n = 0;
+	unsigned int n = 0;
 
 	bp = getblock(fd, offset+29);	/* 1 sector suffices */
 	if (bp == NULL)
-- 
2.23.0
