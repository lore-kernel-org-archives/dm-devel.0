From: bmarzins@sourceware.org
Subject: multipath-tools kpartx/dasd.c libcheckers/Make ...
Date: 13 Dec 2006 00:03:01 -0000
Message-ID: <20061213000301.21431.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-12-13 00:02:59

Modified files:
	kpartx         : dasd.c 
	libcheckers    : Makefile checkers.c checkers.h emc_clariion.c 
	                 readsector0.c 
	libmultipath   : alias.c config.c config.h configure.c 
	                 devmapper.c devmapper.h discovery.c hwtable.c 
	                 structs.c structs.h 
	multipath      : main.c 
	multipathd     : multipathd.8 
	path_priority/pp_alua: rtpg.c 
Added files:
	libcheckers    : libsg.c libsg.h 

Log message:
	Updating the code in multipath head to the latest from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/dasd.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/libsg.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/libsg.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/Makefile.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.h.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/emc_clariion.c.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/readsector0.c.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/alias.c.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&r1=1.19&r2=1.20
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&r1=1.18&r2=1.19
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&r1=1.22&r2=1.23
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&r1=1.32&r2=1.33
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&r1=1.20&r2=1.21
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.c.diff?cvsroot=dm&r1=1.14&r2=1.15
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&r1=1.18&r2=1.19
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&r1=1.44&r2=1.45
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.8.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- multipath-tools/kpartx/dasd.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/kpartx/dasd.c	2006/12/13 00:02:59	1.2
@@ -40,14 +40,20 @@
 #include "byteorder.h"
 #include "dasd.h"
 
+unsigned long sectors512(unsigned long sectors, int blocksize)
+{
+	return sectors * (blocksize >> 9);
+}
+
 /*
  */
 int 
 read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 {
 	int retval = -1;
-	int blocksize, offset, size;
+	int blocksize;
 	long disksize;
+	unsigned long offset, size;
 	dasd_information_t info;
 	struct hd_geometry geo;
 	char type[5] = {0,};
@@ -172,13 +178,13 @@
 			/* disk is reserved minidisk */
 			blocksize = label[3];
 			offset = label[13];
-			size = (label[7] - 1)*(blocksize >> 9);
+			size   = sectors512(label[7] - 1, blocksize);
 		} else {
-			offset = (info.label_block + 1) * (blocksize >> 9);
-			size = disksize - offset;
+			offset = info.label_block + 1;
+			size   = disksize;
 		}
-		sp[0].start = offset * (blocksize >> 9);
-		sp[0].size = size - offset * (blocksize >> 9);
+		sp[0].start = sectors512(offset, blocksize);
+		sp[0].size  = size - sp[0].start;
 		retval = 1;
 	} else if ((strncmp(type, "VOL1", 4) == 0) &&
 		(!info.FBA_layout) && (!strcmp(info.type, "ECKD"))) {
@@ -214,8 +220,8 @@
 		        offset = cchh2blk(&f1.DS1EXT1.llimit, &geo);
 			size  = cchh2blk(&f1.DS1EXT1.ulimit, &geo) - 
 				offset + geo.sectors;
-			sp[counter].start = offset * (blocksize >> 9);
-			sp[counter].size = size * (blocksize >> 9);
+			sp[counter].start = sectors512(offset, blocksize);
+			sp[counter].size  = sectors512(size, blocksize);
 			counter++;
 			blk++;
 		}
@@ -224,10 +230,8 @@
 		/*
 		 * Old style LNX1 or unlabeled disk
 		 */
-		offset = (info.label_block + 1) * (blocksize >> 9);
-		size = disksize - offset;
-		sp[0].start = offset * (blocksize >> 9);
-		sp[0].size = size - offset * (blocksize >> 9);
+		sp[0].start = sectors512(info.label_block + 1, blocksize);
+		sp[0].size  = disksize - sp[0].start;
 		retval = 1;
 	}
 
/cvs/dm/multipath-tools/libcheckers/libsg.c,v  -->  standard output
revision 1.1
--- multipath-tools/libcheckers/libsg.c
+++ -	2006-12-13 00:03:00.094733000 +0000
@@ -0,0 +1,79 @@
+/*
+ * Copyright (c) 2004, 2005 Christophe Varoqui
+ */
+#include <string.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+
+#include "checkers.h"
+#include "libsg.h"
+#include "../libmultipath/sg_include.h"
+
+int
+sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff)
+{
+	/* defaults */
+	int blocks = 1;
+	long long start_block = 0;
+	int bs = 512;
+	int cdbsz = 10;
+	int * diop = NULL;
+
+	unsigned char rdCmd[cdbsz];
+	unsigned char *sbb = senseBuff;
+	struct sg_io_hdr io_hdr;
+	int res;
+	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
+	int sz_ind;
+	int retry_count = 3;
+	
+	memset(rdCmd, 0, cdbsz);
+	sz_ind = 1;
+	rdCmd[0] = rd_opcode[sz_ind];
+	rdCmd[2] = (unsigned char)((start_block >> 24) & 0xff);
+	rdCmd[3] = (unsigned char)((start_block >> 16) & 0xff);
+	rdCmd[4] = (unsigned char)((start_block >> 8) & 0xff);
+	rdCmd[5] = (unsigned char)(start_block & 0xff);
+	rdCmd[7] = (unsigned char)((blocks >> 8) & 0xff);
+	rdCmd[8] = (unsigned char)(blocks & 0xff);
+
+	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = cdbsz;
+	io_hdr.cmdp = rdCmd;
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = bs * blocks;
+	io_hdr.dxferp = buff;
+	io_hdr.mx_sb_len = SENSE_BUFF_LEN;
+	io_hdr.sbp = senseBuff;
+	io_hdr.timeout = DEF_TIMEOUT;
+	io_hdr.pack_id = (int)start_block;
+	if (diop && *diop)
+	io_hdr.flags |= SG_FLAG_DIRECT_IO;
+
+retry: 
+	memset(senseBuff, 0, SENSE_BUFF_LEN);
+	while (((res = ioctl(sg_fd, SG_IO, &io_hdr)) < 0) && (EINTR == errno));
+
+	if (res < 0) {
+		if (ENOMEM == errno) {
+			return PATH_UP;
+		}
+		return PATH_DOWN;
+	}
+
+	if ((0 == io_hdr.status) &&
+	    (0 == io_hdr.host_status) &&
+	    (0 == io_hdr.driver_status)) {
+		return PATH_UP;
+	} else {
+		/*
+		 * Retry if UNIT_ATTENTION check condition.
+		 */
+		if ((sbb[2]&0xf) == 6) {
+			if (--retry_count)
+				goto retry;
+		}
+		return PATH_DOWN;
+	}
+}
/cvs/dm/multipath-tools/libcheckers/libsg.h,v  -->  standard output
revision 1.1
--- multipath-tools/libcheckers/libsg.h
+++ -	2006-12-13 00:03:00.170127000 +0000
@@ -0,0 +1,8 @@
+#ifndef _LIBSG_H
+#define _LIBSG_H
+
+#define SENSE_BUFF_LEN 32
+
+int sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff);
+
+#endif /* _LIBSG_H */
--- multipath-tools/libcheckers/Makefile	2006/06/06 18:32:43	1.5
+++ multipath-tools/libcheckers/Makefile	2006/12/13 00:02:59	1.6
@@ -6,7 +6,7 @@
 
 include ../Makefile.inc
 
-OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o
+OBJS = libsg.o checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o
 
 all: $(BUILD)
 
--- multipath-tools/libcheckers/checkers.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/libcheckers/checkers.c	2006/12/13 00:02:59	1.2
@@ -75,8 +75,9 @@
 	return NULL;
 }
 
-int checker_init (struct checker * c)
+int checker_init (struct checker * c, void ** mpctxt_addr)
 {
+	c->mpcontext = mpctxt_addr;
 	return c->init(c);
 }
 
--- multipath-tools/libcheckers/checkers.h	2006/07/13 19:49:22	1.5
+++ multipath-tools/libcheckers/checkers.h	2006/12/13 00:02:59	1.6
@@ -2,7 +2,44 @@
 #define _CHECKERS_H
 
 /*
- * path states
+ *
+ * Userspace (multipath/multipathd) path states
+ *
+ * PATH_WILD:
+ * - Use: None of the checkers (returned if we don't have an fd)
+ * - Description: Corner case where "fd <= 0" for path fd (see checker_check())
+ *
+ * PATH_UNCHECKED:
+ * - Use: Only in directio checker
+ * - Description: set when fcntl(F_GETFL) fails to return flags or O_DIRECT
+ *   not include in flags, or O_DIRECT read fails
+ * - Notes:
+ *   - multipathd: uses it to skip over paths in sync_map_state()
+ *   - multipath: used in update_paths(); if state==PATH_UNCHECKED, call
+ *     pathinfo()
+ *
+ * PATH_DOWN:
+ * - Use: All checkers (directio, emc_clariion, hp_sw, readsector0, tur)
+ * - Description: Either a) SG_IO ioctl failed, or b) check condition on some
+ *   SG_IO ioctls that succeed (tur, readsector0 checkers); path is down and
+ *   you shouldn't try to send commands to it
+ *
+ * PATH_UP:
+ * - Use: All checkers (directio, emc_clariion, hp_sw, readsector0, tur)
+ * - Description: Path is up and I/O can be sent to it
+ *
+ * PATH_SHAKY:
+ * - Use: Only emc_clariion
+ * - Description: Indicates path not available for "normal" operations
+ *
+ * PATH_GHOST:
+ * - Use: Only hp_sw
+ * - Description: Indicates a "passive/standby" path on active/passive HP
+ *   arrays.  These paths will return valid answers to certain SCSI commands
+ *   (tur, read_capacity, inquiry, start_stop), but will fail I/O commands.
+ *   The path needs an initialization command to be sent to it in order for
+ *   I/Os to succeed.
+ *
  */
 #define PATH_WILD	-1
 #define PATH_UNCHECKED	0
@@ -46,14 +83,16 @@
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
 	void * context;                      /* store for persistent data */
+	void ** mpcontext;                   /* store for persistent data
+						shared multipath-wide */
 	int (*check)(struct checker *);
 	int (*init)(struct checker *);       /* to allocate the context */
 	void (*free)(struct checker *);      /* to free the context */
 };
 
-#define MSG(c, a) snprintf((c)->message, CHECKER_MSG_LEN, a);
+#define MSG(c, fmt, args...) snprintf((c)->message, CHECKER_MSG_LEN, fmt, ##args);
 
-int checker_init (struct checker *);
+int checker_init (struct checker *, void **);
 void checker_put (struct checker *);
 void checker_reset (struct checker * c);
 void checker_set_fd (struct checker *, int);
--- multipath-tools/libcheckers/emc_clariion.c	2006/09/15 17:55:40	1.6
+++ multipath-tools/libcheckers/emc_clariion.c	2006/12/13 00:02:59	1.7
@@ -11,25 +11,76 @@
 #include <sys/ioctl.h>
 #include <errno.h>
 
-#include "checkers.h"
-
 #include "../libmultipath/sg_include.h"
+#include "libsg.h"
+#include "checkers.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
 #define HEAVY_CHECK_COUNT       10
 
-struct emc_clariion_checker_context {
+/*
+ * Mechanism to track CLARiiON inactive snapshot LUs.
+ * This is done so that we can fail passive paths
+ * to an inactive snapshot LU even though since a
+ * simple read test would return 02/04/03 instead
+ * of 05/25/01 sensekey/ASC/ASCQ data.
+ */
+#define	IS_INACTIVE_SNAP(c)   (c->mpcontext ?				   \
+			       ((struct emc_clariion_checker_LU_context *) \
+					(*c->mpcontext))->inactive_snap	   \
+					    : 0)
+
+#define	SET_INACTIVE_SNAP(c)  if (c->mpcontext)				   \
+				((struct emc_clariion_checker_LU_context *)\
+					(*c->mpcontext))->inactive_snap = 1
+
+#define	CLR_INACTIVE_SNAP(c)  if (c->mpcontext)				   \
+				((struct emc_clariion_checker_LU_context *)\
+					(*c->mpcontext))->inactive_snap = 0
+
+struct emc_clariion_checker_path_context {
 	char wwn[16];
 	unsigned wwn_set;
 };
 
