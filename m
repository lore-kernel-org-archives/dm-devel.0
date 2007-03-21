From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/3] C4 Inquiry based path checker
Date: Wed, 21 Mar 2007 11:38:38 -0800
Message-ID: <20070321193838.24487.83544.sendpatchset@localhost.localdomain>
References: <20070321193833.24487.76682.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070321193833.24487.76682.sendpatchset@localhost.localdomain>
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
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, christophe.varoqui@free.fr, agk@redhat.com
List-Id: dm-devel.ids

Index: multipath-tools-0.4.7/libcheckers/Makefile
===================================================================
--- multipath-tools-0.4.7.orig/libcheckers/Makefile	2007-03-02 18:42:00.000000000 -0800
+++ multipath-tools-0.4.7/libcheckers/Makefile	2007-03-02 18:42:19.000000000 -0800
@@ -6,7 +6,7 @@
 
 include ../Makefile.inc
 
-OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o
+OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o rdac.o
 
 all: $(BUILD)
 
Index: multipath-tools-0.4.7/libcheckers/rdac.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ multipath-tools-0.4.7/libcheckers/rdac.c	2007-03-20 14:43:38.000000000 -0700
@@ -0,0 +1,109 @@
+/*
+ * Copyright (c) 2005 Christophe Varoqui
+ */
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
+#include "checkers.h"
+
+#include "../libmultipath/sg_include.h"
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
+#define MSG_RDAC_UP	"rdac checker reports path is up"
+#define MSG_RDAC_DOWN	"rdac checker reports path is down"
+#define MSG_RDAC_GHOST	"rdac checker reports path is ghost"
+
+struct rdac_checker_context {
+	void * dummy;
+};
+
+int rdac_init (struct checker * c)
+{
+	return 0;
+}
+
+void rdac_free (struct checker * c)
+{
+	return;
+}
+
+static int
+do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len)
+{
+	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = { INQUIRY_CMD, 1, 0, 0, 0, 0 };
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
+struct volume_access_inq
+{
+	char dontcare0[8];
+	char avtcvp;
+	char dontcare1[39];
+};
+
+extern int
+rdac(struct checker * c)
+{
+	struct volume_access_inq inq;
+
+	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
+		MSG(c, MSG_RDAC_DOWN);
+		return PATH_DOWN;
+	}
+
+	return ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);
+}
Index: multipath-tools-0.4.7/libcheckers/checkers.c
===================================================================
--- multipath-tools-0.4.7.orig/libcheckers/checkers.c	2006-03-13 03:07:45.000000000 -0800
+++ multipath-tools-0.4.7/libcheckers/checkers.c	2007-03-20 14:44:56.000000000 -0700
@@ -7,6 +7,7 @@
 #include "tur.h"
 #include "hp_sw.h"
 #include "emc_clariion.h"
+#include "rdac.h"
 #include "readsector0.h"
 
 static struct checker checkers[] = {
@@ -48,6 +49,15 @@
 	},
 	{
 		.fd         = 0,
+		.name       = RDAC,
+		.message    = "",
+		.context    = NULL,
+		.check      = rdac,
+		.init       = rdac_init,
+		.free       = rdac_free
+	},
+	{
+		.fd         = 0,
 		.name       = READSECTOR0,
 		.message    = "",
 		.context    = NULL,
Index: multipath-tools-0.4.7/libcheckers/rdac.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ multipath-tools-0.4.7/libcheckers/rdac.h	2007-03-20 14:43:58.000000000 -0700
@@ -0,0 +1,8 @@
+#ifndef _RDAC_H
+#define _RDAC_H
+
+int rdac(struct checker *);
+int rdac_init(struct checker *);
+void rdac_free(struct checker *);
+
+#endif /* _RDAC_H */
Index: multipath-tools-0.4.7/libcheckers/checkers.h
===================================================================
--- multipath-tools-0.4.7.orig/libcheckers/checkers.h	2006-03-13 03:07:45.000000000 -0800
+++ multipath-tools-0.4.7/libcheckers/checkers.h	2007-03-02 18:50:48.000000000 -0800
@@ -14,6 +14,7 @@
 #define DIRECTIO     "directio"
 #define TUR          "tur"
 #define HP_SW        "hp_sw"
+#define RDAC         "rdac"
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
 

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
