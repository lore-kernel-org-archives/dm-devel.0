From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 6/8] Introduce the ibmultipath/unaligned.h header
	file
Date: Thu,  8 Mar 2018 00:15:49 +0100
Message-ID: <20180307231551.15162-7-mwilck@suse.com>
References: <20180307231551.15162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307231551.15162-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

From: Bart Van Assche <bart.vanassche@wdc.com>

This patch avoids that Coverity reports the following for the code
in libmultipath/prioritizers/alua_rtpg.c:

   CID 173256:  Integer handling issues  (SIGN_EXTENSION)
    Suspicious implicit sign extension: "buf[0]" with type "unsigned char" (8 bits, unsigned) is promoted in "((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) + 4" to type "int" (32 bits, signed), then sign-extended to type "unsigned long" (64 bits, unsigned).  If "((buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3]) + 4" is greater than 0x7FFFFFFF, the upper bits of the result will all be 1.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c      |  8 ++++----
 libmultipath/checkers/hp_sw.c         |  4 ++--
 libmultipath/discovery.c              |  9 +++++----
 libmultipath/prioritizers/alua_rtpg.c | 13 ++++++------
 libmultipath/prioritizers/alua_spc3.h | 35 ++------------------------------
 libmultipath/prioritizers/ontap.c     |  4 ++--
 libmultipath/unaligned.h              | 38 +++++++++++++++++++++++++++++++++++
 7 files changed, 60 insertions(+), 51 deletions(-)
 create mode 100644 libmultipath/unaligned.h

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 29df8c6f2da1..dbed4ca7fad4 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -13,6 +13,7 @@
 #include <libudev.h>
 #include "mpath_pr_ioctl.h"
 #include "mpath_persist.h"
+#include "unaligned.h"
 
 #include "debug.h"
 
@@ -243,10 +244,9 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 		memcpy(&fdesc.key, p, 8 );
 		fdesc.flag = p[12];
 		fdesc.scope_type =  p[13];
-		fdesc.rtpi = ((p[18] << 8) | p[19]);
+		fdesc.rtpi = get_unaligned_be16(&p[18]);
 
-		tid_len_len = ((p[20] << 24) | (p[21] << 16) |
-				(p[22] << 8) | p[23]);
+		tid_len_len = get_unaligned_be32(&p[20]);
 
 		if (tid_len_len > 0)
 			decode_transport_id( &fdesc, &p[24], tid_len_len);
@@ -277,7 +277,7 @@ decode_transport_id(struct prin_fulldescr *fdesc, unsigned char * p, int length)
 			jump = 24;
 			break;
 		case MPATH_PROTOCOL_ID_ISCSI:
-			num = ((p[2] << 8) | p[3]);
+			num = get_unaligned_be16(&p[2]);
 			memcpy(&fdesc->trnptid.iscsi_name, &p[4], num);
 			jump = (((num + 4) < 24) ? 24 : num + 4);
 			break;
diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index 6019c9dbcd9d..cee9aab8d089 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -14,6 +14,7 @@
 #include "checkers.h"
 
 #include "../libmultipath/sg_include.h"
+#include "../libmultipath/unaligned.h"
 
 #define TUR_CMD_LEN		6
 #define INQUIRY_CMDLEN		6
@@ -63,8 +64,7 @@ do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
 	if (evpd)
 		inqCmdBlk[1] |= 1;
 	inqCmdBlk[2] = (unsigned char) pg_op;
-	inqCmdBlk[3] = (unsigned char)((mx_resp_len >> 8) & 0xff);
-	inqCmdBlk[4] = (unsigned char) (mx_resp_len & 0xff);
+	put_unaligned_be16(mx_resp_len, &inqCmdBlk[3]);
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
 	memset(sense_b, 0, SENSE_BUFF_LEN);
 	io_hdr.interface_id = 'S';
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 23e99f05b406..3d38a2550980 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -30,6 +30,7 @@
 #include "discovery.h"
 #include "prio.h"
 #include "defaults.h"
+#include "unaligned.h"
 #include "prioritizers/alua_rtpg.h"
 #include "foreign.h"
 
