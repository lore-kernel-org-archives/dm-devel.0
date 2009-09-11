From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers readsector0.c
Date: 11 Sep 2009 14:33:29 -0000
Message-ID: <20090911143329.2131.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-09-11 14:33:28

Modified files:
	libcheckers    : readsector0.c 

Log message:
	Backported scsi sense buffer retry code from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/readsector0.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1

--- multipath-tools/libcheckers/readsector0.c	2006/07/13 19:49:22	1.5
+++ multipath-tools/libcheckers/readsector0.c	2009/09/11 14:33:28	1.5.2.1
@@ -14,6 +14,7 @@
 #include "checkers.h"
 
 #include "../libmultipath/sg_include.h"
+#include "../libmultipath/debug.h"
 
 #define SENSE_BUFF_LEN 32
 
@@ -50,6 +51,7 @@
 	int res;
 	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
 	int sz_ind;
+	int retry_count = 3;
 	
 	memset(rdCmd, 0, cdbsz);
 	sz_ind = 1;
@@ -75,6 +77,8 @@
 	if (diop && *diop)
 	io_hdr.flags |= SG_FLAG_DIRECT_IO;
 
+retry:
+	memset(senseBuff, 0, SENSE_BUFF_LEN);
 	while (((res = ioctl(sg_fd, SG_IO, &io_hdr)) < 0) && (EINTR == errno));
 
 	if (res < 0) {
@@ -89,6 +93,24 @@
 	    (0 == io_hdr.driver_status)) {
 		return PATH_UP;
 	} else {
+		int key = 0;
+
+		if (io_hdr.sb_len_wr > 3) {
+			if (senseBuff[0] == 0x72 || senseBuff[0] == 0x73)
+				key = senseBuff[1] & 0x0f;
+			else if (io_hdr.sb_len_wr > 13 &&
+				 ((senseBuff[0] & 0x7f) == 0x70 ||
+				  (senseBuff[0] & 0x7f) == 0x71))
+				key = senseBuff[2] & 0x0f;
+		}
+
+		/*
+		 * Retry if UNIT_ATTENTION check condition.
+		 */
+		if (key == 0x6) {
+			if (--retry_count)
+				goto retry;
+		}
 		return PATH_DOWN;
 	}
 }
