From: Dave Wysochanski <davidw@netapp.com>
Subject: patch to add path priority callout for netapp targets,
	update hwtable.c
Date: Tue, 15 Nov 2005 04:28:48 -0500
Message-ID: <4379AA50.9090705@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050409060701060702090101"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050409060701060702090101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patch against latest multipath-tools-0.4.6




--------------050409060701060702090101
Content-Type: text/x-patch;
 name="pp_netapp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pp_netapp.patch"

diff -Nurp multipath-tools-0.4.6/libmultipath/hwtable.c multipath-tools-0.4.6-pp_netapp/libmultipath/hwtable.c
--- multipath-tools-0.4.6/libmultipath/hwtable.c	Fri Nov 11 11:12:31 2005
+++ multipath-tools-0.4.6-pp_netapp/libmultipath/hwtable.c	Tue Nov 15 04:00:25 2005
@@ -28,7 +28,6 @@ setup_default_hwtable (vector hw)
 	r += store_hwe(hw, "HP", "A6189A", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "HP", "OPEN-", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "IBM", "ProFibre 4000R", MULTIBUS, DEFAULT_GETUID);
-	r += store_hwe(hw, "NETAPP", "LUN", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "SGI", "TP9100", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "SGI", "TP9300", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "STK", "OPENstorage D280", GROUP_BY_SERIAL, DEFAULT_GETUID);
@@ -40,6 +39,9 @@ setup_default_hwtable (vector hw)
 		   "1 queue_if_no_path", "emc_clariion", FAILBACK_IMMEDIATE);
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
+	r += store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO, DEFAULT_GETUID,
+		   "/sbin/mpath_prio_netapp /dev/%n", NULL,
+		   "1 queue_if_no_path", "readsector0");
 	r += store_hwe_ext(hw, "SGI", "TP9400", MULTIBUS, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
 	r += store_hwe_ext(hw, "SGI", "TP9500", FAILOVER, DEFAULT_GETUID,
diff -Nurp multipath-tools-0.4.6/path_priority/pp_netapp/Makefile multipath-tools-0.4.6-pp_netapp/path_priority/pp_netapp/Makefile
--- multipath-tools-0.4.6/path_priority/pp_netapp/Makefile	Wed Dec 31 19:00:00 1969
+++ multipath-tools-0.4.6-pp_netapp/path_priority/pp_netapp/Makefile	Tue Nov 15 03:56:49 2005
@@ -0,0 +1,27 @@
+EXEC		= mpath_prio_netapp
+BUILD		= glibc
+OBJS		= pp_netapp.o
+
+TOPDIR		= ../..
+include $(TOPDIR)/Makefile.inc
+
+CFLAGS = -pipe -g -O2 -Wall -Wunused -Wstrict-prototypes
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
+	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+clean:	
+	rm -f *.o $(EXEC)
+
+%.o:	%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
diff -Nurp multipath-tools-0.4.6/path_priority/pp_netapp/pp_netapp.c multipath-tools-0.4.6-pp_netapp/path_priority/pp_netapp/pp_netapp.c
--- multipath-tools-0.4.6/path_priority/pp_netapp/pp_netapp.c	Wed Dec 31 19:00:00 1969
+++ multipath-tools-0.4.6-pp_netapp/path_priority/pp_netapp/pp_netapp.c	Tue Nov 15 03:55:47 2005
@@ -0,0 +1,268 @@
+/* 
+ * Copyright 2005 Network Appliance, Inc., All Rights Reserved
+ * Author:  David Wysochanski available at davidw@netapp.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
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
+#define SG_TIMEOUT	30000
+
+
+static void dump_cdb(unsigned char *cdb, int size)
+{
+	int i;
+	
+	fprintf(stderr, "- SCSI CDB: ");
+	for (i=0; i<size; i++) {
+		fprintf(stderr, "0x%02x ", cdb[i]);
+	}
+	fprintf(stderr, "\n");
+}
+
+static void process_sg_error(struct sg_io_hdr *io_hdr)
+{
+	int i;
+	
+	fprintf(stderr, "- masked_status=0x%02x, host_status=0x%02x, "
+		"driver_status=0x%02x\n", io_hdr->masked_status,
+		io_hdr->host_status, io_hdr->driver_status);
+	if (io_hdr->sb_len_wr > 0) {
+		fprintf(stderr, "- SCSI sense data: ");
+		for (i=0; i<io_hdr->sb_len_wr; i++) {
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
+	unsigned char cdb[10] = {0xc0, 0, 0x1, 0xa, 0x98, 0xa,
+				 pg, sizeof(sb), 0, 0};
+	struct sg_io_hdr io_hdr;
+	int ret = -1;
+	int fd;
+
+	fd = open(dev, O_RDWR|O_NONBLOCK);
+
+	if (fd <= 0) {
+		fprintf(stderr, "Opening %s failed, errno=%d.\n", dev, errno);
+		goto out_no_close;
+	}
+
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = sizeof (cdb);
+	io_hdr.mx_sb_len = sizeof (sb);
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = *results_size;
+	io_hdr.dxferp = results;
+	io_hdr.cmdp = cdb;
+	io_hdr.sbp = sb;
+	io_hdr.timeout = SG_TIMEOUT;
+	io_hdr.pack_id = 0;
+	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+		fprintf(stderr, "SG_IO ioctl failed, errno=%d\n", errno);
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
+	if (results[4] != 0x0a || results[5] != 0x98 ||
+	    results[6] != 0x0a ||results[7] != 0x01) {
+		dump_cdb(cdb, sizeof(cdb));
+		fprintf(stderr, "GVA return wrong format ");
+		fprintf(stderr, "results[4-7] = 0x%02x 0x%02x 0x%02x 0x%02x\n",
+			results[4], results[5], results[6], results[7]);
+		goto out;
+	}
+	ret = 0;
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
+	unsigned char cdb[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xc1, 0,
+						   sizeof(sb), 0};
+	struct sg_io_hdr io_hdr;
+	int ret = -1;
+	int fd;
+
+	fd = open(dev, O_RDWR|O_NONBLOCK);
+
+	if (fd <= 0) {
+		fprintf(stderr, "Opening %s failed, errno=%d.\n", dev, errno);
+		goto out_no_close;
+	}
+
+	memset(&results, 0, sizeof (results));
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = sizeof (cdb);
+	io_hdr.mx_sb_len = sizeof (sb);
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = sizeof (results);
+	io_hdr.dxferp = results;
+	io_hdr.cmdp = cdb;
+	io_hdr.sbp = sb;
+	io_hdr.timeout = SG_TIMEOUT;
+	io_hdr.pack_id = 0;
+	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+		fprintf(stderr, "ioctl sending inquiry command failed, "
+			"errno=%d\n", errno);
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
+	if (results[1] != 0xc1 || results[8] != 0x0a ||
+	    results[9] != 0x98 || results[10] != 0x0a ||
+	    results[11] != 0x0 || results[12] != 0xc1 ||
+	    results[13] != 0x0) {
+		fprintf(stderr,"Proxy info page in unknown format - ");
+		fprintf(stderr,"results[8-13]=0x%02x 0x%02x 0x%02x 0x%02x "
+			"0x%02x 0x%02x\n",
+			results[8], results[9], results[10],
+			results[11], results[12], results[13]);
+		dump_cdb(cdb, sizeof(cdb));
+		goto out;
+	}
+	ret = (results[19] & 0x02) >> 1;
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
+	int results_size=RESULTS_MAX;
+	int rc;
+	int is_proxy;
+	int is_iscsi_software;
+	int is_iscsi_hardware;
+	int tot_len;
+
+	is_iscsi_software = is_iscsi_hardware = is_proxy = 0;
+
+	memset(&results, 0, sizeof (results));
+	rc = send_gva(dev, 0x41, results, &results_size);
+	if (rc == 0) {
+		tot_len = results[0] << 24 | results[1] << 16 |
+			  results[2] << 8 | results[3];
+		if (tot_len <= 8) {
+			goto try_fcp_proxy;
+		}
+		if (results[8] != 0x41) {
+			fprintf(stderr, "GVA page 0x41 error - "
+				"results[8] = 0x%x\n", results[8]);
+			goto try_fcp_proxy;
+		}
+		if ((strncmp(&results[12], "ism_sw", 6) == 0) ||
+		    (strncmp(&results[12], "iswt", 4) == 0)) {
+			is_iscsi_software = 1;
+			goto prio_select;
+		}
+		else if (strncmp(&results[12], "ism_sn", 6) == 0) {
+			is_iscsi_hardware = 1;
+			goto prio_select;
+		}
+	}
+	
+ try_fcp_proxy:	
+	rc = get_proxy(dev);
+	if (rc >= 0) {
+		is_proxy = rc;
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
+	if (argc != 2) {
+		fprintf(stderr, "Arguments wrong!\n");
+		prio = 0;
+	} else
+		prio = netapp_prio(argv[1]);
+	
+	printf("%d\n", prio);
+	exit(0);
+}
+

--------------050409060701060702090101
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050409060701060702090101--
