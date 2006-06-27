From: James Cassidy <jcassidy@qfire.net>
Subject: Re: RHEL 4.3 to Sun 6320 storage
Date: Tue, 27 Jun 2006 16:41:47 -0400
Message-ID: <44A1980B.6040208@qfire.net>
References: <1151402657.4766.13.camel@x41ade>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000403080802080406050507"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1151402657.4766.13.camel@x41ade>
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
--------------000403080802080406050507
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Andrew Elwell wrote:

> but the error log is filling up with 
>  kernel: Device sde not ready.
>  kernel: end_request: I/O error, dev sde, sector 2181037632
>  multipathd: 8:64: mark as failed
>  multipathd: cab2a01t2: remaining active paths: 1
>  multipathd: 8:64: tur checker reports path is up
>  multipathd: 8:64: reinstated
>  multipathd: cab2a01t2: remaining active paths: 2
>  kernel: Device sde not ready.
>  kernel: end_request: I/O error, dev sde, sector 3187670215
>  kernel: device-mapper: dm-multipath: Failing path 8:64.

You'll get a device not ready on the secondary/ghost path if you have
MPxIO enabled on the array.


> 
> etc. I guess I should be using something other than the default for
> prio_callout, but what?

Nothing included with the standard kernel and multipath-tools will
work if you have the 6320 array set in MPxIO mode.  You'll either
have to set the array into 'rw' mode, which I would not recommend if
you are sharing LUNs between hosts, or you can try the patches
for the kernel and multipath-tools that I've been working on.
I've attached the patches.

The first patch is to add a hardware handler to the kernel so it
can send the command to the array to enable the secondary path to
become active if there is a problem with the primary path.  Be
sure to enable the hardware handler in the config after applying
the patch and before recompiling your kernel.

The kernel patch requires the bio-sense-data.patch be applied first.
I would also recommend applying the dm-mpath-hw-handler-sense-data
patch also.  Hopefully someone comes along and produces an alternative
to the bio-sense-data patch that can get included into the standard
kernel, but until then you have to apply it yourself.


The second patch is to the multipath-tools to add priority checker
to make sure device-mapper uses the primary path if that is available.
It also adds an entry to the hardware table so that it defaults are
set correctly for a Sun T3/T4 array. There is also a path checker
included, but readsector0 might also work too.


Comments and suggestions on the patches are welcomed.

-- 
Jim


> 
> Please can someone give me hints on the correct incantation for
> path_checker, path_grouping_policy, prio_callout
> 
> Many thanks
> 
> Andrew
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--------------000403080802080406050507
Content-Type: text/x-patch;
 name="multipath-tools-sun-tx.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-sun-tx.patch"

diff -uNr multipath-tools-0.4.7.orig/libcheckers/Makefile multipath-tools-0.4.7/libcheckers/Makefile
--- multipath-tools-0.4.7.orig/libcheckers/Makefile	2006-03-13 06:07:45.000000000 -0500
+++ multipath-tools-0.4.7/libcheckers/Makefile	2006-06-09 11:20:14.748802000 -0400
@@ -6,7 +6,7 @@
 
 include ../Makefile.inc
 
-OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o
+OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o sun_tx.o
 
 all: $(BUILD)
 
diff -uNr multipath-tools-0.4.7.orig/libcheckers/checkers.c multipath-tools-0.4.7/libcheckers/checkers.c
--- multipath-tools-0.4.7.orig/libcheckers/checkers.c	2006-03-13 06:07:45.000000000 -0500
+++ multipath-tools-0.4.7/libcheckers/checkers.c	2006-06-09 11:08:08.131391250 -0400
@@ -8,6 +8,7 @@
 #include "hp_sw.h"
 #include "emc_clariion.h"
 #include "readsector0.h"
+#include "sun_tx.h"
 
 static struct checker checkers[] = {
 	{
@@ -55,6 +56,15 @@
 		.init       = readsector0_init,
 		.free       = readsector0_free
 	},
+	{
+		.fd         = 0,
+		.name       = SUN_TX,
+		.message    = "",
+		.context    = NULL,
+		.check      = sun_tx,
+		.init       = sun_tx_init,
+		.free       = sun_tx_free
+	},
 	{0, "", "", NULL, NULL, NULL, NULL},
 };
 
diff -uNr multipath-tools-0.4.7.orig/libcheckers/checkers.h multipath-tools-0.4.7/libcheckers/checkers.h
--- multipath-tools-0.4.7.orig/libcheckers/checkers.h	2006-03-13 06:07:45.000000000 -0500
+++ multipath-tools-0.4.7/libcheckers/checkers.h	2006-06-09 11:07:56.878688000 -0400
@@ -16,6 +16,7 @@
 #define HP_SW        "hp_sw"
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
+#define SUN_TX       "sun_tx"
 
 #define DEFAULT_CHECKER READSECTOR0
 
