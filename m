From: Sebastian Herbszt <herbszt@gmx.de>
Subject: multipath-tools: mismatch between CDB allocation length
 and SG_IO dxfer_len
Date: Sat, 5 Apr 2014 13:13:23 +0200
Message-ID: <20140405131323.00000d4b@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Hello,

while playing with multipath-tools and scst I got the following warning:

[ 6382.467569] [3806]: scst: scst_parse_cmd:826:Warning: expected
transfer length 256 for opcode 0x12 (handler vdisk_blockio, target
scst_local) doesn't match decoded value 128
[ 6382.467574] [3806]: scst_parse_cmd:828:Suspicious CDB:
[ 6382.467579]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[ 6382.467581]    0: 12 01 c0 00 80 00   ......

This happened when my scst target pretended to be a CLARiiON.
I noticed a mismatch in emc_clariion_prio (libmultipath/prioritizers/emc.c)
between the allocation length and dxfer_len:

int emc_clariion_prio(const char *dev, int fd)
{
        unsigned char sense_buffer[256];
        unsigned char sb[128];
        unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
                                                sizeof(sb), 0};

...

        memset(&sense_buffer, 0, 256);
        io_hdr.interface_id = 'S';
        io_hdr.cmd_len = sizeof (inqCmdBlk);
        io_hdr.mx_sb_len = sizeof (sb);
        io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
        io_hdr.dxfer_len = sizeof (sense_buffer);
        io_hdr.dxferp = sense_buffer;
        io_hdr.cmdp = inqCmdBlk;
        io_hdr.sbp = sb;
        io_hdr.timeout = 60000;
        io_hdr.pack_id = 0;

The following change shrinks the size of sense_buffer to 128.

Sebastian

diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index 87e9a8d..91b3d90 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -14,15 +14,15 @@
 
 int emc_clariion_prio(const char *dev, int fd)
 {
-	unsigned char sense_buffer[256];
+	unsigned char sense_buffer[128];
 	unsigned char sb[128];
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
-						sizeof(sb), 0};
+						sizeof(sense_buffer), 0};
 	struct sg_io_hdr io_hdr;
 	int ret = PRIO_UNDEF;
 
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
-	memset(&sense_buffer, 0, 256);
+	memset(&sense_buffer, 0, 128);
 	io_hdr.interface_id = 'S';
 	io_hdr.cmd_len = sizeof (inqCmdBlk);
 	io_hdr.mx_sb_len = sizeof (sb);
