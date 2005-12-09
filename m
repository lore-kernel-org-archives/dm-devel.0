From: Hannes Reinecke <hare@suse.de>
Subject: [kpartx] Resend: add support for S/390 DASD
Date: Fri, 09 Dec 2005 12:48:23 +0100
Message-ID: <43996F07.2090206@suse.de>
References: <4396ECC5.2090202@suse.de> <1133995475.5650.54.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050802060901090809080201"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1133995475.5650.54.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050802060901090809080201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christophe Varoqui wrote:
> On mer, 2005-12-07 at 15:08 +0100, Hannes Reinecke wrote:
>> Hi Christophe,
>>
>> this patch adds kpartx support for S/390 DASD partitions.
>> Helpful when using multipath-tools on them.
>>
> Looks promising.
>=20
> Can you split the fix [1] from the rest and include the dasd.c you seem=

> to have left out.
>=20
Errm. Of course.
Here is it.

The fix [1] is already sent (check for 'fix mapname length').

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050802060901090809080201
Content-Type: text/x-patch;
 name="kpartx-dasd-support.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="kpartx-dasd-support.patch"

[kpartx] Add suport for S/390 ECKD DASD

This patch adds support for S/390 ECKD DASD partition tables.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/kpartx/Makefile b/kpartx/Makefile
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -10,11 +10,11 @@ CFLAGS =3D -pipe -g -Wall -Wunused -Wstric
=20
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS =3D bsd.o dos.o kpartx.o solaris.o unixware.o gpt.o crc32.o \
-	       lopart.o xstrncpy.o devmapper.o \
+	       lopart.o xstrncpy.o devmapper.o dasd.o \
 	       $(MULTIPATHLIB)-$(BUILD).a $(libdm)
 else
 	LDFLAGS =3D -ldevmapper
-	OBJS =3D bsd.o dos.o kpartx.o solaris.o unixware.o \
+	OBJS =3D bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o \
 	       gpt.o crc32.o lopart.o xstrncpy.o devmapper.o
 endif
