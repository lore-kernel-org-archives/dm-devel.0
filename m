From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 21/21] [kpartx] Add handling for SUN partition
	tables
Date: Mon, 21 May 2007 11:24:36 +0200
Message-ID: <20070521092436.CCCD6D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Not that I've come across one of these disks, but it's a nice testbed for
the stacked partition handling. And might even be useful at one point.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/Makefile |    4 +-
 kpartx/kpartx.c |    8 +++-
 kpartx/kpartx.h |    1 +
 kpartx/sun.c    |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 4 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index a43f881..ba69550 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -10,11 +10,11 @@ CFLAGS += -I. -D_LARGEFILE64_SOURCE
 
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o gpt.o crc32.o \
-	       lopart.o xstrncpy.o devmapper.o dasd.o mac.o \
+	       lopart.o xstrncpy.o devmapper.o dasd.o mac.o sun.o \
 	       $(MULTIPATHLIB)-$(BUILD).a $(libdm)
 else
 	LDFLAGS = -ldevmapper
-	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o \
+	OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
 	       gpt.o mac.o crc32.o lopart.o xstrncpy.o devmapper.o
 endif
 
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 48169f1..30f23da 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -79,6 +79,7 @@ initpts(void)
 	addpts("unixware", read_unixware_pt);
 	addpts("dasd", read_dasd_pt);
 	addpts("mac", read_mac_pt);
+	addpts("sun", read_sun_pt);
 }
 
 static char short_opts[] = "ladgvnp:t:";
@@ -374,6 +375,9 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
+					unsigned long start;
+					int k = slices[j].container - 1;
+
 					if (slices[j].size == 0)
 						continue;
 					if (slices[j].minor > 0)
@@ -382,11 +386,11 @@ main(int argc, char **argv){
 						continue;
 					slices[j].minor = m++;
 
+					start = slices[j].start - slices[k].start;
 					printf("%s%s%d : 0 %lu /dev/dm-%d %lu\n",
 					       mapname, delim, j+1,
 					       (unsigned long) slices[j].size,
-					       slices[j].minor,
-					       (unsigned long) slices[j].start);
+					       slices[k].minor, start);
 					c--;
 				}
 				/* Terminate loop if nothing more to resolve */
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index b49c543..9b3aeca 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -36,6 +36,7 @@ extern ptreader read_unixware_pt;
 extern ptreader read_gpt_pt;
 extern ptreader read_dasd_pt;
 extern ptreader read_mac_pt;
+extern ptreader read_sun_pt;
 
 char *getblock(int fd, unsigned int secnr);
 
diff --git a/kpartx/sun.c b/kpartx/sun.c
new file mode 100644
index 0000000..3d88b21
--- /dev/null
+++ b/kpartx/sun.c
@@ -0,0 +1,131 @@
+/*
+ * Lifted from util-linux' partx sun.c
+ *
+ * Copyrights of the original file apply
+ * Copyright (c) 2007 Hannes Reinecke
+ */
+#include "kpartx.h"
+#include "byteorder.h"
+#include <stdio.h>
+#include <sys/types.h>
+#include <time.h>		/* time_t */
+
+#define SUN_DISK_MAGIC		0xDABE	/* Disk magic number */
+#define SUN_DISK_MAXPARTITIONS	8
+
+struct __attribute__ ((packed)) sun_raw_part {
+	u_int32_t	start_cylinder; /* where the part starts... */
+	u_int32_t	num_sectors;	/* ...and it's length */
+};
+
+struct __attribute__ ((packed)) sun_part_info {
+	u_int8_t	spare1;
+	u_int8_t	id;		/* Partition type */
+	u_int8_t	spare2;
+	u_int8_t	flags;		/* Partition flags */
+};
+
+struct __attribute__ ((packed)) sun_disk_label {
+	char		info[128];	/* Informative text string */
+	u_int8_t	spare0[14];
+	struct sun_part_info infos[SUN_DISK_MAXPARTITIONS];
+	u_int8_t	spare1[246];	/* Boot information etc. */
+	u_int16_t	rspeed;		/* Disk rotational speed */
+	u_int16_t	pcylcount;	/* Physical cylinder count */
+	u_int16_t	sparecyl;	/* extra sects per cylinder */
+	u_int8_t	spare2[4];	/* More magic... */
+	u_int16_t	ilfact;		/* Interleave factor */
+	u_int16_t	ncyl;		/* Data cylinder count */
+	u_int16_t	nacyl;		/* Alt. cylinder count */
+	u_int16_t	ntrks;		/* Tracks per cylinder */
+	u_int16_t	nsect;		/* Sectors per track */
+	u_int8_t	spare3[4];	/* Even more magic... */
+	struct sun_raw_part partitions[SUN_DISK_MAXPARTITIONS];
+	u_int16_t	magic;		/* Magic number */
+	u_int16_t	csum;		/* Label xor'd checksum */
+};
+
+/* Checksum Verification */
+static int
+sun_verify_checksum (struct sun_disk_label *label)
+{
+	u_int16_t *ush = ((u_int16_t *)(label + 1)) - 1;
+	u_int16_t csum = 0;
+
+	while (ush >= (u_int16_t *)label)
+		csum ^= *ush--;
+
+	return !csum;
+}
+
+int
+read_sun_pt(int fd, struct slice all, struct slice *sp, int ns) {
+	struct sun_disk_label *l;
+	struct sun_raw_part *s;
+	unsigned int offset = all.start, end;
+	int i, j, n;
+	char *bp;
+
+	bp = getblock(fd, offset);
+	if (bp == NULL)
+		return -1;
+
+	l = (struct sun_disk_label *) bp;
+	if(be16_to_cpu(l->magic) != SUN_DISK_MAGIC)
+		return -1;
+
+	if (!sun_verify_checksum(l)) {
+		fprintf(stderr, "Corrupted Sun disk label\n");
+		return -1;
+	}
+
+	for(i=0, n=0; i<SUN_DISK_MAXPARTITIONS; i++) {
+		s = &l->partitions[i];
+
+		if (s->num_sectors == 0)
+			continue;
+		if (n < ns) {
+			sp[n].start = offset +
+				be32_to_cpu(s->start_cylinder) * be16_to_cpu(l->nsect) * be16_to_cpu(l->ntrks);
+			sp[n].size = be32_to_cpu(s->num_sectors);
+			n++;
+		} else {
+			fprintf(stderr,
+				"sun_disklabel: too many slices\n");
+			break;
+		}
+	}
+	/*
+	 * Convention has it that the SUN disklabel will always have
+	 * the 'c' partition spanning the entire disk.
+	 * So we have to check for contained slices.
+	 */
+	for(i = 0; i < SUN_DISK_MAXPARTITIONS; i++) {
+		if (sp[i].size == 0)
+			continue;
+
+		end = sp[i].start + sp[i].size;
+		for(j = 0; j < SUN_DISK_MAXPARTITIONS; j ++) {
+			if ( i == j )
+				continue;
+			if (sp[j].size == 0)
+				continue;
+
+			if (sp[i].start < sp[j].start) {
+				if (end > sp[j].start &&
+				    end < sp[j].start + sp[j].size) {
+					/* Invalid slice */
+					fprintf(stderr,
+						"sun_disklabel: slice %d overlaps with %d\n", i , j);
+					sp[i].size = 0;
+				}
+			} else {
+				if (end <= sp[j].start + sp[j].size) {
+					sp[i].container = j + 1;
+				}
+			}
+		}
+	}
+	return n;
+}
+
-- 
1.4.3.4
