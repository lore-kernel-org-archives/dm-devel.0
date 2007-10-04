From: Ritesh Raj Sarraf <rsarraf@netapp.com>
Subject: [PATCH] Rename prio callout program mpath_prio_netapp to
	mpath_prio_ontap
Date: Thu, 4 Oct 2007 14:55:19 +0530
Message-ID: <200710041455.20037.rsarraf@netapp.com>
Reply-To: rsarraf@netapp.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0433757922=="
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

--===============0433757922==
Content-Type: multipart/signed; boundary="nextPart1868160.gJf7fAUQjY";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1868160.gJf7fAUQjY
Content-Type: multipart/mixed;
  boundary="Boundary-01=_/FLBH0Q9xmlsSAH"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_/FLBH0Q9xmlsSAH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Attached are 2 patches to rename the callout program from mpath_prio_netapp=
 to=20
mpath_prio_ontap.
The decision for the name change has mainly been for having a more generic=
=20
name.

The patches were created against the multipath-tools git repository.


Thanks,
Ritesh

--Boundary-01=_/FLBH0Q9xmlsSAH
Content-Type: text/x-diff; charset="utf-8";
	name="0001-Rename-pp_netapp-to-pp_ontap-for-generic-naming-conv.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Rename-pp_netapp-to-pp_ontap-for-generic-naming-conv.patch"

=46rom 0e1c1dd546adc6d356e97c0872debf402220d818 Mon Sep 17 00:00:00 2001
=46rom: Ritesh Raj Sarraf <rsarraf@netapp.com>
Date: Wed, 3 Oct 2007 16:27:59 +0530
Subject: [PATCH] Rename pp_netapp to pp_ontap for generic naming convention

This patch changes prio callout file mpath_prio_netapp to mpath_prio_ontap =
and
some other minor changes

Signed-off-by: Ritesh Raj Sarraf <rsarraf@netapp.com>
=2D--
 libmultipath/hwtable.c              |    4 +-
 multipath-tools.spec.in             |    2 +-
 path_priority/pp_netapp/Makefile    |   22 ---
 path_priority/pp_netapp/pp_netapp.c |  268 -------------------------------=
=2D--
 path_priority/pp_ontap/Makefile     |   22 +++
 path_priority/pp_ontap/pp_ontap.c   |  272 +++++++++++++++++++++++++++++++=