@@ -850,7 +851,7 @@ sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
 	}
 retry:
 	if (0 == do_inq(fd, 0, 1, pg, buff, len)) {
-		len = buff[3] + (buff[2] << 8) + 4;
+		len = get_unaligned_be16(&buff[2]) + 4;
 		if (len >= maxlen)
 			return len;
 		if (len > DEFAULT_SGIO_LEN)
@@ -881,7 +882,7 @@ static int
 parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 {
 	char *p = NULL;
-	int len = in[3] + (in[2] << 8);
+	int len = get_unaligned_be16(&in[2]);
 
 	if (len >= out_len) {
 		condlog(2, "vpd pg80 overflow, %d/%d bytes required",
@@ -1081,7 +1082,7 @@ get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 			pg, buff[1]);
 		return -ENODATA;
 	}
-	buff_len = (buff[2] << 8) + buff[3] + 4;
+	buff_len = get_unaligned_be16(&buff[2]) + 4;
 	if (buff_len > 4096)
 		condlog(3, "vpd pg%02x page truncated", pg);
 
@@ -1113,7 +1114,7 @@ get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 			pg, buff[1]);
 		return -ENODATA;
 	}
-	buff_len = (buff[2] << 8) + buff[3] + 4;
+	buff_len = get_unaligned_be16(&buff[2]) + 4;
 	if (buff_len > 4096)
 		condlog(3, "vpd pg%02x page truncated", pg);
 
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index e9d83286ff16..e43150200ffc 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -26,6 +26,7 @@
 #include "../structs.h"
 #include "../prio.h"
 #include "../discovery.h"
+#include "../unaligned.h"
 #include "alua_rtpg.h"
 
 #define SENSE_BUFF_LEN  32
@@ -128,7 +129,7 @@ do_inquiry(int fd, int evpd, unsigned int codepage,
 		inquiry_command_set_evpd(&cmd);
 		cmd.page = codepage;
 	}
-	set_uint16(cmd.length, resplen);
+	put_unaligned_be16(resplen, cmd.length);
 	PRINT_HEX((unsigned char *) &cmd, sizeof(cmd));
 
 	memset(&hdr, 0, sizeof(hdr));
@@ -220,7 +221,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
 		if (rc < 0)
 			goto out;
 
-		scsi_buflen = (buf[2] << 8 | buf[3]) + 4;
+		scsi_buflen = get_unaligned_be16(&buf[2]) + 4;
 		/* Paranoia */
 		if (scsi_buflen >= USHRT_MAX)
 			scsi_buflen = USHRT_MAX;
@@ -251,7 +252,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
 				continue;
 			}
 			p  = (struct vpd83_tpg_dscr *)dscr->data;
-			rc = get_uint16(p->tpg);
+			rc = get_unaligned_be16(p->tpg);
 		}
 	}
 
@@ -274,7 +275,7 @@ do_rtpg(int fd, void* resp, long resplen, unsigned int timeout)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.op			= OPERATION_CODE_RTPG;
 	rtpg_command_set_service_action(&cmd);
-	set_uint32(cmd.length, resplen);
+	put_unaligned_be32(resplen, cmd.length);
 	PRINT_HEX((unsigned char *) &cmd, sizeof(cmd));
 
 	memset(&hdr, 0, sizeof(hdr));
@@ -321,7 +322,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
 	rc = do_rtpg(fd, buf, buflen, timeout);
 	if (rc < 0)
 		goto out;
