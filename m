From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 2/4] kpartx: read devices with direct IO
Date: Thu,  2 Jul 2020 19:38:25 -0500
Message-ID: <1593736707-14216-3-git-send-email-bmarzins@redhat.com>
References: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If kpartx is used on top of shared storage, and a device has its
partition table changed on one machine, and then kpartx is run on
another, it may not see the new data, because the cache still contains
the old data, and there is nothing to tell the machine running kpartx to
invalidate it. To solve this, kpartx should read the devices using
direct io.

One issue with how this code has been updated is that the original code
for getblock() always read 1024 bytes. The new code reads a logical
sector size chunk of the device, and returns a pointer to the 512 byte
sector that the caller asked for, within that (possibly larger) chunk.
This means that if the logical sector size is 512, then the code is now
only reading 512 bytes.  Looking through the code for the various
partition types, I can't see a case where more than 512 bytes is needed
and getblock() is used.  If anyone has a reason why this code should be
reading 1024 bytes at minmum, I can certainly change this.  But when I
looked, I couldn't find a case where reading 512 bytes would cause a
problem.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/dasd.c   |  7 ++++---
 kpartx/gpt.c    | 22 +++++++++----------
 kpartx/kpartx.c | 56 +++++++++++++++++++++++++++++++++++++++----------
 kpartx/kpartx.h |  2 ++
 4 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 14b9d3aa..f0398645 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -22,6 +22,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -117,13 +118,13 @@ read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
 
 		sprintf(pathname, "/dev/.kpartx-node-%u-%u",
 			(unsigned int)major(dev), (unsigned int)minor(dev));
