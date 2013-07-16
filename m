From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/30] kpartx: support disk with non-512B sectors
Date: Tue, 16 Jul 2013 09:13:01 +0200
Message-ID: <1373958801-103613-11-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Petr Uzel <petr.uzel@suse.cz>
List-Id: dm-devel.ids

From: Petr Uzel <petr.uzel@suse.cz>

libdevmapper expects sector size to be recalculated to 512B, so we need
to teach kpartx to do so if the underlying DM device has different
sector size (for GPT and msods partition tables).

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 kpartx/dos.c    | 17 ++++++++++-------
 kpartx/gpt.c    | 20 +-------------------
 kpartx/kpartx.c | 12 ++++++++++++
 kpartx/kpartx.h |  8 ++++++++
 4 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/kpartx/dos.c b/kpartx/dos.c
index a1a9961..0e57f0e 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -26,7 +26,9 @@ read_extended_partition(int fd, struct partition *ep, int en,
 	int moretodo = 1;
 	int i, n=0;
 
-	next = start = le32_to_cpu(ep->start_sect);
+	int sector_size_mul = get_sector_size(fd)/512;
+
+	next = start = sector_size_mul * le32_to_cpu(ep->start_sect);
 
 	while (moretodo) {
 		here = next;
@@ -45,14 +47,14 @@ read_extended_partition(int fd, struct partition *ep, int en,
 			memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
 			if (is_extended(p.sys_type)) {
 				if (p.nr_sects && !moretodo) {
-					next = start + le32_to_cpu(p.start_sect);
+					next = start + sector_size_mul * le32_to_cpu(p.start_sect);
 					moretodo = 1;
 				}
 				continue;
 			}
 			if (n < ns) {
-				sp[n].start = here + le32_to_cpu(p.start_sect);
-				sp[n].size = le32_to_cpu(p.nr_sects);
+				sp[n].start = here + sector_size_mul * le32_to_cpu(p.start_sect);
+				sp[n].size = sector_size_mul * le32_to_cpu(p.nr_sects);
 				sp[n].container = en + 1;
 				n++;
 			} else {
@@ -77,6 +79,7 @@ read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	unsigned long offset = all.start;
 	int i, n=4;
 	unsigned char *bp;
+	int sector_size_mul = get_sector_size(fd)/512;
 
 	bp = (unsigned char *)getblock(fd, offset);
 	if (bp == NULL)
@@ -90,15 +93,15 @@ read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
 		if (is_gpt(p.sys_type))
 			return 0;
 		if (i < ns) {
-			sp[i].start =  le32_to_cpu(p.start_sect);
-			sp[i].size = le32_to_cpu(p.nr_sects);
+			sp[i].start =  sector_size_mul * le32_to_cpu(p.start_sect);
+			sp[i].size = sector_size_mul * le32_to_cpu(p.nr_sects);
 		} else {
 			fprintf(stderr,
 				"dos_partition: too many slices\n");
 			break;
 		}
 		if (is_extended(p.sys_type)) {
-			sp[i].size = 2; /* extended partitions only get two
+			sp[i].size = sector_size_mul * 2; /* extended partitions only get two
 					   sectors mapped for LILO to install */
 			n += read_extended_partition(fd, &p, i, sp+n, ns-n);
 		}
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 0a22927..5a54970 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -38,6 +38,7 @@
 #include <byteswap.h>
 #include <linux/fs.h>
 #include "crc32.h"
+#include "kpartx.h"
 
 #if BYTE_ORDER == LITTLE_ENDIAN
 #  define __le16_to_cpu(x) (x)
@@ -116,25 +117,6 @@ is_pmbr_valid(legacy_mbr *mbr)
 
 
 /************************************************************
- * get_sector_size
- * Requires:
- *  - filedes is an open file descriptor, suitable for reading
- * Modifies: nothing
- * Returns:
- *  sector size, or 512.
- ************************************************************/
-static int
-get_sector_size(int filedes)
-{
-	int rc, sector_size = 512;
-
-	rc = ioctl(filedes, BLKSSZGET, &sector_size);
-	if (rc)
-		sector_size = 512;
-	return sector_size;
-}
-
-/************************************************************
  * _get_num_sectors
  * Requires:
  *  - filedes is an open file descriptor, suitable for reading
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 98d88c0..1369542 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -26,6 +26,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <stdint.h>
+#include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <ctype.h>
@@ -695,3 +696,14 @@ getblock (int fd, unsigned int secnr) {
 
 	return bp->block;
 }
+
+int
+get_sector_size(int filedes)
+{
+	int rc, sector_size = 512;
+
+	rc = ioctl(filedes, BLKSSZGET, &sector_size);
+	if (rc)
+		sector_size = 512;
+	return sector_size;
+}
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 61d31b6..a55c211 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -2,6 +2,7 @@
 #define _KPARTX_H
 
 #include <stdint.h>
+#include <sys/ioctl.h>
 
 /*
  * For each partition type there is a routine that takes
@@ -18,6 +19,13 @@
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
 
+#ifndef BLKSSZGET
+#define BLKSSZGET  _IO(0x12,104)	/* get block device sector size */
+#endif
+
+int
+get_sector_size(int filedes);
+
 /*
  * units: 512 byte sectors
  */
-- 
1.7.12.4
