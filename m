From: Yang Feng <philip.yang@huawei.com>
Subject: [PATCH 1/2] multipath-tools/libmultipath: Support for
	the native NVMe Ioctl command.
Date: Thu, 20 Jul 2017 11:36:06 +0800
Message-ID: <1500521767-15884-2-git-send-email-philip.yang@huawei.com>
References: <1500521767-15884-1-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500521767-15884-1-git-send-email-philip.yang@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, mwilck@suse.com, xose.vazquez@gmail.com
Cc: philip.yang@huawei.com, zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

1. The SCSI-to-NVMe translations have been removed in the patch "nvme:
Remove SCSI translations" in the linux-nvme, so the native NVMe Ioctl
command should be supported in the multipath-tools.
2. In the prioritizers/path_latency.c, modify the func do_readsector0():
send a native NVMe Read Ioctl command to the nvme device, and send a SG
Read Ioctl command to the scsi device.
3. In the tur checker, add support for the native NVMe Keep Alive Ioctl
command to the nvme device.

Signed-off-by: Yang Feng <philip.yang@huawei.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/checkers.c                  |   7 ++
 libmultipath/checkers.h                  |   4 +
 libmultipath/checkers/Makefile           |   4 +-
 libmultipath/checkers/emc_clariion.c     |   4 +-
 libmultipath/checkers/libsg.c            |  94 ----------------------
 libmultipath/checkers/libsg.h            |   9 ---
 libmultipath/checkers/readsector0.c      |   4 +-
 libmultipath/checkers/tur.c              |  64 ++++++++++-----
 libmultipath/discovery.c                 |   1 +
 libmultipath/libnvme.c                   | 130 +++++++++++++++++++++++++++++++
 libmultipath/libnvme.h                   |  10 +++
 libmultipath/libsg.c                     | 113 +++++++++++++++++++++++++++
 libmultipath/libsg.h                     |  13 ++++
 libmultipath/prioritizers/Makefile       |   2 +-
 libmultipath/prioritizers/path_latency.c |  34 +++++---
 multipath/multipath.conf.5               |   2 +-
 16 files changed, 354 insertions(+), 141 deletions(-)
 delete mode 100644 libmultipath/checkers/libsg.c
 delete mode 100644 libmultipath/checkers/libsg.h
 create mode 100644 libmultipath/libnvme.c
 create mode 100644 libmultipath/libnvme.h
 create mode 100644 libmultipath/libsg.c
 create mode 100644 libmultipath/libsg.h

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 05e024f..00fbd6e 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -162,6 +162,13 @@ void checker_set_fd (struct checker * c, int fd)
 	c->fd = fd;
 }
 
