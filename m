From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 13/21] [libmultipath] Add new priority checker
	mpath_hp_sw
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.9016CD44CD@pentland.suse.de>
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


All paths from a controller with HP Active/Standby firmware
should really be grouped according to their status; otherwise
the path switching will not work properly or you can use only
one path to that array.
This patch adds a new priority checker 'mpath_hp_sw' which
will allow these paths to be grouped accordingly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 path_priority/pp_hp_sw/Makefile   |   25 ++++++++
 path_priority/pp_hp_sw/pp_hp_sw.c |  119 +++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/path_priority/pp_hp_sw/Makefile b/path_priority/pp_hp_sw/Makefile
new file mode 100644
index 0000000..e7debf5
--- /dev/null
+++ b/path_priority/pp_hp_sw/Makefile
@@ -0,0 +1,25 @@
+EXEC		= mpath_prio_hp_sw
+BUILD		= glibc
+OBJS		= pp_hp_sw.o
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
+
+%.o:	%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/path_priority/pp_hp_sw/pp_hp_sw.c b/path_priority/pp_hp_sw/pp_hp_sw.c
new file mode 100644
index 0000000..e4a18b1
--- /dev/null
+++ b/path_priority/pp_hp_sw/pp_hp_sw.c
@@ -0,0 +1,119 @@
+/*
+ * Path priority checker for HP active/standby controller
+ *
+ * Check the path state and sort them into groups.
+ * There is actually a preferred path in the controller;
+ * we should ask HP on how to retrieve that information.
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
+#define TUR_CMD_LEN		6
+#define SCSI_CHECK_CONDITION	0x2
+#define SCSI_COMMAND_TERMINATED	0x22
+#define SG_ERR_DRIVER_SENSE	0x08
+#define RECOVERED_ERROR		0x01
+#define NOT_READY		0x02
+#define UNIT_ATTENTION		0x06
+
+#define HP_PATH_ACTIVE		0x04
+#define HP_PATH_STANDBY		0x02
+#define HP_PATH_FAILED		0x00
+
+#include "../../libmultipath/sg_include.h"
+
+int hp_sw_prio(const char *dev)
+{
+        unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
+	unsigned char sb[128];
+	struct sg_io_hdr io_hdr;
+	int ret = HP_PATH_FAILED;
+	int fd;
+
+	fd = open(dev, O_RDWR|O_NONBLOCK);
+
+	if (fd <= 0) {
+		fprintf(stderr, "Opening the device failed.\n");
+		goto out;
+	}
+
+	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	io_hdr.interface_id = 'S';
+	io_hdr.cmd_len = sizeof (turCmdBlk);
+	io_hdr.mx_sb_len = sizeof (sb);
+	io_hdr.dxfer_direction = SG_DXFER_NONE;
+	io_hdr.cmdp = turCmdBlk;
+	io_hdr.sbp = sb;
+	io_hdr.timeout = 60000;
+	io_hdr.pack_id = 0;
+ retry:
+	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+		fprintf(stderr, "sending tur command failed\n");
+		goto out;
+	}
+        io_hdr.status &= 0x7e;
+        if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
+            (0 == io_hdr.driver_status)) {
+		/* Command completed normally, path is active */
+                ret = HP_PATH_ACTIVE;
+	}
+
+        if ((SCSI_CHECK_CONDITION == io_hdr.status) ||
+            (SCSI_COMMAND_TERMINATED == io_hdr.status) ||
+            (SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status))) {
+                if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
+                        int sense_key, asc, asq;
+                        unsigned char * sense_buffer = io_hdr.sbp;
+                        if (sense_buffer[0] & 0x2) {
+                                sense_key = sense_buffer[1] & 0xf;
+				asc = sense_buffer[2];
+				asq = sense_buffer[3];
+			} else {
+                                sense_key = sense_buffer[2] & 0xf;
+				asc = sense_buffer[12];
+				asq = sense_buffer[13];
+			}
+                        if(RECOVERED_ERROR == sense_key)
+                                ret = HP_PATH_ACTIVE;
+			if(NOT_READY == sense_key) {
+				if (asc == 0x04 && asq == 0x02) {
+					/* This is a standby path */
+					ret = HP_PATH_STANDBY;
+				}
+			}
+			if(UNIT_ATTENTION == sense_key) {
+				if (asc == 0x29) {
+					/* Retry for device reset */
+					goto retry;
+				}
+			}
+                }
+        }
+
+	close(fd);
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
+		fprintf(stderr, "Arguments wrong!\n");
+		prio = 0;
+	} else
+		prio = hp_sw_prio(argv[1]);
+
+	printf("%d\n", prio);
+	exit(0);
+}
+
-- 
1.4.3.4
