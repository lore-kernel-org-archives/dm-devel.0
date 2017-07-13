From: Yang Feng <philip.yang@huawei.com>
Subject: [PATCH 1/2] multipath-tools/libmultipath: Support for
	the native NVMe Ioctl command.
Date: Thu, 13 Jul 2017 15:51:27 +0800
Message-ID: <1499932288-15420-2-git-send-email-philip.yang@huawei.com>
References: <1499932288-15420-1-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1499932288-15420-1-git-send-email-philip.yang@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com
List-Id: dm-devel.ids

1. The SCSI-to-NVMe translations have been removed in the patch "nvme:
Remove SCSI translations" in the linux-nvme, so the native NVMe Ioctl
command should be supported in the multipath-tools.
2. In the prioritizers/path_latency.c, modify the func do_readsector0():
send a native NVMe Read Ioctl command to the nvme device, and send a SG
Read Ioctl command to the scsi device.
3. In the checkers, delete the file tur.c and create the new file ping.c:
ping.c can support the native NVMe Keep Alive Ioctl command to the nvme
device, and can support the SG TUR Ioctl command to the scsi device.

Signed-off-by: Yang Feng <philip.yang@huawei.com>
---
 libmultipath/checkers.c                  |   7 +
 libmultipath/checkers.h                  |   6 +-
 libmultipath/checkers/Makefile           |   6 +-
 libmultipath/checkers/emc_clariion.c     |   4 +-
 libmultipath/checkers/libsg.c            |  94 -------
 libmultipath/checkers/libsg.h            |   9 -
 libmultipath/checkers/ping.c             | 453 +++++++++++++++++++++++++++++++
 libmultipath/checkers/readsector0.c      |   4 +-
 libmultipath/checkers/tur.c              | 427 -----------------------------
 libmultipath/checkers/tur.h              |   8 -
 libmultipath/defaults.h                  |   2 +-
 libmultipath/discovery.c                 |   1 +
 libmultipath/hwtable.c                   |   2 +-
 libmultipath/libnvme.c                   | 130 +++++++++
 libmultipath/libnvme.h                   |  10 +
 libmultipath/libsg.c                     | 113 ++++++++
 libmultipath/libsg.h                     |  13 +
 libmultipath/prioritizers/Makefile       |   2 +-
 libmultipath/prioritizers/path_latency.c |  58 +---
 libmultipath/propsel.c                   |   2 +-
 multipath/multipath.conf.5               |   4 +-
 21 files changed, 754 insertions(+), 601 deletions(-)
 delete mode 100644 libmultipath/checkers/libsg.c
 delete mode 100644 libmultipath/checkers/libsg.h
 create mode 100644 libmultipath/checkers/ping.c
 delete mode 100644 libmultipath/checkers/tur.c
 delete mode 100644 libmultipath/checkers/tur.h
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
index 1d225de..506dd4c 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -79,7 +79,7 @@ enum path_check_state {
 };
 
 #define DIRECTIO     "directio"
-#define TUR          "tur"
+#define PING         "ping"
 #define HP_SW        "hp_sw"
 #define RDAC         "rdac"
 #define EMC_CLARIION "emc_clariion"
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
index bce6b8b..3ab04ef 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -9,7 +9,7 @@ CFLAGS += $(LIB_CFLAGS) -I..
 LIBS= \
 	libcheckcciss_tur.so \
 	libcheckreadsector0.so \
