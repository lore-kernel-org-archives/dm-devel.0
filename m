From: Levy_Jerome@emc.com
Subject: [PATCH 2.6.9-34] emc_clariion_checker: Additional SCSI
	info on query command error
Date: Wed, 9 Jul 2008 12:49:08 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF6016CBD16@CORPUSMX40B.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

emc_clariion_checker returns a "query command error" but no information
as to what generated the error. The proposed patch adds the
sense/ASC/ASCQ or SCSI/host/driver byte information as available from
the SG_IO interface to assist in troubleshooting. The changes should be
pretty universal but this was built on 2.6.9-34 under the
multipath-tools-0.4.5.56 tree.=20
---
Hope I'm getting this format right. This is my first time submitting a
patch. Please yell directly at me if I'm screwing it up. Thanks...

Jerry Levy, Engineer IV
EMC Global Services Technical Support, PREM ISG
AMER Host Systems Software - UNIX
E-mail: levy_jerome@emc.com
---

--- libcheckers/emc_clariion.c  2008-07-09 12:29:52.000000000 -0400
+++ libcheckers/emc_clariion.c.original 2008-07-09 10:39:05.000000000
-0400
@@ -32,7 +32,6 @@ int emc_clariion(int fd, char *msg, void
        unsigned char sb[128] =3D { 0, };
        unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D {INQUIRY_CMD, 1, 0xC0=
,
0,
                                                sizeof(sb), 0};
-       unsigned char msgbuf[128];
        struct sg_io_hdr io_hdr;
        struct emc_clariion_checker_context * ctxt =3D NULL;
        int ret;
@@ -87,15 +86,7 @@ int emc_clariion(int fd, char *msg, void
                goto out;
        }
        if (io_hdr.info & SG_INFO_OK_MASK) {
-               if(io_hdr.sb_len_wr) {
-                       sprintf(msgbuf,"emc_clariion_checker: query
command error (sense 0x%02X, ASC 0x%02x, ASCQ 0x%02x)",
-
sense_buffer[2],sense_buffer[12],sense_buffer[13]);
-               }
-               else {
-                       sprintf(msgbuf,"emc_clariion_checker: query
command error (SCSI 0x%02X, host 0x%02x, driver 0x%02x)",
-
io_hdr.masked_status,io_hdr.host_status,io_hdr.driver_status);
-               }
-               MSG(msgbuf);
+               MSG("emc_clariion_checker: query command indicates
error");
                ret =3D PATH_DOWN;
                goto out;
        }