+struct emc_clariion_checker_LU_context {
+	int inactive_snap;
+};
+
+extern void
+hexadecimal_to_ascii(char * wwn, char *wwnstr)
+{
+	int i,j, nbl;
+
+	for (i=0,j=0;i<16;i++) {
+		wwnstr[j++] = ((nbl = ((wwn[i]&0xf0) >> 4)) <= 9) ?
+					'0' + nbl : 'a' + (nbl - 10);
+		wwnstr[j++] = ((nbl = (wwn[i]&0x0f)) <= 9) ?
+					'0' + nbl : 'a' + (nbl - 10);
+	}
+	wwnstr[32]=0;
+}
+
 int emc_clariion_init (struct checker * c)
 {
-	c->context = malloc(sizeof(struct emc_clariion_checker_context));
+	/*
+	 * Allocate and initialize the path specific context.
+	 */
+	c->context = malloc(sizeof(struct emc_clariion_checker_path_context));
 	if (!c->context)
 		return 1;
-	((struct emc_clariion_checker_context *)c->context)->wwn_set = 0;
+	((struct emc_clariion_checker_path_context *)c->context)->wwn_set = 0;
+
+	/*
+	 * Allocate and initialize the multi-path global context.
+	 */
+	if (c->mpcontext) {
+		void * mpctxt = malloc(sizeof(int));
+		*c->mpcontext = mpctxt;
+		CLR_INACTIVE_SNAP(c);
+	}
+
 	return 0;
 }
 
@@ -40,13 +91,15 @@
 
 int emc_clariion(struct checker * c)
 {
-	unsigned char sense_buffer[256] = { 0, };
-	unsigned char sb[128] = { 0, };
+	unsigned char sense_buffer[128] = { 0, };
+	unsigned char sb[SENSE_BUFF_LEN] = { 0, }, *sbb;
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
-						sizeof(sb), 0};
+						sizeof(sense_buffer), 0};
 	struct sg_io_hdr io_hdr;
-	struct emc_clariion_checker_context * ct =
-		(struct emc_clariion_checker_context *)c->context;
+	struct emc_clariion_checker_path_context * ct =
+		(struct emc_clariion_checker_path_context *)c->context;
+	char wwnstr[33];
+	int ret;
 
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
 	io_hdr.interface_id = 'S';
@@ -69,7 +122,8 @@
 	}
 	if (/* Verify the code page - right page & revision */
 	    sense_buffer[1] != 0xc0 || sense_buffer[9] != 0x00) {
-		MSG(c, "emc_clariion_checker: Path unit report page in unknown format");
+		MSG(c, "emc_clariion_checker: Path unit report page in "
+		    "unknown format");
 		return PATH_DOWN;
 	}
 
@@ -79,19 +133,22 @@
 		|| (sense_buffer[28] & 0x07) != 0x04
 		/* Arraycommpath should be set to 1 */
 		|| (sense_buffer[30] & 0x04) != 0x04) {
-		MSG(c, "emc_clariion_checker: Path not correctly configured for failover");
+		MSG(c, "emc_clariion_checker: Path not correctly configured "
+		    "for failover");
 		return PATH_DOWN;
 	}
 
 	if ( /* LUN operations should indicate normal operations */
 		sense_buffer[48] != 0x00) {
-		MSG(c, "emc_clariion_checker: Path not available for normal operations");
+		MSG(c, "emc_clariion_checker: Path not available for normal "
+		    "operations");
 		return PATH_SHAKY;
 	}
 
 	if ( /* LUN should at least be bound somewhere and not be LUNZ */
 		sense_buffer[4] == 0x00) {
-		MSG(c, "emc_clariion_checker: Logical Unit is unbound or LUNZ");
+		MSG(c, "emc_clariion_checker: Logical Unit is unbound "
+		    "or LUNZ");
 		return PATH_DOWN;
 	}
 	
@@ -102,7 +159,8 @@
 	 */
 	if (ct->wwn_set) {
 		if (memcmp(ct->wwn, &sense_buffer[10], 16) != 0) {
-			MSG(c, "emc_clariion_checker: Logical Unit WWN has changed!");
+			MSG(c, "emc_clariion_checker: Logical Unit WWN "
+			    "has changed!");
 			return PATH_DOWN;
 		}
 	} else {
@@ -110,7 +168,59 @@
 		ct->wwn_set = 1;
 	}
 	
-	
-	MSG(c, "emc_clariion_checker: Path healthy");
-        return PATH_UP;
+	/*
+	 * Issue read on active path to determine if inactive snapshot.
+	 */
+	if (sense_buffer[4] == 2) {/* if active path */
+		unsigned char buf[512];
+
+		ret = sg_read(c->fd, &buf[0], sbb = &sb[0]);
+		if (ret == PATH_DOWN) {
+			hexadecimal_to_ascii(ct->wwn, wwnstr);
+
+			/*
+		 	 * Check for inactive snapshot LU this way.  Must
+			 * fail these.
+	 	 	 */
+			if (((sbb[2]&0xf) == 5) && (sbb[12] == 0x25) &&
+			    (sbb[13]==1)) {
+				/*
+			 	 * Do this so that we can fail even the
+			 	 * passive paths which will return
+				 * 02/04/03 not 05/25/01 on read.
+			 	 */
+				SET_INACTIVE_SNAP(c);
+				MSG(c, "emc_clariion_checker: Active "
+					"path to inactive snapshot WWN %s.",
+					wwnstr);
+			} else
+				MSG(c, "emc_clariion_checker: Read "
+					"error for WWN %s.  Sense data are "
+					"0x%x/0x%x/0x%x.", wwnstr,
+					sbb[2]&0xf, sbb[12], sbb[13]);
+		} else {
+			MSG(c, "emc_clariion_checker: Active path is "
+			    "healthy.");
+			/*
+		 	 * Remove the path from the set of paths to inactive
+		 	 * snapshot LUs if it was in this list since the
+		 	 * snapshot is no longer inactive.
+		 	 */
+			CLR_INACTIVE_SNAP(c);
+		}
+	} else {
+		if (IS_INACTIVE_SNAP(c)) {
+			hexadecimal_to_ascii(ct->wwn, wwnstr);
+			MSG(c, "emc_clariion_checker: Passive "
+				"path to inactive snapshot WWN %s.",
+				wwnstr);
+			ret = PATH_DOWN;
+		} else {
+			MSG(c,
+		    	    "emc_clariion_checker: Passive path is healthy.");
+			ret = PATH_UP;	/* not ghost */
+		}
+	}
+
+	return ret;
 }