diff -uNr multipath-tools-0.4.7.orig/libcheckers/sun_tx.c multipath-tools-0.4.7/libcheckers/sun_tx.c
--- multipath-tools-0.4.7.orig/libcheckers/sun_tx.c	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools-0.4.7/libcheckers/sun_tx.c	2006-06-09 11:23:40.461658250 -0400
@@ -0,0 +1,110 @@
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
+#define INQUIRY_CMD		0x12
+#define INQUIRY_CMDLEN		6
+#define SENSE_BUFF_LEN		32
+#define DEF_TIMEOUT		60000
+#define SCSI_CHECK_CONDITION	0x2
+#define SCSI_COMMAND_TERMINATED 0x22
+#define SG_ERR_DRIVER_SENSE     0x08
+#define RECOVERED_ERROR         0x01
+#define MX_ALLOC_LEN            255
+
+#define MSG_SUN_TX_UP    "sun_tx checker reports path is up"
+#define MSG_SUN_TX_DOWN  "sun_tx checker reports path is down"
+#define MSG_SUN_TX_GHOST "sun_tx checker reports path is ghost"
+
+static int
+do_inq(int sg_fd, int evpd, unsigned int pg_op,
+       void *resp, int mx_resp_len)
+{
+        unsigned char inqCmdBlk[INQUIRY_CMDLEN] =
+            { INQUIRY_CMD, 0, 0, 0, 0, 0 };
+        unsigned char sense_b[SENSE_BUFF_LEN];
+        struct sg_io_hdr io_hdr;
+                                                                                                                 
+        if (evpd)
+                inqCmdBlk[1] |= 1;
+        inqCmdBlk[2] = (unsigned char) pg_op;
+	inqCmdBlk[3] = (unsigned char)((mx_resp_len >> 8) & 0xff);
+	inqCmdBlk[4] = (unsigned char) (mx_resp_len & 0xff);
+        memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+        io_hdr.interface_id = 'S';
+        io_hdr.cmd_len = sizeof (inqCmdBlk);
+        io_hdr.mx_sb_len = sizeof (sense_b);
+        io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+        io_hdr.dxfer_len = mx_resp_len;
+        io_hdr.dxferp = resp;
+        io_hdr.cmdp = inqCmdBlk;
+        io_hdr.sbp = sense_b;
+        io_hdr.timeout = DEF_TIMEOUT;
+ 
+        if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
+                return 1;
+ 
+        /* treat SG_ERR here to get rid of sg_err.[ch] */
+        io_hdr.status &= 0x7e;
+        if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
+            (0 == io_hdr.driver_status))
+                return 0;
+        if ((SCSI_CHECK_CONDITION == io_hdr.status) ||
+            (SCSI_COMMAND_TERMINATED == io_hdr.status) ||
+            (SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status))) {
+                if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
+                        int sense_key;
+                        unsigned char * sense_buffer = io_hdr.sbp;
+                        if (sense_buffer[0] & 0x2)
+                                sense_key = sense_buffer[1] & 0xf;
+                        else
+                                sense_key = sense_buffer[2] & 0xf;
+                        if(RECOVERED_ERROR == sense_key)
+                                return 0;
+                }
+        }
+        return 1;
+}
+
+
+extern int
+sun_tx (struct checker * c)
+{
+	char buff[255];
+
+	if (0 != do_inq(c->fd, 0, 0, buff, sizeof(buff))) {
+		MSG(c, MSG_SUN_TX_DOWN);
+		return PATH_DOWN;
+	}
+
+	if (0x20 & buff[6]) {
+		MSG(c, MSG_SUN_TX_GHOST);
+		return PATH_GHOST;
+	}
+
+	MSG(c, MSG_SUN_TX_UP);
+	return PATH_UP;
+}
+
+extern int
+sun_tx_init (struct checker * c)
+{
+	return 0;
+}
+
+void
+sun_tx_free (struct checker * c)
+{
+	return;
+}
+
diff -uNr multipath-tools-0.4.7.orig/libcheckers/sun_tx.h multipath-tools-0.4.7/libcheckers/sun_tx.h
--- multipath-tools-0.4.7.orig/libcheckers/sun_tx.h	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools-0.4.7/libcheckers/sun_tx.h	2006-06-09 11:08:48.561918000 -0400
@@ -0,0 +1,9 @@
+
+#ifndef _SUN_TX_H
+#define _SUN_TX_H
+
+int sun_tx (struct checker *);
+int sun_tx_init (struct checker *);
+void sun_tx_free (struct checker *);
+
+#endif /* _SUN_TX_H */
diff -uNr multipath-tools-0.4.7.orig/libmultipath/hwtable.c multipath-tools-0.4.7/libmultipath/hwtable.c
--- multipath-tools-0.4.7.orig/libmultipath/hwtable.c	2006-03-13 06:07:45.000000000 -0500
+++ multipath-tools-0.4.7/libmultipath/hwtable.c	2006-06-12 14:56:00.671262250 -0400
@@ -422,18 +422,18 @@
 	 */
 	{
 		.vendor        = "SUN",
-		.product       = "{StorEdge 3510,T4}",
+		.product       = "(StorEdge 3510|T[34])",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
+		.getprio       = "/sbin/mpath_prio_sun_tx /dev/%n",
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 sun_tx",
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = SUN_TX,
 	},
 	/*
 	 * EOL
diff -uNr multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/Makefile multipath-tools-0.4.7/path_priority/pp_sun_tx/Makefile
--- multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools-0.4.7/path_priority/pp_sun_tx/Makefile	2006-06-09 11:31:42.435779750 -0400
@@ -0,0 +1,32 @@
+
+EXEC           = mpath_prio_sun_tx
+OBJS           = main.o
+BUILD          = glibc
+INSTALL        = install -D
+
+TOPDIR	= ../..
+
+ifneq ($(shell ls $(TOPDIR)/Makefile.inc 2> /dev/null),)
+include $(TOPDIR)/Makefile.inc
+endif
+
+CFLAGS += -Wall -O0 -g
+
+all: $(BUILD)
+
+glibc: $(OBJS)
+	$(CC) -o $(EXEC) $(OBJS) $(LDFLAGS)
+
+klibc: $(OBJS)
+	$(CC) -static -o $(EXEC) $(OBJS)
+
+install: $(BUILD)
+	$(INSTALL) -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+
+clean:
+	rm -f *.o $(EXEC)
+
+main.o: main.c scsi3.h sun_tx.h Makefile
diff -uNr multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/main.c multipath-tools-0.4.7/path_priority/pp_sun_tx/main.c
--- multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/main.c	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools-0.4.7/path_priority/pp_sun_tx/main.c	2006-06-09 10:56:34.916068000 -0400
@@ -0,0 +1,90 @@
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "sun_tx.h"
+
+#define SUN_TX_PRIO_SUCCESS			0
+#define SUN_TX_PRIO_INVALID_COMMANDLINE	1
+#define SUN_TX_PRIO_OPEN_FAILED		2
+
+static void
+print_help(char *program)
+{
+	printf("Usage: %s <device>\n", program);
+}
+
+static int
+open_block_device(char *name)
+{
+	int		fd;
+	struct stat	st;
+
+        if (stat(name, &st) != 0) {
+                fprintf(stderr, "Cannot get file status from %s (errno = %i)!\n",
+                        name, errno);
+                return -SUN_TX_PRIO_OPEN_FAILED;
+        }
+        if (!S_ISBLK(st.st_mode)) {
+                fprintf(stderr, "%s is not a block device!\n", name);
+                return -SUN_TX_PRIO_OPEN_FAILED;
+        }
+        fd = open(name, O_RDONLY);
+        if (fd < 0) {
+                fprintf(stderr, "Couldn't open %s (errno = %i)!\n", name, errno);
+                return -SUN_TX_PRIO_OPEN_FAILED;
+        }
+        return fd;
+}
+
+static int
+close_block_device(int fd)
+{
+        return close(fd);
+}
+
+int
+main(int argc, char **argv)
+{
+	int		fd;
+	char		device[256];
+
+	if (argc != 2) {
+		print_help(argv[0]);
+		return -1;
+	}
+
+	if (argv[1][0] == '/') {
+		strncpy( device, argv[1], sizeof(device));
+	} else {
+		strncpy( device, "/dev/", sizeof(device));
+		strncat( device, argv[1], sizeof(device)-5);
+	}
+
+	fd = open_block_device(device);
+
+	if (fd < 0)
+		return -fd;
+
+	{
+		scsi3_inquiry_t	resp;
+
+		if (scsi3_inquiry(fd, 0, 0, (unsigned char *)&resp, sizeof(resp)) != 0)
+			return -2;
+
+		if (resp.vendor1 == 0)
+			puts("50");
+		else
+			puts("1");
+	}
+
+	close_block_device(fd);
+	return SUN_TX_PRIO_SUCCESS;
+}
diff -uNr multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/scsi3.h multipath-tools-0.4.7/path_priority/pp_sun_tx/scsi3.h
--- multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/scsi3.h	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools-0.4.7/path_priority/pp_sun_tx/scsi3.h	2006-06-09 10:20:03.035084000 -0400
@@ -0,0 +1,446 @@
+
+#ifndef __SCSI3_H__
+#define __SCSI3_H__
+
+#include <endian.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#define __user
+#include  <scsi/sg.h>
+
+
+#define SCSI3_CMD_INQUIRY	0x12
+
+#define SCSI3_PQ_CONNECTED		0x0
+#define SCSI3_PQ_DISCONNECTED		0x1
+#define SCSI3_PQ_UNSUPPORTED		0x3
+
+#define PDT_DIRECT_ACCESS                               0x00
+#define PDT_SEQUENTIAL_ACCESS                           0x01
+#define PDT_PRINTER                                     0x02
+#define PDT_PROCESSOR                                   0x03
+#define PDT_WRITE_ONCE                                  0x04
+#define PDT_CD_DVD                                      0x05
+#define PDT_SCANNER                                     0x06
+#define PDT_OPTICAL_MEMORY                              0x07
+#define PDT_MEDIUM_CHANGER                              0x08
+#define PDT_COMMUNICATIONS                              0x09
+#define PDT_STORAGE_ARRAY_CONTROLLER                    0x0c
+#define PDT_ENCLOSURE_SERVICES                          0x0d
+#define PDT_SIMPLIFIED_DIRECT_ACCESS                    0x0e
+#define PDT_OPTICAL_CARD_READER_WRITER                  0x0f
+#define PDT_BRIDGE_CONTROLLER                           0x10
+#define PDT_OBJECT_BASED                                0x11
+#define PDT_AUTOMATION_INTERFACE                        0x12
+#define PDT_LUN                                         0x1e
+#define PDT_UNKNOWN                                     0x1f
+
+#define VERSION_NONE                                    0x00
+#define VERSION_SPC                                     0x03
+#define VERSION_SPC2                                    0x04
+#define VERSION_SPC3                                    0x05
+#define VERSION_SPC4					0x06
+
+#define TPGS_NO_SUPPORT					0x00
+#define TPGS_IMPLICIT_SUPPORT				0x01
+#define TPGS_EXPLICIT_SUPPORT				0x10
+#define TPGS_IMPLICIT_AND_EXPLICIT_SUPPORT		0x11
+
+static inline unsigned short
+scsi3_get_uint16(unsigned char *p)
+{
+	return (p[0] << 8) + p[1];
+}
+
+static inline void
+scsi3_set_uint16(unsigned char *p, unsigned short v)
+{
+	p[0] = (v >> 8) & 0xff;
+	p[1] = v & 0xff;
+}
+
+static inline unsigned int
+scsi3_get_uint32(unsigned char *p)
+{
+	return (p[0] << 24) + (p[1] << 16) + (p[2] << 8) + p[3];
+}
+
+static inline void
+scsi3_set_uint32(unsigned char *p, unsigned short v)
+{
+	p[0] = (v >> 24) & 0xff;
+	p[1] = (v >> 16) & 0xff;
+	p[2] = (v >> 8) & 0xff;
+	p[3] = v & 0xff;
+}
+
+/* Notes: */
+/* assert 'rdf' field should be equal to 2 */
+
+typedef struct {
+	unsigned char code;		/* Operation Code (0x12) */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned evpd : 1;
+	unsigned obsolete1 : 1;
+	unsigned reserved1 : 6;
+#else
+	unsigned reserved1 : 6;
+	unsigned obsolete1 : 1;
+	unsigned evpd : 1;
+#endif
+
+	unsigned char pc;		/* Page Code */
+	unsigned char length[2];
+	unsigned char control;
+} __attribute__((packed)) scsi3_inquiry6_t;
+
+typedef struct {
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned pdt : 5;		/* Peripheral Device Type */
+	unsigned pq : 3;		/* Peripheral Qualifier */
+
+	unsigned reserved1 : 7;
+	unsigned rmb : 1;
+
+	unsigned char version;
+
+	unsigned rdf : 4;		/* Response Data Format */
+	unsigned hisup : 1;		/* Hierarchical Addressing Model */
+	unsigned normaca : 1;		/* Supports ACA task attribute */
+	unsigned obsolete1 : 1;
+	unsigned obsolete2 : 1;
+
+	unsigned char	length;		/* Additional Length */
+
+	unsigned protect : 1;
+	unsigned reserved2 : 2;
+	unsigned tpc : 1 ;		/* Third Party Copy */
+	unsigned tpgs : 2;		/* Target Port Group Support */
+	unsigned acc : 1;		/* Access Controls Coordinator */
+	unsigned sccs : 1;		/* Embedded Storage Array Controller */
+					/* ... See SCC-2 for details */
+
+	unsigned addr16 : 1;
+	unsigned obsolete3 : 1;
+	unsigned obsolete4 : 1;
+	unsigned obsolete5 : 1;
+	unsigned multip : 1;
+	unsigned vendor1 : 1;		/* Vendor Specific */
+	unsigned encserv : 1;
+	unsigned bque : 1;
+
+	unsigned vendor2 : 1;		/* Vendor Specific */
+	unsigned cmdque : 1;
+	unsigned obsolete6 : 1;
+	unsigned linked : 1;
+	unsigned sync : 1;
+	unsigned wbus16 : 1;
+	unsigned obsolete7 : 1;
+	unsigned obsolete8 : 1;
+
+#else
+	unsigned pq : 3;		/* Peripheral Qualifier */
+	unsigned pdt : 5;		/* Peripheral Device Type */
+
+	unsigned rmb : 1;
+	unsigned reserved1 : 7;
+
+	unsigned char version;
+
+	unsigned obsolete2 : 1;
+	unsigned obsolete1 : 1;
+	unsigned normaca : 1;		/* Supports ACA task attribute */
+	unsigned hisup : 1;		/* Hierarchical Addressing Model */
+	unsigned rdf : 4;		/* Response Data Format */
+
+	unsigned char	length;		/* Additional Length */
+
+	unsigned sccs : 1;
+	unsigned acc : 1;
+	unsigned tpgs : 2;		/* */
+	unsigned tpc : 1 ;		/* Third Party Copy */
+	unsigned reserved2 : 2;
+	unsigned protect : 1;
+
+	unsigned bque : 1;
+	unsigned encserv : 1;
+	unsigned vendor1 : 1;		/* Vendor Specific */
+	unsigned multip : 1;
+	unsigned obsolete5 : 1;
+	unsigned obsolete4 : 1;
+	unsigned obsolete3 : 1;
+	unsigned addr16 : 1;
+
+	unsigned obsolete8 : 1;
+	unsigned obsolete7 : 1;
+	unsigned wbus16 : 1;
+	unsigned sync : 1;
+	unsigned linked : 1;
+	unsigned obsolete6 : 1;
+	unsigned cmdque : 1;
+	unsigned vendor2 : 1;		/* Vendor Specific */
+#endif
+	unsigned char	vendor_identification[8];
+	unsigned char	product_identification[8];
+	unsigned char	product_revision[4];
+	unsigned char	vendor3[20];
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned ius : 1;
+	unsigned qas : 1;
+	unsigned clocking : 2;
+	unsigned reserved3 : 4;
+#else
+	unsigned reserved3 : 4;
+	unsigned clocking : 2;
+	unsigned qas : 1;
+	unsigned iua : 1;
+#endif
+
+	unsigned char	reserved4;
+
+	unsigned char	version_descriptor[8][2];
+
+	unsigned char	reserved5[22];
+
+	unsigned char	vendor_parameters[0];
+} __attribute__((packed)) scsi3_inquiry_t;
+
+static inline int
+scsi3_inquiry_multiport(scsi3_inquiry_t *id)
+{
+	return id->multip;
+}
+
+static inline int
+sun_tx_inquiry_active_path(scsi3_inquiry_t *id)
+{
+	return id->multip && id->vendor1;
+}
+
+#define SCSI3_CHECK_CONDITION		0x2
+#define SCSI3_COMMAND_TERMINATED	0x22
+#define SCSI3_SG_ERROR_DRIVER_SENSE	0x08
+#define SCSI3_RECOVERED_ERROR		0x01
+
+static int
+scsi3_error(struct sg_io_hdr *hdr)
+{
+        /* Treat SG_ERR here to get rid of sg_err.[ch] */
+        hdr->status &= 0x7e;
+
+        if (
+                (hdr->status == 0)        &&
+                (hdr->host_status == 0)   &&
+                (hdr->driver_status == 0)
+        ) {
+                return 0;
+        }
+
+        if (
+                (hdr->status == SCSI3_CHECK_CONDITION)    ||
+                (hdr->status == SCSI3_COMMAND_TERMINATED) ||
+                ((hdr->driver_status & 0xf) == SCSI3_SG_ERROR_DRIVER_SENSE)
+        ) {
+                if (hdr->sbp && (hdr->sb_len_wr > 2)) {
+                        int             sense_key;
+                        unsigned char * sense_buffer = hdr->sbp;
+
+                        if (sense_buffer[0] & 0x2)
+                                sense_key = sense_buffer[1] & 0xf;
+                        else
+                                sense_key = sense_buffer[2] & 0xf;
+
+                        if (sense_key == SCSI3_RECOVERED_ERROR)
+                                return 0;
+                }
+        }
+
+        return 1;
+}
+
+
+static inline int
+scsi3_inquiry(int fd, int evpd, unsigned int pc, void *resp, int resplen)
+{
+	scsi3_inquiry6_t	cmd;
+	struct sg_io_hdr	hdr;
+	unsigned char		sense[32];
+
+	memset(&cmd, 0, sizeof(scsi3_inquiry6_t));
+
+	cmd.code = SCSI3_CMD_INQUIRY;
+
+	if (evpd) {
+		cmd.evpd = 1;
+		cmd.pc = pc;
+	}
+
+	scsi3_set_uint16(cmd.length, resplen);
+
+	memset(&hdr, 0, sizeof(struct sg_io_hdr));
+
+	hdr.interface_id	= 'S';
+	hdr.cmdp		= (unsigned char *) &cmd;
+	hdr.cmd_len		= sizeof(cmd);
+	hdr.dxfer_direction	= SG_DXFER_FROM_DEV;
+	hdr.dxferp		= resp;
+	hdr.dxfer_len		= resplen;
+	hdr.sbp			= sense;
+	hdr.mx_sb_len		= sizeof(sense);
+	hdr.timeout		= 60000;
+	
+
+	if (ioctl(fd, SG_IO, &hdr) < 0) {
+		return -1;
+	}
+
+	if (scsi3_error(&hdr)) {
+		return -2;
+	}
+
+	return 0;
+}
+
+#define SCSI3_ASSOC_LUN		0x00
+#define SCSI3_ASSOC_PORT	0x01
+#define SCSI3_ASSOC_TARGET	0x10
+
+#define SCSI3_PROTOCOL_FC		0x0		/* FCP-2 */
+#define SCSI3_PROTOCOL_pSCSI		0x1		/* SPI-5 */
+#define SCSI3_PROTOCOL_SSA		0x2		/* SSA-S3P */
+#define SCSI3_PROTOCOL_IEEE1394		0x3		/* SBP-3 */
+#define SCSI3_PROTOCOL_SRP		0x4		/* SRP */
+#define SCSI3_PROTOCOL_iSCSI		0x5		/* iSCSI */
+#define SCSI3_PROTOCOL_SAS		0x6		/* SAS */
+#define SCSI3_PROTOCOL_ADT		0x7		/* ADT */
+#define SCSI3_PROTOCOL_ATAPI		0x8		/* ATA/ATAPI-7 */
+#define SCSI3_UNKNOWN			0xf
+
+#define SCSI3_CODESET_BINARY		0x1
+#define SCSI3_CODESET_ASCII		0x2
+#define SCSI3_CODESET_UTF8		0x3
+
+#define SCSI3_TYPE_VENDOR1		0x0
+#define SCSI3_TYPE_VENDOR_ID		0x1
+#define SCSI3_TYPE_EUI64		0x2
+#define SCSI3_TYPE_NAA			0x3
+#define SCSI3_TYPE_RTPI			0x4		/* Relative Target Port Identifier */
+#define SCSI3_TYPE_TPG			0x5		/* Target Port Group */
+#define SCSI3_TYPE_LPG			0x6		/* Logical Unit Group */
+#define SCSI3_TYPE_MD5			0x7		/* MD% Logical Unit Identifier */
+#define SCSI3_TYPE_NAME			0x8		/* SCSI name string */
+
+#define SCSI3_DEVICE_ID_PAGE 0x83
+typedef struct {
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned pdt : 5;		/* Peripheral Device Type */
+	unsigned pq : 3;		/* Peripheral Qualifier */
+#else
+	unsigned pq : 3;		/* Peripheral Qualifier */
+	unsigned pdt : 5;		/* Peripheral Device Type */
+#endif
+
+	unsigned char pc;		/* Page Code == 0x83 */
+
+	unsigned char length[2];	/* Page Length */
+
+	unsigned char list[0];
+} __attribute__((packed)) scsi3_device_id_page_t;
+
+typedef struct {
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned codeset : 4;		/* Code Set */
+	unsigned pi : 4;		/* Protocol Identifier */
+
+	unsigned type : 4;		/* Designator Type */
+	unsigned assoc : 2;		/* Port or Target */
+	unsigned reserved1 : 1;
+	unsigned piv : 1;
+#else
+	unsigned pi : 4;		/* Protocol Identifier */
+	unsigned codeset : 4;		/* Code Set */
+
+	unsigned piv : 1;
+	unsigned reserved1 : 1;
+	unsigned assoc : 2;
+	unsigned type : 4;
+#endif
+
+	unsigned char reserved2;
+
+	unsigned char length;		/* Designator Length */
+
+	unsigned char data[0];
+} __attribute__((packed)) scsi3_device_descr_page_t;
+
+static inline unsigned int
+scsi3_protocol( scsi3_device_descr_page_t *ddp )
+{
+	if (ddp->piv == 1 && 
+	    (ddp->assoc == SCSI3_ASSOC_PORT || ddp->assoc == SCSI3_ASSOC_TARGET ))
+		return ddp->pi;
+	else
+		return SCSI3_UNKNOWN;
+}
+
+
+static inline unsigned char *
+scsi3_get_device_descriptor(scsi3_device_id_page_t *dip,
+                            unsigned char codeset,
+                            unsigned char assoc,
+                            unsigned char type,
+                            unsigned char length )
+{
+	scsi3_device_descr_page_t *p = NULL;
+	unsigned char *pend = NULL;
+
+	if (dip->pc != SCSI3_DEVICE_ID_PAGE)
+		return NULL;
+
+	pend = (unsigned char *) dip->list;
+	pend += scsi3_get_uint16( dip->length );
+
+
+	p = (scsi3_device_descr_page_t *) dip->list;
+
+	while ( (unsigned char *)p < pend )
+	{
+		if ( codeset == p->codeset && assoc == p->assoc &&
+		     type == p->type && length == p->length )
+			return (unsigned char *)p->data;
+
+		/* next */
+		p = (scsi3_device_descr_page_t *) (((unsigned char *)p) + p->length + sizeof(scsi3_device_descr_page_t));
+	}
+
+	return NULL;
+}
+
+typedef struct {
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned company_id_3 : 4;	/* Company ID MSB */
+	unsigned naa : 4;		/* NAA (0x6) */
+#else
+	unsigned naa : 4;		/* NAA (0x6 */
+	unsigned company_id_3 : 4;	/* Company ID MSB */
+#endif
+
+	unsigned company_id_2;		/* Company ID Middle */
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned vendor_id_2 : 4;	/* Vendor ID MSB */
+	unsigned company_id_1 : 4;	/* Company ID LSB */
+#else
+	unsigned company_id_1 : 4;	/* Company ID LSB */
+	unsigned vendor_id_2 : 4;	/* Vendor ID MSB */
+#endif
+
+	unsigned char vendor_id_1;	/* Vendor ID LSB */
+
+	unsigned char vendir_id_ext[2];	/* Vendor ID Extension */
+} __attribute__((packed)) scsi3_naa_iee_reg_ext_t;
+
+
+#endif 
diff -uNr multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/sun_tx.h multipath-tools-0.4.7/path_priority/pp_sun_tx/sun_tx.h
--- multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/sun_tx.h	1969-12-31 19:00:00.000000000 -0500
+++ multipath-tools-0.4.7/path_priority/pp_sun_tx/sun_tx.h	2006-06-09 09:04:30.995849250 -0400
@@ -0,0 +1,94 @@
+
+
+#ifndef __SUN_TX_H__
+#define __SUN_TX_H__
+
+#include "scsi3.h"
+
+/*
+ * Notes:
+ * 	* inquiry.vendor3[0...8] = Serial Number
+ * 	* inquiry.vendor3[9] = '1' is Master Controller, '0' is Alternative Master
+ *
+ * 	* LUN WWN contained in device_id_page
+ * 	* inquiry.vendor1 = 0x0 is Preferred Path, 0x1 is Standby Path
+ */
+
+
+/* Sun vendor specific SCSI CDB commands for T3 and T4 arrays */
+/* the command should be of length 10 */
+#define SUN_TX_FAILOVER_CDB_OP			0xd0
+
+
+/* place in CDB[1] of the command */
+#define SUN_TX_FAILOVER_CDB_GRAB		0x01	/* change passive path to active */
+#define SUN_TX_FAILOVER_CDB_RESERVATION_CHECK	0x02	/* check for reservations */
+
+/* ASC values for Sun's T3/T4 indicating failover */
+#define SUN_TX_ASC_LUN_NOT_READY		0x04	/* SCSI standard */
+#define SUN_TX_ASC_FAILOVER_IN_PROGRESS		0x90	/* Sun specific */
+
+/* ASCQ values for ASC = ASC_FAILOVER_IN_PROGRESS */
+#define SUN_TX_ASCQ_BECOMING_INACTIVE		0x00
+#define SUN_TX_ASCQ_BECOMING_ACTIVE		0x01
+
+/* Sun's ASCQ values for ASC = SUN_TX_ASC_LUN_NOT_READY */
+#define SUN_TX_ASCQ_PATH_INACTIVE		0x88	/* Sun specific */
+
+
+typedef enum {
+	SUN_TX_PORT_FO_MODE_NONE,
+	SUN_TX_PORT_FO_MODE_RW,
+	SUN_TX_PORT_FO_MODE_MPXIO,
+	SUN_TX_PORT_FO_MODE_IOCTL,
+	SUN_TX_PORT_FO_MAX_MODE
+} sun_tx_fo_mode_t;
+
+typedef enum {
+	SUN_TX_PORT_STATE_ACTIVE,
+	SUN_TX_PORT_STATE_INACTIVE
+} sun_tx_port_state_t;
+
+/* System failover mode (VPD Page 0x83 -- Device Identification) */
+#define SUN_TX_PORT_ID_TYPE 0x0f
+typedef struct {
+	unsigned char	mode;
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	unsigned state : 2;
+	unsigned reserved1 : 6;
+#else
+	unsigned reserved1 : 6;
+	unsigned state : 2;
+#endif
+
+	unsigned char	reserved2[2];
+} sun_tx_port_id_page_t;
+
+/* System ID Page (VPD Page 0xD0) */
+#define SUN_TX_SYSTEM_ID_PAGE	0xd0
+typedef struct {
+	unsigned char	pq;
+	unsigned char	page_code;
+	unsigned char	reserved1;
+	unsigned char	page_length;
+	unsigned char	code_set;
+	unsigned char	id_type;
+	unsigned char	reserved2;
+	unsigned char	id_length;
+	unsigned char	system_wwn[16];
+} sun_tx_system_id_page_t;
+
+
+/* Device IP Address Page (VPD Page 0xD1) */
+#define SUN_TX_IP_ADDRESS_ID_PAGE	0xd1
+typedef struct {
+	unsigned char	pagecode;
+	unsigned char	reserved1;
+	unsigned char	pagelength;
+	unsigned char	ip_address[15];
+} sun_tx_ip_address_page_t;
+
+
+#define SUN_TX
+#endif
Files multipath-tools-0.4.7.orig/path_priority/pp_sun_tx/test and multipath-tools-0.4.7/path_priority/pp_sun_tx/test differ