++++
 6 files changed, 297 insertions(+), 293 deletions(-)
 delete mode 100644 path_priority/pp_netapp/Makefile
 delete mode 100644 path_priority/pp_netapp/pp_netapp.c
 create mode 100644 path_priority/pp_ontap/Makefile
 create mode 100644 path_priority/pp_ontap/pp_ontap.c

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ef761d7..6043c43 100644
=2D-- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -444,7 +444,7 @@ static struct hwentry default_hw[] =3D {
 		.vendor        =3D "NETAPP",
 		.product       =3D "LUN.*",
 		.getuid        =3D DEFAULT_GETUID,
=2D		.getprio       =3D "/sbin/mpath_prio_netapp /dev/%n",
+		.getprio       =3D "/sbin/mpath_prio_ontap /dev/%n",
 		.features      =3D "1 queue_if_no_path",
 		.hwhandler     =3D DEFAULT_HWHANDLER,
 		.selector      =3D DEFAULT_SELECTOR,
@@ -465,7 +465,7 @@ static struct hwentry default_hw[] =3D {
 		.vendor        =3D "IBM",
 		.product       =3D "Nseries.*",
 		.getuid        =3D DEFAULT_GETUID,
=2D		.getprio       =3D "/sbin/mpath_prio_netapp /dev/%n",
+		.getprio       =3D "/sbin/mpath_prio_ontap /dev/%n",
 		.features      =3D "1 queue_if_no_path",
 		.hwhandler     =3D DEFAULT_HWHANDLER,
 		.selector      =3D DEFAULT_SELECTOR,
diff --git a/multipath-tools.spec.in b/multipath-tools.spec.in
index 3caede6..5e0d1a8 100644
=2D-- a/multipath-tools.spec.in
+++ b/multipath-tools.spec.in
@@ -48,7 +48,7 @@ rm -rf $RPM_BUILD_ROOT
 %{prefix}/sbin/mpath_prio_emc
 %{prefix}/sbin/mpath_prio_random
 %{prefix}/sbin/mpath_prio_balance_units
=2D%{prefix}/sbin/mpath_prio_netapp
+%{prefix}/sbin/mpath_prio_ontap
 %{prefix}/sbin/mpath_prio_rdac
 %{prefix}/sbin/mpath_prio_hds_modular
 %{prefix}/usr/share/man/man8/devmap_name.8.gz
diff --git a/path_priority/pp_netapp/Makefile b/path_priority/pp_netapp/Mak=
efile
deleted file mode 100644
index b29d002..0000000
=2D-- a/path_priority/pp_netapp/Makefile
+++ /dev/null
@@ -1,22 +0,0 @@
=2DEXEC		=3D mpath_prio_netapp
=2DBUILD		=3D glibc
=2DOBJS		=3D pp_netapp.o
=2D
=2DTOPDIR		=3D ../..
=2Dinclude $(TOPDIR)/Makefile.inc
=2D
=2Dall: $(BUILD)
=2D
=2Dglibc:	$(OBJS)
=2D	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
=2D
=2Dklibc:	$(OBJS)
=2D	$(CC) -static -o $(EXEC) $(OBJS)
=2D
=2Dinstall: $(EXEC)
=2D	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
=2D
=2Duninstall:
=2D	rm $(DESTDIR)$(bindir)/$(EXEC)
=2Dclean:=09
=2D	rm -f *.o $(EXEC)
diff --git a/path_priority/pp_netapp/pp_netapp.c b/path_priority/pp_netapp/=
pp_netapp.c
deleted file mode 100644
index 8562a95..0000000
=2D-- a/path_priority/pp_netapp/pp_netapp.c
+++ /dev/null
@@ -1,268 +0,0 @@
=2D/*=20
=2D * Copyright 2005 Network Appliance, Inc., All Rights Reserved
=2D * Author:  David Wysochanski available at davidw@netapp.com
=2D *
=2D * This program is free software; you can redistribute it and/or modify
=2D * it under the terms of the GNU General Public License version 2 as
=2D * published by the Free Software Foundation.
=2D *
=2D * This program is distributed in the hope that it will be useful, but
=2D * WITHOUT ANY WARRANTY; without even the implied warranty of=20
=2D * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
=2D * General Public License v2 for more details.
=2D */
=2D
=2D#include <stdio.h>
=2D#include <stdlib.h>
=2D#include <string.h>
=2D#include <sys/types.h>
=2D#include <sys/stat.h>
=2D#include <unistd.h>
=2D#include <fcntl.h>
=2D#include <sys/ioctl.h>
=2D#include <errno.h>
=2D#include <assert.h>
=2D
=2D#include "../../libmultipath/sg_include.h"
=2D
=2D#define INQUIRY_CMD	0x12
=2D#define INQUIRY_CMDLEN	6
=2D#define DEFAULT_PRIO	10
=2D#define RESULTS_MAX	256
=2D#define SG_TIMEOUT	30000
=2D
=2D
=2Dstatic void dump_cdb(unsigned char *cdb, int size)
=2D{
=2D	int i;
=2D=09
=2D	fprintf(stderr, "- SCSI CDB: ");
=2D	for (i=3D0; i<size; i++) {
=2D		fprintf(stderr, "0x%02x ", cdb[i]);
=2D	}
=2D	fprintf(stderr, "\n");
=2D}
=2D
=2Dstatic void process_sg_error(struct sg_io_hdr *io_hdr)
=2D{
=2D	int i;
=2D=09
=2D	fprintf(stderr, "- masked_status=3D0x%02x, host_status=3D0x%02x, "
=2D		"driver_status=3D0x%02x\n", io_hdr->masked_status,
=2D		io_hdr->host_status, io_hdr->driver_status);
=2D	if (io_hdr->sb_len_wr > 0) {
=2D		fprintf(stderr, "- SCSI sense data: ");
=2D		for (i=3D0; i<io_hdr->sb_len_wr; i++) {
=2D			fprintf(stderr, "0x%02x ", io_hdr->sbp[i]);
=2D		}
=2D		fprintf(stderr, "\n");
=2D	}
=2D}
=2D
=2D/*
=2D * Returns:
=2D * -1: error, errno set
=2D *  0: success
=2D */
=2Dstatic int send_gva(const char *dev, unsigned char pg,
=2D		    unsigned char *results, int *results_size)
=2D{
=2D	unsigned char sb[128];
=2D	unsigned char cdb[10] =3D {0xc0, 0, 0x1, 0xa, 0x98, 0xa,
=2D				 pg, sizeof(sb), 0, 0};
=2D	struct sg_io_hdr io_hdr;
=2D	int ret =3D -1;
=2D	int fd;
=2D
=2D	fd =3D open(dev, O_RDWR|O_NONBLOCK);
=2D
=2D	if (fd <=3D 0) {
=2D		fprintf(stderr, "Opening %s failed, errno=3D%d.\n", dev, errno);
=2D		goto out_no_close;
=2D	}
=2D
=2D	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
=2D	io_hdr.interface_id =3D 'S';
=2D	io_hdr.cmd_len =3D sizeof (cdb);
=2D	io_hdr.mx_sb_len =3D sizeof (sb);
=2D	io_hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;
=2D	io_hdr.dxfer_len =3D *results_size;
=2D	io_hdr.dxferp =3D results;
=2D	io_hdr.cmdp =3D cdb;
=2D	io_hdr.sbp =3D sb;
=2D	io_hdr.timeout =3D SG_TIMEOUT;
=2D	io_hdr.pack_id =3D 0;
=2D	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
=2D		fprintf(stderr, "SG_IO ioctl failed, errno=3D%d\n", errno);
=2D		dump_cdb(cdb, sizeof(cdb));
=2D		goto out;
=2D	}
=2D	if (io_hdr.info & SG_INFO_OK_MASK) {
=2D		fprintf(stderr, "SCSI error\n");
=2D		dump_cdb(cdb, sizeof(cdb));
=2D		process_sg_error(&io_hdr);
=2D		goto out;
=2D	}
=2D
=2D	if (results[4] !=3D 0x0a || results[5] !=3D 0x98 ||
=2D	    results[6] !=3D 0x0a ||results[7] !=3D 0x01) {
=2D		dump_cdb(cdb, sizeof(cdb));
=2D		fprintf(stderr, "GVA return wrong format ");
=2D		fprintf(stderr, "results[4-7] =3D 0x%02x 0x%02x 0x%02x 0x%02x\n",
=2D			results[4], results[5], results[6], results[7]);
=2D		goto out;
=2D	}
=2D	ret =3D 0;
=2D out:
=2D	close(fd);
=2D out_no_close:
=2D	return(ret);
=2D}
=2D
=2D/*
=2D * Retuns:
=2D * -1: Unable to obtain proxy info
=2D *  0: Device _not_ proxy path
=2D *  1: Device _is_ proxy path
=2D */
=2Dstatic int get_proxy(const char *dev)
=2D{
=2D	unsigned char results[256];
=2D	unsigned char sb[128];
=2D	unsigned char cdb[INQUIRY_CMDLEN] =3D {INQUIRY_CMD, 1, 0xc1, 0,
=2D						   sizeof(sb), 0};
=2D	struct sg_io_hdr io_hdr;
=2D	int ret =3D -1;
=2D	int fd;
=2D
=2D	fd =3D open(dev, O_RDWR|O_NONBLOCK);
=2D
=2D	if (fd <=3D 0) {
=2D		fprintf(stderr, "Opening %s failed, errno=3D%d.\n", dev, errno);
=2D		goto out_no_close;
=2D	}
=2D
=2D	memset(&results, 0, sizeof (results));
=2D	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
=2D	io_hdr.interface_id =3D 'S';
=2D	io_hdr.cmd_len =3D sizeof (cdb);
=2D	io_hdr.mx_sb_len =3D sizeof (sb);
=2D	io_hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;
=2D	io_hdr.dxfer_len =3D sizeof (results);
=2D	io_hdr.dxferp =3D results;
=2D	io_hdr.cmdp =3D cdb;
=2D	io_hdr.sbp =3D sb;
=2D	io_hdr.timeout =3D SG_TIMEOUT;
=2D	io_hdr.pack_id =3D 0;
=2D	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
=2D		fprintf(stderr, "ioctl sending inquiry command failed, "
=2D			"errno=3D%d\n", errno);
=2D		dump_cdb(cdb, sizeof(cdb));
=2D		goto out;
=2D	}
=2D	if (io_hdr.info & SG_INFO_OK_MASK) {
=2D		fprintf(stderr, "SCSI error\n");
=2D		dump_cdb(cdb, sizeof(cdb));
=2D		process_sg_error(&io_hdr);
=2D		goto out;
=2D	}
=2D
=2D	if (results[1] !=3D 0xc1 || results[8] !=3D 0x0a ||
=2D	    results[9] !=3D 0x98 || results[10] !=3D 0x0a ||
=2D	    results[11] !=3D 0x0 || results[12] !=3D 0xc1 ||
=2D	    results[13] !=3D 0x0) {
=2D		fprintf(stderr,"Proxy info page in unknown format - ");
=2D		fprintf(stderr,"results[8-13]=3D0x%02x 0x%02x 0x%02x 0x%02x "
=2D			"0x%02x 0x%02x\n",
=2D			results[8], results[9], results[10],
=2D			results[11], results[12], results[13]);
=2D		dump_cdb(cdb, sizeof(cdb));
=2D		goto out;
=2D	}
=2D	ret =3D (results[19] & 0x02) >> 1;
=2D
=2D out:
=2D	close(fd);
=2D out_no_close:
=2D	return(ret);
=2D}
=2D
=2D/*
=2D * Returns priority of device based on device info.
=2D *
=2D * 4: FCP non-proxy, FCP proxy unknown, or unable to determine protocol
=2D * 3: iSCSI HBA
=2D * 2: iSCSI software
=2D * 1: FCP proxy
=2D */
=2Dstatic int netapp_prio(const char *dev)
=2D{
=2D	unsigned char results[RESULTS_MAX];
=2D	int results_size=3DRESULTS_MAX;
=2D	int rc;
=2D	int is_proxy;
=2D	int is_iscsi_software;
=2D	int is_iscsi_hardware;
=2D	int tot_len;
=2D
=2D	is_iscsi_software =3D is_iscsi_hardware =3D is_proxy =3D 0;
=2D
=2D	memset(&results, 0, sizeof (results));
=2D	rc =3D send_gva(dev, 0x41, results, &results_size);
=2D	if (rc =3D=3D 0) {
=2D		tot_len =3D results[0] << 24 | results[1] << 16 |
=2D			  results[2] << 8 | results[3];
=2D		if (tot_len <=3D 8) {
=2D			goto try_fcp_proxy;
=2D		}
=2D		if (results[8] !=3D 0x41) {
=2D			fprintf(stderr, "GVA page 0x41 error - "
=2D				"results[8] =3D 0x%x\n", results[8]);
=2D			goto try_fcp_proxy;
=2D		}
=2D		if ((strncmp((char *)&results[12], "ism_sw", 6) =3D=3D 0) ||
=2D		    (strncmp((char *)&results[12], "iswt", 4) =3D=3D 0)) {
=2D			is_iscsi_software =3D 1;
=2D			goto prio_select;
=2D		}
=2D		else if (strncmp((char *)&results[12], "ism_sn", 6) =3D=3D 0) {
=2D			is_iscsi_hardware =3D 1;
=2D			goto prio_select;
=2D		}
=2D	}
=2D=09
=2D try_fcp_proxy:=09
=2D	rc =3D get_proxy(dev);
=2D	if (rc >=3D 0) {
=2D		is_proxy =3D rc;
=2D	}
=2D
=2D prio_select:
=2D	if (is_iscsi_hardware) {
=2D		return 3;
=2D	} else if (is_iscsi_software) {
=2D		return 2;
=2D	} else {
=2D		if (is_proxy) {
=2D			return 1;
=2D		} else {
=2D			/* Either non-proxy, or couldn't get proxy info */
=2D			return 4;
=2D		}
=2D	}
=2D}
=2D
=2Dint
=2Dmain (int argc, char **argv)
=2D{
=2D	int prio;
=2D	if (argc !=3D 2) {
=2D		fprintf(stderr, "Arguments wrong!\n");
=2D		prio =3D 0;
=2D	} else
=2D		prio =3D netapp_prio(argv[1]);
=2D=09
=2D	printf("%d\n", prio);
=2D	exit(0);
=2D}
=2D
diff --git a/path_priority/pp_ontap/Makefile b/path_priority/pp_ontap/Makef=
ile
new file mode 100644
index 0000000..8b8f901
=2D-- /dev/null
+++ b/path_priority/pp_ontap/Makefile
@@ -0,0 +1,22 @@
+EXEC		=3D mpath_prio_ontap
+BUILD		=3D glibc
+OBJS		=3D pp_ontap.o
+
+TOPDIR		=3D ../..
+include $(TOPDIR)/Makefile.inc
+
+all: $(BUILD)
+
+glibc:	$(OBJS)
+	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+
+klibc:	$(OBJS)
+	$(CC) -static -o $(EXEC) $(OBJS)
+
+install: $(EXEC)
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+clean:=09
+	rm -f *.o $(EXEC)
diff --git a/path_priority/pp_ontap/pp_ontap.c b/path_priority/pp_ontap/pp_=
ontap.c
new file mode 100644
index 0000000..38ab277
=2D-- /dev/null
+++ b/path_priority/pp_ontap/pp_ontap.c
@@ -0,0 +1,272 @@
+/*=20
+ * Copyright 2005 Network Appliance, Inc., All Rights Reserved
+ * Author:  David Wysochanski available at davidw@netapp.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of=20
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License v2 for more details.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <assert.h>
+
+#include "../../libmultipath/sg_include.h"
+
+#define INQUIRY_CMD	0x12
+#define INQUIRY_CMDLEN	6
+#define DEFAULT_PRIO	10
+#define RESULTS_MAX	256
+#define SG_TIMEOUT	60000
+
+
+static void dump_cdb(unsigned char *cdb, int size)
+{
+	int i;
+=09
+	fprintf(stderr, "- SCSI CDB: ");
+	for (i=3D0; i<size; i++) {
+		fprintf(stderr, "0x%02x ", cdb[i]);
+	}
+	fprintf(stderr, "\n");
+}
+
+static void process_sg_error(struct sg_io_hdr *io_hdr)
+{
+	int i;
+=09
+	fprintf(stderr, "- masked_status=3D0x%02x, host_status=3D0x%02x, "
+		"driver_status=3D0x%02x\n", io_hdr->masked_status,
+		io_hdr->host_status, io_hdr->driver_status);
+	if (io_hdr->sb_len_wr > 0) {
+		fprintf(stderr, "- SCSI sense data: ");
+		for (i=3D0; i<io_hdr->sb_len_wr; i++) {
+			fprintf(stderr, "0x%02x ", io_hdr->sbp[i]);
+		}
+		fprintf(stderr, "\n");
+	}
+}
+
+/*
+ * Returns:
+ * -1: error, errno set
+ *  0: success
+ */
+static int send_gva(const char *dev, unsigned char pg,
+		    unsigned char *results, int *results_size)
+{
+	unsigned char sb[128];
+	unsigned char cdb[10] =3D {0xc0, 0, 0x1, 0xa, 0x98, 0xa,
+				 pg, sizeof(sb), 0, 0};
+	struct sg_io_hdr io_hdr;
+	int ret =3D -1;
+	int fd;
+
+	fd =3D open(dev, O_RDWR|O_NONBLOCK);
+
+	if (fd <=3D 0) {
+		fprintf(stderr, "Opening %s failed, errno=3D%d.\n", dev, errno);
+		goto out_no_close;
+	}
+
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	io_hdr.interface_id =3D 'S';
+	io_hdr.cmd_len =3D sizeof (cdb);
+	io_hdr.mx_sb_len =3D sizeof (sb);
+	io_hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len =3D *results_size;
+	io_hdr.dxferp =3D results;
+	io_hdr.cmdp =3D cdb;
+	io_hdr.sbp =3D sb;
+	io_hdr.timeout =3D SG_TIMEOUT;
+	io_hdr.pack_id =3D 0;
+	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+		fprintf(stderr, "SG_IO ioctl failed, errno=3D%d\n", errno);
+		dump_cdb(cdb, sizeof(cdb));
+		goto out;
+	}
+	if (io_hdr.info & SG_INFO_OK_MASK) {
+		fprintf(stderr, "SCSI error\n");
+		dump_cdb(cdb, sizeof(cdb));
+		process_sg_error(&io_hdr);
+		goto out;
+	}
+
+	if (results[4] !=3D 0x0a || results[5] !=3D 0x98 ||
+	    results[6] !=3D 0x0a ||results[7] !=3D 0x01) {
+		dump_cdb(cdb, sizeof(cdb));
+		fprintf(stderr, "GVA return wrong format ");
+		fprintf(stderr, "results[4-7] =3D 0x%02x 0x%02x 0x%02x 0x%02x\n",
+			results[4], results[5], results[6], results[7]);
+		goto out;
+	}
+	ret =3D 0;
+ out:
+	close(fd);
+ out_no_close:
+	return(ret);
+}
+
+/*
+ * Retuns:
+ * -1: Unable to obtain proxy info
+ *  0: Device _not_ proxy path
+ *  1: Device _is_ proxy path
+ */
+static int get_proxy(const char *dev)
+{
+	unsigned char results[256];
+	unsigned char sb[128];
+	unsigned char cdb[INQUIRY_CMDLEN] =3D {INQUIRY_CMD, 1, 0xc1, 0,
+						   sizeof(sb), 0};
+	struct sg_io_hdr io_hdr;
+	int ret =3D -1;
+	int fd;
+
+	fd =3D open(dev, O_RDWR|O_NONBLOCK);
+
+	if (fd <=3D 0) {
+		fprintf(stderr, "Opening %s failed, errno=3D%d.\n", dev, errno);
+		goto out_no_close;
+	}
+
+	memset(&results, 0, sizeof (results));
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	io_hdr.interface_id =3D 'S';
+	io_hdr.cmd_len =3D sizeof (cdb);
+	io_hdr.mx_sb_len =3D sizeof (sb);
+	io_hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len =3D sizeof (results);
+	io_hdr.dxferp =3D results;
+	io_hdr.cmdp =3D cdb;
+	io_hdr.sbp =3D sb;
+	io_hdr.timeout =3D SG_TIMEOUT;
+	io_hdr.pack_id =3D 0;
+	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+		fprintf(stderr, "ioctl sending inquiry command failed, "
+			"errno=3D%d\n", errno);
+		dump_cdb(cdb, sizeof(cdb));
+		goto out;
+	}
+	if (io_hdr.info & SG_INFO_OK_MASK) {
+		fprintf(stderr, "SCSI error\n");
+		dump_cdb(cdb, sizeof(cdb));
+		process_sg_error(&io_hdr);
+		goto out;
+	}
+
+	if (results[1] !=3D 0xc1 || results[8] !=3D 0x0a ||
+	    results[9] !=3D 0x98 || results[10] !=3D 0x0a ||
+	    results[11] !=3D 0x0 || results[12] !=3D 0xc1 ||
+	    results[13] !=3D 0x0) {
+		fprintf(stderr,"Proxy info page in unknown format - ");
+		fprintf(stderr,"results[8-13]=3D0x%02x 0x%02x 0x%02x 0x%02x "
+			"0x%02x 0x%02x\n",
+			results[8], results[9], results[10],
+			results[11], results[12], results[13]);
+		dump_cdb(cdb, sizeof(cdb));
+		goto out;
+	}
+	ret =3D (results[19] & 0x02) >> 1;
+
+ out:
+	close(fd);
+ out_no_close:
+	return(ret);
+}
+
+/*
+ * Returns priority of device based on device info.
+ *
+ * 4: FCP non-proxy, FCP proxy unknown, or unable to determine protocol
+ * 3: iSCSI HBA
+ * 2: iSCSI software
+ * 1: FCP proxy
+ */
+static int netapp_prio(const char *dev)
+{
+	unsigned char results[RESULTS_MAX];
+	int results_size=3DRESULTS_MAX;
+	int rc;
+	int is_proxy;
+	int is_iscsi_software;
+	int is_iscsi_hardware;
+	int tot_len;
+
+	is_iscsi_software =3D is_iscsi_hardware =3D is_proxy =3D 0;
+
+	memset(&results, 0, sizeof (results));
+	rc =3D send_gva(dev, 0x41, results, &results_size);
+	if (rc >=3D 0) {
+		tot_len =3D results[0] << 24 | results[1] << 16 |
+			  results[2] << 8 | results[3];
+		if (tot_len <=3D 8) {
+			goto try_fcp_proxy;
+		}
+		if (results[8] !=3D 0x41) {
+			fprintf(stderr, "GVA page 0x41 error - "
+				"results[8] =3D 0x%x\n", results[8]);
+			goto try_fcp_proxy;
+		}
+		if ((strncmp((char *)&results[12], "ism_sw", 6) =3D=3D 0) ||
+		    (strncmp((char *)&results[12], "iswt", 4) =3D=3D 0)) {
+			is_iscsi_software =3D 1;
+			goto prio_select;
+		}
+		else if (strncmp((char *)&results[12], "ism_sn", 6) =3D=3D 0) {
+			is_iscsi_hardware =3D 1;
+			goto prio_select;
+		}
+	} else {
+		return 0;
+	}
+=09
+ try_fcp_proxy:=09
+	rc =3D get_proxy(dev);
+	if (rc >=3D 0) {
+		is_proxy =3D rc;
+	} else {
+		return 0;
+	}
+
+ prio_select:
+	if (is_iscsi_hardware) {
+		return 3;
+	} else if (is_iscsi_software) {
+		return 2;
+	} else {
+		if (is_proxy) {
+			return 1;
+		} else {
+			/* Either non-proxy, or couldn't get proxy info */
+			return 4;
+		}
+	}
+}
+
+int
+main (int argc, char **argv)
+{
+	int prio;
+	if (argc !=3D 2) {
+		fprintf(stderr, "Arguments wrong!\n");
+		prio =3D 0;
+	} else
+		prio =3D netapp_prio(argv[1]);
+=09
+	printf("%d\n", prio);
+	exit(0);
+}
+
=2D-=20
1.5.3.2


