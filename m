From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Improve sense code scanning in sg_read() and tur
	checker
Date: Wed, 30 Apr 2008 11:03:45 +0200
Message-ID: <20080430090345.8558D18C6FF@pentland.suse.de>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


sg_read and tur should be able to correctly parse sense data,
as we might need to retry any UNIT ATTENTION sense codes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers/libsg.c |   13 ++++++++-
 libmultipath/checkers/tur.c   |   58 ++++++++++++++++++++++++++++------------
 2 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/libmultipath/checkers/libsg.c b/libmultipath/checkers/libsg.c
index 9171b10..4cb7ecc 100644
--- a/libmultipath/checkers/libsg.c
+++ b/libmultipath/checkers/libsg.c
@@ -72,10 +72,21 @@ retry:
 	    (0 == io_hdr.driver_status)) {
 		return PATH_UP;
 	} else {
+		int key = 0;
+
+		if (io_hdr.sb_len_wr > 3) {
+			if (sbb[0] == 0x72 || sbb[0] == 0x73)
+				key = sbb[1] & 0x0f;
+			else if (io_hdr.sb_len_wr > 13 &&
+				 ((sbb[0] & 0x7f) == 0x70 ||
+				  (sbb[0] & 0x7f) == 0x71))
+				key = sbb[2] & 0x0f;
+		}
+
 		/*
 		 * Retry if UNIT_ATTENTION check condition.
 		 */
-		if ((sbb[2]&0xf) == 6) {
+		if (key == 0x6) {
 			if (--retry_count)
 				goto retry;
 		}
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index e84435e..43b846d 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -41,26 +41,48 @@ extern int
 libcheck_check (struct checker * c)
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
+ retry:
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
 		MSG(c, MSG_TUR_DOWN);
-                return PATH_DOWN;
-        }
+		return PATH_DOWN;
+	}
 	MSG(c, MSG_TUR_UP);
-        return PATH_UP;
+	return PATH_UP;
 }
-- 
1.5.2.4
