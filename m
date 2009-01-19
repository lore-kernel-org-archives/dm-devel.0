From: bmarzins@sourceware.org
Subject: multipath-tools kpartx/devmapper.c kpartx/devm ...
Date: 19 Jan 2009 22:34:03 -0000
Message-ID: <20090119223403.2486.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2009-01-19 22:34:02

Modified files:
	kpartx         : devmapper.c devmapper.h gpt.c kpartx.c kpartx.h 
	libmultipath   : parser.c 

Log message:
	Fixes for 455616 and 456457. Make kpartx deal with 64 bit size files, and fix
	the parser issue that makes multipath ignore sections in multipath.conf if
	there isn't a space between the section name and the open brace.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.6.2.2&r2=1.6.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.3.2.2&r2=1.3.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/gpt.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.7.2.3&r2=1.7.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/parser.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.2&r2=1.17.2.3

--- multipath-tools/kpartx/devmapper.c	2008/04/14 22:32:04	1.6.2.2
+++ multipath-tools/kpartx/devmapper.c	2009/01/19 22:34:01	1.6.2.3
@@ -4,10 +4,12 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <stdint.h>
 #include <libdevmapper.h>
 #include <ctype.h>
 #include <linux/kdev_t.h>
 #include <errno.h>
+#include "devmapper.h"
 
 #define UUID_PREFIX "part%d-"
 #define MAX_PREFIX_LEN 8
@@ -72,7 +74,7 @@
 
 extern int
 dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long size, const char *uuid, int part,