-	libchecktur.so \
+	libcheckping.so \
 	libcheckdirectio.so \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
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
diff --git a/libmultipath/checkers/ping.c b/libmultipath/checkers/ping.c
new file mode 100644
index 0000000..3a87571
--- /dev/null
+++ b/libmultipath/checkers/ping.c
@@ -0,0 +1,453 @@
+/*
+ * Some code borrowed from sg-utils and
+ * NVM-Express command line utility,
+ * including using of a TUR command and
+ * a Keep Alive command.
+ *
+ * Copyright (c) 2004 Christophe Varoqui
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/sysmacros.h>
+#include <errno.h>
+#include <sys/time.h>
+#include <pthread.h>
+
+#include "checkers.h"
+
+#include "../libmultipath/debug.h"
+#include "../libmultipath/sg_include.h"
+#include "../libmultipath/util.h"
+#include "../libmultipath/time-util.h"
+#include "../libmultipath/libsg.h"
+#include "../libmultipath/libnvme.h"
+
+#define SENSE_BUFF_LEN   32
+
+#define MSG_PING_UP      "ping checker reports path is up"
+#define MSG_PING_DOWN    "ping checker reports path is down"
+#define MSG_PING_GHOST   "ping checker reports path is in standby state"
+#define MSG_PING_RUNNING "ping checker still running"
+#define MSG_PING_TIMEOUT "ping checker timed out"
+#define MSG_PING_FAILED  "ping checker failed to initialize"
+
+struct ping_checker_context {
+	dev_t devt;
+	int state;
+	int running;
+	int fd;
+	char dev[FILE_NAME_SIZE];
+	unsigned int timeout;
+	time_t time;
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t active;
+	pthread_spinlock_t hldr_lock;
+	int holders;
+	char message[CHECKER_MSG_LEN];
+};
+
+static const char *ping_devt(char *devt_buf, int size,
+			    struct ping_checker_context *ct)
+{
+	dev_t devt;
+
+	pthread_mutex_lock(&ct->lock);
+	devt = ct->devt;
+	pthread_mutex_unlock(&ct->lock);
+
+	snprintf(devt_buf, size, "%d:%d", major(devt), minor(devt));
+	return devt_buf;
+}
+
+int libcheck_init (struct checker * c)
+{
+	struct ping_checker_context *ct;
+	pthread_mutexattr_t attr;
+
+	ct = malloc(sizeof(struct ping_checker_context));
+	if (!ct)
+		return 1;
+	memset(ct, 0, sizeof(struct ping_checker_context));
+
+	ct->state = PATH_UNCHECKED;
+	ct->fd = -1;
+	ct->holders = 1;
+       memset(ct->dev, 0, sizeof(ct->dev));
+	pthread_cond_init_mono(&ct->active);
+	pthread_mutexattr_init(&attr);
+	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
+	pthread_mutex_init(&ct->lock, &attr);
+	pthread_mutexattr_destroy(&attr);
+	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
+	c->context = ct;
+
+	return 0;
+}
+
+static void cleanup_context(struct ping_checker_context *ct)
+{
+	pthread_mutex_destroy(&ct->lock);
+	pthread_cond_destroy(&ct->active);
+	pthread_spin_destroy(&ct->hldr_lock);
+	free(ct);
+}
+
+void libcheck_free (struct checker * c)
+{
+	if (c->context) {
+		struct ping_checker_context *ct = c->context;
+		int holders;
+		pthread_t thread;
+
+		pthread_spin_lock(&ct->hldr_lock);
+		ct->holders--;
+		holders = ct->holders;
+		thread = ct->thread;
+		pthread_spin_unlock(&ct->hldr_lock);
+		if (holders)
+			pthread_cancel(thread);
+		else
+			cleanup_context(ct);
+		c->context = NULL;
+	}
+	return;
+}
+
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
+#define PING_MSG(fmt, args...)					\
+	do {							\
+		char msg[CHECKER_MSG_LEN];			\
+								\
+		snprintf(msg, sizeof(msg), fmt, ##args);	\
+		copy_message(cb_arg, msg);			\
+	} while (0)
+
+static int
+tur_check(int fd, unsigned int timeout,
+	  void (*copy_message)(void *, const char *), void *cb_arg)
+{
+	struct sg_io_hdr io_hdr;
+	unsigned char sense_buffer[SENSE_BUFF_LEN];
+	int retry_tur = 5;
+
+retry:
+	if (sg_tur(fd, &io_hdr, sense_buffer,
+        sizeof(sense_buffer), timeout) < 0) {
+		PING_MSG(MSG_PING_DOWN);
+		return PATH_DOWN;
+    }
+
+	if ((io_hdr.status & 0x7e) == 0x18) {
+		/*
+		 * SCSI-3 arrays might return
+		 * reservation conflict on TUR
+		 */
+		PING_MSG(MSG_PING_UP);
+		return PATH_UP;
+	}
+	if (io_hdr.info & SG_INFO_OK_MASK) {
+		int key = 0, asc, ascq;
+
+		switch (io_hdr.host_status) {
+		case DID_OK:
+		case DID_NO_CONNECT:
+		case DID_BAD_TARGET:
+		case DID_ABORT:
+		case DID_TRANSPORT_FAILFAST:
+			break;
+		default:
+			/* Driver error, retry */
+			if (--retry_tur)
+				goto retry;
+			break;
+		}
+		if (io_hdr.sb_len_wr > 3) {
+			if (io_hdr.sbp[0] == 0x72 || io_hdr.sbp[0] == 0x73) {
+				key = io_hdr.sbp[1] & 0x0f;
+				asc = io_hdr.sbp[2];
+				ascq = io_hdr.sbp[3];
+			} else if (io_hdr.sb_len_wr > 13 &&
+				   ((io_hdr.sbp[0] & 0x7f) == 0x70 ||
+				    (io_hdr.sbp[0] & 0x7f) == 0x71)) {
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
+		else if (key == 0x2) {
+			/* Not Ready */
+			/* Note: Other ALUA states are either UP or DOWN */
+			if( asc == 0x04 && ascq == 0x0b){
+				/*
+				 * LOGICAL UNIT NOT ACCESSIBLE,
+				 * TARGET PORT IN STANDBY STATE
+				 */
+				PING_MSG(MSG_PING_GHOST);
+				return PATH_GHOST;
+			}
+		}
+		PING_MSG(MSG_PING_DOWN);
+		return PATH_DOWN;
+	}
+    PING_MSG(MSG_PING_UP);
+	return PATH_UP;
+}
+
+static int
+keep_alive_check(int fd, unsigned int timeout,
+	  void (*copy_message)(void *, const char *), void *cb_arg)
+{
+    int err;
+
+    err = nvme_keep_alive(fd, timeout);
+    if (err == 0) {
+        PING_MSG(MSG_PING_UP);
+        return PATH_UP;
+	}
+
+	PING_MSG(MSG_PING_DOWN);
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
+
+#define ping_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
+#define ping_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
+
+static void cleanup_func(void *data)
+{
+	int holders;
+	struct ping_checker_context *ct = data;
+	pthread_spin_lock(&ct->hldr_lock);
+	ct->holders--;
+	holders = ct->holders;
+	ct->thread = 0;
+	pthread_spin_unlock(&ct->hldr_lock);
+	if (!holders)
+		cleanup_context(ct);
+}
+
+static int ping_running(struct ping_checker_context *ct)
+{
+	pthread_t thread;
+
+	pthread_spin_lock(&ct->hldr_lock);
+	thread = ct->thread;
+	pthread_spin_unlock(&ct->hldr_lock);
+
+	return thread != 0;
+}
+
+static void copy_msg_to_tcc(void *ct_p, const char *msg)
+{
+	struct ping_checker_context *ct = ct_p;
+
+	pthread_mutex_lock(&ct->lock);
+	strlcpy(ct->message, msg, sizeof(ct->message));
+	pthread_mutex_unlock(&ct->lock);
+}
+
+static void *ping_thread(void *ctx)
+{
+	struct ping_checker_context *ct = ctx;
+	int state;
+	char devt[32];
+
+	condlog(3, "%s: ping checker starting up",
+		ping_devt(devt, sizeof(devt), ct));
+
+	/* This thread can be canceled, so setup clean up */
+	ping_thread_cleanup_push(ct);
+
+	/* PING checker start up */
+	pthread_mutex_lock(&ct->lock);
+	ct->state = PATH_PENDING;
+	ct->message[0] = '\0';
+	pthread_mutex_unlock(&ct->lock);
+       state = ping_check(ct->fd, ct->dev, ct->timeout, copy_msg_to_tcc, ct->message);
+	pthread_testcancel();
+
+	/* PING checker done */
+	pthread_mutex_lock(&ct->lock);
+	ct->state = state;
+	pthread_cond_signal(&ct->active);
+	pthread_mutex_unlock(&ct->lock);
+
+	condlog(3, "%s: ping checker finished, state %s",
+		ping_devt(devt, sizeof(devt), ct), checker_state_name(state));
+	ping_thread_cleanup_pop(ct);
+
+	return ((void *)0);
+}
+
+
+static void ping_timeout(struct timespec *tsp)
+{
+	clock_gettime(CLOCK_MONOTONIC, tsp);
+	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
+	normalize_timespec(tsp);
+}
+
+static void ping_set_async_timeout(struct checker *c)
+{
+	struct ping_checker_context *ct = c->context;
+	struct timespec now;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	ct->time = now.tv_sec + c->timeout;
+}
+
+static int ping_check_async_timeout(struct checker *c)
+{
+	struct ping_checker_context *ct = c->context;
+	struct timespec now;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	return (now.tv_sec > ct->time);
+}
+
+static void copy_msg_to_checker(void *c_p, const char *msg)
+{
+	struct checker *c = c_p;
+
+	strlcpy(c->message, msg, sizeof(c->message));
+}
+
+int libcheck_check(struct checker * c)
+{
+	struct ping_checker_context *ct = c->context;
+	struct timespec tsp;
+	struct stat sb;
+	pthread_attr_t attr;
+	int ping_status, r;
+	char devt[32];
+
+
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	if (fstat(c->fd, &sb) == 0) {
+		pthread_mutex_lock(&ct->lock);
+		ct->devt = sb.st_rdev;
+		pthread_mutex_unlock(&ct->lock);
+	}
+
+	if (c->sync)
+               return ping_check(c->fd, c->dev, c->timeout, copy_msg_to_checker, c);
+
+	/*
+	 * Async mode
+	 */
+	r = pthread_mutex_lock(&ct->lock);
+	if (r != 0) {
+		condlog(2, "%s: ping mutex lock failed with %d",
+			ping_devt(devt, sizeof(devt), ct), r);
+		MSG(c, MSG_PING_FAILED);
+		return PATH_WILD;
+	}
+
+	if (ct->running) {
+		/*
+		 * Check if PING checker is still running. Hold hldr_lock
+		 * around the pthread_cancel() call to avoid that
+		 * pthread_cancel() gets called after the (detached) PING
+		 * thread has exited.
+		 */
+		pthread_spin_lock(&ct->hldr_lock);
+		if (ct->thread) {
+			if (ping_check_async_timeout(c)) {
+				condlog(3, "%s: ping checker timeout",
+					ping_devt(devt, sizeof(devt), ct));
+				pthread_cancel(ct->thread);
+				ct->running = 0;
+				MSG(c, MSG_PING_TIMEOUT);
+				ping_status = PATH_TIMEOUT;
+			} else {
+				condlog(3, "%s: ping checker not finished",
+					ping_devt(devt, sizeof(devt), ct));
+				ct->running++;
+				ping_status = PATH_PENDING;
+			}
+		} else {
+			/* PING checker done */
+			ct->running = 0;
+			ping_status = ct->state;
+			strlcpy(c->message, ct->message, sizeof(c->message));
+		}
+		pthread_spin_unlock(&ct->hldr_lock);
+		pthread_mutex_unlock(&ct->lock);
+	} else {
+		if (ping_running(ct)) {
+			/* pthread cancel failed. continue in sync mode */
+			pthread_mutex_unlock(&ct->lock);
+			condlog(3, "%s: ping thread not responding",
+				ping_devt(devt, sizeof(devt), ct));
+			return PATH_TIMEOUT;
+		}
+		/* Start new PING checker */
+		ct->state = PATH_UNCHECKED;
+		ct->fd = c->fd;
+               strncpy(ct->dev, c->dev, strlen(c->dev)+1);
+		ct->timeout = c->timeout;
+		pthread_spin_lock(&ct->hldr_lock);
+		ct->holders++;
+		pthread_spin_unlock(&ct->hldr_lock);
+		ping_set_async_timeout(c);
+		setup_thread_attr(&attr, 32 * 1024, 1);
+		r = pthread_create(&ct->thread, &attr, ping_thread, ct);
+		pthread_attr_destroy(&attr);
+		if (r) {
+			pthread_spin_lock(&ct->hldr_lock);
+			ct->holders--;
+			pthread_spin_unlock(&ct->hldr_lock);
+			pthread_mutex_unlock(&ct->lock);
+			ct->thread = 0;
+			condlog(3, "%s: failed to start ping thread, using"
+				" sync mode", ping_devt(devt, sizeof(devt), ct));
+			return ping_check(c->fd, c->dev, c->timeout,
+					 copy_msg_to_checker, c);
+		}
+		ping_timeout(&tsp);
+		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
+		ping_status = ct->state;
+		strlcpy(c->message, ct->message, sizeof(c->message));
+		pthread_mutex_unlock(&ct->lock);
+		if (ping_running(ct) &&
+		    (ping_status == PATH_PENDING || ping_status == PATH_UNCHECKED)) {
+			condlog(3, "%s: ping checker still running",
+				ping_devt(devt, sizeof(devt), ct));
+			ct->running = 1;
+			ping_status = PATH_PENDING;
+		}
+	}
+
+	return ping_status;
+}
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
deleted file mode 100644
index b4a5cb2..0000000
--- a/libmultipath/checkers/tur.c
+++ /dev/null
@@ -1,427 +0,0 @@
-/*
- * Some code borrowed from sg-utils.
- *
- * Copyright (c) 2004 Christophe Varoqui
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/ioctl.h>
-#include <sys/sysmacros.h>
-#include <errno.h>
-#include <sys/time.h>
-#include <pthread.h>
-
-#include "checkers.h"
-
-#include "../libmultipath/debug.h"
-#include "../libmultipath/sg_include.h"
-#include "../libmultipath/util.h"
-#include "../libmultipath/time-util.h"
-#include "../libmultipath/util.h"
-
-#define TUR_CMD_LEN 6
-#define HEAVY_CHECK_COUNT       10
-
-#define MSG_TUR_UP	"tur checker reports path is up"
-#define MSG_TUR_DOWN	"tur checker reports path is down"
-#define MSG_TUR_GHOST	"tur checker reports path is in standby state"
-#define MSG_TUR_RUNNING	"tur checker still running"
-#define MSG_TUR_TIMEOUT	"tur checker timed out"
-#define MSG_TUR_FAILED	"tur checker failed to initialize"
-
-struct tur_checker_context {
-	dev_t devt;
-	int state;
-	int running;
-	int fd;
-	unsigned int timeout;
-	time_t time;
-	pthread_t thread;
-	pthread_mutex_t lock;
-	pthread_cond_t active;
-	pthread_spinlock_t hldr_lock;
-	int holders;
-	char message[CHECKER_MSG_LEN];
-};
-
-static const char *tur_devt(char *devt_buf, int size,
-			    struct tur_checker_context *ct)
-{
-	dev_t devt;
-
-	pthread_mutex_lock(&ct->lock);
-	devt = ct->devt;
-	pthread_mutex_unlock(&ct->lock);
-
-	snprintf(devt_buf, size, "%d:%d", major(devt), minor(devt));
-	return devt_buf;
-}
-
-int libcheck_init (struct checker * c)
-{
-	struct tur_checker_context *ct;
-	pthread_mutexattr_t attr;
-
-	ct = malloc(sizeof(struct tur_checker_context));
-	if (!ct)
-		return 1;
-	memset(ct, 0, sizeof(struct tur_checker_context));
-
-	ct->state = PATH_UNCHECKED;
-	ct->fd = -1;
-	ct->holders = 1;
-	pthread_cond_init_mono(&ct->active);
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
-	pthread_mutex_init(&ct->lock, &attr);
-	pthread_mutexattr_destroy(&attr);
-	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
-	c->context = ct;
-
-	return 0;
-}
-
-static void cleanup_context(struct tur_checker_context *ct)
-{
-	pthread_mutex_destroy(&ct->lock);
-	pthread_cond_destroy(&ct->active);
-	pthread_spin_destroy(&ct->hldr_lock);
-	free(ct);
-}
-
-void libcheck_free (struct checker * c)
-{
-	if (c->context) {
-		struct tur_checker_context *ct = c->context;
-		int holders;
-		pthread_t thread;
-
-		pthread_spin_lock(&ct->hldr_lock);
-		ct->holders--;
-		holders = ct->holders;
-		thread = ct->thread;
-		pthread_spin_unlock(&ct->hldr_lock);
-		if (holders)
-			pthread_cancel(thread);
-		else
-			cleanup_context(ct);
-		c->context = NULL;
-	}
-	return;
-}
-
-void libcheck_repair (struct checker * c)
-{
-	return;
-}
-
-#define TUR_MSG(fmt, args...)					\
-	do {							\
-		char msg[CHECKER_MSG_LEN];			\
-								\
-		snprintf(msg, sizeof(msg), fmt, ##args);	\
-		copy_message(cb_arg, msg);			\
-	} while (0)
-
-static int
-tur_check(int fd, unsigned int timeout,
-	  void (*copy_message)(void *, const char *), void *cb_arg)
-{
-	struct sg_io_hdr io_hdr;
-	unsigned char turCmdBlk[TUR_CMD_LEN] = { 0x00, 0, 0, 0, 0, 0 };
-	unsigned char sense_buffer[32];
-	int retry_tur = 5;
-
-retry:
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
-		TUR_MSG(MSG_TUR_DOWN);
-		return PATH_DOWN;
-	}
-	if ((io_hdr.status & 0x7e) == 0x18) {
-		/*
-		 * SCSI-3 arrays might return
-		 * reservation conflict on TUR
-		 */
-		TUR_MSG(MSG_TUR_UP);
-		return PATH_UP;
-	}
-	if (io_hdr.info & SG_INFO_OK_MASK) {
-		int key = 0, asc, ascq;
-
-		switch (io_hdr.host_status) {
-		case DID_OK:
-		case DID_NO_CONNECT:
-		case DID_BAD_TARGET:
-		case DID_ABORT:
-		case DID_TRANSPORT_FAILFAST:
-			break;
-		default:
-			/* Driver error, retry */
-			if (--retry_tur)
-				goto retry;
-			break;
-		}
-		if (io_hdr.sb_len_wr > 3) {
-			if (io_hdr.sbp[0] == 0x72 || io_hdr.sbp[0] == 0x73) {
-				key = io_hdr.sbp[1] & 0x0f;
-				asc = io_hdr.sbp[2];
-				ascq = io_hdr.sbp[3];
-			} else if (io_hdr.sb_len_wr > 13 &&
-				   ((io_hdr.sbp[0] & 0x7f) == 0x70 ||
-				    (io_hdr.sbp[0] & 0x7f) == 0x71)) {
-				key = io_hdr.sbp[2] & 0x0f;
-				asc = io_hdr.sbp[12];
-				ascq = io_hdr.sbp[13];
-			}
-		}
-		if (key == 0x6) {
-			/* Unit Attention, retry */
-			if (--retry_tur)
-				goto retry;
-		}
-		else if (key == 0x2) {
-			/* Not Ready */
-			/* Note: Other ALUA states are either UP or DOWN */
-			if( asc == 0x04 && ascq == 0x0b){
-				/*
-				 * LOGICAL UNIT NOT ACCESSIBLE,
-				 * TARGET PORT IN STANDBY STATE
-				 */
-				TUR_MSG(MSG_TUR_GHOST);
-				return PATH_GHOST;
-			}
-		}
-		TUR_MSG(MSG_TUR_DOWN);
-		return PATH_DOWN;
-	}
-	TUR_MSG(MSG_TUR_UP);
-	return PATH_UP;
-}
-
-#define tur_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
-#define tur_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
-
-static void cleanup_func(void *data)
-{
-	int holders;
-	struct tur_checker_context *ct = data;
-	pthread_spin_lock(&ct->hldr_lock);
-	ct->holders--;
-	holders = ct->holders;
-	ct->thread = 0;
-	pthread_spin_unlock(&ct->hldr_lock);
-	if (!holders)
-		cleanup_context(ct);
-}
-
-static int tur_running(struct tur_checker_context *ct)
-{
-	pthread_t thread;
-
-	pthread_spin_lock(&ct->hldr_lock);
-	thread = ct->thread;
-	pthread_spin_unlock(&ct->hldr_lock);
-
-	return thread != 0;
-}
-
-static void copy_msg_to_tcc(void *ct_p, const char *msg)
-{
-	struct tur_checker_context *ct = ct_p;
-
-	pthread_mutex_lock(&ct->lock);
-	strlcpy(ct->message, msg, sizeof(ct->message));
-	pthread_mutex_unlock(&ct->lock);
-}
-
-static void *tur_thread(void *ctx)
-{
-	struct tur_checker_context *ct = ctx;
-	int state;
-	char devt[32];
-
-	condlog(3, "%s: tur checker starting up",
-		tur_devt(devt, sizeof(devt), ct));
-
-	/* This thread can be canceled, so setup clean up */
-	tur_thread_cleanup_push(ct);
-
-	/* TUR checker start up */
-	pthread_mutex_lock(&ct->lock);
-	ct->state = PATH_PENDING;
-	ct->message[0] = '\0';
-	pthread_mutex_unlock(&ct->lock);
-
-	state = tur_check(ct->fd, ct->timeout, copy_msg_to_tcc, ct->message);
-	pthread_testcancel();
-
-	/* TUR checker done */
-	pthread_mutex_lock(&ct->lock);
-	ct->state = state;
-	pthread_cond_signal(&ct->active);
-	pthread_mutex_unlock(&ct->lock);
-
-	condlog(3, "%s: tur checker finished, state %s",
-		tur_devt(devt, sizeof(devt), ct), checker_state_name(state));
-	tur_thread_cleanup_pop(ct);
-
-	return ((void *)0);
-}
-
-
-static void tur_timeout(struct timespec *tsp)
-{
-	clock_gettime(CLOCK_MONOTONIC, tsp);
-	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
-	normalize_timespec(tsp);
-}
-
-static void tur_set_async_timeout(struct checker *c)
-{
-	struct tur_checker_context *ct = c->context;
-	struct timespec now;
-
-	clock_gettime(CLOCK_MONOTONIC, &now);
-	ct->time = now.tv_sec + c->timeout;
-}
-
-static int tur_check_async_timeout(struct checker *c)
-{
-	struct tur_checker_context *ct = c->context;
-	struct timespec now;
-
-	clock_gettime(CLOCK_MONOTONIC, &now);
-	return (now.tv_sec > ct->time);
-}
-
-static void copy_msg_to_checker(void *c_p, const char *msg)
-{
-	struct checker *c = c_p;
-
-	strlcpy(c->message, msg, sizeof(c->message));
-}
-
-int libcheck_check(struct checker * c)
-{
-	struct tur_checker_context *ct = c->context;
-	struct timespec tsp;
-	struct stat sb;
-	pthread_attr_t attr;
-	int tur_status, r;
-	char devt[32];
-
-
-	if (!ct)
-		return PATH_UNCHECKED;
-
-	if (fstat(c->fd, &sb) == 0) {
-		pthread_mutex_lock(&ct->lock);
-		ct->devt = sb.st_rdev;
-		pthread_mutex_unlock(&ct->lock);
-	}
-
-	if (c->sync)
-		return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
-
-	/*
-	 * Async mode
-	 */
-	r = pthread_mutex_lock(&ct->lock);
-	if (r != 0) {
-		condlog(2, "%s: tur mutex lock failed with %d",
-			tur_devt(devt, sizeof(devt), ct), r);
-		MSG(c, MSG_TUR_FAILED);
-		return PATH_WILD;
-	}
-
-	if (ct->running) {
-		/*
-		 * Check if TUR checker is still running. Hold hldr_lock
-		 * around the pthread_cancel() call to avoid that
-		 * pthread_cancel() gets called after the (detached) TUR
-		 * thread has exited.
-		 */
-		pthread_spin_lock(&ct->hldr_lock);
-		if (ct->thread) {
-			if (tur_check_async_timeout(c)) {
-				condlog(3, "%s: tur checker timeout",
-					tur_devt(devt, sizeof(devt), ct));
-				pthread_cancel(ct->thread);
-				ct->running = 0;
-				MSG(c, MSG_TUR_TIMEOUT);
-				tur_status = PATH_TIMEOUT;
-			} else {
-				condlog(3, "%s: tur checker not finished",
-					tur_devt(devt, sizeof(devt), ct));
-				ct->running++;
-				tur_status = PATH_PENDING;
-			}
-		} else {
-			/* TUR checker done */
-			ct->running = 0;
-			tur_status = ct->state;
-			strlcpy(c->message, ct->message, sizeof(c->message));
-		}
-		pthread_spin_unlock(&ct->hldr_lock);
-		pthread_mutex_unlock(&ct->lock);
-	} else {
-		if (tur_running(ct)) {
-			/* pthread cancel failed. continue in sync mode */
-			pthread_mutex_unlock(&ct->lock);
-			condlog(3, "%s: tur thread not responding",
-				tur_devt(devt, sizeof(devt), ct));
-			return PATH_TIMEOUT;
-		}
-		/* Start new TUR checker */
-		ct->state = PATH_UNCHECKED;
-		ct->fd = c->fd;
-		ct->timeout = c->timeout;
-		pthread_spin_lock(&ct->hldr_lock);
-		ct->holders++;
-		pthread_spin_unlock(&ct->hldr_lock);
-		tur_set_async_timeout(c);
-		setup_thread_attr(&attr, 32 * 1024, 1);
-		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
-		pthread_attr_destroy(&attr);
-		if (r) {
-			pthread_spin_lock(&ct->hldr_lock);
-			ct->holders--;
-			pthread_spin_unlock(&ct->hldr_lock);
-			pthread_mutex_unlock(&ct->lock);
-			ct->thread = 0;
-			condlog(3, "%s: failed to start tur thread, using"
-				" sync mode", tur_devt(devt, sizeof(devt), ct));
-			return tur_check(c->fd, c->timeout,
-					 copy_msg_to_checker, c);
-		}
-		tur_timeout(&tsp);
-		r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
-		tur_status = ct->state;
-		strlcpy(c->message, ct->message, sizeof(c->message));
-		pthread_mutex_unlock(&ct->lock);
-		if (tur_running(ct) &&
-		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
-			condlog(3, "%s: tur checker still running",
-				tur_devt(devt, sizeof(devt), ct));
-			ct->running = 1;
-			tur_status = PATH_PENDING;
-		}
-	}
-
-	return tur_status;
-}
diff --git a/libmultipath/checkers/tur.h b/libmultipath/checkers/tur.h
deleted file mode 100644
index a2e8c88..0000000
--- a/libmultipath/checkers/tur.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _TUR_H
-#define _TUR_H
-
-int tur (struct checker *);
-int tur_init (struct checker *);
-void tur_free (struct checker *);
-
-#endif /* _TUR_H */
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index db2b756..9a65cec 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -32,7 +32,7 @@
 #define DEFAULT_UEV_WAIT_TIMEOUT 30
 #define DEFAULT_PRIO		PRIO_CONST
 #define DEFAULT_PRIO_ARGS	""
