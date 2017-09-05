From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH 1/3] multipath-tools: use direct IO for path
	latency prioritizer
Date: Tue, 5 Sep 2017 21:45:03 +0800
Message-ID: <1504619105-14788-2-git-send-email-guanjunxiong@huawei.com>
References: <1504619105-14788-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1504619105-14788-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: guanjunxiong@huawei.com, philip.yang@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com, chengjike.cheng@huawei.com
List-Id: dm-devel.ids

The SCSI-to-NVMe translations which was blamed broken has been removed
since linux kernel 4.13, so that SG_IO IOCTL used in the reading is not
supported. Instead, this patch drops sg_read method and uses direct IO
reading both for NVMe device and SCSI device.

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/prioritizers/path_latency.c | 85 +++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 7 deletions(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index 9fc2dfc0..c75ae03f 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -19,15 +19,19 @@
  * This file is released under the GPL version 2, or any later version.
  */
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <math.h>
 #include <ctype.h>
 #include <time.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+#include <unistd.h>
 
 #include "debug.h"
 #include "prio.h"
 #include "structs.h"
-#include "../checkers/libsg.h"
 
 #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
 
@@ -47,6 +51,8 @@
 #define USEC_PER_SEC		1000000LL
 #define NSEC_PER_USEC		1000LL
 
+#define DEF_BLK_SIZE		4096
+
 static long long path_latency[MAX_IO_NUM];
 
 static inline long long timeval_to_us(const struct timespec *tv)
@@ -55,15 +61,72 @@ static inline long long timeval_to_us(const struct timespec *tv)
 	    (tv->tv_nsec / NSEC_PER_USEC);
 }
 
-static int do_readsector0(int fd, unsigned int timeout)
+static int prepare_directio_read(int fd, int *blksz, char **pbuf,
+		int *restore_flags)
+{
+	unsigned long pgsize = getpagesize();
+	long flags;
+
+	if (ioctl(fd, BLKBSZGET, blksz) < 0) {
+		pp_pl_log(3,"catnnot get blocksize, set default");
+		*blksz = DEF_BLK_SIZE;
+	}
+	if (posix_memalign((void **)pbuf, pgsize, *blksz))
+		return -1;
+
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0)
+		goto free_out;
+	if (!(flags & O_DIRECT)) {
+		flags |= O_DIRECT;
+		if (fcntl(fd, F_SETFL, flags) < 0)
+			goto free_out;
+		*restore_flags = 1;
+	}
+
+	return 0;
+
+free_out:
+	free(*pbuf);
+
+	return -1;
+}
+
+static void cleanup_directio_read(int fd, char *buf, int restore_flags)
 {
-	unsigned char buf[4096];
-	unsigned char sbuf[SENSE_BUFF_LEN];
+	long flags;
+
+	free(buf);
+
+	if (!restore_flags)
+		return;
+	if ((flags = fcntl(fd, F_GETFL)) >= 0) {
+		int ret __attribute__ ((unused));
+		flags &= ~O_DIRECT;
+		/* No point in checking for errors */
+		ret = fcntl(fd, F_SETFL, flags);
+	}
+}
+
+static int do_directio_read(int fd, unsigned int timeout, char *buf, int sz)
+{
+	fd_set read_fds;
+	struct timeval tm = { .tv_sec = timeout };
 	int ret;
+	int num_read;
 
-	ret = sg_read(fd, &buf[0], 4096, &sbuf[0], SENSE_BUFF_LEN, timeout);
+	if (lseek(fd, 0, SEEK_SET) == -1)
+		return -1;
+	FD_ZERO(&read_fds);
+	FD_SET(fd, &read_fds);
+	ret = select(fd+1, &read_fds, NULL, NULL, &tm);
+	if (ret <= 0)
+		return -1;
+	num_read = read(fd, buf, sz);
+	if (num_read != sz)
+		return -1;
 
-	return ret;
+	return 0;
 }
 
 int check_args_valid(int io_num, int base_num)
@@ -194,6 +257,9 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 	long long toldelay = 0;
 	long long before, after;
 	struct timespec tv;
+	int blksize;
+	char *buf;
+	int restore_flags = 0;
 
 	if (pp->fd < 0)
 		return -1;
@@ -205,13 +271,16 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 
 	memset(path_latency, 0, sizeof(path_latency));
 
+	prepare_directio_read(pp->fd, &blksize, &buf, &restore_flags);
+
 	temp = io_num;
 	while (temp-- > 0) {
 		(void)clock_gettime(CLOCK_MONOTONIC, &tv);
 		before = timeval_to_us(&tv);
 
-		if (do_readsector0(pp->fd, timeout) == 2) {
+		if (do_directio_read(pp->fd, timeout, buf, blksize)) {
 			pp_pl_log(0, "%s: path down", pp->dev);
+			cleanup_directio_read(pp->fd, buf, restore_flags);
 			return -1;
 		}
 
@@ -222,6 +291,8 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 		toldelay += path_latency[index++];
 	}
 
+	cleanup_directio_read(pp->fd, buf, restore_flags);
+
 	avglatency = toldelay / (long long)io_num;
 	pp_pl_log(4, "%s: average latency is (%lld us)", pp->dev, avglatency);
 
-- 
2.11.1
