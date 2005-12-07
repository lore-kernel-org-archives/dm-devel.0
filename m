From: Hannes Reinecke <hare@suse.de>
Subject: Path-priority checker for SGI TPC
Date: Wed, 07 Dec 2005 10:31:35 +0100
Message-ID: <4396ABF7.7040003@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040801030203040007080407"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040801030203040007080407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

SGI TPC also has the notion of a preferred path; the switch-over to a
secondary path takes some seconds. So we should calculate a proper
priority for it.

Patch is against current git tree.

Sidenote: The default policy says still 'FAILOVER'. Shouldn't we switch
to GROUP_BY_PRIO now that we have a priority checker?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------040801030203040007080407
Content-Type: text/x-patch;
 name="multipath-tools-pp_tpc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath-tools-pp_tpc.patch"

From: Hannes Reinecke <hare@suse.de>
Subject: path_priority for SGI TP9X00

This patch add the path_priority checker for SGI TPC storage servers.
They have a preferred path and one (or several) secondary ones. When
accessed from the secondary path the famous 'Auto Volume Transfer' takes
over, which switches this path to become the preferred one.

This whole process takes about 10secs, so we should be better select the
priority accordingly.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -46,9 +46,9 @@ setup_default_hwtable (vector hw)
 		   DEFAULT_GETUID, "/sbin/mpath_prio_alua %d", "0", "0",
 		   "tur", FAILBACK_UNDEF);
 	r += store_hwe_ext(hw, "SGI", "TP9400", MULTIBUS, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
+		   "/sbin/mpath_prio_tpc /dev/%n", "0", "0", "tur", FAILBACK_UNDEF);
 	r += store_hwe_ext(hw, "SGI", "TP9500", FAILOVER, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
+		   "/sbin/mpath_prio_tpc /dev/%n", "0", "0", "tur", FAILBACK_UNDEF);
 
 	return r;
 }
diff --git a/path_priority/pp_tpc/Makefile b/path_priority/pp_tpc/Makefile
new file mode 100644
--- /dev/null
+++ b/path_priority/pp_tpc/Makefile
@@ -0,0 +1,29 @@
+EXEC		= mpath_prio_tpc
+BUILD		= glibc
+OBJS		= pp_tpc.o
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
+	$(STRIP) $(EXEC)
+
+klibc:	$(OBJS)
+	$(CC) -static -o $(EXEC) $(OBJS)
+	$(STRIP) $(EXEC)
+
+install: $(EXEC)
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
+
+uninstall:
+	rm $(DESTDIR)$(bindir)/$(EXEC)
+clean:	
+	rm -f *.o $(EXEC)
+
+%.o:	%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/path_priority/pp_tpc/pp_tpc.c b/path_priority/pp_tpc/pp_tpc.c
new file mode 100644
--- /dev/null
+++ b/path_priority/pp_tpc/pp_tpc.c
@@ -0,0 +1,118 @@
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
+	    sense_buffer[4] != 'v' ||
+	    sense_buffer[5] != 'a' ||
+	    sense_buffer[6] != 'c' ||
+	    sense_buffer[7] != '1' ) {
+		fprintf(stderr, "Volume access control page in unknown format");
+		goto out;
+	}
+	
+	if ( /* Auto-volume Transfer Enabled */
+	    	(sense_buffer[8] & 0x80) != 0x80 ) {
+		fprintf(stderr, "Auto-volume Transfer not enabled");
+	}
+
+	if ( /* Current Volume Path Bit */
+		( sense_buffer[8] & 0x01) == 0x01 ) {
+		/* 
+		 * This volume was owned by the controller receiving
+		 * the inquiry command.
+		 */
+		ret |= 0x02;
+	}
+
+	/* Volume Preferred Path Priority */
+	switch ( sense_buffer[9] & 0x0F ) {
+	case 0x01:
+		/* 
+		 * Access to this volume is most preferred through
+		 * this path and other paths with this value.
+		 */
+		ret |= 0x04;
+		break;
+	case 0x02:
+		/*
+		 * Access to this volume through this path is to be used
+		 * as a secondary path. Typically this path would be used
+		 * for fail-over situations.
+		 */
+		ret |= 0x01;
+		break;
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

--------------040801030203040007080407
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040801030203040007080407--