-		if ((fd_dasd = open(pathname, O_RDONLY)) == -1) {
+		if ((fd_dasd = open(pathname, O_RDONLY | O_DIRECT)) == -1) {
 			/* Devicenode does not exist. Try to create one */
 			if (mknod(pathname, 0600 | S_IFBLK, dev) == -1) {
 				/* Couldn't create a device node */
 				return -1;
 			}
-			fd_dasd = open(pathname, O_RDONLY);
+			fd_dasd = open(pathname, O_RDONLY | O_DIRECT);
 			/*
 			 * The file will vanish when the last process (we)
 			 * has ceased to access it.
@@ -175,7 +176,7 @@ read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
 	 * Get volume label, extract name and type.
 	 */
 
-	if (!(data = (unsigned char *)malloc(blocksize)))
+	if (aligned_malloc((void **)&data, blocksize, NULL))
 		goto out;
 
 
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 785b34ea..f7fefb70 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -243,8 +243,7 @@ alloc_read_gpt_entries(int fd, gpt_header * gpt)
 
 	if (!count) return NULL;
 
-	pte = (gpt_entry *)malloc(count);
-	if (!pte)
+	if (aligned_malloc((void **)&pte, get_sector_size(fd), &count))
 		return NULL;
 	memset(pte, 0, count);
 
@@ -269,12 +268,11 @@ static gpt_header *
 alloc_read_gpt_header(int fd, uint64_t lba)
 {
 	gpt_header *gpt;
-	gpt = (gpt_header *)
-	    malloc(sizeof (gpt_header));
-	if (!gpt)
+	size_t size = sizeof (gpt_header);
+	if (aligned_malloc((void **)&gpt, get_sector_size(fd), &size))
 		return NULL;
-	memset(gpt, 0, sizeof (*gpt));
-	if (!read_lba(fd, lba, gpt, sizeof (gpt_header))) {
+	memset(gpt, 0, size);
+	if (!read_lba(fd, lba, gpt, size)) {
 		free(gpt);
 		return NULL;
 	}
@@ -498,6 +496,7 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
 	legacy_mbr *legacymbr = NULL;
+	size_t size = sizeof(legacy_mbr);
 	uint64_t lastlba;
 	if (!gpt || !ptes)
 		return 0;
@@ -526,11 +525,10 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 	}
 
 	/* This will be added to the EFI Spec. per Intel after v1.02. */
-	legacymbr = malloc(sizeof (*legacymbr));
-	if (legacymbr) {
-		memset(legacymbr, 0, sizeof (*legacymbr));
-		read_lba(fd, 0, (uint8_t *) legacymbr,
-			 sizeof (*legacymbr));
+	if (aligned_malloc((void **)&legacymbr, get_sector_size(fd),
+			   &size) == 0) {
+		memset(legacymbr, 0, size);
+		read_lba(fd, 0, (uint8_t *) legacymbr, size);
 		good_pmbr = is_pmbr_valid(legacymbr);
 		free(legacymbr);
 		legacymbr=NULL;
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index d3620c5c..c24ad6d9 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -19,6 +19,7 @@
  * cva, 2002-10-26
  */
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <fcntl.h>
 #include <errno.h>
@@ -41,7 +42,6 @@
 
 #define SIZE(a) (sizeof(a)/sizeof((a)[0]))
 
-#define READ_SIZE	1024
 #define MAXTYPES	64
 #define MAXSLICES	256
 #define DM_TARGET	"linear"
@@ -388,7 +388,7 @@ main(int argc, char **argv){
 		set_delimiter(mapname, delim);
 	}
 
-	fd = open(device, O_RDONLY);
+	fd = open(device, O_RDONLY | O_DIRECT);
 
 	if (fd == -1) {
 		perror(device);
@@ -690,9 +690,9 @@ xmalloc (size_t size) {
  */
 
 static int
-sseek(int fd, unsigned int secnr) {
+sseek(int fd, unsigned int secnr, int secsz) {
 	off64_t in, out;
-	in = ((off64_t) secnr << 9);
+	in = ((off64_t) secnr * secsz);
 	out = 1;
 
 	if ((out = lseek64(fd, in, SEEK_SET)) != in)
@@ -703,6 +703,31 @@ sseek(int fd, unsigned int secnr) {
 	return 0;
 }
 
+int
+aligned_malloc(void **mem_p, size_t align, size_t *size_p)
+{
+	static size_t pgsize = 0;
+	size_t size;
+	int err;
+
+	if (!mem_p || !align || (size_p && !*size_p))
+		return EINVAL;
+
+	if (!pgsize)
+		pgsize = getpagesize();
+
+	if (size_p)
+		size = ((*size_p + align - 1) / align) * align;
+	else
+		size = pgsize;
+
+	err = posix_memalign(mem_p, pgsize, size);
+	if (!err && size_p)
+		*size_p = size;
+	return err;
+}
+
+/* always in sector size blocks */
 static
 struct block {
 	unsigned int secnr;
@@ -710,30 +735,39 @@ struct block {
 	struct block *next;
 } *blockhead;
 
+/* blknr is always in 512 byte blocks */
 char *
-getblock (int fd, unsigned int secnr) {
+getblock (int fd, unsigned int blknr) {
+	unsigned int secsz = get_sector_size(fd);
+	unsigned int blks_per_sec = secsz / 512;
+	unsigned int secnr = blknr / blks_per_sec;
+	unsigned int blk_off = (blknr % blks_per_sec) * 512;
 	struct block *bp;
 
 	for (bp = blockhead; bp; bp = bp->next)
 
 		if (bp->secnr == secnr)
-			return bp->block;
+			return bp->block + blk_off;
 
-	if (sseek(fd, secnr))
+	if (sseek(fd, secnr, secsz))
 		return NULL;
 
 	bp = xmalloc(sizeof(struct block));
 	bp->secnr = secnr;
 	bp->next = blockhead;
 	blockhead = bp;
-	bp->block = (char *) xmalloc(READ_SIZE);
+	if (aligned_malloc((void **)&bp->block, secsz, NULL)) {
+		fprintf(stderr, "aligned_malloc failed\n");
+		exit(1);
+	}
 
-	if (read(fd, bp->block, READ_SIZE) != READ_SIZE) {
+	if (read(fd, bp->block, secsz) != secsz) {
 		fprintf(stderr, "read error, sector %d\n", secnr);
-		bp->block = NULL;
+		blockhead = bp->next;
+		return NULL;
 	}
 
-	return bp->block;
+	return bp->block + blk_off;
 }
 
 int
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 67edeb82..727632c1 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -1,6 +1,7 @@
 #ifndef _KPARTX_H
 #define _KPARTX_H
 
+#include <stddef.h>
 #include <stdint.h>
 #include <sys/ioctl.h>
 
@@ -61,6 +62,7 @@ extern ptreader read_mac_pt;
 extern ptreader read_sun_pt;
 extern ptreader read_ps3_pt;
 
+int aligned_malloc(void **mem_p, size_t align, size_t *size_p);
 char *getblock(int fd, unsigned int secnr);
 
 static inline unsigned int
-- 
2.17.2