--- multipath-tools/libcheckers/readsector0.c	2006/07/13 19:49:22	1.5
+++ multipath-tools/libcheckers/readsector0.c	2006/12/13 00:02:59	1.6
@@ -2,20 +2,9 @@
  * Copyright (c) 2004, 2005 Christophe Varoqui
  */
 #include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/ioctl.h>
-#include <errno.h>
 
 #include "checkers.h"
-
-#include "../libmultipath/sg_include.h"
-
-#define SENSE_BUFF_LEN 32
+#include "libsg.h"
 
 #define MSG_READSECTOR0_UP	"readsector0 checker reports path is up"
 #define MSG_READSECTOR0_DOWN	"readsector0 checker reports path is down"
@@ -34,72 +23,14 @@
 	return;
 }
 
-static int
-sg_read (int sg_fd, unsigned char * buff)
-{
-	/* defaults */
-	int blocks = 1;
-	long long start_block = 0;
-	int bs = 512;
-	int cdbsz = 10;
-	int * diop = NULL;
-
-	unsigned char rdCmd[cdbsz];
-	unsigned char senseBuff[SENSE_BUFF_LEN];
-	struct sg_io_hdr io_hdr;
-	int res;
-	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
-	int sz_ind;
-	
-	memset(rdCmd, 0, cdbsz);
-	sz_ind = 1;
-	rdCmd[0] = rd_opcode[sz_ind];
-	rdCmd[2] = (unsigned char)((start_block >> 24) & 0xff);
-	rdCmd[3] = (unsigned char)((start_block >> 16) & 0xff);
-	rdCmd[4] = (unsigned char)((start_block >> 8) & 0xff);
-	rdCmd[5] = (unsigned char)(start_block & 0xff);
-	rdCmd[7] = (unsigned char)((blocks >> 8) & 0xff);
-	rdCmd[8] = (unsigned char)(blocks & 0xff);
-
-	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
-	io_hdr.interface_id = 'S';
-	io_hdr.cmd_len = cdbsz;
-	io_hdr.cmdp = rdCmd;
-	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
-	io_hdr.dxfer_len = bs * blocks;
-	io_hdr.dxferp = buff;
-	io_hdr.mx_sb_len = SENSE_BUFF_LEN;
-	io_hdr.sbp = senseBuff;
-	io_hdr.timeout = DEF_TIMEOUT;
-	io_hdr.pack_id = (int)start_block;
-	if (diop && *diop)
-	io_hdr.flags |= SG_FLAG_DIRECT_IO;
-
-	while (((res = ioctl(sg_fd, SG_IO, &io_hdr)) < 0) && (EINTR == errno));
-
-	if (res < 0) {
-		if (ENOMEM == errno) {
-			return PATH_UP;
-		}
-		return PATH_DOWN;
-	}
-
-	if ((0 == io_hdr.status) &&
-	    (0 == io_hdr.host_status) &&
-	    (0 == io_hdr.driver_status)) {
-		return PATH_UP;
-	} else {
-		return PATH_DOWN;
-	}
-}
-
 extern int
 readsector0 (struct checker * c)
 {
 	unsigned char buf[512];
+	unsigned char sbuf[SENSE_BUFF_LEN];
 	int ret;
 
-	ret = sg_read(c->fd, &buf[0]);
+	ret = sg_read(c->fd, &buf[0], &sbuf[0]);
 
 	switch (ret)
 	{
--- multipath-tools/libmultipath/alias.c	2006/06/06 18:32:43	1.4
+++ multipath-tools/libmultipath/alias.c	2006/12/13 00:02:59	1.5
@@ -166,28 +166,14 @@
 
 
 static int
-lookup_binding(int fd, char *map_wwid, char **map_alias)
+lookup_binding(FILE *f, char *map_wwid, char **map_alias)
 {
 	char buf[LINE_MAX];
-	FILE *f;
 	unsigned int line_nr = 0;
-	int scan_fd;
 	int id = 0;
 
 	*map_alias = NULL;
-	scan_fd = dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		return -1;
-	}
-	f = fdopen(scan_fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor : %s",
-			strerror(errno));
-		close(scan_fd);
-		return -1;
-	}
+
 	while (fgets(buf, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
@@ -215,38 +201,22 @@
 			if (*map_alias == NULL)
 				condlog(0, "Cannot copy alias from bindings "
 					"file : %s", strerror(errno));
-			fclose(f);
 			return id;
 		}
 	}
 	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
-	fclose(f);
 	return id;
 }	
 
 static int
-rlookup_binding(int fd, char **map_wwid, char *map_alias)
+rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
 {
 	char buf[LINE_MAX];
-	FILE *f;
 	unsigned int line_nr = 0;
-	int scan_fd;
 	int id = 0;
 
 	*map_wwid = NULL;
-	scan_fd = dup(fd);
-	if (scan_fd < 0) {
-		condlog(0, "Cannot dup bindings file descriptor : %s",
-			strerror(errno));
-		return -1;
-	}
-	f = fdopen(scan_fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor : %s",
-			strerror(errno));
-		close(scan_fd);
-		return -1;
-	}
+
 	while (fgets(buf, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
@@ -274,12 +244,10 @@
 			if (*map_wwid == NULL)
 				condlog(0, "Cannot copy alias from bindings "
 					"file : %s", strerror(errno));
-			fclose(f);
 			return id;
 		}
 	}
 	condlog(3, "No matching alias [%s] in bindings file.", map_alias);
-	fclose(f);
 	return id;
 }	
 