=20
diff --git a/kpartx/dasd.c b/kpartx/dasd.c
new file mode 100644
--- /dev/null
+++ b/kpartx/dasd.c
@@ -0,0 +1,240 @@
+/*
+ * dasd.c
+ *
+ * IBM DASD partition table handling.
+ *
+ * Mostly taken from drivers/s390/block/dasd.c
+ *
+ * Copyright (c) 2005, Hannes Reinecke, SUSE Linux Products GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307=
,
+ * USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <inttypes.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/hdreg.h>
+#include <errno.h>
+#include <string.h>
+#include <fcntl.h>
+#include <libdevmapper.h>
+#include "devmapper.h"
+#include "kpartx.h"
+#include "byteorder.h"
+#include "dasd.h"
+
+/*
+ */
+int=20
+read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
+{
+	int retval =3D -1;
+	int blocksize, offset, size;
+	long disksize;
+	dasd_information_t info;
+	struct hd_geometry geo;
+	char type[5] =3D {0,};
+	char name[7] =3D {0,};
+	char *label_raw;
+	volume_label_t vlabel;
+	unsigned char *data =3D NULL;
+	unsigned int blk;
+	int fd_dasd =3D -1;
+	struct stat sbuf;
+	dev_t dev;
+	char *devname;
+	char pathname[256];
+
+	if (fd < 0) {
+		return -1;
+	}
+
+	if (fstat(fd, &sbuf) =3D=3D -1) {
+		return -1;
+	}
+
+	devname =3D dm_mapname(major(sbuf.st_rdev), minor(sbuf.st_rdev));
+
+	if (devname !=3D NULL) {
+		/* We were passed a handle to a dm device.
+		 * Get the first target and operate on that instead.
+		 */
+		if (!(dev =3D dm_get_first_dep(devname))) {
+			free(devname);
+			return -1;
+		}
+		free(devname);
+
+		if ((unsigned int)major(dev) !=3D 94) {
+			/* Not a DASD */
+			return -1;
+		}
+
+		/*
+		 * Hard to believe, but there's no simple way to translate
+		 * major/minor into an openable device file, so we have
+		 * to create one for ourselves.
+		 */
+	=09
+		sprintf(pathname, "/dev/.kpartx-node-%u-%u",
+			(unsigned int)major(dev), (unsigned int)minor(dev));
+		if ((fd_dasd =3D open(pathname, O_RDONLY)) =3D=3D -1) {
+			/* Devicenode does not exist. Try to create one */
+			if (mknod(pathname, 0600 | S_IFBLK, dev) =3D=3D -1) {
+				/* Couldn't create a device node */
+				return -1;
+			}
+			fd_dasd =3D open(pathname, O_RDONLY);
+			/*
+			 * The file will vanish when the last process (we)
+			 * has ceased to access it.
+			 */
+			unlink(pathname);
+		}
+		if (!fd_dasd) {
+			/* Couldn't open the device */
+			return -1;
+		}
+	} else {
+		fd_dasd =3D fd;
+	}
+
+	if (ioctl(fd_dasd, BIODASDINFO, (unsigned long)&info) !=3D 0) {
+		goto out;
+	}
+
+	if (ioctl(fd_dasd, HDIO_GETGEO, (unsigned long)&geo) !=3D 0) {
+		goto out;
+	}
+=09
+	if (ioctl(fd_dasd, BLKGETSIZE, &disksize) !=3D 0)
+		goto out;
+
+	if (ioctl(fd_dasd, BLKSSZGET, &blocksize) !=3D 0)
+		goto out;
+
+	if (blocksize < 512 || blocksize > 4096)
+		goto out;
+
+	/*
+	 * Get volume label, extract name and type.
+	 */
+
+	if (!(data =3D (unsigned char *)malloc(blocksize)))
+		goto out;
+
+
+	if (lseek(fd_dasd, info.label_block * blocksize, SEEK_SET) =3D=3D -1)
+		goto out;
+	if (read(fd_dasd, data, blocksize) =3D=3D -1) {
+		perror("read");
+		goto out;
+	}
+	vtoc_ebcdic_dec(data, type, 4);
+
+	if ((!info.FBA_layout) && (!strcmp(info.type, "ECKD")))
+		label_raw =3D &data[8];
+	else
+		label_raw =3D &data[4];
+
+	name[6] =3D '\0';
+	vtoc_ebcdic_dec(label_raw, name, 6);
+
+	memcpy (&vlabel, data, sizeof(volume_label_t));
+
+	/*
+	 * Three different types: CMS1, VOL1 and LNX1/unlabeled
+	 */
+	if (strncmp(type, "CMS1", 4) =3D=3D 0) {
+		/*
+		 * VM style CMS1 labeled disk
+		 */
+		int *label =3D (int *) &vlabel;
+
+		if (label[13] !=3D 0) {
+			/* disk is reserved minidisk */
+			blocksize =3D label[3];
+			offset =3D label[13];
+			size =3D (label[7] - 1)*(blocksize >> 9);
+		} else {
+			offset =3D (info.label_block + 1) * (blocksize >> 9);
+			size =3D disksize - offset;
+		}
+		sp[0].start =3D offset * (blocksize >> 9);
+		sp[0].size =3D size - offset * (blocksize >> 9);
+		retval =3D 1;
+	} else if ((strncmp(type, "VOL1", 4) =3D=3D 0) &&
+		(!info.FBA_layout) && (!strcmp(info.type, "ECKD"))) {
+		/*
+		 * New style VOL1 labeled disk
+		 */
+		int counter;
+
+		/* get block number and read then go through format1 labels */
+		blk =3D cchhb2blk(&vlabel.vtoc, &geo) + 1;
+		counter =3D 0;
+		if (lseek(fd_dasd, blk * blocksize, SEEK_SET) =3D=3D -1)
+			goto out;
+
+		while (read(fd_dasd, data, blocksize) !=3D -1) {
+			format1_label_t f1;
+
+			memcpy(&f1, data, sizeof(format1_label_t));
+
+			/* skip FMT4 / FMT5 / FMT7 labels */
+			if (EBCtoASC[f1.DS1FMTID] =3D=3D '4'
+			    || EBCtoASC[f1.DS1FMTID] =3D=3D '5'
+			    || EBCtoASC[f1.DS1FMTID] =3D=3D '7') {
+			        blk++;
+				continue;
+			}
+
+			/* only FMT1 valid at this point */
+			if (EBCtoASC[f1.DS1FMTID] !=3D '1')
+				break;
+
+			/* OK, we got valid partition data */
+		        offset =3D cchh2blk(&f1.DS1EXT1.llimit, &geo);
+			size  =3D cchh2blk(&f1.DS1EXT1.ulimit, &geo) -=20
+				offset + geo.sectors;
+			sp[counter].start =3D offset * (blocksize >> 9);
+			sp[counter].size =3D size * (blocksize >> 9);
+			counter++;
+			blk++;
+		}
+		retval =3D counter;
+	} else {
+		/*
+		 * Old style LNX1 or unlabeled disk
+		 */
+		offset =3D (info.label_block + 1) * (blocksize >> 9);
+		size =3D disksize - offset;
+		sp[0].start =3D offset * (blocksize >> 9);
+		sp[0].size =3D size - offset * (blocksize >> 9);
+		retval =3D 1;
+	}
+
+ out:
+	if (data !=3D NULL)
+		free(data);
+	if (fd_dasd !=3D -1 && fd_dasd !=3D fd)
+		close(fd_dasd);
+	return retval;
+}
diff --git a/kpartx/dasd.h b/kpartx/dasd.h
new file mode 100644
--- /dev/null
+++ b/kpartx/dasd.h
@@ -0,0 +1,272 @@
+/*
+ * dasd.h
+ *
+ * IBM DASD partition table handling.
+ *
+ * Mostly taken from drivers/s390/block/dasd.c
+ *
+ * Copyright (c) 2005, Hannes Reinecke, SUSE Linux Products GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307=
,
+ * USA.
+ */
+
+#ifndef _DASD_H
+#define _DASD_H
+
+typedef struct ttr=20
+{
+        uint16_t tt;
+        uint8_t  r;
+} __attribute__ ((packed)) ttr_t;
+
+typedef struct cchhb=20
+{
+        uint16_t cc;
+        uint16_t hh;
+        uint8_t b;
+} __attribute__ ((packed)) cchhb_t;
+
+typedef struct cchh=20
+{
+        uint16_t cc;
+        uint16_t hh;
+} __attribute__ ((packed)) cchh_t;
+
+typedef struct labeldate=20
+{
+        uint8_t  year;
+        uint16_t day;
+} __attribute__ ((packed)) labeldate_t;
+
+
+typedef struct volume_label=20
+{
+        char volkey[4];         /* volume key =3D volume label          =
       */
+	char vollbl[4];	        /* volume label                              */=

+	char volid[6];	        /* volume identifier                         */
+	uint8_t security;	        /* security byte                             =
*/
+	cchhb_t vtoc;           /* VTOC address                              */=

+	char res1[5];	        /* reserved                                  */
+        char cisize[4];	        /* CI-size for FBA,...                  =
     */
+                                /* ...blanks for CKD                    =
     */
+	char blkperci[4];       /* no of blocks per CI (FBA), blanks for CKD */=

+	char labperci[4];       /* no of labels per CI (FBA), blanks for CKD */=

+	char res2[4];	        /* reserved                                  */
+	char lvtoc[14];	        /* owner code for LVTOC                      */=

+	char res3[29];	        /* reserved                                  */
+} __attribute__ ((packed)) volume_label_t;
+
+
+typedef struct extent=20
+{
+        uint8_t  typeind;          /* extent type indicator             =
        */
+        uint8_t  seqno;            /* extent sequence number            =
        */
+        cchh_t llimit;          /* starting point of this extent        =
     */
+        cchh_t ulimit;          /* ending point of this extent          =
     */
+} __attribute__ ((packed)) extent_t;
+
+
+typedef struct dev_const=20
+{
+        uint16_t DS4DSCYL;           /* number of logical cyls          =
        */
+        uint16_t DS4DSTRK;           /* number of tracks in a logical cy=
linder  */
+        uint16_t DS4DEVTK;           /* device track length             =
        */
+        uint8_t  DS4DEVI;            /* non-last keyed record overhead  =
        */
+        uint8_t  DS4DEVL;            /* last keyed record overhead      =
        */
+        uint8_t  DS4DEVK;            /* non-keyed record overhead differ=
ential  */
+        uint8_t  DS4DEVFG;           /* flag byte                       =
        */
+        uint16_t DS4DEVTL;           /* device tolerance                =
        */
+        uint8_t  DS4DEVDT;           /* number of DSCB's per track      =
        */
+        uint8_t  DS4DEVDB;           /* number of directory blocks per t=
rack    */
+} __attribute__ ((packed)) dev_const_t;
+
+
+typedef struct format1_label=20
+{
+	char  DS1DSNAM[44];       /* data set name                           */=

+	uint8_t  DS1FMTID;           /* format identifier                      =
 */
+	char  DS1DSSN[6];         /* data set serial number                  */=

+	uint16_t DS1VOLSQ;           /* volume sequence number                 =
 */
+	labeldate_t DS1CREDT;     /* creation date: ydd                      */=

+	labeldate_t DS1EXPDT;     /* expiration date                         */=

+	uint8_t  DS1NOEPV;           /* number of extents on volume            =
 */
+        uint8_t  DS1NOBDB;           /* no. of bytes used in last direct=
ion blk */
+	uint8_t  DS1FLAG1;           /* flag 1                                 =
 */
+	char  DS1SYSCD[13];       /* system code                             */=

+	labeldate_t DS1REFD;      /* date last referenced                    */=

+        uint8_t  DS1SMSFG;           /* system managed storage indicator=
s       */
+        uint8_t  DS1SCXTF;           /* sec. space extension flag byte  =
        */
+        uint16_t DS1SCXTV;           /* secondary space extension value =
        */
+        uint8_t  DS1DSRG1;           /* data set organisation byte 1    =
        */
+        uint8_t  DS1DSRG2;           /* data set organisation byte 2    =
        */
+  	uint8_t  DS1RECFM;           /* record format                        =
   */
+	uint8_t  DS1OPTCD;           /* option code                            =
 */
+	uint16_t DS1BLKL;            /* block length                           =
 */
+	uint16_t DS1LRECL;           /* record length                          =
 */
+	uint8_t  DS1KEYL;            /* key length                             =
 */
+	uint16_t DS1RKP;             /* relative key position                  =
 */
+	uint8_t  DS1DSIND;           /* data set indicators                    =
 */
+        uint8_t  DS1SCAL1;           /* secondary allocation flag byte  =
        */
+  	char DS1SCAL3[3];         /* secondary allocation quantity           =
*/
+	ttr_t DS1LSTAR;           /* last used track and block on track      */=

+	uint16_t DS1TRBAL;           /* space remaining on last used track     =
 */
+        uint16_t res1;               /* reserved                        =
        */
+	extent_t DS1EXT1;         /* first extent description                */=

+	extent_t DS1EXT2;         /* second extent description               */=

+	extent_t DS1EXT3;         /* third extent description                */=

+	cchhb_t DS1PTRDS;         /* possible pointer to f2 or f3 DSCB       */=

+} __attribute__ ((packed)) format1_label_t;
+
+
+/*
+ * struct dasd_information_t
+ * represents any data about the data, which is visible to userspace
+ */
+typedef struct dasd_information_t {
+	unsigned int devno;		/* S/390 devno */
+	unsigned int real_devno;	/* for aliases */
+	unsigned int schid;		/* S/390 subchannel identifier */
+	unsigned int cu_type  : 16;	/* from SenseID */
+	unsigned int cu_model :  8;	/* from SenseID */
+	unsigned int dev_type : 16;	/* from SenseID */
+	unsigned int dev_model : 8;	/* from SenseID */
+	unsigned int open_count;
+	unsigned int req_queue_len;
+	unsigned int chanq_len;		/* length of chanq */
+	char type[4];			/* from discipline.name, 'none' for unknown */
+	unsigned int status;		/* current device level */
+	unsigned int label_block;	/* where to find the VOLSER */
+	unsigned int FBA_layout;	/* fixed block size (like AIXVOL) */
+	unsigned int characteristics_size;
+	unsigned int confdata_size;
+	char characteristics[64];	/* from read_device_characteristics */
+	char configuration_data[256];	/* from read_configuration_data */
+} dasd_information_t;
+
+#define DASD_IOCTL_LETTER	 'D'
+#define BIODASDINFO _IOR(DASD_IOCTL_LETTER,1,dasd_information_t)
+#define BLKGETSIZE _IO(0x12,96)
+#define BLKSSZGET _IO(0x12,104)
+
+/*
+ * Only compile this on S/390. Doesn't make any sense
+ * for other architectures.
+ */
+
+static unsigned char EBCtoASC[256] =3D
+{
+/* 0x00  NUL   SOH   STX   ETX  *SEL    HT  *RNL   DEL */
+	0x00, 0x01, 0x02, 0x03, 0x07, 0x09, 0x07, 0x7F,
+/* 0x08  -GE  -SPS  -RPT    VT    FF    CR    SO    SI */
+	0x07, 0x07, 0x07, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+/* 0x10  DLE   DC1   DC2   DC3  -RES   -NL    BS  -POC
+                                -ENP  ->LF             */
+	0x10, 0x11, 0x12, 0x13, 0x07, 0x0A, 0x08, 0x07,
+/* 0x18  CAN    EM  -UBS  -CU1  -IFS  -IGS  -IRS  -ITB
+                                                  -IUS */
+	0x18, 0x19, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+/* 0x20  -DS  -SOS    FS  -WUS  -BYP    LF   ETB   ESC
+                                -INP                   */
+	0x07, 0x07, 0x1C, 0x07, 0x07, 0x0A, 0x17, 0x1B,
+/* 0x28  -SA  -SFE   -SM  -CSP  -MFA   ENQ   ACK   BEL
+                     -SW                               */
+	0x07, 0x07, 0x07, 0x07, 0x07, 0x05, 0x06, 0x07,
+/* 0x30 ----  ----   SYN   -IR   -PP  -TRN  -NBS   EOT */
+	0x07, 0x07, 0x16, 0x07, 0x07, 0x07, 0x07, 0x04,
+/* 0x38 -SBS   -IT  -RFF  -CU3   DC4   NAK  ----   SUB */
+	0x07, 0x07, 0x07, 0x07, 0x14, 0x15, 0x07, 0x1A,
+/* 0x40   SP   RSP           =C3=A4              ----       */
+	0x20, 0xFF, 0x83, 0x84, 0x85, 0xA0, 0x07, 0x86,
+/* 0x48                      .     <     (     +     | */
+	0x87, 0xA4, 0x9B, 0x2E, 0x3C, 0x28, 0x2B, 0x7C,
+/* 0x50    &                                      ---- */
+	0x26, 0x82, 0x88, 0x89, 0x8A, 0xA1, 0x8C, 0x07,
+/* 0x58          =C3=9F     !     $     *     )     ;       */
+	0x8D, 0xE1, 0x21, 0x24, 0x2A, 0x29, 0x3B, 0xAA,
+/* 0x60    -     /  ----     =C3=84  ----  ----  ----       */
+	0x2D, 0x2F, 0x07, 0x8E, 0x07, 0x07, 0x07, 0x8F,
+/* 0x68             ----     ,     %     _     >     ? */
+	0x80, 0xA5, 0x07, 0x2C, 0x25, 0x5F, 0x3E, 0x3F,
+/* 0x70  ---        ----  ----  ----  ----  ----  ---- */
+	0x07, 0x90, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+/* 0x78    *     `     :     #     @     '     =3D     " */
+	0x70, 0x60, 0x3A, 0x23, 0x40, 0x27, 0x3D, 0x22,
+/* 0x80    *     a     b     c     d     e     f     g */
+	0x07, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
+/* 0x88    h     i              ----  ----  ----       */
+	0x68, 0x69, 0xAE, 0xAF, 0x07, 0x07, 0x07, 0xF1,
+/* 0x90    =C2=B0     j     k     l     m     n     o     p */
+	0xF8, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x70,
+/* 0x98    q     r                    ----        ---- */
+	0x71, 0x72, 0xA6, 0xA7, 0x91, 0x07, 0x92, 0x07,
+/* 0xA0          ~     s     t     u     v     w     x */
+	0xE6, 0x7E, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
+/* 0xA8    y     z              ----  ----  ----  ---- */
+	0x79, 0x7A, 0xAD, 0xAB, 0x07, 0x07, 0x07, 0x07,
+/* 0xB0    ^                    ----     =C2=A7  ----       */
+	0x5E, 0x9C, 0x9D, 0xFA, 0x07, 0x07, 0x07, 0xAC,
+/* 0xB8       ----     [     ]  ----  ----  ----  ---- */
+	0xAB, 0x07, 0x5B, 0x5D, 0x07, 0x07, 0x07, 0x07,
+/* 0xC0    {     A     B     C     D     E     F     G */
+	0x7B, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
+/* 0xC8    H     I  ----           =C3=B6              ---- */
+	0x48, 0x49, 0x07, 0x93, 0x94, 0x95, 0xA2, 0x07,
+/* 0xD0    }     J     K     L     M     N     O     P */
+	0x7D, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50,
+/* 0xD8    Q     R  ----           =C3=BC                   */
+	0x51, 0x52, 0x07, 0x96, 0x81, 0x97, 0xA3, 0x98,
+/* 0xE0    \           S     T     U     V     W     X */
+	0x5C, 0xF6, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
+/* 0xE8    Y     Z        ----     =C3=96  ----  ----  ---- */
+	0x59, 0x5A, 0xFD, 0x07, 0x99, 0x07, 0x07, 0x07,
+/* 0xF0    0     1     2     3     4     5     6     7 */
+	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+/* 0xF8    8     9  ----  ----     =C3=9C  ----  ----  ---- */
+	0x38, 0x39, 0x07, 0x07, 0x9A, 0x07, 0x07, 0x07
+};
+
+static inline void=20
+vtoc_ebcdic_dec (const unsigned char *source, char *target, int l)=20
+{
+	int i;
+
+	for (i =3D 0; i < l; i++)=20
+		target[i]=3D(char)EBCtoASC[(unsigned char)(source[i])];
+}
+
+/*
+ * compute the block number from a=20
+ * cyl-cyl-head-head structure
+ */
+static inline int
+cchh2blk (cchh_t *ptr, struct hd_geometry *geo) {
+        return ptr->cc * geo->heads * geo->sectors +
+	       ptr->hh * geo->sectors;
+}
+
+
+/*
+ * compute the block number from a=20
+ * cyl-cyl-head-head-block structure
+ */
+static inline int
+cchhb2blk (cchhb_t *ptr, struct hd_geometry *geo) {
+        return ptr->cc * geo->heads * geo->sectors +
+		ptr->hh * geo->sectors +
+		ptr->b;
+}
+
+#endif /* _DASD_H */
diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -144,3 +144,36 @@ out:
 	return mapname;
 }
