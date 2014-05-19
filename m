From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: [PATCH]multipath-tools: Mismatch between allocation
 length and transfer length in rdac prio
Date: Mon, 19 May 2014 14:49:03 +0000
Message-ID: <7973fb83653f408fa27af8d60da6e8c6@hioexcmbx08-prd.hq.netapp.com>
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

Fix mismatch between allocation length and dxfer len in rdac prio.

Signed-off-by: shiva krishna merla <shivakrishna.merla@netapp.com>
---
--- a/libmultipath/prioritizers/rdac.c	2014-02-10 08:55:09.017765026 -0600
+++ b/libmultipath/prioritizers/rdac.c	2014-05-19 07:48:29.416854704 -0500
@@ -14,15 +14,15 @@
 
 int rdac_prio(const char *dev, int fd)
 {
-	unsigned char sense_buffer[256];
+	unsigned char sense_buffer[128];
 	unsigned char sb[128];
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC9, 0,
-						sizeof(sb), 0};
+						sizeof(sense_buffer), 0};
 	struct sg_io_hdr io_hdr;
 	int ret = 0;
 
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
-	memset(sense_buffer, 0, 256);
+	memset(sense_buffer, 0, 128);
 	io_hdr.interface_id = 'S';
 	io_hdr.cmd_len = sizeof (inqCmdBlk);
 	io_hdr.mx_sb_len = sizeof (sb);
--