--------------000403080802080406050507
Content-Type: text/x-patch;
 name="dm-sun-tx-0.0.1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-sun-tx-0.0.1.patch"


* Apply bio-sense-data.patch first.
* Apply dm-mpath-hw-handler-sense-data.patch first.

diff -uNr linux/drivers/md/Kconfig linux.sun_tx/drivers/md/Kconfig
--- linux/drivers/md/Kconfig	2006-06-05 10:26:24.000000000 -0400
+++ linux.sun_tx/drivers/md/Kconfig	2006-06-09 12:09:46.174504500 -0400
@@ -236,6 +236,12 @@
 	---help---
 	  Multipath support for EMC CX/AX series hardware.
 
+config DM_MULTIPATH_SUN_TX
+	tristate "SUN T3/T4 multipath support (EXPIERMENTAL)"
+	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Multipath support for SUN T3/T4/6120 series hardware.
+
 config BLK_DEV_DM_BBR
 	tristate "Bad Block Relocation Device Target (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
diff -uNr linux/drivers/md/Makefile linux.sun_tx/drivers/md/Makefile
--- linux/drivers/md/Makefile	2006-06-05 10:26:24.000000000 -0400
+++ linux.sun_tx/drivers/md/Makefile	2006-06-09 12:10:12.252134250 -0400
@@ -34,6 +34,7 @@
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
+obj-$(CONFIG_DM_MULTIPATH_SUN_TX) += dm-sun-tx.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
diff -uNr linux/drivers/md/dm-sun-tx.c linux.sun_tx/drivers/md/dm-sun-tx.c
--- linux/drivers/md/dm-sun-tx.c	1969-12-31 19:00:00.000000000 -0500
+++ linux.sun_tx/drivers/md/dm-sun-tx.c	2006-06-13 14:50:27.477507250 -0400
@@ -0,0 +1,319 @@
+/*
+ * Multipath support for SUN T3/T4
+ */
+
+#include "dm.h"
+#include "dm-hw-handler.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+
+#define SUN_TX_FAILOVER_TIMEOUT (60 * HZ)
+#define SUN_TX_FAILOVER_OP 0xd0
+#define SUN_TX_FAILOVER_GRAB 0x01
+
+#define SUN_TX_INQUIRY_TIMEOUT (60 * HZ)
+#define SUN_TX_INQUIRY_CMD 0x12;
+#define SUN_TX_INQUIRY_RESP_SIZE		255
+
+#define SUN_TX_ASC_FAILOVER_IN_PROGRESS		0x90
+
+/* ASCQ values for ASC = ASC_FAILOVER_IN_PROGRESS */
+#define SUN_TX_ASCQ_BECOMING_INACTIVE		0x00
+#define SUN_TX_ASCQ_BECOMING_ACTIVE		0x01
+
+/* ASCQ values for ASC = SAM_STAT_BUSY */
+#define SUN_TX_ASCQ_PATH_INACTIVE		0x88
+
+
+struct sun_tx_handler {
+	spinlock_t lock;
+
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+};
+
+struct sun_tx_bio_data {
+	struct sun_tx_handler *  h;
+	struct path *            path;
+	struct request *	 rq;
+};
+
+static inline void free_bio(struct bio *bio)
+{
+	__free_page(bio->bi_io_vec[0].bv_page);
+	bio_put(bio);
+}
+
+static int sun_tx_failover_endio(struct bio *bio, unsigned int bytes_done, int error)
+{
+	struct sun_tx_bio_data *bd = bio->bi_private;
+
+	/* LUN GRAB Request should not return any data */
+	if (bio->bi_size)
+		return 1;
+
+	if (error)
+		dm_pg_init_complete(bd->path, MP_FAIL_PATH);
+	else
+		dm_pg_init_complete(bd->path, 0);
+
+	free_bio(bio);
+	kfree(bd);
+	return 0;
+}
+
+
+static struct bio *sun_tx_bio(void)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_ATOMIC, 1);
+	if (!bio) {
+		DMERR("dm-sun-tx: get_failover_bio: bio_alloc() failed.");
+		return NULL;
+	}
+
+	bio->bi_rw |= (1 << BIO_RW);
+	bio->bi_sector = 0;
+
+	return bio;
+}
+
+static struct page *sun_tx_alloc_page(struct bio *bio, unsigned int data_size)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_ATOMIC);
+	if(!page) {
+		DMERR("dm-sun-tx: sun_tx_alloc_page: alloc_page() failed.");
+		bio_put(bio);
+		return NULL;
+	}
+
+	if (bio_add_page(bio, page, data_size, 0) != data_size) {
+		DMERR("dm-sun-tx: sun_tx_alloc_page: bio_add_page() failed.");
+		__free_page(page);
+		bio_put(bio);
+		return NULL;
+	}
+
+	return bio_data(bio);
+}
+
+static struct request *sun_tx_rq(struct sun_tx_handler *h,
+                                        struct bio *bio, struct path *path)
+{
+	struct request *rq;
+	struct block_device *bdev = bio->bi_bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	if (!rq) {
+		DMERR("dm-sun-tx: sun_tx_rq: blk_get_request failed");
+		return NULL;
+	}
+
+	rq->bio = rq->biotail = bio;
+	blk_rq_bio_prep(q, rq, bio);
+
+	rq->rq_disk = bdev->bd_contains->bd_disk;
+
+	/* bio back ed don't set data */
+	rq->buffer = rq->data = NULL;
+	/* rq data_len used for pc cmd's request_bufflen */
+	rq->data_len = bio->bi_size;
+
+	rq->sense = h->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = 0;
+
+	memset(&rq->cmd, 0, BLK_MAX_CDB);
+
+	return rq;
+}
+
+static struct sun_tx_bio_data *sun_tx_failover_grab(struct sun_tx_handler *h,
+                                            struct path *path)
+{
+	struct bio *bio;
+	struct sun_tx_bio_data *bd;
+	unsigned char *page;
+
+	bd = kmalloc(sizeof(*bd), GFP_KERNEL);
+	if (!bd) {
+		DMERR("dm-sun-tx: sun_tx_failover_grab: no bd");
+		return NULL;
+	}
+
+	memset(bd, 0, sizeof(*bd));
+	bd->h = h;
+	bd->path = path;
+
+	bio = sun_tx_bio();
+	if (!bio) {
+		DMERR("dm-sun-tx: sun_tx_failover_grab: no bio");
+		kfree(bd);
+		return NULL;
+	}
+	bio->bi_end_io = sun_tx_failover_endio;
+	bio->bi_bdev = path->dev->bdev;
+	bio->bi_private = bd;
+
+	page = (unsigned char *)sun_tx_alloc_page(bio, 1);
+	if (!page) {
+		DMERR("dm-sun-tx: sun_tx_failover_grab: alloc page failed");
+		free_bio(bio);
+		kfree(bd);
+		return NULL;
+	}
+
+	memset(page, 0, 1);
+
+	bd->rq = sun_tx_rq(h, bio, path);
+	if (!bd->rq) {
+		DMERR("dm-sun-tx: sun_tx_failover_grab: no rq");
+		free_bio(bio);
+		kfree(bd);
+		return NULL;
+	}
+
+	bd->rq->timeout = SUN_TX_FAILOVER_TIMEOUT;
+	bd->rq->flags  |= (REQ_BLOCK_PC | REQ_FAILFAST | REQ_NOMERGE);
+
+	/* Prepare Sun T3/T4 command to grab lun on standby path */
+	bd->rq->cmd[0] = SUN_TX_FAILOVER_OP;
+	bd->rq->cmd[1] = SUN_TX_FAILOVER_GRAB;
+	bd->rq->cmd_len = 10;
+
+	return bd;
+}
+
+static void sun_tx_pg_init(struct hw_handler *hwh, unsigned bypassed,
+                           struct path *path)
+{
+	struct sun_tx_bio_data *bd = NULL;
+	struct request_queue *q = bdev_get_queue(path->dev->bdev);
+
+	DMINFO("sun_tx_pg_init called");
+
+	if (!q) {
+		DMINFO("dm-sun-tx: sun_tx_pg_init: no queue");
+		goto fail_path;
+	}
+
+	/* Determine if this is a preferred path */
+	/* This requires SCSI inquiry command */
+	bd = sun_tx_failover_grab(hwh->context, path);
+	if (!bd) {
+		DMINFO("dm-sun-tx: sun_tx_pg_init: no bd");
+		goto fail_path;
+	}
+
+	DMINFO("dm-sun-tx: sun_tx_pg_init: sending lun grab command");
+	elv_add_request(q, bd->rq, ELEVATOR_INSERT_FRONT, 1);
+	return;
+
+fail_path:
+	if (bd)
+		kfree(bd);
+
+	dm_pg_init_complete(path, MP_FAIL_PATH);
+}
+
+static int sun_tx_create(struct hw_handler *hwh, unsigned argc, char **argv)
+{
+	struct sun_tx_handler *h;
+
+	DMINFO("sun_tx_create called");
+
+	h = kmalloc(sizeof(*h), GFP_KERNEL);
+
+	if (!h)
+		return -ENOMEM;
+
+	memset(h, 0, sizeof(*h));
+	spin_lock_init(&h->lock);
+
+	hwh->context = h;
+
+	return 0;
+}
+
+static void sun_tx_destroy(struct hw_handler *hwh)
+{
+	struct sun_tx_handler *h = (struct sun_tx_handler *) hwh->context;
+
+	kfree(h);
+	hwh->context = NULL;
+}
+
+static unsigned sun_tx_error(struct hw_handler *hwh, struct bio *bio)
+{
+	unsigned char key;
+	unsigned char asc;
+	unsigned char ascq;
+
+	if (bio_sense_valid(bio)) {
+		key = (bio_sense_value(bio) >> 16) & 0xff;
+		asc = (bio_sense_value(bio) >> 8) & 0xff;
+		ascq = bio_sense_value(bio) & 0xff;
+
+		if (asc == SUN_TX_ASC_FAILOVER_IN_PROGRESS &&
+		    ascq == SUN_TX_ASCQ_BECOMING_ACTIVE) {
+			/* This path should be available soon, so just keep
+			 * trying till it is */
+			return 0;
+		} else if (asc == SUN_TX_ASC_FAILOVER_IN_PROGRESS &&
+		           ascq == SUN_TX_ASCQ_BECOMING_INACTIVE) {
+			/* This is a passive path, so we should bypass it */
+			return MP_BYPASS_PG;
+		} else if (asc == SAM_STAT_BUSY &&
+			   ascq == SUN_TX_ASCQ_PATH_INACTIVE) {
+			/* Tried to use the inactive path */
+			return MP_BYPASS_PG;
+		} else if (key == UNIT_ATTENTION) {
+			/* Unit Attention Code.  This is the first IO
+			 * to the new path, so just retry. */
+			return 0;
+		}
+	}
+
+	return dm_scsi_err_handler(hwh, bio);
+}
+
+
+static struct hw_handler_type sun_tx_hwh = {
+	.name = "sun_tx",
+	.module = THIS_MODULE,
+	.create = sun_tx_create,
+	.destroy = sun_tx_destroy,
+	.pg_init = sun_tx_pg_init,
+	.error = sun_tx_error,
+};
+
+static int __init dm_sun_tx_init(void)
+{
+	int r = dm_register_hw_handler(&sun_tx_hwh);
+
+	if (r < 0)
+		DMERR("sun-tx: register failed %d", r);
+
+	DMINFO("dm-sun-tx version 0.0.1 loaded");
+
+	return r;
+}
+
+static void __exit dm_sun_tx_exit(void)
+{
+	int r = dm_unregister_hw_handler(&sun_tx_hwh);
+
+	if (r < 0)
+		DMERR("sun-tx: unregister failed %d", r);
+}
+
+module_init(dm_sun_tx_init);
+module_exit(dm_sun_tx_exit);
+
+
+MODULE_DESCRIPTION(DM_NAME " SUN T3/T4-family multipath");
+MODULE_AUTHOR("James Cassidy <jcassidy-lkernel@qfire.net>");
+MODULE_LICENSE("GPL");

--------------000403080802080406050507
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000403080802080406050507--
