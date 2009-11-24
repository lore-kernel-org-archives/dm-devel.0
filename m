From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers Makefile checkers. ...
Date: 24 Nov 2009 20:03:17 -0000
Message-ID: <20091124200317.15011.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2009-11-24 20:03:16

Modified files:
	libcheckers    : Makefile checkers.c checkers.h tur.c 
Added files:
	libcheckers    : hp_tur.h 

Log message:
	Fix for 437585.
	Added hp_tur checker, that checks if the LUNs wwid has changed.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/hp_tur.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.3&r2=1.1.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.3&r2=1.5.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/tur.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.3&r2=1.4.2.4

--- multipath-tools/libcheckers/Makefile	2007/06/18 17:37:18	1.5.2.2
+++ multipath-tools/libcheckers/Makefile	2009/11/24 20:03:16	1.5.2.3
@@ -6,7 +6,7 @@
 
 include ../Makefile.inc
 
-OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o rdac.o cciss_tur.o
+OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o rdac.o cciss_tur.o hp_tur.o
 
 all: $(BUILD)
 
@@ -16,6 +16,9 @@
 glibc: $(OBJS)
 	ar rs libcheckers-glibc.a *.o
 
+hp_tur.o: tur.c
+	$(CC) $(CFLAGS) -DCHECK_WWID -c -o $@ $<
+
 install:
 
 uninstall:
--- multipath-tools/libcheckers/checkers.c	2007/12/17 22:27:37	1.1.2.3
+++ multipath-tools/libcheckers/checkers.c	2009/11/24 20:03:16	1.1.2.4
@@ -5,6 +5,7 @@
 
 #include "directio.h"
 #include "tur.h"
+#include "hp_tur.h"
 #include "hp_sw.h"
 #include "emc_clariion.h"
 #include "rdac.h"
@@ -35,6 +36,16 @@
 	{
 		.fd         = 0,
 		.sync       = 1,
+		.name       = HP_TUR,
+		.message    = "",
+		.context    = NULL,
+		.check      = hp_tur,
+		.init       = hp_tur_init,
+		.free       = hp_tur_free
+	},
+	{
+		.fd         = 0,
+		.sync       = 1,
 		.name       = HP_SW,
 		.message    = "",
 		.context    = NULL,
@@ -82,7 +93,16 @@
 		.init       = cciss_tur_init,
 		.free       = cciss_tur_free
 	},
-	{0, 1, "", "", NULL, NULL, NULL, NULL},
+	{
+		.fd         = 0,
+		.sync       = 1,
+		.name       = "",
+		.message    = "",
+		.context    = NULL,
+		.check      = NULL,
+		.init       = NULL,
+		.free       = NULL
+	},
 };
 
 void checker_set_fd (struct checker * c, int fd)
--- multipath-tools/libcheckers/checkers.h	2007/12/17 22:27:37	1.5.2.3
+++ multipath-tools/libcheckers/checkers.h	2009/11/24 20:03:16	1.5.2.4
@@ -14,6 +14,7 @@
 
 #define DIRECTIO     "directio"
 #define TUR          "tur"
+#define HP_TUR	     "hp_tur"
 #define HP_SW        "hp_sw"
 #define RDAC         "rdac"
 #define EMC_CLARIION "emc_clariion"
@@ -43,12 +44,14 @@
 #define CHECKER_NAME_LEN 16
 #define CHECKER_MSG_LEN 256
 #define CHECKER_DEV_LEN 256