-	scsi_buflen = (buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3]) + 4;
+	scsi_buflen = get_unaligned_be32(&buf[0]) + 4;
 	if (scsi_buflen > UINT_MAX)
 		scsi_buflen = UINT_MAX;
 	if (buflen < scsi_buflen) {
@@ -342,7 +343,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
 	tpgd = (struct rtpg_data *) buf;
 	rc   = -RTPG_TPG_NOT_FOUND;
 	RTPG_FOR_EACH_PORT_GROUP(tpgd, dscr) {
-		if (get_uint16(dscr->tpg) == tpg) {
+		if (get_unaligned_be16(dscr->tpg) == tpg) {
 			if (rc != -RTPG_TPG_NOT_FOUND) {
 				PRINT_DEBUG("get_asymmetric_access_state: "
 					"more than one entry with same port "
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index 13a0924719b4..58d507a5cbc9 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -14,37 +14,6 @@
  */
 #ifndef __SPC3_H__
 #define __SPC3_H__
-/*=============================================================================
- * Some helper functions for getting and setting 16 and 32 bit values.
- *=============================================================================
- */
-static inline unsigned short
-get_uint16(unsigned char *p)
-{
-	return (p[0] << 8) + p[1];
-}
-
-static inline void
-set_uint16(unsigned char *p, unsigned short v)
-{
-	p[0] = (v >> 8) & 0xff;
-	p[1] = v & 0xff;
-}
-
-static inline unsigned int
-get_uint32(unsigned char *p)
-{
-	return (p[0] << 24) + (p[1] << 16) + (p[2] << 8) + p[3];
-}
-
-static inline void
-set_uint32(unsigned char *p, unsigned int v)
-{
-	p[0] = (v >> 24) & 0xff;
-	p[1] = (v >> 16) & 0xff;
-	p[2] = (v >>  8) & 0xff;
-	p[3] = v & 0xff;
-}
 
 /*=============================================================================
  * Definitions to support the standard inquiry command as defined in SPC-3.
@@ -232,7 +201,7 @@ struct vpd83_data {
 		for( \
 			d = p->data; \
 			(((char *) d) - ((char *) p)) < \
-			get_uint16(p->length); \
+			get_unaligned_be16(p->length); \
 			d = (struct vpd83_dscr *) \
 				((char *) d + d->length + 4) \
 		)
@@ -315,7 +284,7 @@ struct rtpg_data {
 #define RTPG_FOR_EACH_PORT_GROUP(p, g) \
 		for( \
 			g = &(p->data[0]); \
-			(((char *) g) - ((char *) p)) < get_uint32(p->length); \
+			(((char *) g) - ((char *) p)) < get_unaligned_be32(p->length); \
 			g = (struct rtpg_tpg_dscr *) ( \
 				((char *) g) + \
 				sizeof(struct rtpg_tpg_dscr) + \
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index ca06d6ce3a9f..6505033f44c9 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -22,6 +22,7 @@
 #include "debug.h"
 #include "prio.h"
 #include "structs.h"
+#include "unaligned.h"
 
 #define INQUIRY_CMD	0x12
 #define INQUIRY_CMDLEN	6
@@ -197,8 +198,7 @@ static int ontap_prio(const char *dev, int fd, unsigned int timeout)
 	memset(&results, 0, sizeof (results));
 	rc = send_gva(dev, fd, 0x41, results, &results_size, timeout);
 	if (rc >= 0) {
-		tot_len = results[0] << 24 | results[1] << 16 |
-			  results[2] << 8 | results[3];
+		tot_len = get_unaligned_be32(&results[0]);
 		if (tot_len <= 8) {
 			goto try_fcp_proxy;
 		}
diff --git a/libmultipath/unaligned.h b/libmultipath/unaligned.h
new file mode 100644
index 000000000000..14ec8b23e397
--- /dev/null
+++ b/libmultipath/unaligned.h
@@ -0,0 +1,38 @@
+#ifndef _UNALIGNED_H_
+#define _UNALIGNED_H_
+
+#include <stdint.h>
+
+static inline uint16_t get_unaligned_be16(const void *ptr)
+{
+	const uint8_t *p = ptr;
+
+	return p[0] << 8 | p[1];
+}
+
+static inline uint32_t get_unaligned_be32(void *ptr)
+{
+	const uint8_t *p = ptr;
+
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline void put_unaligned_be16(uint16_t val, void *ptr)
+{
+	uint8_t *p = ptr;
+
+	p[0] = val >> 8;
+	p[1] = val;
+}
+
+static inline void put_unaligned_be32(uint32_t val, void *ptr)
+{
+	uint8_t *p = ptr;
+
+	p[0] = val >> 24;
+	p[1] = val >> 16;
+	p[2] = val >> 8;
+	p[3] = val;
+}
+
+#endif /* _UNALIGNED_H_ */
-- 
2.16.1