@@ -327,7 +295,8 @@
 get_user_friendly_alias(char *wwid, char *file)
 {
 	char *alias;
-	int fd, id;
+	int fd, scan_fd, id;
+	FILE *f;
 
 	if (!wwid || *wwid == '\0') {
 		condlog(3, "Cannot find binding for empty WWID");
@@ -337,14 +306,37 @@
 	fd = open_bindings_file(file);
 	if (fd < 0)
 		return NULL;
-	id = lookup_binding(fd, wwid, &alias);
+
+	scan_fd = dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "Cannot dup bindings file descriptor : %s",
+			strerror(errno));
+		close(fd);
+		return NULL;
+	}
+
+	f = fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor : %s",
+			strerror(errno));
+		close(scan_fd);
+		close(fd);
+		return NULL;
+	}
+
+	id = lookup_binding(f, wwid, &alias);
 	if (id < 0) {
+		fclose(f);
+		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
+
 	if (!alias)
 		alias = allocate_binding(fd, wwid, id);
 
+	fclose(f);
+	close(scan_fd);
 	close(fd);
 	return alias;
 }
@@ -353,7 +345,8 @@
 get_user_friendly_wwid(char *alias, char *file)
 {
 	char *wwid;
-	int fd, id;
+	int fd, scan_fd, id;
+	FILE *f;
 
 	if (!alias || *alias == '\0') {
 		condlog(3, "Cannot find binding for empty alias");
@@ -363,12 +356,34 @@
 	fd = open_bindings_file(file);
 	if (fd < 0)
 		return NULL;
-	id = rlookup_binding(fd, &wwid, alias);
+
+	scan_fd = dup(fd);
+	if (scan_fd < 0) {
+		condlog(0, "Cannot dup bindings file descriptor : %s",
+			strerror(errno));
+		close(fd);
+		return NULL;
+	}
+
+	f = fdopen(scan_fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor : %s",
+			strerror(errno));
+		close(scan_fd);
+		close(fd);
+		return NULL;
+	}
+
+	id = rlookup_binding(f, &wwid, alias);
 	if (id < 0) {
+		fclose(f);
+		close(scan_fd);
 		close(fd);
 		return NULL;
 	}
 
+	fclose(f);
+	close(scan_fd);
 	close(fd);
 	return wwid;
 }
--- multipath-tools/libmultipath/config.c	2006/11/30 23:25:13	1.19
+++ multipath-tools/libmultipath/config.c	2006/12/13 00:02:59	1.20
@@ -21,7 +21,7 @@
 #include "defaults.h"
 
 static struct hwentry *
-find_hwe_strmatch (vector hwtable, char * vendor, char * product)
+find_hwe_strmatch (vector hwtable, char * vendor, char * product, char * revision)
 {
 	int i;
 	struct hwentry *hwe, *ret = NULL;
@@ -33,6 +33,9 @@
 		if (hwe->product && product && strcmp(hwe->product, product))
 			continue;
 
+		if (hwe->revision && revision && strcmp(hwe->revision, revision))
+			continue;
+
 		ret = hwe;
 		break;
 	}
@@ -40,11 +43,11 @@
 }
 
 struct hwentry *
-find_hwe (vector hwtable, char * vendor, char * product)
+find_hwe (vector hwtable, char * vendor, char * product, char * revision)
 {
 	int i;
 	struct hwentry *hwe, *ret = NULL;
-	regex_t vre, pre;
+	regex_t vre, pre, rre;
 
 	vector_foreach_slot (hwtable, hwe, i) {
 		if (hwe->vendor &&
@@ -55,12 +58,23 @@
 			regfree(&vre);
 			break;
 		}
+		if (hwe->revision &&
+		    regcomp(&rre, hwe->revision, REG_EXTENDED|REG_NOSUB)) {
+			regfree(&vre);
+			regfree(&pre);
+			break;
+		}
 		if ((!hwe->vendor || !regexec(&vre, vendor, 0, NULL, 0)) &&
-		    (!hwe->product || !regexec(&pre, product, 0, NULL, 0)))
+		    (!hwe->product || !regexec(&pre, product, 0, NULL, 0)) &&
+		    (!hwe->revision || !regexec(&rre, revision, 0, NULL, 0)))
 			ret = hwe;
-		
-		regfree(&pre);
-		regfree(&vre);
+
+		if (hwe->revision)
+			regfree(&rre);
+		if (hwe->product)
+			regfree(&pre);
+		if (hwe->vendor)
+			regfree(&vre);
 
 		if (ret)
 			break;
@@ -112,6 +126,9 @@
 	if (hwe->product)
 		FREE(hwe->product);
 
+	if (hwe->revision)
+		FREE(hwe->revision);
+
 	if (hwe->selector)
 		FREE(hwe->selector);
 
@@ -225,23 +242,12 @@
 	return dst;
 }
 
-static int
-dup_hwe (vector hwtable, char * vendor, char * product)
-{
-	struct hwentry * hwe = find_hwe(hwtable, vendor, product);
-
-	if (hwe)
-		return 1;
-
-	return 0;
-}
-
 int
 store_hwe (vector hwtable, struct hwentry * dhwe)
 {
 	struct hwentry * hwe;
 
-	if (find_hwe_strmatch(hwtable, dhwe->vendor, dhwe->product))
+	if (find_hwe_strmatch(hwtable, dhwe->vendor, dhwe->product, dhwe->revision))
 		return 0;
 	
 	if (!(hwe = alloc_hwe()))
@@ -253,6 +259,9 @@
 	if (!dhwe->product || !(hwe->product = set_param_str(dhwe->product)))
 		goto out;
 	
+	if (dhwe->revision && !(hwe->revision = set_param_str(dhwe->revision)))
+		goto out;
+	
 	if (dhwe->getuid && !(hwe->getuid = set_param_str(dhwe->getuid)))
 		goto out;
 
--- multipath-tools/libmultipath/config.h	2006/06/06 18:32:43	1.18
+++ multipath-tools/libmultipath/config.h	2006/12/13 00:02:59	1.19
@@ -11,6 +11,7 @@
 struct hwentry {
 	char * vendor;
 	char * product;
+	char * revision;
 	char * getuid;
 	char * getprio;
 	char * features;
@@ -81,7 +82,7 @@
 
 struct config * conf;
 
-struct hwentry * find_hwe (vector hwtable, char * vendor, char * product);
+struct hwentry * find_hwe (vector hwtable, char * vendor, char * product, char *revision);
 struct mpentry * find_mpe (char * wwid);
 char * get_mpe_wwid (char * alias);
 
--- multipath-tools/libmultipath/configure.c	2006/07/13 20:35:22	1.2
+++ multipath-tools/libmultipath/configure.c	2006/12/13 00:02:59	1.3
@@ -443,7 +443,7 @@
 		if ((mpp = add_map_with_path(vecs, pp1, 0)) == NULL)
 			return 1;
 
-		if (pp1->priority < 0)
+		if (pp1->priority == PRIO_UNDEF)
 			mpp->action = ACT_REJECT;
 
 		if (!mpp->paths) {
@@ -470,7 +470,7 @@
 					mpp->size);
 				mpp->action = ACT_REJECT;
 			}
-			if (pp2->priority < 0)
+			if (pp2->priority == PRIO_UNDEF)
 				mpp->action = ACT_REJECT;
 		}
 		verify_paths(mpp, vecs, NULL);
