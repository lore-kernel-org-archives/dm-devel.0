From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: multipath-tools: mismatch between CDB allocation
 length and SG_IO dxfer_len
Date: Thu, 22 May 2014 00:46:30 +0200
Message-ID: <20140522004630.00003f9a@localhost>
References: <20140405131323.00000d4b@localhost>
	<20140521131429.00005192@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140521131429.00005192@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

> Hi,
> 
> have you verified this part is not enough to fix the problem, without
> shrinking the response size to 128 ?
> 
>         unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
> -                                               sizeof(sb), 0};
> +                                               sizeof(sense_buffer), 0};

sizeof(sense_buffer) is 256 and it gets truncated to 0:

ioctl(4, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[6]=[12, 01, c0, 00, 00, 00], ...

[ 3730.100199] [5674]: scst: scst_parse_cmd:828:Warning: expected transfer length 256 for opcode INQUIRY (handler vdisk_blockio, target scst_local) doesn't match decoded value 0
[ 3730.100203] [5674]: scst_parse_cmd:830:Suspicious CDB:
[ 3730.100204]  (h)___0__1__2__3__4__5__6__7__8__9__A__B__C__D__E__F
[ 3730.100206]    0: 12 01 c0 00 00 00   ......

This works

@@ -16,8 +16,9 @@ int emc_clariion_prio(const char *dev, int fd)
 {
        unsigned char sense_buffer[256];
        unsigned char sb[128];
-       unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
-                                               sizeof(sb), 0};
+       unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0,
+                                       (sizeof(sense_buffer) >> 8) & 0xff,
+                                       sizeof(sense_buffer) & 0xff,  0};
        struct sg_io_hdr io_hdr;
        int ret = PRIO_UNDEF;

but I am not sure a buffer of 256 is required, because the checker just uses
128 bytes for the same page.

> Is it me or the variable name is just plain misleading ?

Should be "resp" or something like that.

> Best regards,
> Christophe Varoqui
> www.opensvc.com

Please keep me CC'ed in replies.

Sebastian