-#define DEFAULT_CHECKER		TUR
+#define DEFAULT_CHECKER		PING
 #define DEFAULT_FLUSH		FLUSH_DISABLED
 #define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
 #define DEFAULT_FORCE_SYNC	0
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 663c8ea..bae5d24 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1539,6 +1539,7 @@ get_state (struct path * pp, struct config *conf, int daemon)
 			return PATH_UNCHECKED;
 		}
 		checker_set_fd(c, pp->fd);
+               checker_set_dev(c, pp->dev);
 		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
 			memset(c, 0x0, sizeof(struct checker));
 			condlog(3, "%s: checker init failed", pp->dev);
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 390d143..9e8e9e3 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1081,7 +1081,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = FAILOVER,
 		.uid_attribute = "ID_SERIAL",
 		.selector      = "service-time 0",
-		.checker_name  = TUR,
+		.checker_name  = PING,
 		.alias_prefix  = "mpath",
 		.features      = "0",
 		.hwhandler     = "0",
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
index 8f633e0..21209ff 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -26,29 +26,11 @@
 #include "debug.h"
 #include "prio.h"
 #include "structs.h"
-#include <linux/types.h>
-#include <sys/ioctl.h>
-#include "../checkers/libsg.h"
+#include "libsg.h"
+#include "libnvme.h"
 
 #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
 