@@ -555,7 +555,7 @@
 {
 	struct path * pp;
 	char buff[FILE_NAME_SIZE];
-	char * refwwid = NULL;
+	char * refwwid = NULL, tmpwwid[WWID_SIZE];
 
 	if (dev_type == DEV_NONE)
 		return NULL;
@@ -610,6 +610,12 @@
 		goto out;
 	}
 	if (dev_type == DEV_DEVMAP) {
+
+		if (((dm_get_uuid(dev, tmpwwid)) == 0) && (strlen(tmpwwid))) {
+			refwwid = tmpwwid;
+			goto out;
+		}
+
 		/*
 		 * may be a binding
 		 */
--- multipath-tools/libmultipath/devmapper.c	2006/11/28 15:46:21	1.22
+++ multipath-tools/libmultipath/devmapper.c	2006/12/13 00:02:59	1.23
@@ -27,7 +27,6 @@
 #define UUID_PREFIX "mpath-"
 #define UUID_PREFIX_LEN 6
 
-
 static void
 dm_dummy_log (int level, const char *file, int line, const char *f, ...)
 {
@@ -46,13 +45,35 @@
 	dm_log_init(&dm_dummy_log);
 }
 
-extern int
-dm_prereq (char * str, int x, int y, int z)
+static int
+dm_libprereq (void)
+{
+	char version[64];
+	int v[3];
+	int minv[3] = {1, 2, 11};
+
+	dm_get_library_version(version, sizeof(version));
+	condlog(3, "libdevmapper version %s", version);
+	sscanf(version, "%d.%d.%d ", &v[0], &v[1], &v[2]);
+
+	if ((v[0] > minv[0]) ||
+	    ((v[0] ==  minv[0]) && (v[1] > minv[1])) ||
+	    ((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])))
+		return 0;
+	condlog(0, "libdevmapper version must be >= %d.%.2d.%.2d",
+		minv[0], minv[1], minv[2]);
+	return 1;
+}
+
+static int
+dm_drvprereq (char * str)
 {
 	int r = 2;
 	struct dm_task *dmt;
 	struct dm_versions *target;
 	struct dm_versions *last_target;
+	int minv[3] = {1, 0, 3};
+	unsigned int *v;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)))
 		return 3;
@@ -63,37 +84,44 @@
 		condlog(0, "Can not communicate with kernel DM");
 		goto out;
 	}
-
 	target = dm_task_get_versions(dmt);
 
 	do {
 		last_target = target;
-
 		if (!strncmp(str, target->name, strlen(str))) {
-			r--;
-			
-			if (target->version[0] >= x &&
-			    target->version[1] >= y &&
-			    target->version[2] >= z)
-				r--;
-
+			r = 1;
 			break;
 		}
-
 		target = (void *) target + target->next;
 	} while (last_target != target);
 
-	if (r == 2)
+	if (r == 2) {
 		condlog(0, "DM multipath kernel driver not loaded");
-	else if (r == 1)
-		condlog(0, "DM multipath kernel driver version too old");
-
+		goto out;
+	}
+	v = target->version;
+	if ((v[0] > minv[0]) ||
+	    ((v[0] == minv[0]) && (v[1] > minv[1])) ||
+	    ((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2]))) {
+		r = 0;
+		goto out;
+	}
+	condlog(0, "DM multipath kernel driver must be >= %u.%.2u.%.2u",
+		minv[0], minv[1], minv[2]);
 out:
 	dm_task_destroy(dmt);
 	return r;
 }
 
 extern int
+dm_prereq (char * str)
+{
+	if (dm_libprereq())
+		return 1;
+	return dm_drvprereq(str);
+}
+
+extern int
 dm_simplecmd (int task, const char *name) {
 	int r = 0;
 	struct dm_task *dmt;
@@ -224,6 +252,7 @@
 {
 	struct dm_task *dmt;
 	const char *uuidtmp;
+	int r = 1;
 
 	dmt = dm_task_create(DM_DEVICE_INFO);
 	if (!dmt)
@@ -245,10 +274,10 @@
 	else
 		uuid[0] = '\0';
 
+	r = 0;
 uuidout:
 	dm_task_destroy(dmt);
-
-	return 0;
+	return r;
 }
 
 extern int
--- multipath-tools/libmultipath/devmapper.h	2006/06/06 18:32:43	1.11
+++ multipath-tools/libmultipath/devmapper.h	2006/12/13 00:02:59	1.12
@@ -1,6 +1,6 @@
 void dm_shut_log(void);
 void dm_restore_log(void);
-int dm_prereq (char *, int, int, int);
+int dm_prereq (char *);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *,
 	       unsigned long long, const char *uuid);
--- multipath-tools/libmultipath/discovery.c	2006/10/12 16:16:09	1.32
+++ multipath-tools/libmultipath/discovery.c	2006/12/13 00:02:59	1.33
@@ -347,7 +347,7 @@
             { INQUIRY_CMD, 0, 0, 0, 0, 0 };
         unsigned char sense_b[SENSE_BUFF_LEN];
         struct sg_io_hdr io_hdr;
