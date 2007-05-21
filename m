From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 2/2] Add path priority callout for RDAC
Date: Mon, 21 May 2007 14:50:42 -0700
Message-ID: <20070521215042.29373.18871.sendpatchset@localhost.localdomain>
References: <20070521215031.29373.63818.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070521215031.29373.63818.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

RDAC currently doesn't have a path priority callout. This affects
the expected behavior of multipath. i.e multipath's active path group doesn't
always lead to the preferred path of the device.

This patch sets the priority of a path based on the preferred path that is
queried from the controller through the C9 inquiry page.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Index: multipath-tools-0.4.7/path_priority/pp_rdac/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ multipath-tools-0.4.7/path_priority/pp_rdac/Makefile	2007-05-17 18:26:27.000000000 -0700
@@ -0,0 +1,25 @@
+EXEC		= mpath_prio_rdac
+BUILD		= glibc
+OBJS		= pp_rdac.o
+
+TOPDIR		= ../..
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
+	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+clean:
+	rm -f *.o $(EXEC)
+
+%.o:	%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
Index: multipath-tools-0.4.7/path_priority/pp_rdac/pp_rdac.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ multipath-tools-0.4.7/path_priority/pp_rdac/pp_rdac.c	2007-05-17 18:31:08.000000000 -0700
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2007 Christophe Varoqui
+ * Copyright (C) Chandra Seetharaman, IBM Corp. 2007
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
+
+#include "../../libmultipath/sg_include.h"
+
+#define INQUIRY_CMDLEN		6
+#define INQUIRY_CMD		0x12
+#define SENSE_BUFF_LEN		32
+#define DEF_TIMEOUT		60000
+#define SCSI_CHECK_CONDITION	0x2
+#define SCSI_COMMAND_TERMINATED	0x22
+#define SG_ERR_DRIVER_SENSE	0x08
+#define RECOVERED_ERROR		0x01
+
+static int
+do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len)
+{
+	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0, 0, 0, 0};
+	unsigned char sense_b[SENSE_BUFF_LEN];
+	struct sg_io_hdr io_hdr;
+
+	inqCmdBlk[2] = (unsigned char) pg_op;
+	inqCmdBlk[4] = (unsigned char) (mx_resp_len & 0xff);
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = sizeof (inqCmdBlk);
+	io_hdr.mx_sb_len = sizeof (sense_b);
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = mx_resp_len;
+	io_hdr.dxferp = resp;
+	io_hdr.cmdp = inqCmdBlk;
+	io_hdr.sbp = sense_b;
+	io_hdr.timeout = DEF_TIMEOUT;
+
+	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
+		return 1;
+
+	/* treat SG_ERR here to get rid of sg_err.[ch] */
+	io_hdr.status &= 0x7e;
+	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
+			(0 == io_hdr.driver_status))
+		return 0;
+	if ((SCSI_CHECK_CONDITION == io_hdr.status) ||
+		(SCSI_COMMAND_TERMINATED == io_hdr.status) ||
+		(SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status))) {
+		if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
+			int sense_key;
+			unsigned char * sense_buffer = io_hdr.sbp;
+			if (sense_buffer[0] & 0x2)
+				sense_key = sense_buffer[1] & 0xf;
+			else
+				sense_key = sense_buffer[2] & 0xf;
+			if (RECOVERED_ERROR == sense_key)
+				return 0;
+		}
+	}
+	return 1;
+}
+
+struct c9_inquiry
+{
+	char dontcare0[9];
+	char path_prio;
+	char dontcare1[38];
+};
+
+extern int
+rdac(const char *dev)
+{
+	struct c9_inquiry inq;
+
+	int fd = open(dev, O_RDWR|O_NONBLOCK);
+
+	if (fd <= 0) {
+		fprintf(stderr, "Opening the device <%s> failed.\n", dev);
+		return 0;
+	}
+
+
+	if (0 != do_inq(fd, 0xC9, &inq, sizeof(struct c9_inquiry))) {
+		fprintf(stderr, "C9 Inquiry of device <%s> failed.\n", dev);
+		return 0;
+	}
+	return (inq.path_prio == 1 ? 100 : 0);
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
+		prio = rdac(argv[1]);
+
+	printf("%d\n", prio);
+	exit(0);
+}
+

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
