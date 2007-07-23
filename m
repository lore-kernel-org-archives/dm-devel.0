From: bmarzins@sourceware.org
Subject: multipath-tools ./Makefile path_priority/pp_tp ...
Date: 23 Jul 2007 21:37:11 -0000
Message-ID: <20070723213711.30492.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-07-23 21:37:10

Modified files:
	.              : Makefile 
Added files:
	path_priority/pp_tpc: Makefile pp_tpc.c 

Log message:
	Fix for bz #247891. Added mpath_prio_tpc priority callout to RHEL4.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.6&r2=1.6.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_tpc/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_tpc/pp_tpc.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.2.4.1

--- multipath-tools/Makefile	2006/04/24 23:50:01	1.6
+++ multipath-tools/Makefile	2007/07/23 21:37:10	1.6.2.1
@@ -22,14 +22,14 @@
 
 BUILDDIRS = libmultipath libcheckers path_priority/pp_emc \
 	    path_priority/pp_alua path_priority/pp_netapp \
-	    path_priority/pp_hds_modular multipath multipathd \
-	    kpartx
+	    path_priority/pp_hds_modular path_priority/pp_tpc \
+	    multipath multipathd kpartx
 ALLDIRS	= $(shell find . -type d -maxdepth 1 -mindepth 1)
 
 VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
 INSTALLDIRS = multipath multipathd kpartx path_priority/pp_emc \
 	     path_priority/pp_alua path_priority/pp_netapp \
-	     path_priority/pp_hds_modular
+	     path_priority/pp_hds_modular path_priority/pp_tpc
 
 
 all: recurse
/cvs/dm/multipath-tools/path_priority/pp_tpc/Makefile,v  -->  standard output
revision 1.1.4.1
--- multipath-tools/path_priority/pp_tpc/Makefile
+++ -	2007-07-23 21:37:11.419612000 +0000
@@ -0,0 +1,22 @@
+EXEC		= mpath_prio_tpc
+BUILD		= glibc
+OBJS		= pp_tpc.o
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
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+clean:	
+	rm -f *.o $(EXEC)
/cvs/dm/multipath-tools/path_priority/pp_tpc/pp_tpc.c,v  -->  standard output
revision 1.2.4.1
--- multipath-tools/path_priority/pp_tpc/pp_tpc.c
+++ -	2007-07-23 21:37:11.497489000 +0000
@@ -0,0 +1,113 @@
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
+#define __user
+#include <scsi/sg.h>
+
+#define INQUIRY_CMD     0x12
+#define INQUIRY_CMDLEN  6
+
+int sgi_tpc_prio(const char *dev)
+{
+	unsigned char sense_buffer[256];
+	unsigned char sb[128];
+	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC9, 0,
+						sizeof(sb), 0};
+	struct sg_io_hdr io_hdr;
+	int ret = 0;
+	int fd;
+
+	fd = open(dev, O_RDWR|O_NONBLOCK);
+
+	if (fd <= 0) {
+		fprintf(stderr, "opening of the device failed.\n");
+		goto out;
+	}
+
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = sizeof (inqCmdBlk);
+	io_hdr.mx_sb_len = sizeof (sb);
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = sizeof (sense_buffer);
+	io_hdr.dxferp = sense_buffer;
+	io_hdr.cmdp = inqCmdBlk;
+	io_hdr.sbp = sb;
+	io_hdr.timeout = 60000;
+	io_hdr.pack_id = 0;
+	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+		fprintf(stderr, "sending inquiry command failed\n");
+		goto out;
+	}
+	if (io_hdr.info & SG_INFO_OK_MASK) {
+		fprintf(stderr, "inquiry command indicates error");
+		goto out;
+	}
+
+	close(fd);
+	
+	if (/* Verify the code page - right page & page identifier */
+	    sense_buffer[1] != 0xc9 || 
+	    sense_buffer[3] != 0x2c ||
+	    sense_buffer[4] != 'v' ||
+	    sense_buffer[5] != 'a' ||
+	    sense_buffer[6] != 'c' ) {
+		fprintf(stderr, "Volume access control page in unknown format");
+		goto out;
+	}
+	
+	if ( /* Current Volume Path Bit */
+		( sense_buffer[8] & 0x01) == 0x01 ) {
+		/* 
+		 * This volume was owned by the controller receiving
+		 * the inquiry command.
+		 */
+		ret |= 0x01;
+	}
+
+	/* Volume Preferred Path Priority */
+	switch ( sense_buffer[9] & 0x0F ) {
+	case 0x01:
+		/* 
+		 * Access to this volume is most preferred through
+		 * this path and other paths with this value.
+		 */
+		ret |= 0x02;
+		break;
+	case 0x02:
+		/*
+		 * Access to this volume through this path is to be used
+		 * as a secondary path. Typically this path would be used
+		 * for fail-over situations.
+		 */
+		/* Fallthrough */
+	default:
+		/* Reserved values */
+		break;
+	}
+	
+out:
+	return(ret);
+}
+
+int
+main (int argc, char **argv)
+{
+	int prio;
+	if (argc != 2) {
+		fprintf(stderr, "Wrong number of arguments.\n");
+		fprintf(stderr, "Usage: %s device\n", argv[0]);
+		prio = 0;
+	} else
+		prio = sgi_tpc_prio(argv[1]);
+
+	printf("%d\n", prio);
+	exit(0);
+}