-                                                                                                                 
+
         if (cmddt)
                 inqCmdBlk[1] |= 2;
         if (evpd)
@@ -365,10 +365,10 @@
         io_hdr.cmdp = inqCmdBlk;
         io_hdr.sbp = sense_b;
         io_hdr.timeout = DEF_TIMEOUT;
- 
+
         if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
                 return -1;
- 
+
         /* treat SG_ERR here to get rid of sg_err.[ch] */
         io_hdr.status &= 0x7e;
         if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
@@ -501,7 +501,7 @@
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
+	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, pp->rev);
 
 	/*
 	 * host / bus / target / lun
@@ -585,7 +585,7 @@
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
+	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, NULL);
 
 	/*
 	 * host / bus / target / lun
@@ -670,12 +670,15 @@
 {
 	struct checker * c = &pp->checker;
 
+	if (!pp->mpp)
+		return 0;
+
 	if (!checker_selected(c)) {
 		select_checker(pp);
 		if (!checker_selected(c))
 			return 1;
 		checker_set_fd(c, pp->fd);
-		if (checker_init(c))
+		if (checker_init(c, &pp->mpp->mpcontext))
 			return 1;
 	}
 	pp->state = checker_check(c);
@@ -697,14 +700,14 @@
 		pp->getprio_selected = 1;
 	}
 	if (!pp->getprio) {
-		pp->priority = 1;
+		pp->priority = PRIO_DEFAULT;
 	} else if (apply_format(pp->getprio, &buff[0], pp)) {
 		condlog(0, "error formatting prio callout command");
-		pp->priority = -1;
+		pp->priority = PRIO_UNDEF;
 		return 1;
 	} else if (execute_program(buff, prio, 16)) {
 		condlog(0, "error calling out %s", buff);
-		pp->priority = -1;
+		pp->priority = PRIO_UNDEF;
 		return 1;
 	} else
 		pp->priority = atoi(prio);
@@ -760,7 +763,12 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	if (mask & DI_PRIO && pp->state != PATH_DOWN)
+	 /*
+	  * Retrieve path priority for even PATH_DOWN paths if it has never
+	  * been successfully obtained before.
+	  */
+	if (mask & DI_PRIO &&
+	    (pp->state != PATH_DOWN || pp->priority == PRIO_UNDEF))
 		get_prio(pp);
 
 	if (mask & DI_WWID && !strlen(pp->wwid))
--- multipath-tools/libmultipath/hwtable.c	2006/10/12 16:16:09	1.20
+++ multipath-tools/libmultipath/hwtable.c	2006/12/13 00:02:59	1.21
@@ -91,7 +91,7 @@
 	},
 	{
 		.vendor        = "HP",
-		.product       = "(HSV2.*|A6189A)",
+		.product       = "A6189A",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -104,6 +104,53 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = READSECTOR0,
 	},
+	{
+		.vendor        = "HP",
+		.product       = "HSV20.*",
+		.revision      = "[123].*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = HP_SW,
+	},
+	{
+		.vendor        = "HP",
+		.product       = "HSV20.*",
+		.revision      = "[^123].*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
+	{
+		.vendor        = "HP",
+		.product       = "HSV21.*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
 	/*
 	 * DDN controller family
 	 *
@@ -123,7 +170,7 @@
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = DIRECTIO,
 	},
 	/*
 	 * EMC / Clariion controller family
@@ -329,7 +376,7 @@
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
--- multipath-tools/libmultipath/structs.c	2006/06/06 18:32:43	1.14
+++ multipath-tools/libmultipath/structs.c	2006/12/13 00:02:59	1.15
@@ -31,6 +31,7 @@
 		pp->sg_id.scsi_id = -1;
 		pp->sg_id.lun = -1;
 		pp->fd = -1;
+		pp->priority = PRIO_UNDEF;
 	}
 	return pp;
 }
@@ -116,9 +117,10 @@
 
 	mpp = (struct multipath *)MALLOC(sizeof(struct multipath));
 
-	if (mpp)
+	if (mpp) {
 		mpp->bestpg = 1;
-
+		mpp->mpcontext = NULL;
+	}
 	return mpp;
 }
 
@@ -179,6 +181,7 @@
 
 	free_pathvec(mpp->paths, free_paths);
 	free_pgvec(mpp->pg, free_paths);
+	FREE_PTR(mpp->mpcontext);
 	FREE(mpp);
 }
 
--- multipath-tools/libmultipath/structs.h	2006/06/06 18:32:43	1.18
+++ multipath-tools/libmultipath/structs.h	2006/12/13 00:02:59	1.19
@@ -18,6 +18,9 @@
 #define NO_PATH_RETRY_FAIL	-1
 #define NO_PATH_RETRY_QUEUE	-2
 
+#define PRIO_UNDEF		-1
+#define PRIO_DEFAULT		1
+
 enum free_path_switch {
 	KEEP_PATHS,
 	FREE_PATHS
@@ -157,6 +160,9 @@
 	unsigned int stat_map_loads;
 	unsigned int stat_total_queueing_time;
 	unsigned int stat_queueing_timeouts;
+
+	/* checkers shared data */
+	void * mpcontext;
 };
 
 struct pathgroup {
--- multipath-tools/multipath/main.c	2006/11/30 23:25:13	1.44
+++ multipath-tools/multipath/main.c	2006/12/13 00:02:59	1.45
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44 2006/11/30 23:25:13 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.45 2006/12/13 00:02:59 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -128,13 +128,15 @@
 					pp->state = PATH_DOWN;
 					continue;
 				}
+				pp->mpp = mpp;
 				pathinfo(pp, conf->hwtable, DI_ALL);
 				continue;
 			}
+			pp->mpp = mpp;
 			if (pp->state == PATH_UNCHECKED)
 				pathinfo(pp, conf->hwtable, DI_CHECKER);
 
-			if (!pp->priority)
+			if (pp->priority == PRIO_UNDEF)
 				pathinfo(pp, conf->hwtable, DI_PRIO);
 		}
 	}
