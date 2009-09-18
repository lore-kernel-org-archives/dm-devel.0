From: bmarzins@sourceware.org
Subject: multipath-tools/kpartx dasd.c dasd.h
Date: 18 Sep 2009 22:27:41 -0000
Message-ID: <20090918222741.5469.qmail@sourceware.org>
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
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2009-09-18 22:27:41

Modified files:
	kpartx         : dasd.c dasd.h 

Log message:
	Fix for bz #524009
	Port of large dasd support from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/dasd.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.4.1&r2=1.1.4.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/dasd.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.4.1

--- multipath-tools/kpartx/dasd.c	2007/01/04 19:03:28	1.1.4.1
+++ multipath-tools/kpartx/dasd.c	2009/09/18 22:27:41	1.1.4.2
@@ -6,6 +6,7 @@
  * Mostly taken from drivers/s390/block/dasd.c
  *
  * Copyright (c) 2005, Hannes Reinecke, SUSE Linux Products GmbH
+ * Copyright IBM Corporation, 2009
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -40,7 +41,7 @@
 #include "byteorder.h"
 #include "dasd.h"
 
-unsigned long sectors512(unsigned long sectors, int blocksize)
+unsigned long long sectors512(unsigned long long sectors, int blocksize)
 {
 	return sectors * (blocksize >> 9);
 }
@@ -52,16 +53,14 @@
 {
 	int retval = -1;
 	int blocksize;
-	long disksize;
-	unsigned long offset, size;
+	uint64_t disksize;
+	uint64_t offset, size, fmt_size;
 	dasd_information_t info;
 	struct hd_geometry geo;
 	char type[5] = {0,};
-	char name[7] = {0,};
-	unsigned char *label_raw;
 	volume_label_t vlabel;
 	unsigned char *data = NULL;
-	unsigned int blk;
+	uint64_t blk;
 	int fd_dasd = -1;
 	struct stat sbuf;
 	dev_t dev;
@@ -129,9 +128,10 @@
 	if (ioctl(fd_dasd, HDIO_GETGEO, (unsigned long)&geo) != 0) {
 		goto out;
 	}
-	
-	if (ioctl(fd_dasd, BLKGETSIZE, &disksize) != 0)
+
+	if (ioctl(fd_dasd, BLKGETSIZE64, &disksize) != 0)
 		goto out;
+	disksize >>= 9;
 
 	if (ioctl(fd_dasd, BLKSSZGET, &blocksize) != 0)
 		goto out;
@@ -153,17 +153,14 @@
 		perror("read");
 		goto out;
 	}
-	vtoc_ebcdic_dec(data, type, 4);
 
 	if ((!info.FBA_layout) && (!strcmp(info.type, "ECKD")))
-		label_raw = &data[8];
-	else
-		label_raw = &data[4];
-
-	name[6] = '\0';
-	vtoc_ebcdic_dec(label_raw, name, 6);
-
-	memcpy (&vlabel, data, sizeof(volume_label_t));
+		memcpy (&vlabel, data, sizeof(vlabel));
+	else {
+		bzero(&vlabel,4);
+		memcpy (&vlabel.vollbl, data, sizeof(vlabel) - 4);
+	}
+	vtoc_ebcdic_dec(vlabel.vollbl, type, 4);
 
 	/*
 	 * Three different types: CMS1, VOL1 and LNX1/unlabeled
@@ -172,16 +169,16 @@
 		/*
 		 * VM style CMS1 labeled disk
 		 */
-		int *label = (int *) &vlabel;
+		unsigned int *label = (unsigned int *) &vlabel;
 