+#define WWID_SIZE 128
 
 struct checker {
 	int fd;
 	int sync;
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
+	char wwid[WWID_SIZE];                /* LUN wwid */
 	void * context;                      /* store for persistent data */
 	int (*check)(struct checker *);
 	int (*init)(struct checker *);       /* to allocate the context */
--- multipath-tools/libcheckers/tur.c	2009/06/08 21:38:01	1.4.2.3
+++ multipath-tools/libcheckers/tur.c	2009/11/24 20:03:16	1.4.2.4
@@ -15,41 +15,155 @@
 
 #include "checkers.h"
 
+#include "../libmultipath/debug.h"
 #include "../libmultipath/sg_include.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
 
+#ifdef CHECK_WWID
+/* from linux/include/scsi/scsi.h */
+#define DID_BUS_BUSY    0x02
+#define DID_ERROR       0x07
+#define DID_TRANSPORT_DISRUPTED 0x0e
+
+#define MSG_TUR_UP     "HP tur checker reports path is up"
+#define MSG_TUR_DOWN   "HP tur checker reports path is down"
+#define MSG_TUR_GHOST  "HP tur checker reports path is in standby state"
+#define EVPD            0x01
+#define PAGE_83         0x83
+#define INQUIRY_CMD     0x12
+#define INQUIRY_CMDLEN  6
+#define SCSI_INQ_BUFF_LEN 96
+#else
 #define MSG_TUR_UP	"tur checker reports path is up"
 #define MSG_TUR_GHOST	"tur checker reports path in standby state"
 #define MSG_TUR_DOWN	"tur checker reports path is down"
+#endif
+
+#ifdef CHECK_WWID
+static int
+do_inq(struct checker * c, char * wwid)
+{
+	int ret = -1;
+	unsigned char inq_cmd[INQUIRY_CMDLEN] =
+	{INQUIRY_CMD, EVPD, PAGE_83, 0, SCSI_INQ_BUFF_LEN, 0 };
+	unsigned char sense_buffer[32];
+	unsigned char resp_buffer[SCSI_INQ_BUFF_LEN];
+	char *pbuff;
+
+	int m,k;
+	int retry_tur = 5;
+	struct sg_io_hdr io_hdr;
+
+retry:
+	memset(resp_buffer, 0, sizeof(resp_buffer));
+	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
+
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = sizeof(inq_cmd);
+	io_hdr.mx_sb_len = sizeof(sense_buffer);
+	io_hdr.dxfer_direction = -3; // Data transfer from the device.
+	io_hdr.dxfer_len = sizeof(resp_buffer);
+	io_hdr.dxferp = (unsigned char *)resp_buffer;
+	io_hdr.cmdp = inq_cmd;
+	io_hdr.sbp = sense_buffer;
+	io_hdr.timeout = 60; // IOCTL timeout value.
+
+	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
+		condlog(0, "SG_IO ioctl failed: %s", strerror(errno));
+		return ret;
+	}
+	if (io_hdr.info & SG_INFO_OK_MASK){
+		int key = 0, asc, ascq;
+
+		if (io_hdr.host_status == DID_BUS_BUSY ||
+				io_hdr.host_status == DID_ERROR ||
+				io_hdr.host_status == DID_TRANSPORT_DISRUPTED) {
+			if (--retry_tur)
+				goto retry;
+		}
+		if (io_hdr.sb_len_wr > 3) {
+			if (io_hdr.sbp[0] == 0x72 || io_hdr.sbp[0] == 0x73) {
+				key = io_hdr.sbp[1] & 0x0f;
+				asc = io_hdr.sbp[2];
+				ascq = io_hdr.sbp[3];
+			} else if (io_hdr.sb_len_wr > 13 &&
+					((io_hdr.sbp[0] & 0x7f) == 0x70 ||
+					 (io_hdr.sbp[0] & 0x7f) == 0x71)) {
+				key = io_hdr.sbp[2] & 0x0f;
+				asc = io_hdr.sbp[12];
+				ascq = io_hdr.sbp[13];
+			}
+		}
+		if (key == 0x6) {
+			/* Unit Attention, retry */
+			if (--retry_tur)
+				goto retry;
+		}
+		return ret;
+	}
+
+	pbuff = (char *) resp_buffer;
+
+	wwid[0] = '3';
+	for (m = 8, k = 1; m < 11; ++m, k+=2)
+		sprintf(&wwid[k], "%02x", (unsigned int)pbuff[m] & 0xff);
+	for (m = 11; m < 24; ++m, k+=2)
+		sprintf(&wwid[k], "%02x", (unsigned int)pbuff[m] & 0xff);
+
+	return (ret = 0);
+}
+#endif
+
 
 /* from linux/include/scsi/scsi.h */
 #define DID_BUS_BUSY    0x02
 #define DID_ERROR       0x07
 #define DID_TRANSPORT_DISRUPTED 0x0e
 
+#ifdef CHECK_WWID
+struct hp_tur_checker_context {
+#else
 struct tur_checker_context {
+#endif
 	void * dummy;
 };
 
+#ifdef CHECK_WWID
+int hp_tur_init (struct checker * c)
+{
+	memset(c->wwid, 0, WWID_SIZE);
+#else
 int tur_init (struct checker * c)
 {
+#endif
 	return 0;
 }
 
+#ifdef CHECK_WWID
+void hp_tur_free (struct checker * c)
+#else
 void tur_free (struct checker * c)
+#endif
 {
 	return;
 }
 
 extern int
+#ifdef CHECK_WWID
+hp_tur (struct checker * c)
+#else
 tur (struct checker * c)
+#endif
 {
 	struct sg_io_hdr io_hdr;
 	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
 	unsigned char sense_buffer[32];
 	int retry_tur = 5;
+#ifdef CHECK_WWID
+	char wwid[WWID_SIZE];
+#endif
 
 retry:
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
@@ -106,6 +220,24 @@
 		MSG(c, MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
+#ifdef CHECK_WWID
+	if (!do_inq(c, wwid)) {
+
+		if(!strcmp(c->wwid, "\0")) {
+			strcpy(c->wwid, wwid);
+			goto up;
+		}
+
+		if (strcmp(c->wwid , wwid)) {
+			condlog(0,
+				"hp_tur: Lun collided. new_wwid %s old_wwid %s",
+				wwid, c->wwid);
+			MSG(c, MSG_TUR_DOWN);
+			return PATH_DOWN;
+		}
+	}
+up:
+#endif
 	MSG(c, MSG_TUR_UP);
 	return PATH_UP;
 }