@@ -314,7 +316,7 @@
 		exit(1);
 	}
 
-	if (dm_prereq(DEFAULT_TARGET, 1, 0, 3))
+	if (dm_prereq(DEFAULT_TARGET))
 		exit(1);
 
 	if (sysfs_get_mnt_path(sysfs_path, FILE_NAME_SIZE)) {
--- multipath-tools/multipathd/multipathd.8	2006/08/02 21:37:23	1.4
+++ multipath-tools/multipathd/multipathd.8	2006/12/13 00:02:59	1.5
@@ -1,10 +1,15 @@
-.TH MULTIPATHD 8 "July 2006" "Linux Administrator's Manual"
+.TH MULTIPATHD 8 "November 2006" "Linux Administrator's Manual"
 .SH NAME
 multipathd \- multipath daemon
-.SH SYNOPSYS
+
+.SH SYNOPSIS
 .B multipathd
+.RB [\| options \|]
 
-This daemon is in charge of checking for failed paths. When this happens,
+.SH DESCRIPTION
+The 
+.B multipathd 
+daemon is in charge of checking for failed paths. When this happens,
 it will reconfigure the multipath map the path belongs to, so that this map 
 regains its maximum performance and redundancy.
 
@@ -12,11 +17,80 @@
 In turn, the multipath tool signals the multipathd daemon when it is done with 
 devmap reconfiguration, so that it can refresh its failed path list.
 
+.SH OPTIONS
+.TP
+.B \-d
+Forground Mode. Don't daemonize, and print all messages to stdout and stderr.
+.TP 
+.B -v "level"
+Verbosity level. Print additional information while running multipathd. A  level of 0 means only print errors. A level of 3 or greater prints debugging information as well. 
+.TP
+.B -k 
+multipathd will enter interactive mode. From this mode, the available commands can be viewed by entering "help". When you are finished entering commands, press CTRL-D to quit.
+
+.SH COMMANDS
+.TP
+The following commands can be used in interactive mode:
+.TP
+.B list|show paths
+Show the paths that multipathd is monitoring, and their state. 
+.TP
+.B list|show maps|multipaths
+Show the multipath devices that the multipathd is monitoring. 
+.TP
+.B list|show maps|multipaths status
+Show the status of all multipath devices that the multipathd is monitoring.
+.TP
+.B list|show maps|multipaths stats
+Show some statistics of all multipath devices that the multipathd is monitoring.
+.TP
+.B list|show maps|multipaths topology
+Show the current multipath topology. Same as "multipath -ll".
+.TP
+.B list|show topology
+Show the current multipath topology. Same as "multipath -ll".
+.TP
+.B list|show map|multipath $map topology
+Show topology of a single multipath device specified by $map, e.g. 36005076303ffc56200000000000010aa.
+This map could be obtained from "list maps".
+.TP
+.B list|show config
+Show the currently used configuration, derived from default values and values specified within the configuration file /etc/multipath.conf.
+.TP
+.B add path $path
+Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g. sda).
+.TP 
+.B remove|del path $path
+Stop monitoring a path. $path is as listed in /sys/block (e.g. sda).
+.TP
+.B add map $map
+Add a multipath device to the list of monitored devices. $map can either be a device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias for the multipath device (e.g. mpath1) or the uid of the multipath device (e.g. 36005076303ffc56200000000000010aa). 
+.TP
+.B remove|del map $map
+Stop monitoring a multipath device.
+.TP 
+.B switch|switchgroup map $map group $group
+Force a multipath device to switch to a specific path group. $group is the path group index, starting with 1.
+.TP
+.B reconfigure
+Reconfigures the multipaths. This should be triggered automatically after any hotplug event.
+.TP
+.B suspend map|multipath $map
+Sets map $map into suspend state.
+.TP
+.B resume map|multipath $map
+Resumes map $map from suspend state.
+.TP
+.B fail path $path
+Sets path $path into failed state.
+.TP
+.B reinstate path $path
+Resumes path $path from failed state.
+
 .SH "SEE ALSO"
 .BR multipath (8)
 .BR kpartx (8)
 .BR hotplug (8)
 .SH "AUTHORS"
-This man page was assembled by Patrick Caulfield 
-for the Debian project. From documentation provided
-by the multipath author Christophe Varoqui, <christophe.varoqui@free.fr> and others.
+.B multipathd
+was developed by Christophe Varoqui, <christophe.varoqui@free.fr> and others.
--- multipath-tools/path_priority/pp_alua/rtpg.c	2006/07/13 19:49:23	1.3
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2006/12/13 00:02:59	1.4
@@ -21,6 +21,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <errno.h>
+#include <inttypes.h>
 
 #define __user
 #include <scsi/sg.h>
@@ -251,14 +252,38 @@
 int
 get_asymmetric_access_state(int fd, unsigned int tpg)
 {
-	unsigned char		buf[128];
+	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
 	struct rtpg_tpg_dscr *	dscr;
 	int			rc;
+	int			buflen;
+	uint32_t		scsi_buflen;
 
-	rc = do_rtpg(fd, buf, sizeof(buf));
+	buflen = 128; /* Initial value from old code */
+	buf = (unsigned char *)malloc(buflen);
+	if (!buf) {
+		PRINT_DEBUG ("malloc failed: could not allocate"
+			"%u bytes\n", buflen);
+		return -RTPG_RTPG_FAILED;
+	}
+	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		return rc;
+	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
+	if (buflen < (scsi_buflen + 4)) {
+		free(buf);
+		buf = (unsigned char *)malloc(scsi_buflen);
+		if (!buf) {
+			PRINT_DEBUG ("malloc failed: could not allocate"
+				"%u bytes\n", scsi_buflen);
+			return -RTPG_RTPG_FAILED;
+		}
+		buflen = scsi_buflen;
+		rc = do_rtpg(fd, buf, buflen);
+		if (rc < 0)
+			goto out;
+	}
+		
 
 	tpgd = (struct rtpg_data *) buf;
 	rc   = -RTPG_TPG_NOT_FOUND;
@@ -274,7 +299,8 @@
 			}
 		}
 	}
-
+out:
+	free(buf);
 	return rc;
 }
 