--Boundary-01=_/FLBH0Q9xmlsSAH
Content-Type: text/x-diff; charset="utf-8";
	name="0002-Updated-manpage-with-the-new-path-prio-callout-name.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-Updated-manpage-with-the-new-path-prio-callout-name.patch"

=46rom c3fef2aad724614bcf6d004827b1e7bae9124a44 Mon Sep 17 00:00:00 2001
=46rom: Ritesh Raj Sarraf <rsarraf@netapp.com>
Date: Wed, 3 Oct 2007 16:32:09 +0530
Subject: [PATCH] Updated manpage with the new path prio callout name


Signed-off-by: Ritesh Raj Sarraf <rsarraf@netapp.com>
=2D--
 multipath/multipath.conf.5 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c8ab6b0..96e4d27 100644
=2D-- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -130,7 +130,7 @@ Generate the path priority for EMC arrays
 .B mpath_prio_alua /dev/%n
 Generate the path priority based on the SCSI-3 ALUA settings.
 .TP
=2D.B mpath_prio_netapp /dev/%n
+.B mpath_prio_ontap /dev/%n
 Generate the path priority for NetApp arrays.
 .TP
 .B mpath_prio_rdac /dev/%n
=2D-=20
1.5.3.2


--Boundary-01=_/FLBH0Q9xmlsSAH--

--nextPart1868160.gJf7fAUQjY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHBLF/4Rhi6gTxMLwRAn18AJ4txYKvHtjXv9BE12mJbn0/enSNywCgiXqv
xdNVVR6P3lmvx+Cvai6kU/Y=
=jqSZ
-----END PGP SIGNATURE-----

--nextPart1868160.gJf7fAUQjY--


--===============0433757922==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0433757922==--
