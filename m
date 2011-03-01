From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] multipath: Retry host transient errors for rdac
	checker
Date: Tue, 1 Mar 2011 12:08:24 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF7DC637@cosmail01.lsi.com>
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sometimes if the host is in transient state, we need to wait till the devloss timeout to
expire before switching path group. We have seen in some cases path group switch happens
even before the devloss timeout expire. This patch fixes the problem for rdac checker..

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- multipath-tools/libmultipath/checkers/rdac.c.orig	2011-02-16 13:58:06.000000000 -0600
+++ multipath-tools/libmultipath/checkers/rdac.c	2011-02-17 12:01:23.000000000 -0600
@@ -48,7 +48,9 @@
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = { INQUIRY_CMD, 1, 0, 0, 0, 0 };
 	unsigned char sense_b[SENSE_BUFF_LEN];
 	struct sg_io_hdr io_hdr;
+	int retry_rdac = 5;
 
+retry:
 	inqCmdBlk[2] = (unsigned char) pg_op;
 	inqCmdBlk[4] = (unsigned char) (mx_resp_len & 0xff);
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
@@ -72,6 +74,22 @@
 	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
 	    (0 == io_hdr.driver_status))
 		return 0;
+
+	/* check if we need to retry this error */
+	if (io_hdr.info & SG_INFO_OK_MASK) {
+		switch (io_hdr.host_status) {
+		case DID_BUS_BUSY:
+		case DID_ERROR:
+		case DID_TRANSPORT_DISRUPTED:
+			/* Transport error, retry */
+			if (--retry_rdac)
+				goto retry;
+			break;
+		default:
+			break;
+		}
+	}
+
 	if ((SCSI_CHECK_CONDITION == io_hdr.status) ||
 	    (SCSI_COMMAND_TERMINATED == io_hdr.status) ||
 	    (SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status))) {
