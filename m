From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Add cciss_tur checker
Date: Wed, 30 Apr 2008 11:04:38 +0200
Message-ID: <20080430090438.A171F18C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


The 'normal' SG_IO tur checker has some issues with cciss, so
we'd better use a dedicated path checker here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers.h           |    1 +
 libmultipath/checkers/Makefile    |    1 +
 libmultipath/checkers/cciss.h     |  142 +++++++++++++++++++++++++++++++++++++
 libmultipath/checkers/cciss_tur.c |  137 +++++++++++++++++++++++++++++++++++
 4 files changed, 281 insertions(+), 0 deletions(-)
 create mode 100644 libmultipath/checkers/cciss.h
 create mode 100644 libmultipath/checkers/cciss_tur.c

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 93337f1..4ff475d 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -61,6 +61,7 @@
 #define RDAC         "rdac"
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
+#define CCISS_TUR    "cciss_tur"
 
 #define DEFAULT_CHECKER DIRECTIO
 
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index f37a0f9..9b517f2 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -5,6 +5,7 @@
 include ../../Makefile.inc
 
 LIBS= \
+	libcheckcciss_tur.so \
 	libcheckreadsector0.so \
 	libchecktur.so \
 	libcheckdirectio.so \
diff --git a/libmultipath/checkers/cciss.h b/libmultipath/checkers/cciss.h
new file mode 100644
index 0000000..f6a37d8
--- /dev/null
+++ b/libmultipath/checkers/cciss.h
@@ -0,0 +1,142 @@
+#ifndef CCISS_H
+#define CCISS_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define CCISS_IOC_MAGIC 'B'
+
+/*
+ * transfer direction
+ */
+#define XFER_NONE		0x00
+#define XFER_WRITE		0x01
+#define XFER_READ		0x02
+#define XFER_RSVD		0x03
+
+/*
+ * task attribute
+ */
+#define ATTR_UNTAGGED		0x00
+#define ATTR_SIMPLE		0x04
+#define ATTR_HEADOFQUEUE	0x05
+#define ATTR_ORDERED		0x06
+#define ATTR_ACA		0x07
+
+/*
+ * cdb type
+ */
+#define TYPE_CMD		0x00
+#define TYPE_MSG		0x01
+
+#define SENSEINFOBYTES		32
+
+/*
+ * Type defs used in the following structs
+ */
+#define BYTE __u8
+#define WORD __u16
+#define HWORD __u16
+#define DWORD __u32
+
+#pragma pack(1)
+
+//Command List Structure
+typedef union _SCSI3Addr_struct {
+   struct {
+    BYTE Dev;
+    BYTE Bus:6;
+    BYTE Mode:2;        // b00
+  } PeripDev;
+   struct {
+    BYTE DevLSB;
+    BYTE DevMSB:6;
+    BYTE Mode:2;        // b01
+  } LogDev;
+   struct {
+    BYTE Dev:5;
+    BYTE Bus:3;
+    BYTE Targ:6;
+    BYTE Mode:2;        // b10
+  } LogUnit;
+} SCSI3Addr_struct;
+
+typedef struct _PhysDevAddr_struct {
+  DWORD             TargetId:24;
+  DWORD             Bus:6;
+  DWORD             Mode:2;
+  SCSI3Addr_struct  Target[2]; //2 level target device addr
+} PhysDevAddr_struct;
+  
+typedef struct _LogDevAddr_struct {
+  DWORD            VolId:30;
+  DWORD            Mode:2;
+  BYTE             reserved[4];
+} LogDevAddr_struct;
+
+typedef union _LUNAddr_struct {
+  BYTE               LunAddrBytes[8];
+  SCSI3Addr_struct   SCSI3Lun[4];
+  PhysDevAddr_struct PhysDev;
+  LogDevAddr_struct  LogDev;
+} LUNAddr_struct;
+
+typedef struct _RequestBlock_struct {
+  BYTE   CDBLen;
+  struct {
+    BYTE Type:3;
+    BYTE Attribute:3;
+    BYTE Direction:2;
+  } Type;
+  HWORD  Timeout;
+  BYTE   CDB[16];
+} RequestBlock_struct;
+
+typedef union _MoreErrInfo_struct{
+  struct {
+    BYTE  Reserved[3];
+    BYTE  Type;
+    DWORD ErrorInfo;
+  }Common_Info;
+  struct{
+    BYTE  Reserved[2];
+    BYTE  offense_size;//size of offending entry
+    BYTE  offense_num; //byte # of offense 0-base
+    DWORD offense_value;
+  }Invalid_Cmd;
+}MoreErrInfo_struct;
+
+typedef struct _ErrorInfo_struct {
+  BYTE               ScsiStatus;
+  BYTE               SenseLen;
+  HWORD              CommandStatus;
+  DWORD              ResidualCnt;
+  MoreErrInfo_struct MoreErrInfo;
+  BYTE               SenseInfo[SENSEINFOBYTES];
+} ErrorInfo_struct;
+
+#pragma pack()
+
+typedef struct _IOCTL_Command_struct {
+	LUNAddr_struct		LUN_info;
+	RequestBlock_struct	Request;
+	ErrorInfo_struct	error_info;
+	WORD			buf_size;  /* size in bytes of the buf */
+	BYTE			*buf;
+} IOCTL_Command_struct;
+
+typedef struct _LogvolInfo_struct{
+	__u32   LunID;
+	int     num_opens;  /* number of opens on the logical volume */
+	int     num_parts;  /* number of partitions configured on logvol */
+} LogvolInfo_struct;
+
+#define CCISS_PASSTHRU     _IOWR(CCISS_IOC_MAGIC, 11, IOCTL_Command_struct)
+#define CCISS_GETLUNINFO   _IOR(CCISS_IOC_MAGIC, 17, LogvolInfo_struct)
+
+int cciss_init( struct checker *);
+void cciss_free (struct checker * c);
+int cciss_tur( struct checker *);
+
+#endif
+
diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
new file mode 100644
index 0000000..4c26901
--- /dev/null
+++ b/libmultipath/checkers/cciss_tur.c
@@ -0,0 +1,137 @@
+/*
+ *****************************************************************************
+ *                                                                           *
+ *     (C)  Copyright 2007 Hewlett-Packard Development Company, L.P          *
+ *                                                                           *
+ * This program is free software; you can redistribute it and/or modify it   *
+ * under the terms of the GNU General Public License as published by the Free*
+ * Software  Foundation; either version 2 of the License, or (at your option)*
+ * any later version.                                                        *
+ *                                                                           *
+ * This program is distributed in the hope that it will be useful, but       *
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY*
+ * or FITNESS FOR  A PARTICULAR PURPOSE. See the GNU General Public License  *
+ * for more details.                                                         *
+ *                                                                           *
+ * You should have received a copy of the GNU General Public License along   *
+ * with this program; if not, write to the Free Software Foundation, Inc.,   *
+ * 675 Mass Ave, Cambridge, MA 02139, USA.                                   *
+ *                                                                           *
+ * The copy of the GNU General Public License is available at                *
+ * /opt/hp/HPDMmultipath-tool directoy                                       *
+ *                                                                           *
+ *****************************************************************************
+*/
+
+/*
+ *  This program originally derived from and inspired by
+ *  Christophe Varoqui's tur.c, part of libchecker.
+ */
+
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
+#include "checkers.h"
+
+#include "cciss.h"
+
+#define TUR_CMD_LEN 6
+#define HEAVY_CHECK_COUNT       10
+
+#define MSG_CCISS_TUR_UP	"cciss_tur checker reports path is up"
+#define MSG_CCISS_TUR_DOWN	"cciss_tur checker reports path is down"
+
+struct cciss_tur_checker_context {
+	void * dummy;
+};
+
+int libcheck_init (struct checker * c)
+{
+	return 0;
+}
+
+void libcheck_free (struct checker * c)
+{
+	return;
+}
+
+extern int
+libcheck_check (struct checker * c)
+{
+	int rc;
+	int ret;
+	unsigned int lun = 0;
+	struct cciss_tur_checker_context * ctxt = NULL;
+	LogvolInfo_struct    lvi;       // logical "volume" info
+	IOCTL_Command_struct cic;       // cciss ioctl command
+
+	if ((c->fd) <= 0) {
+		MSG(c,"no usable fd");
+		ret = -1;
+		goto out;
+	}
+
+	rc = ioctl(c->fd, CCISS_GETLUNINFO, &lvi);
+	if ( rc != 0) {
+		perror("Error: ");
+		fprintf(stderr, "cciss TUR  failed in CCISS_GETLUNINFO: %s\n",
+			strerror(errno));
+		MSG(c,MSG_CCISS_TUR_DOWN);
+		ret = PATH_DOWN;
+		goto out;
+	} else {
+		lun = lvi.LunID;
+	}
+
+	memset(&cic, 0, sizeof(cic));
+	cic.LUN_info.LogDev.VolId = lun & 0x3FFFFFFF;
+	cic.LUN_info.LogDev.Mode = 0x01; /* logical volume addressing */
+	cic.Request.CDBLen = 6;  /* need to try just 2 bytes here */
+	cic.Request.Type.Type =  TYPE_CMD; // It is a command.
+	cic.Request.Type.Attribute = ATTR_SIMPLE;
+	cic.Request.Type.Direction = XFER_NONE;
+	cic.Request.Timeout = 0;
+
+	cic.Request.CDB[0] = 0;
+	cic.Request.CDB[1] = 0;
+	cic.Request.CDB[2] = 0;
+	cic.Request.CDB[3] = 0;
+	cic.Request.CDB[4] = 0;
+	cic.Request.CDB[5] = 0;
+
+	rc = ioctl(c->fd, CCISS_PASSTHRU, &cic);
+	if (rc < 0) {
+		fprintf(stderr, "cciss TUR  failed: %s\n",
+			strerror(errno));
+		MSG(c,MSG_CCISS_TUR_DOWN);
+		ret = PATH_DOWN;
+		goto out;
+	}
+
+	if ((cic.error_info.CommandStatus | cic.error_info.ScsiStatus )) {
+		MSG(c,MSG_CCISS_TUR_DOWN);
+		ret = PATH_DOWN;
+		goto out;
+	}
+
+	MSG(c,MSG_CCISS_TUR_UP);
+
+	ret = PATH_UP;
+out:
+	/*
+	 * caller told us he doesn't want to keep the context :
+	 * free it
+	 */
+	if (!c->context)
+		free(ctxt);
+
+	return(ret);
+}
-- 
1.5.2.4