=20
+/*
+ * dm_get_first_dep
+ *
+ * Return the device number of the first dependend device
+ * for a given target.
+ */
+dev_t dm_get_first_dep(char *devname)
+{
+	struct dm_task *dmt;
+	struct dm_deps *dm_deps;
+	dev_t ret =3D 0;
+
+	if ((dmt =3D dm_task_create(DM_DEVICE_DEPS)) =3D=3D NULL) {
+		return ret;
+	}
+	if (!dm_task_set_name(dmt, devname)) {
+		goto out;
+	}
+	if (!dm_task_run(dmt)) {
+		goto out;
+	}
+	if ((dm_deps =3D dm_task_get_deps(dmt)) =3D=3D NULL) {
+		goto out;
+	}
+	if (dm_deps->count > 0) {
+		ret =3D dm_deps->device[0];
+	}
+out:
+	dm_task_destroy(dmt);
+
+	return ret;
+}
+
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -3,3 +3,4 @@ int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, unsigned l=
ong);
 int dm_map_present (char *);
 const char * dm_mapname(int major, int minor);
+dev_t dm_get_first_dep(char *devname);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -77,6 +77,7 @@ initpts(void)
 	addpts("bsd", read_bsd_pt);
 	addpts("solaris", read_solaris_pt);
 	addpts("unixware", read_unixware_pt);
+	addpts("dasd", read_dasd_pt);
 }
=20
 static char short_opts[] =3D "ladgvnp:t:";
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -31,6 +31,7 @@ extern ptreader read_bsd_pt;
 extern ptreader read_solaris_pt;
 extern ptreader read_unixware_pt;
 extern ptreader read_gpt_pt;
+extern ptreader read_dasd_pt;
=20
 char *getblock(int fd, unsigned int secnr);
=20

--------------050802060901090809080201
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050802060901090809080201--
