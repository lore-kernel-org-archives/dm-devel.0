From: bmarzins@sourceware.org
Subject: multipath-tools/kpartx dasd.c
Date: 4 Jan 2007 19:03:28 -0000
Message-ID: <20070104190328.14354.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-01-04 19:03:28

Modified files:
	kpartx         : dasd.c 

Log message:
	Add Stefan Bader's dasd partition fix.
	
	Note: with the dasd partition fix, it may be necessary to remake the file
	system on the device, because the superblock may no longer be at the same
	location in the partition.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/dasd.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.4.1

--- multipath-tools/kpartx/dasd.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/kpartx/dasd.c	2007/01/04 19:03:28	1.1.4.1
@@ -40,14 +40,20 @@
 #include "byteorder.h"
 #include "dasd.h"
 
+unsigned long sectors512(unsigned long sectors, int blocksize)
+{
+	return sectors * (blocksize >> 9);
+}
+
 /*
  */
 int 
 read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 {
 	int retval = -1;
-	int blocksize, offset, size;
+	int blocksize;
 	long disksize;
+	unsigned long offset, size;
 	dasd_information_t info;
 	struct hd_geometry geo;
 	char type[5] = {0,};
@@ -172,13 +178,13 @@
 			/* disk is reserved minidisk */
 			blocksize = label[3];
 			offset = label[13];
-			size = (label[7] - 1)*(blocksize >> 9);
+			size   = sectors512(label[7] - 1, blocksize);
 		} else {
-			offset = (info.label_block + 1) * (blocksize >> 9);
-			size = disksize - offset;
+			offset = info.label_block + 1;
+			size   = disksize;
 		}
-		sp[0].start = offset * (blocksize >> 9);
-		sp[0].size = size - offset * (blocksize >> 9);
+		sp[0].start = sectors512(offset, blocksize);
+		sp[0].size  = size - sp[0].start;
 		retval = 1;
 	} else if ((strncmp(type, "VOL1", 4) == 0) &&
 		(!info.FBA_layout) && (!strcmp(info.type, "ECKD"))) {
@@ -214,8 +220,8 @@
 		        offset = cchh2blk(&f1.DS1EXT1.llimit, &geo);
 			size  = cchh2blk(&f1.DS1EXT1.ulimit, &geo) - 
 				offset + geo.sectors;
-			sp[counter].start = offset * (blocksize >> 9);
-			sp[counter].size = size * (blocksize >> 9);
+			sp[counter].start = sectors512(offset, blocksize);
+			sp[counter].size  = sectors512(size, blocksize);
 			counter++;
 			blk++;
 		}
@@ -224,10 +230,8 @@
 		/*
 		 * Old style LNX1 or unlabeled disk
 		 */
-		offset = (info.label_block + 1) * (blocksize >> 9);
-		size = disksize - offset;
-		sp[0].start = offset * (blocksize >> 9);
-		sp[0].size = size - offset * (blocksize >> 9);
+		sp[0].start = sectors512(info.label_block + 1, blocksize);
+		sp[0].size  = disksize - sp[0].start;
 		retval = 1;
 	}
 
