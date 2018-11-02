From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 13/21] libmultipath: clariion checker: leave
	unsupported paths alone
Date: Fri,  2 Nov 2018 13:21:17 +0100
Message-ID: <20181102122125.30906-14-mwilck@suse.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

A checker shouldn't set the path state to PATH_DOWN if it fails
to obtain information about the path in the first place. Add logic
to the checker to distinguish a failed path from an unsupported path.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/emc_clariion.c | 54 ++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index f8e55b93..6fc89113 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -20,6 +20,11 @@
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
 #define HEAVY_CHECK_COUNT       10
+#define SCSI_COMMAND_TERMINATED	0x22
+#define SCSI_CHECK_CONDITION	0x2
+#define RECOVERED_ERROR		0x01
+#define ILLEGAL_REQUEST		0x05
+#define SG_ERR_DRIVER_SENSE	0x08
 
 /*
  * Mechanism to track CLARiiON inactive snapshot LUs.
@@ -130,7 +135,9 @@ int libcheck_check (struct checker * c)
 		(struct emc_clariion_checker_path_context *)c->context;
 	char wwnstr[33];
 	int ret;
+	int retry_emc = 5;
 
+retry:
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
 	memset(sense_buffer, 0, 128);
 	memset(sb, 0, SENSE_BUFF_LEN);
@@ -145,13 +152,60 @@ int libcheck_check (struct checker * c)
 	io_hdr.timeout = c->timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
+		if (errno == ENOTTY) {
+			c->msgid = CHECKER_MSGID_UNSUPPORTED;
+			return PATH_WILD;
+		}
 		c->msgid = MSG_CLARIION_QUERY_FAILED;
 		return PATH_DOWN;
 	}
+
 	if (io_hdr.info & SG_INFO_OK_MASK) {
+		switch (io_hdr.host_status) {
+		case DID_BUS_BUSY:
+		case DID_ERROR:
+		case DID_SOFT_ERROR:
+		case DID_TRANSPORT_DISRUPTED:
+			/* Transport error, retry */
+			if (--retry_emc)
+				goto retry;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (SCSI_CHECK_CONDITION == io_hdr.status ||
+	    SCSI_COMMAND_TERMINATED == io_hdr.status ||
+	    SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status)) {
+		if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
+			unsigned char *sbp = io_hdr.sbp;
+			int sense_key;
+
+			if (sbp[0] & 0x2)
+				sense_key = sbp[1] & 0xf;
+			else
+				sense_key = sbp[2] & 0xf;
+
+			if (sense_key == ILLEGAL_REQUEST) {
+				c->msgid = CHECKER_MSGID_UNSUPPORTED;
+				return PATH_WILD;
+			} else if (sense_key != RECOVERED_ERROR) {
+				condlog(1, "emc_clariion_checker: INQUIRY failed with sense key %02x",
+					sense_key);
+				c->msgid = MSG_CLARIION_QUERY_ERROR;
+				return PATH_DOWN;
+			}
+		}
+	}
+
+	if (io_hdr.info & SG_INFO_OK_MASK) {
+		condlog(1, "emc_clariion_checker: INQUIRY failed without sense, status %02x",
+			io_hdr.status);
 		c->msgid = MSG_CLARIION_QUERY_ERROR;
 		return PATH_DOWN;
 	}
+
 	if (/* Verify the code page - right page & revision */
 	    sense_buffer[1] != 0xc0 || sense_buffer[9] != 0x00) {
 		c->msgid = MSG_CLARIION_UNIT_REPORT;
-- 
2.19.1
