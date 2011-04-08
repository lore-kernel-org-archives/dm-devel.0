From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 1/1] multipath-tools: Set the rdac TAS bit if it
	changeable
Date: Fri, 8 Apr 2011 13:02:44 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFAC96A9@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>
List-Id: dm-devel.ids

This patch sets the rdac TAS bit if it is changeable. This is called only once
per lun during the discovery.
The Task Aborted Status (TAS) bit in Control Mode Page (Page 0x0A) controls
the behavior of aborted tasks. By default, the TAS bit is set to zero. The
rdac checker should issue a mode sense page 0x0A to determine the TAS bit
value and whether or not the TAS bit is changeable. If the TAS bit is set
to 0 and changeable, the rdac checker should issue a mode select page 0x0A
to change TAS to 1 and save it.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by  : Yanling Qi <yanling.qi@lsi.com>
Reviewed-by  : Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>

---
--- multipath-tools/libmultipath/checkers/rdac.c.orig	2011-04-08 10:08:42.000000000 -0500
+++ multipath-tools/libmultipath/checkers/rdac.c	2011-04-08 10:22:21.000000000 -0500
@@ -12,27 +12,113 @@
 #include <errno.h>
 
 #include "checkers.h"
+#include "debug.h"
 
 #include "../libmultipath/sg_include.h"
 
 #define INQUIRY_CMDLEN		6
 #define INQUIRY_CMD		0x12
+#define MODE_SENSE_CMD		0x5a
+#define MODE_SELECT_CMD		0x55
+#define MODE_SEN_SEL_CMDLEN	10
 #define SENSE_BUFF_LEN		32
 #define SCSI_CHECK_CONDITION	0x2
 #define SCSI_COMMAND_TERMINATED	0x22
 #define SG_ERR_DRIVER_SENSE	0x08
 #define RECOVERED_ERROR		0x01
 
+
+#define CURRENT_PAGE_CODE_VALUES	0
+#define CHANGEABLE_PAGE_CODE_VALUES 	1
+
 #define MSG_RDAC_UP    "rdac checker reports path is up"
 #define MSG_RDAC_DOWN  "rdac checker reports path is down"
 #define MSG_RDAC_GHOST "rdac checker reports path is ghost"
 
+struct control_mode_page {
+	unsigned char header[8];
+	unsigned char page_code;
+	unsigned char page_len;
+	unsigned char dontcare0[3];
+	unsigned char tas_bit;
+	unsigned char dontcare1[6];
+};
+
 struct rdac_checker_context {
 	void * dummy;
 };
 
 int libcheck_init (struct checker * c)
 {
+	unsigned char cmd[MODE_SEN_SEL_CMDLEN];
+	unsigned char sense_b[SENSE_BUFF_LEN];
+	struct sg_io_hdr io_hdr;
+	struct control_mode_page current, changeable;
+	int set = 0;
+
+	memset(cmd, 0, MODE_SEN_SEL_CMDLEN);
+	cmd[0] = MODE_SENSE_CMD;
+	cmd[1] = 0x08; /* DBD bit on */
+	cmd[2] = 0xA + (CURRENT_PAGE_CODE_VALUES << 6);
+	cmd[8] = (sizeof(struct control_mode_page) &  0xff);
+
+	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
+	memset(sense_b, 0, SENSE_BUFF_LEN);
+	memset(&current, 0, sizeof(struct control_mode_page));
+
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = MODE_SEN_SEL_CMDLEN;
+	io_hdr.mx_sb_len = sizeof(sense_b);
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = (sizeof(struct control_mode_page) &  0xff);
+	io_hdr.dxferp = &current;
+	io_hdr.cmdp = cmd;
+	io_hdr.sbp = sense_b;
+	io_hdr.timeout = c->timeout;
+
+	if (ioctl(c->fd, SG_IO, &io_hdr) < 0)
+		goto out;
+
+	/* check the TAS bit to see if it is already set */
+	if ((current.tas_bit >> 6) & 0x1) {
+		set = 1;
+		goto out;
+	}
+
+	/* get the changeble values */
+	cmd[2] = 0xA + (CHANGEABLE_PAGE_CODE_VALUES << 6);
+	io_hdr.dxferp = &changeable;
+	memset(&changeable, 0, sizeof(struct control_mode_page));
+
+	if (ioctl(c->fd, SG_IO, &io_hdr) < 0)
+		goto out;
+
+	/* if TAS bit is not settable exit */
+	if (((changeable.tas_bit >> 6) & 0x1) == 0)
+		goto out;
+
+	/* Now go ahead and set it */
+	memset(cmd, 0, MODE_SEN_SEL_CMDLEN);
+	cmd[0] = MODE_SELECT_CMD;
+	cmd[1] = 0x1; /* set SP bit on */
+	cmd[8] = (sizeof(struct control_mode_page) &  0xff);
+
+	/* use the same buffer as current, only set the tas bit */
+	current.page_code = 0xA;
+	current.page_len = 0xA;
+	current.tas_bit |= (1 << 6);
+
+	io_hdr.dxfer_direction = SG_DXFER_TO_DEV;
+	io_hdr.dxferp = &current;
+
+	if (ioctl(c->fd, SG_IO, &io_hdr) < 0)
+		goto out;
+
+	/* Success */
+	set = 1;
+out:
+	if (set == 0)
+		condlog(0, "rdac checker failed to set TAS bit");
 	return 0;
 }
 
