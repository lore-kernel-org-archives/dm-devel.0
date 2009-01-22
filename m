From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers tur.c
Date: 22 Jan 2009 22:20:19 -0000
Message-ID: <20090122222019.11216.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-01-22 22:20:18

Modified files:
	libcheckers    : tur.c 

Log message:
	Fix for bz #449886. Just backporting the tur retry code to RHEL4.  This fix is
	already in RHEL5 and upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/tur.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1

--- multipath-tools/libcheckers/tur.c	2005/11/16 20:24:57	1.2
+++ multipath-tools/libcheckers/tur.c	2009/01/22 22:20:18	1.2.2.1
@@ -36,6 +36,7 @@
         struct sg_io_hdr io_hdr;
         unsigned char sense_buffer[32];
 	struct tur_checker_context * ctxt = NULL;
+	int retry_tur = 5;
 	int ret;
 
 	/*
@@ -71,6 +72,7 @@
 		goto out;
 	}
 	
+retry:
         memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
         io_hdr.interface_id = 'S';
         io_hdr.cmd_len = sizeof (turCmdBlk);
@@ -86,6 +88,26 @@
 		goto out;
         }
         if (io_hdr.info & SG_INFO_OK_MASK) {
+		int key = 0, asc, ascq;
+
+		if (io_hdr.sb_len_wr > 3) {
+			if (io_hdr.sbp[0] == 0x72 || io_hdr.sbp[0] == 0x73) {
+				key = io_hdr.sbp[1] & 0x0f;
+				asc = io_hdr.sbp[2];
+				ascq = io_hdr.sbp[3];
+			} else if (io_hdr.sb_len_wr > 13 &&
+				   ((io_hdr.sbp[0] & 0x7f) == 0x70 ||
+				    (io_hdr.sbp[0] & 0x7f) == 0x71)) {
+				key = io_hdr.sbp[2] & 0x0f;
+				asc = io_hdr.sbp[12];
+				ascq = io_hdr.sbp[13];
+			}
+		}
+		if (key == 0x6) {
+			/* Unit Attention, retry */
+			if (--retry_tur)
+				goto retry;
+		}
 		MSG(MSG_TUR_DOWN);
                 ret = PATH_DOWN;
 		goto out;
