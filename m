From: Brian Wong <bwong@pillardata.com>
Subject: [multipath-tools] [patch] retry tur on reset
Date: Wed, 31 May 2006 13:25:58 -0700
Message-ID: <1149107158.5790.3.camel@ca-bwong3.trans.corp>
Reply-To: bwong@pillardata.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-jZgaljb1wbuJvM3nNOuV"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-jZgaljb1wbuJvM3nNOuV
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

hi christophe,

this patch retries the tur sgio in the tur checker when the status
returned is a scsi reset.  

cheers,

brian

--=-jZgaljb1wbuJvM3nNOuV
Content-Disposition: attachment; filename=diff.out
Content-Type: text/x-patch; name=diff.out; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/libcheckers/tur.c b/libcheckers/tur.c
index d40a273..463dba9 100644
--- a/libcheckers/tur.c
+++ b/libcheckers/tur.c
@@ -43,7 +43,7 @@ tur (struct checker * c)
 	struct sg_io_hdr io_hdr;
         unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
         unsigned char sense_buffer[32];
-
+	
         memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
         io_hdr.interface_id = 'S';
         io_hdr.cmd_len = sizeof (turCmdBlk);
@@ -53,10 +53,28 @@ tur (struct checker * c)
         io_hdr.sbp = sense_buffer;
         io_hdr.timeout = 20000;
         io_hdr.pack_id = 0;
-        if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
+ do_sgio:
+	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
 		MSG(c, MSG_TUR_DOWN);
-                return PATH_DOWN;
-        }
+		return PATH_DOWN;
+	}
+	if (io_hdr.status == SCSI_CHECK_CONDITION) {
+		if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
+			int		sense_key;
+			unsigned char *	sense_buffer = io_hdr.sbp;
+			
+			if (sense_buffer[0] & 0x2)
+				sense_key = sense_buffer[1] & 0xf;
+			else
+				sense_key = sense_buffer[2] & 0xf;
+
+			/* retry UA, SCSI RESET conditions */
+			if (sense_key == 0x06 && sense_buffer[12] == 0x29) {
+				goto do_sgio;
+			}
+			
+		}
+	}
         if (io_hdr.info & SG_INFO_OK_MASK) {
 		MSG(c, MSG_TUR_DOWN);
                 return PATH_DOWN;

--=-jZgaljb1wbuJvM3nNOuV
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-jZgaljb1wbuJvM3nNOuV--