+void checker_set_dev(struct checker *c, char *dev)
+{
+    if (!c)
+        return;
+    strncpy(c->dev, dev, strlen(dev)+1);
+}
+
 void checker_set_sync (struct checker * c)
 {
 	if (!c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 1d225de..f924624 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -97,6 +97,8 @@ enum path_check_state {
 #define CHECKER_DEV_LEN 256
 #define LIB_CHECKER_NAMELEN 256
 
+#define FILE_NAME_SIZE  256
+
 struct checker {
 	struct list_head node;
 	void *handle;
@@ -107,6 +109,7 @@ struct checker {
 	int disable;
 	char name[CHECKER_NAME_LEN];
 	char message[CHECKER_MSG_LEN];       /* comm with callers */
+    char dev[FILE_NAME_SIZE];
 	void * context;                      /* store for persistent data */
 	void ** mpcontext;                   /* store for persistent data shared
 						multipath-wide. Use MALLOC if
@@ -132,6 +135,7 @@ void checker_reset (struct checker *);
 void checker_set_sync (struct checker *);
 void checker_set_async (struct checker *);
 void checker_set_fd (struct checker *, int);
+void checker_set_dev(struct checker *c, char *dev);
 void checker_enable (struct checker *);
 void checker_disable (struct checker *);
 void checker_repair (struct checker *);
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index bce6b8b..a9be6b6 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -24,10 +24,10 @@ all: $(LIBS)
 libcheckrbd.so: rbd.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
 
-libcheckdirectio.so: libsg.o directio.o
+libcheckdirectio.so: ../libsg.o ../libnvme.o directio.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
 
-libcheck%.so: libsg.o %.o
+libcheck%.so: ../libsg.o ../libnvme.o %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
 install:
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 9c1ffed..12c1e3e 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -12,7 +12,7 @@
 #include <errno.h>
 
 #include "../libmultipath/sg_include.h"
-#include "libsg.h"
+#include "../libmultipath/libsg.h"
 #include "checkers.h"
 #include "debug.h"
 #include "memory.h"
@@ -21,6 +21,8 @@
 #define INQUIRY_CMDLEN  6
 #define HEAVY_CHECK_COUNT       10
 
+#define SENSE_BUFF_LEN  32
+
 /*
  * Mechanism to track CLARiiON inactive snapshot LUs.
  * This is done so that we can fail passive paths
diff --git a/libmultipath/checkers/libsg.c b/libmultipath/checkers/libsg.c
deleted file mode 100644
index 958ea92..0000000
--- a/libmultipath/checkers/libsg.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * Copyright (c) 2004, 2005 Christophe Varoqui
- */
-#include <string.h>
-#include <sys/ioctl.h>
-#include <errno.h>
-#include <sys/stat.h>
-
-#include "checkers.h"
-#include "libsg.h"
-#include "../libmultipath/sg_include.h"
-
-int
-sg_read (int sg_fd, unsigned char * buff, int buff_len,
-	 unsigned char * sense, int sense_len, unsigned int timeout)
-{
-	/* defaults */
-	int blocks;
-	long long start_block = 0;
-	int bs = 512;
-	int cdbsz = 10;
-
-	unsigned char rdCmd[cdbsz];
-	unsigned char *sbb = sense;
-	struct sg_io_hdr io_hdr;
-	int res;
-	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
-	int sz_ind;
-	struct stat filestatus;
-	int retry_count = 3;
-
-	if (fstat(sg_fd, &filestatus) != 0)
-		return PATH_DOWN;
-	bs = (filestatus.st_blksize > 4096)? 4096: filestatus.st_blksize;
-	blocks = buff_len / bs;
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
-	io_hdr.mx_sb_len = sense_len;
-	io_hdr.sbp = sense;
-	io_hdr.timeout = timeout * 1000;
-	io_hdr.pack_id = (int)start_block;
-
-retry:
-	memset(sense, 0, sense_len);
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
-		int key = 0;
-
-		if (io_hdr.sb_len_wr > 3) {
-			if (sbb[0] == 0x72 || sbb[0] == 0x73)
-				key = sbb[1] & 0x0f;
-			else if (io_hdr.sb_len_wr > 13 &&
-				 ((sbb[0] & 0x7f) == 0x70 ||
-				  (sbb[0] & 0x7f) == 0x71))
-				key = sbb[2] & 0x0f;
-		}
-
-		/*
-		 * Retry if UNIT_ATTENTION check condition.
-		 */
-		if (key == 0x6) {
-			if (--retry_count)
-				goto retry;
-		}
-		return PATH_DOWN;
-	}
-}
diff --git a/libmultipath/checkers/libsg.h b/libmultipath/checkers/libsg.h
deleted file mode 100644
index 3994f45..0000000
--- a/libmultipath/checkers/libsg.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _LIBSG_H
-#define _LIBSG_H
-
-#define SENSE_BUFF_LEN 32
-
-int sg_read (int sg_fd, unsigned char * buff, int buff_len,
-	     unsigned char * sense, int sense_len, unsigned int timeout);
-
-#endif /* _LIBSG_H */
diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c
index 8fccb46..e485810 100644
--- a/libmultipath/checkers/readsector0.c
+++ b/libmultipath/checkers/readsector0.c
@@ -4,11 +4,13 @@
 #include <stdio.h>
 
 #include "checkers.h"
-#include "libsg.h"
+#include "../libmultipath/libsg.h"
 
 #define MSG_READSECTOR0_UP	"readsector0 checker reports path is up"
 #define MSG_READSECTOR0_DOWN	"readsector0 checker reports path is down"
 
+#define SENSE_BUFF_LEN 32
+
 struct readsector0_checker_context {
 	void * dummy;
 };
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index b4a5cb2..a0382fa 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -1,5 +1,8 @@
 /*
- * Some code borrowed from sg-utils.
+ * Some code borrowed from sg-utils and
+ * NVM-Express command line utility,
+ * including using of a TUR command and
+ * a Keep Alive command.
  *
  * Copyright (c) 2004 Christophe Varoqui
  */
@@ -22,10 +25,10 @@
 #include "../libmultipath/sg_include.h"
 #include "../libmultipath/util.h"
 #include "../libmultipath/time-util.h"
-#include "../libmultipath/util.h"
+#include "../libmultipath/libsg.h"
+#include "../libmultipath/libnvme.h"
 
-#define TUR_CMD_LEN 6
-#define HEAVY_CHECK_COUNT       10
+#define SENSE_BUFF_LEN   32
 
 #define MSG_TUR_UP	"tur checker reports path is up"
 #define MSG_TUR_DOWN	"tur checker reports path is down"
@@ -39,6 +42,7 @@ struct tur_checker_context {
 	int state;
 	int running;
 	int fd;
+	char dev[FILE_NAME_SIZE];
 	unsigned int timeout;
 	time_t time;
 	pthread_t thread;
@@ -75,6 +79,7 @@ int libcheck_init (struct checker * c)
 	ct->state = PATH_UNCHECKED;
 	ct->fd = -1;
 	ct->holders = 1;
+    memset(ct->dev, 0, sizeof(ct->dev));
 	pthread_cond_init_mono(&ct->active);
 	pthread_mutexattr_init(&attr);
 	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
@@ -133,22 +138,12 @@ tur_check(int fd, unsigned int timeout,
 	  void (*copy_message)(void *, const char *), void *cb_arg)
 {
 	struct sg_io_hdr io_hdr;
-	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
-	unsigned char sense_buffer[32];
+	unsigned char sense_buffer[SENSE_BUFF_LEN];
 	int retry_tur = 5;
 
 retry:
-	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
-	memset(&sense_buffer, 0, 32);
-	io_hdr.interface_id = 'S';
-	io_hdr.cmd_len = sizeof (turCmdBlk);
-	io_hdr.mx_sb_len = sizeof (sense_buffer);
-	io_hdr.dxfer_direction = SG_DXFER_NONE;
-	io_hdr.cmdp = turCmdBlk;
-	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = timeout * 1000;
-	io_hdr.pack_id = 0;
-	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
+	if (sg_tur(fd, &io_hdr, sense_buffer,
+        sizeof(sense_buffer), timeout) < 0) {
 		TUR_MSG(MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
@@ -213,6 +208,35 @@ retry:
 	return PATH_UP;
 }
 
+static int
+keep_alive_check(int fd, unsigned int timeout,
+	  void (*copy_message)(void *, const char *), void *cb_arg)
+{
+    int err;
+
+    err = nvme_keep_alive(fd, timeout);
+    if (err == 0) {
+        TUR_MSG(MSG_TUR_UP);
+        return PATH_UP;
+	}
+
+	TUR_MSG(MSG_TUR_DOWN);
+	return PATH_DOWN;
+}
+
+static int
+ping_check(int fd, char *dev, unsigned int timeout,
+	  void (*copy_message)(void *, const char *), void *cb_arg)
+{
+    if (!strncmp(dev, "nvme", 4))
+    {
+        return keep_alive_check(fd, timeout, copy_message, cb_arg);
+    }
+    else
+    {
+        return tur_check(fd, timeout, copy_message, cb_arg);
+    }
+}
 #define tur_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
 #define tur_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
 
@@ -266,8 +290,7 @@ static void *tur_thread(void *ctx)
 	ct->state = PATH_PENDING;
 	ct->message[0] = '\0';
 	pthread_mutex_unlock(&ct->lock);
-
-	state = tur_check(ct->fd, ct->timeout, copy_msg_to_tcc, ct->message);
+    state = ping_check(ct->fd, ct->dev, ct->timeout, copy_msg_to_tcc, ct->message);
 	pthread_testcancel();
 
 	/* TUR checker done */
@@ -390,6 +413,7 @@ int libcheck_check(struct checker * c)
 		/* Start new TUR checker */
 		ct->state = PATH_UNCHECKED;
 		ct->fd = c->fd;
+        strncpy(ct->dev, c->dev, strlen(c->dev)+1);
 		ct->timeout = c->timeout;
 		pthread_spin_lock(&ct->hldr_lock);
 		ct->holders++;
@@ -406,7 +430,7 @@ int libcheck_check(struct checker * c)
 			ct->thread = 0;
 			condlog(3, "%s: failed to start tur thread, using"
 				" sync mode", tur_devt(devt, sizeof(devt), ct));
-			return tur_check(c->fd, c->timeout,
+			return ping_check(c->fd, c->dev, c->timeout,
 					 copy_msg_to_checker, c);
 		}
 		tur_timeout(&tsp);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 663c8ea..bae5d24 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1539,6 +1539,7 @@ get_state (struct path * pp, struct config *conf, int daemon)
 			return PATH_UNCHECKED;
 		}
 		checker_set_fd(c, pp->fd);
+        checker_set_dev(c, pp->dev);
 		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
 			memset(c, 0x0, sizeof(struct checker));
 			condlog(3, "%s: checker init failed", pp->dev);
diff --git a/libmultipath/libnvme.c b/libmultipath/libnvme.c
new file mode 100644
index 0000000..97c9125
--- /dev/null
+++ b/libmultipath/libnvme.c
@@ -0,0 +1,130 @@
+/*
+ * (C) Copyright HUAWEI Technology Corp. 2017, All Rights Reserved.
+ *
+ * libnvme.c
+ *
+ * Some code borrowed from NVM-Express command line utility.
+ *
+ * Author(s): Yang Feng <philip.yang@huawei.com>
+ *
+ * This file is released under the GPL version 2, or any later version.
+ *
+ */
+#include <linux/types.h>
+#include <sys/ioctl.h>
+#include <stdint.h>
+
+struct nvme_user_io {
+    __u8    opcode;
+    __u8    flags;
+    __u16   control;
+    __u16   nblocks;
+    __u16   rsvd;
+    __u64   metadata;
+    __u64   addr;
+    __u64   slba;
+    __u32   dsmgmt;
+    __u32   reftag;
+    __u16   apptag;
+    __u16   appmask;
+};
+
+struct nvme_admin_cmd {
+    __u8    opcode;
+    __u8    flags;
+    __u16   rsvd1;
+    __u32   nsid;
+    __u32   cdw2;
+    __u32   cdw3;
+    __u64   metadata;
+    __u64   addr;
+    __u32   metadata_len;
+    __u32   data_len;
+    __u32   cdw10;
+    __u32   cdw11;
+    __u32   cdw12;
+    __u32   cdw13;
+    __u32   cdw14;
+    __u32   cdw15;
+    __u32   timeout_ms;
+    __u32   result;
+};
+
+#define NVME_IOCTL_ADMIN_CMD    _IOWR('N', 0x41, struct nvme_admin_cmd)
+#define NVME_IOCTL_SUBMIT_IO    _IOW('N', 0x42, struct nvme_user_io)
+
+static int nvme_io(int fd, __u8 opcode, __u64 slba, __u16 nblocks, __u16 control,
+            __u32 dsmgmt, __u32 reftag, __u16 apptag, __u16 appmask, void *data,
+            void *metadata)
+{
+    struct nvme_user_io io = {
+    .opcode = opcode,
+    .flags = 0,
+    .control = control,
+    .nblocks = nblocks,
+    .rsvd = 0,
+    .metadata = (__u64)(uintptr_t) metadata,
+    .addr = (__u64)(uintptr_t) data,
+    .slba = slba,
+    .dsmgmt = dsmgmt,
+    .reftag = reftag,
+    .appmask = apptag,
+    .apptag = appmask,
+    };
+
+    return ioctl(fd, NVME_IOCTL_SUBMIT_IO, &io);
+}
+
+int nvme_read(int fd, __u64 slba, __u16 nblocks, __u16 control, __u32 dsmgmt,
+            __u32 reftag, __u16 apptag, __u16 appmask, void *data, void *metadata)
+{
+    return nvme_io(fd, 0x2, slba, nblocks, control, dsmgmt,
+        reftag, apptag, appmask, data, metadata);
+}
+
+static int nvme_submit_passthru(int fd, int ioctl_cmd, struct nvme_admin_cmd *cmd)
+{
+	return ioctl(fd, ioctl_cmd, cmd);
+}
+
+int nvme_passthru(int fd, int ioctl_cmd, __u8 opcode, __u8 flags, __u16 rsvd,
+		  __u32 nsid, __u32 cdw2, __u32 cdw3, __u32 cdw10, __u32 cdw11,
+		  __u32 cdw12, __u32 cdw13, __u32 cdw14, __u32 cdw15,
+		  __u32 data_len, void *data, __u32 metadata_len,
+		  void *metadata, __u32 timeout_ms, __u32 *result)
+{
+	struct nvme_admin_cmd cmd = {
+		.opcode		= opcode,
+		.flags		= flags,
+		.rsvd1		= rsvd,
+		.nsid		= nsid,
+		.cdw2		= cdw2,
+		.cdw3		= cdw3,
+		.metadata	= (__u64)(uintptr_t) metadata,
+		.addr		= (__u64)(uintptr_t) data,
+		.metadata_len	= metadata_len,
+		.data_len	= data_len,
+		.cdw10		= cdw10,
+		.cdw11		= cdw11,
+		.cdw12		= cdw12,
+		.cdw13		= cdw13,
+		.cdw14		= cdw14,
+		.cdw15		= cdw15,
+		.timeout_ms	= timeout_ms,
+		.result		= 0,
+	};
+	int err;
+
+	err = nvme_submit_passthru(fd, ioctl_cmd, &cmd);
+	if (!err && result)
+		*result = cmd.result;
+	return err;
+}
+
+int nvme_keep_alive(int fd, __u32 timeout_ms)
+{
+    __u32 result;
+
+    return nvme_passthru(fd, NVME_IOCTL_ADMIN_CMD, 0x18, 0, 0, 0, 0, 0, 0, 0,
+		                0, 0, 0, 0, 0, 0, 0,0 , timeout_ms, &result);
+}
diff --git a/libmultipath/libnvme.h b/libmultipath/libnvme.h
new file mode 100644
index 0000000..a2b5460
--- /dev/null
+++ b/libmultipath/libnvme.h
@@ -0,0 +1,10 @@
+#ifndef _LIBNVME_H
+#define _LIBNVME_H
+
+#include <linux/types.h>
+
+int nvme_read(int fd, __u64 slba, __u16 nblocks, __u16 control, __u32 dsmgmt,
+            __u32 reftag, __u16 apptag, __u16 appmask, void *data, void *metadata);
+int nvme_keep_alive(int fd, __u32 timeout_ms);
+
+#endif /* _LIBNVME_H */
diff --git a/libmultipath/libsg.c b/libmultipath/libsg.c
new file mode 100644
index 0000000..900103e
--- /dev/null
+++ b/libmultipath/libsg.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2004, 2005 Christophe Varoqui
+ */
+#include <string.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <sys/stat.h>
+
+#include "checkers.h"
+#include "libsg.h"
+
+int
+sg_read (int sg_fd, unsigned char * buff, int buff_len,
+	 unsigned char * sense, int sense_len, unsigned int timeout)
+{
+	/* defaults */
+	int blocks;
+	long long start_block = 0;
+	int bs = 512;
+	int cdbsz = 10;
+
+	unsigned char rdCmd[cdbsz];
+	unsigned char *sbb = sense;
+	struct sg_io_hdr io_hdr;
+	int res;
+	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
+	int sz_ind;
+	struct stat filestatus;
+	int retry_count = 3;
+
+	if (fstat(sg_fd, &filestatus) != 0)
+		return PATH_DOWN;
+	bs = (filestatus.st_blksize > 4096)? 4096: filestatus.st_blksize;
+	blocks = buff_len / bs;
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
+	io_hdr.mx_sb_len = sense_len;
+	io_hdr.sbp = sense;
+	io_hdr.timeout = timeout * 1000;
+	io_hdr.pack_id = (int)start_block;
+
+retry:
+	memset(sense, 0, sense_len);
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
+		int key = 0;
+
+		if (io_hdr.sb_len_wr > 3) {
+			if (sbb[0] == 0x72 || sbb[0] == 0x73)
+				key = sbb[1] & 0x0f;
+			else if (io_hdr.sb_len_wr > 13 &&
+				 ((sbb[0] & 0x7f) == 0x70 ||
+				  (sbb[0] & 0x7f) == 0x71))
+				key = sbb[2] & 0x0f;
+		}
+
+		/*
+		 * Retry if UNIT_ATTENTION check condition.
+		 */
+		if (key == 0x6) {
+			if (--retry_count)
+				goto retry;
+		}
+		return PATH_DOWN;
+	}
+}
+
+int
+sg_tur(int fd, struct sg_io_hdr *io_hdr, unsigned char *sense,
+    int sense_len, unsigned int timeout)
+{
+	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
+
+	memset(io_hdr, 0, sizeof(struct sg_io_hdr));
+	memset(sense, 0, sense_len);
+	io_hdr->interface_id = 'S';
+	io_hdr->cmd_len = sizeof(turCmdBlk);
+	io_hdr->mx_sb_len = sense_len;
+	io_hdr->dxfer_direction = SG_DXFER_NONE;
+	io_hdr->cmdp = turCmdBlk;
+	io_hdr->sbp = sense;
+	io_hdr->timeout = timeout * 1000;
+	io_hdr->pack_id = 0;
+
+    return ioctl(fd, SG_IO, io_hdr);
+}
diff --git a/libmultipath/libsg.h b/libmultipath/libsg.h
new file mode 100644
index 0000000..70049a2
--- /dev/null
+++ b/libmultipath/libsg.h
@@ -0,0 +1,13 @@
+#ifndef _LIBSG_H
+#define _LIBSG_H
+
+#include "sg_include.h"
+
+#define TUR_CMD_LEN 6
+
+int sg_read (int sg_fd, unsigned char * buff, int buff_len,
+	     unsigned char * sense, int sense_len, unsigned int timeout);
+int sg_tur(int fd, struct sg_io_hdr *io_hdr, unsigned char *sense,
+        int sense_len, unsigned int timeout);
+
+#endif /* _LIBSG_H */
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 0c71e63..0c5c69b 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -26,7 +26,7 @@ all: $(LIBS)
 libprioalua.so: alua.o alua_rtpg.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
-libpriopath_latency.so: path_latency.o  ../checkers/libsg.o
+libpriopath_latency.so: path_latency.o  ../libsg.o ../libnvme.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm
 
 libprio%.so: %.o
diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index 34b734b..21209ff 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -23,11 +23,11 @@
 #include <math.h>
 #include <ctype.h>
 #include <time.h>
-
 #include "debug.h"
 #include "prio.h"
 #include "structs.h"
-#include "../checkers/libsg.h"
+#include "libsg.h"
+#include "libnvme.h"
 
 #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
 
@@ -44,6 +44,8 @@
 
 #define MAX_CHAR_SIZE           30
 
+#define SENSE_BUFF_LEN          32
+
 #define USEC_PER_SEC            1000000LL
 #define NSEC_PER_USEC           1000LL
 
@@ -51,19 +53,27 @@ static long long path_latency[MAX_IO_NUM];
 
 static inline long long timeval_to_us(const struct timespec *tv)
 {
-	return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec / NSEC_PER_USEC);
+    return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec / NSEC_PER_USEC);
 }
 
-static int do_readsector0(int fd, unsigned int timeout)
+static int do_readsector0(struct path *pp, unsigned int timeout)
 {
-	unsigned char buf[4096];
-	unsigned char sbuf[SENSE_BUFF_LEN];
-	int ret;
+    unsigned char buf[4096];
+    unsigned char mbuf[512];
+    unsigned char sbuf[SENSE_BUFF_LEN];
 
-	ret = sg_read(fd, &buf[0], 4096, &sbuf[0],
-		      SENSE_BUFF_LEN, timeout);
+    if (!strncmp(pp->dev, "nvme", 4))
+    {
+        if (nvme_read(pp->fd, 0, 1, 0, 0, 0, 0, 0, buf, mbuf) != 0)
+            return 0;
+    }
+    else
+    {
+        if (sg_read(pp->fd, &buf[0], 4096, &sbuf[0], SENSE_BUFF_LEN, timeout) == 2)
+            return 0;
+    }
 
-	return ret;
+    return 1;
 }
 
 int check_args_valid(int io_num, int base_num)
@@ -218,9 +228,9 @@ int getprio (struct path *pp, char *args, unsigned int timeout)
         (void)clock_gettime(CLOCK_MONOTONIC, &tv);
         before = timeval_to_us(&tv);
 
-        if (do_readsector0(pp->fd, timeout) == 2)
+        if (do_readsector0(pp, timeout) == 0)
         {
-            pp_pl_log(0, "%s: path down", pp->dev);
+            pp_pl_log(0, "%s: send read sector0 command fail", pp->dev);
             return -1;
         }
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0049cba..a8d4797 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -419,7 +419,7 @@ are:
 deprecated, please use \fItur\fR instead.
 .TP
 .I tur
-Issue a \fITEST UNIT READY\fR command to the device.
+Issue a \fITEST UNIT READY\fR command or a \fIKEEP ALIVE\fR command to the device.
 .TP
 .I emc_clariion
 (Hardware-dependent)
-- 
2.6.4.windows.1