-		if (label[13] != 0) {
+		blocksize = label[4];
+		if (label[14] != 0) {
 			/* disk is reserved minidisk */
-			blocksize = label[3];
-			offset = label[13];
-			size   = sectors512(label[7] - 1, blocksize);
+			offset = label[14];
+			size   = sectors512(label[8] - 1, blocksize);
 		} else {
 			offset = info.label_block + 1;
-			size   = disksize;
+			size   = sectors512(label[8], blocksize);
 		}
 		sp[0].start = sectors512(offset, blocksize);
 		sp[0].size  = size - sp[0].start;
@@ -207,18 +204,20 @@
 			/* skip FMT4 / FMT5 / FMT7 labels */
 			if (EBCtoASC[f1.DS1FMTID] == '4'
 			    || EBCtoASC[f1.DS1FMTID] == '5'
-			    || EBCtoASC[f1.DS1FMTID] == '7') {
+			    || EBCtoASC[f1.DS1FMTID] == '7'
+			    || EBCtoASC[f1.DS1FMTID] == '9') {
 			        blk++;
 				continue;
 			}
 
-			/* only FMT1 valid at this point */
-			if (EBCtoASC[f1.DS1FMTID] != '1')
+			/* only FMT1 and FMT8 valid at this point */
+			if (EBCtoASC[f1.DS1FMTID] != '1' &&
+			    EBCtoASC[f1.DS1FMTID] != '8')
 				break;
 
 			/* OK, we got valid partition data */
 		        offset = cchh2blk(&f1.DS1EXT1.llimit, &geo);
-			size  = cchh2blk(&f1.DS1EXT1.ulimit, &geo) - 
+			size  = cchh2blk(&f1.DS1EXT1.ulimit, &geo) -
 				offset + geo.sectors;
 			sp[counter].start = sectors512(offset, blocksize);
 			sp[counter].size  = sectors512(size, blocksize);
@@ -230,8 +229,27 @@
 		/*
 		 * Old style LNX1 or unlabeled disk
 		 */
+		if (strncmp(type, "LNX1", 4) == 0) {
+			if (vlabel.ldl_version == 0xf2) {
+				fmt_size = sectors512(vlabel.formatted_blocks,
+						      blocksize);
+			} else if (!strcmp(info.type, "ECKD")) {
+				/* formated w/o large volume support */
+				fmt_size = geo.cylinders * geo.heads
+					* geo.sectors * (blocksize >> 9);
+			} else {
+				/* old label and no usable disk geometry
+				 * (e.g. DIAG) */
+				fmt_size = disksize;
+			}
+			size = disksize;
+			if (fmt_size < size)
+				size = fmt_size;
+		} else
+			size = disksize;
+
 		sp[0].start = sectors512(info.label_block + 1, blocksize);
-		sp[0].size  = disksize - sp[0].start;
+		sp[0].size  = size - sp[0].start;
 		retval = 1;
 	}
 
--- multipath-tools/kpartx/dasd.h	2006/06/06 18:46:38	1.1
+++ multipath-tools/kpartx/dasd.h	2009/09/18 22:27:41	1.1.4.1
@@ -6,6 +6,7 @@
  * Mostly taken from drivers/s390/block/dasd.c
  *
  * Copyright (c) 2005, Hannes Reinecke, SUSE Linux Products GmbH
+ * Copyright IBM Corporation, 2009
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -66,7 +67,9 @@
 	char labperci[4];       /* no of labels per CI (FBA), blanks for CKD */
 	char res2[4];	        /* reserved                                  */
 	char lvtoc[14];	        /* owner code for LVTOC                      */
-	char res3[29];	        /* reserved                                  */
+	char res3[28];	        /* reserved                                  */
+	char ldl_version;       /* version number, valid for ldl format      */
+	uint64_t formatted_blocks; /* valid when ldl_version >= f2           */
 } __attribute__ ((packed)) volume_label_t;
 
 
@@ -160,6 +163,7 @@
 #define BIODASDINFO _IOR(DASD_IOCTL_LETTER,1,dasd_information_t)
 #define BLKGETSIZE _IO(0x12,96)
 #define BLKSSZGET _IO(0x12,104)
+#define BLKGETSIZE64 _IOR(0x12,114,size_t) /* device size in bytes (u64 *arg)*/
 
 /*
  * Only compile this on S/390. Doesn't make any sense
@@ -239,7 +243,7 @@
 };
 
 static inline void 
-vtoc_ebcdic_dec (const unsigned char *source, char *target, int l) 
+vtoc_ebcdic_dec (const char *source, char *target, int l)
 {
 	int i;
 
@@ -248,24 +252,41 @@
 }
 
 /*
- * compute the block number from a 
+ * compute the block number from a
  * cyl-cyl-head-head structure
  */
-static inline int
-cchh2blk (cchh_t *ptr, struct hd_geometry *geo) {
-        return ptr->cc * geo->heads * geo->sectors +
-	       ptr->hh * geo->sectors;
-}
+static inline uint64_t
+cchh2blk (cchh_t *ptr, struct hd_geometry *geo)
+{
+	uint64_t cyl;
+	uint16_t head;
 
+	/*decode cylinder and heads for large volumes */
+	cyl = ptr->hh & 0xFFF0;
+	cyl <<= 12;
+	cyl |= ptr->cc;
+	head = ptr->hh & 0x000F;
+	return cyl * geo->heads * geo->sectors +
+	       head * geo->sectors;
+}
 
 /*
- * compute the block number from a 
+ * compute the block number from a
  * cyl-cyl-head-head-block structure
  */
-static inline int
-cchhb2blk (cchhb_t *ptr, struct hd_geometry *geo) {
-        return ptr->cc * geo->heads * geo->sectors +
-		ptr->hh * geo->sectors +
+static inline uint64_t
+cchhb2blk (cchhb_t *ptr, struct hd_geometry *geo)
+{
+	uint64_t cyl;
+	uint16_t head;
+
+	/*decode cylinder and heads for large volumes */
+	cyl = ptr->hh & 0xFFF0;
+	cyl <<= 12;
+	cyl |= ptr->cc;
+	head = ptr->hh & 0x000F;
+	return  cyl * geo->heads * geo->sectors +
+		head * geo->sectors +
 		ptr->b;
 }
 
