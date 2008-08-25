From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers tur.c
Date: 25 Aug 2008 21:43:55 -0000
Message-ID: <20080825214355.17736.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-08-25 21:43:54

Modified files:
	libcheckers    : tur.c 

Log message:
	Fix for bz #448655. Tur checker now retries UNIT ATTENTION sense codes up to 5 times,
	to make sure that it doesn't mark a path as failed when the path has simply
	returned a UNIT ATTENTION sense code.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/tur.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4&r2=1.4.2.1

--- multipath-tools/libcheckers/tur.c	2006/07/13 19:49:22	1.4
+++ multipath-tools/libcheckers/tur.c	2008/08/25 21:43:54	1.4.2.1
@@ -41,26 +41,48 @@
 tur (struct checker * c)
 {
 	struct sg_io_hdr io_hdr;
-        unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
-        unsigned char sense_buffer[32];
+	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
+	unsigned char sense_buffer[32];
+	int retry_tur = 5;
 
-        memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
-        io_hdr.interface_id = 'S';
-        io_hdr.cmd_len = sizeof (turCmdBlk);
-        io_hdr.mx_sb_len = sizeof (sense_buffer);
-        io_hdr.dxfer_direction = SG_DXFER_NONE;
-        io_hdr.cmdp = turCmdBlk;
-        io_hdr.sbp = sense_buffer;
-        io_hdr.timeout = DEF_TIMEOUT;
-        io_hdr.pack_id = 0;
-        if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
+retry:
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = sizeof (turCmdBlk);
+	io_hdr.mx_sb_len = sizeof (sense_buffer);
+	io_hdr.dxfer_direction = SG_DXFER_NONE;
+	io_hdr.cmdp = turCmdBlk;
+	io_hdr.sbp = sense_buffer;
+	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.pack_id = 0;
+	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
 		MSG(c, MSG_TUR_DOWN);
-                return PATH_DOWN;
-        }
-        if (io_hdr.info & SG_INFO_OK_MASK) {
+		return PATH_DOWN;
+	}
+	if (io_hdr.info & SG_INFO_OK_MASK) {
+		int key = 0, asc, ascq;
+
+		if (io_hdr.sb_len_wr > 3) {
+			if (io_hdr.sbp[0] == 0x72 || io_hdr.sbp[0] == 0x73) {
+				key = io_hdr.sbp[1] & 0x0f;
+				asc = io_hdr.sbp[2];
+				ascq = io_hdr.sbp[3];
+			} else if (io_hdr.sb_len_wr > 13 &&
+					((io_hdr.sbp[0] & 0x7f) == 0x70 ||
+					 (io_hdr.sbp[0] & 0x7f) == 0x71)) {
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
 		MSG(c, MSG_TUR_DOWN);
-                return PATH_DOWN;
-        }
+		return PATH_DOWN;
+	}
 	MSG(c, MSG_TUR_UP);
-        return PATH_UP;
+	return PATH_UP;
 }