+	   const char *params, uint64_t size, const char *uuid, int part,
 	   mode_t mode, uid_t uid, gid_t gid) {
 	int r = 0;
 	struct dm_task *dmt;
--- multipath-tools/kpartx/devmapper.h	2008/04/14 22:32:04	1.3.2.2
+++ multipath-tools/kpartx/devmapper.h	2009/01/19 22:34:01	1.3.2.3
@@ -1,7 +1,7 @@
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
-int dm_addmap (int, const char *, const char *, const char *, unsigned long,
-	       char *, int, mode_t, uid_t, gid_t);
+int dm_addmap (int, const char *, const char *, const char *, uint64_t,
+	       const char *, int, mode_t, uid_t, gid_t);
 int dm_map_present (char *);
 const char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
--- multipath-tools/kpartx/gpt.c	2005/04/11 13:36:50	1.2
+++ multipath-tools/kpartx/gpt.c	2009/01/19 22:34:01	1.2.2.1
@@ -36,6 +36,7 @@
 #include <errno.h>
 #include <endian.h>
 #include <byteswap.h>
+#include <linux/fs.h>
 #include "crc32.h"
 
 #if BYTE_ORDER == LITTLE_ENDIAN
@@ -50,10 +51,18 @@
 #  define __cpu_to_le32(x) bswap_32(x)
 #endif
 
+#ifndef BLKGETLASTSECT
 #define BLKGETLASTSECT  _IO(0x12,108)   /* get last sector of block device */
+#endif
+#ifndef BLKGETSIZE
 #define BLKGETSIZE _IO(0x12,96)	        /* return device size */
+#endif
+#ifndef BLKSSZGET
 #define BLKSSZGET  _IO(0x12,104)	/* get block device sector size */
+#endif
+#ifndef BLKGETSIZE64
 #define BLKGETSIZE64 _IOR(0x12,114,sizeof(uint64_t))	/* return device size in bytes (u64 *arg) */
+#endif
 
 struct blkdev_ioctl_param {
         unsigned int block;
@@ -143,20 +152,14 @@
 static uint64_t
 _get_num_sectors(int filedes)
 {
-	unsigned long sectors=0;
 	int rc;
-#if 0
-        uint64_t bytes=0;
+	uint64_t bytes=0;
 
- 	rc = ioctl(filedes, BLKGETSIZE64, &bytes);
+	rc = ioctl(filedes, BLKGETSIZE64, &bytes);
 	if (!rc)
 		return bytes / get_sector_size(filedes);
-#endif
-        rc = ioctl(filedes, BLKGETSIZE, &sectors);
-        if (rc)
-                return 0;
-        
-	return sectors;
+
+	return 0;
 }
 
 /************************************************************
@@ -193,7 +196,7 @@
 		sectors = 1;
 	}
 
-	return sectors - 1;
+	return sectors ? sectors - 1 : 0;
 }
 
 
@@ -220,17 +223,22 @@
 {
 	int sector_size = get_sector_size(fd);
 	off_t offset = lba * sector_size;
+	uint64_t lastlba;
         ssize_t bytesread;
 
 	lseek(fd, offset, SEEK_SET);
 	bytesread = read(fd, buffer, bytes);
 
+	lastlba = last_lba(fd);
+	if (!lastlba)
+		return bytesread;
+
         /* Kludge.  This is necessary to read/write the last
            block of an odd-sized disk, until Linux 2.5.x kernel fixes.
            This is only used by gpt.c, and only to read
            one sector, so we don't have to be fancy.
         */
-        if (!bytesread && !(last_lba(fd) & 1) && lba == last_lba(fd)) {
+        if (!bytesread && !(lastlba & 1) && lba == lastlba) {
                 bytesread = read_lastoddsector(fd, lba, buffer, bytes);
         }
         return bytesread;
@@ -505,7 +513,8 @@
 	if (!gpt || !ptes)
 		return 0;
 
-	lastlba = last_lba(fd);
+	if (!(lastlba = last_lba(fd)))
+		return 0;
 	good_pgpt = is_gpt_valid(fd, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
         if (good_pgpt) {
--- multipath-tools/kpartx/kpartx.c	2008/04/14 22:32:04	1.7.2.3
+++ multipath-tools/kpartx/kpartx.c	2009/01/19 22:34:01	1.7.2.4
@@ -25,6 +25,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <stdint.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <ctype.h>
@@ -452,10 +453,10 @@
 				if (slices[j].size == 0)
 					continue;
 
-				printf("%s%s%d : 0 %lu %s %lu\n",
+				printf("%s%s%d : 0 %"PRIu64" %s %"PRIu64"\n",
 					device + off, delim, j+1,
-					(unsigned long) slices[j].size, device,
-				        (unsigned long) slices[j].start);
+					slices[j].size, device,
+				        slices[j].start);
 			}
 			break;
 
@@ -501,8 +502,8 @@
 				}
 				strip_slash(partname);
 				
-				if (safe_sprintf(params, "%s %lu", device,
-					     (unsigned long)slices[j].start)) {
+				if (safe_sprintf(params, "%s %"PRIu64, device,
+					     slices[j].start)) {
 					fprintf(stderr, "params too small\n");
 					exit(1);
 				}
@@ -520,7 +521,7 @@
 							partname);
 
 				if (verbose)
-					printf("add map %s : 0 %lu %s %s\n",
+					printf("add map %s : 0 %"PRIu64" %s %s\n",
 						partname, slices[j].size,
 						DM_TARGET, params);
 			}
--- multipath-tools/kpartx/kpartx.h	2006/09/19 21:06:40	1.1.2.1
+++ multipath-tools/kpartx/kpartx.h	2009/01/19 22:34:01	1.1.2.2
@@ -1,6 +1,8 @@
 #ifndef _KPARTX_H
 #define _KPARTX_H
 
+#include <stdint.h>
+
 /*
  * For each partition type there is a routine that takes
  * a block device and a range, and returns the list of
@@ -20,8 +22,8 @@
  * units: 512 byte sectors
  */
 struct slice {
-	unsigned long start;
-	unsigned long size;
+	uint64_t start;
+	uint64_t size;
 };
 
 typedef int (ptreader)(int fd, struct slice all, struct slice *sp, int ns);
--- multipath-tools/libmultipath/parser.c	2007/10/12 17:18:14	1.17.2.2
+++ multipath-tools/libmultipath/parser.c	2009/01/19 22:34:02	1.17.2.3
@@ -2,7 +2,7 @@
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
  *  
- * Version:     $Id: parser.c,v 1.17.2.2 2007/10/12 17:18:14 bmarzins Exp $
+ * Version:     $Id: parser.c,v 1.17.2.3 2009/01/19 22:34:02 bmarzins Exp $
  * 
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *              
@@ -155,12 +155,20 @@
 				in_string = 0;
 			else
 				in_string = 1;
+		} else if (!in_string && (*cp == '{' || *cp == '}')) {
+			token = MALLOC(2);
+
+			if (!token)
+				goto out;
 
+			*(token) = *cp;
+			*(token + 1) = '\0';
+			cp++;
 		} else {
 			while ((in_string ||
 				(!isspace((int) *cp) && isascii((int) *cp) &&
-				 *cp != '!' && *cp != '#')) &&
-			       *cp != '\0' && *cp != '"')
+				 *cp != '!' && *cp != '#' && *cp != '{' &&
+				 *cp != '}')) && *cp != '\0' && *cp != '"')
 				cp++;
 			strlen = cp - start;
 			token = MALLOC(strlen + 1);