-struct nvme_user_io {
-    __u8 opcode;
-    __u8 flags;
-    __u16 control;
-    __u16 nblocks;
-    __u16 rsvd;
-    __u64 metadata;
-    __u64 addr;
-    __u64 slba;
-    __u32 dsmgmt;
-    __u32 reftag;
-    __u16 apptag;
-    __u16 appmask;
-};
-
-#define NVME_IOCTL_SUBMIT_IO _IOW('N', 0x42, struct nvme_user_io)
-
 #define MAX_IO_NUM              200
 #define MIN_IO_NUM              2
 
@@ -62,6 +44,8 @@ struct nvme_user_io {
 
 #define MAX_CHAR_SIZE           30
 
+#define SENSE_BUFF_LEN          32
+
 #define USEC_PER_SEC            1000000LL
 #define NSEC_PER_USEC           1000LL
 
@@ -72,34 +56,6 @@ static inline long long timeval_to_us(const struct timespec *tv)
     return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec / NSEC_PER_USEC);
 }
 
-int nvme_io(int fd, __u8 opcode, __u64 slba, __u16 nblocks, __u16 control,
-            __u32 dsmgmt, __u32 reftag, __u16 apptag, __u16 appmask, void *data, void *metadata)
-{
-    struct nvme_user_io io = {
-    .opcode = opcode,
-    .flags = 0,
-    .control = control,
-    .nblocks = nblocks,
-    .rsvd = 0,
-    .metadata = (__u64)(uintptr_t) metadata,
-    .addr = (__u64)(uintptr_t) data,
-    .slba = slba,
-    .dsmgmt = dsmgmt,
-    .reftag = reftag,
-    .appmask = apptag,
-    .apptag = appmask,
-    };
-
-    return ioctl(fd, NVME_IOCTL_SUBMIT_IO, &io);
-}
-
-int nvme_read(int fd, __u64 slba, __u16 nblocks, __u16 control, __u32 dsmgmt,
-            __u32 reftag, __u16 apptag, __u16 appmask, void *data, void *metadata)
-{
-    return nvme_io(fd, 0x2, slba, nblocks, control, dsmgmt,
-        reftag, apptag, appmask, data, metadata);
-}
-
 static int do_readsector0(struct path *pp, unsigned int timeout)
 {
     unsigned char buf[4096];
@@ -108,12 +64,12 @@ static int do_readsector0(struct path *pp, unsigned int timeout)
 
     if (!strncmp(pp->dev, "nvme", 4))
     {
-        if (nvme_read(pp->fd, 0, 1, 0, 0, 0, 0, 0, buf, mbuf) < 0)
+        if (nvme_read(pp->fd, 0, 1, 0, 0, 0, 0, 0, buf, mbuf) != 0)
             return 0;
     }
     else
     {
-        if (sg_read(pp->fd, &buf[0], 4096, &sbuf[0],SENSE_BUFF_LEN, timeout) == 2)
+        if (sg_read(pp->fd, &buf[0], 4096, &sbuf[0], SENSE_BUFF_LEN, timeout) == 2)
             return 0;
     }
 
@@ -300,7 +256,7 @@ int getprio (struct path *pp, char *args, unsigned int timeout)
     Warn the user if latency_interval is smaller than (2 * standard_deviation), or equal */
     standard_deviation = calc_standard_deviation(path_latency, index, avglatency);
     latency_interval = calc_latency_interval(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
-    if ((latency_interval != 0)
+    if ((latency_interval!= 0)
         && (latency_interval <= (2 * standard_deviation)))
         pp_pl_log(3, "%s: latency interval (%lld) according to average latency (%lld us) is smaller than "
             "2 * standard deviation (%lld us), or equal, args base_num (%d) needs to be set bigger value",
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 27f3951..d4c24de 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -316,7 +316,7 @@ int select_checker(struct config *conf, struct path *pp)
 	struct checker * c = &pp->checker;
 
 	if (pp->detect_checker == DETECT_CHECKER_ON && pp->tpgs > 0) {
-		checker_name = TUR;
+		checker_name = PING;
 		origin = "(setting: array autodetected)";
 		goto out;
 	}
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0049cba..915cc50 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -418,8 +418,8 @@ are:
 (Deprecated) Read the first sector of the device. This checker is being
 deprecated, please use \fItur\fR instead.
 .TP
-.I tur
-Issue a \fITEST UNIT READY\fR command to the device.
+.I ping
+Issue a \fITEST UNIT READY\fR command or a \fIKEEP ALIVE\fR command to the device.
 .TP
 .I emc_clariion
 (Hardware-dependent)
-- 
2.6.4.windows.1
