From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH v2] multipath-tools: intermittent IO error
	accounting to improve reliability
Date: Sat, 2 Sep 2017 19:04:07 +0800
Message-ID: <1504350247-12408-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: guanjunxiong@huawei.com, chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

This patch adds a new method of path state checking based on accounting
IO error. This is useful in many scenarios such as intermittent IO error
an a path due to network congestion, or a shaky link.

Three parameters are added for the admin: "path_io_err_sample_time",
"path_io_err_rate_threshold" and "path_io_err_recovery_time".
If path_io_err_sample_time and path_io_err_recovery_time are set to a
value greater than 0, when a path fail event occurs due to an IO error,
multipathd will enqueue this path into a queue of which each member is
sent a couple of continous direct reading asynchronous io at a fixed
sample rate of 10HZ. The IO accounting process for a path will last for
path_io_err_sample_time. If the IO error rate on a particular path is
greater than the path_io_err_rate_threshold, then the path will not
reinstate for recover_time seconds unless there is only one active path.

If recover_time expires, we will reschedule this IO error checking
process. If the path is good enough, we will claim it good.

This helps us place the path in delayed state if we hit a lot of
intermittent IO errors on a particular path due to network/target
issues and isolate such degraded path and allow the admin to rectify
the errors on a path.

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---


changes from V1:
* send continous IO instead of a single IO in a sample interval (Martin)
* when recover time expires, we reschedule the checking process (Hannes)
* Use the error rate threshold as a permillage instead of IO number(Martin)
* Use a common io_context for libaio for all paths (Martin)
* Other small fixes (Martin)



 libmultipath/Makefile      |   5 +-
 libmultipath/config.h      |   9 +
 libmultipath/configure.c   |   3 +
 libmultipath/dict.c        |  41 +++
 libmultipath/io_err_stat.c | 709 +++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/io_err_stat.h |  15 +
 libmultipath/propsel.c     |  53 ++++
 libmultipath/propsel.h     |   3 +
 libmultipath/structs.h     |   7 +
 libmultipath/uevent.c      |  36 ++-
 libmultipath/uevent.h      |   2 +
 multipath/multipath.conf.5 |  43 +++
 multipathd/main.c          |  56 ++++
 13 files changed, 978 insertions(+), 4 deletions(-)
 create mode 100644 libmultipath/io_err_stat.c
 create mode 100644 libmultipath/io_err_stat.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index b3244fc7..dce73afe 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -9,7 +9,7 @@ LIBS = $(DEVLIB).$(SONAME)
 
 CFLAGS += $(LIB_CFLAGS) -I$(mpathcmddir)
 
-LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu
+LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu -laio
 
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
@@ -42,7 +42,8 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
-	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
+	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o \
+	io_err_stat.o
 
 all: $(LIBS)
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ffc69b5f..215d29e9 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -75,6 +75,9 @@ struct hwentry {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_rate_threshold;
+	int path_io_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	char * bl_product;
@@ -106,6 +109,9 @@ struct mpentry {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_rate_threshold;
+	int path_io_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	uid_t uid;
@@ -155,6 +161,9 @@ struct config {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_rate_threshold;
+	int path_io_err_recovery_time;
 	int uxsock_timeout;
 	int strict_timing;
 	int retrigger_tries;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 74b6f52a..81dc97d9 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -298,6 +298,9 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_san_path_err_threshold(conf, mpp);
 	select_san_path_err_forget_rate(conf, mpp);
 	select_san_path_err_recovery_time(conf, mpp);
+	select_path_io_err_sample_time(conf, mpp);
+	select_path_io_err_rate_threshold(conf, mpp);
+	select_path_io_err_recovery_time(conf, mpp);
 	select_skip_kpartx(conf, mpp);
 	select_max_sectors_kb(conf, mpp);
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 9dc10904..18b1fdb1 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1108,6 +1108,35 @@ declare_hw_handler(san_path_err_recovery_time, set_off_int_undef)
 declare_hw_snprint(san_path_err_recovery_time, print_off_int_undef)
 declare_mp_handler(san_path_err_recovery_time, set_off_int_undef)
 declare_mp_snprint(san_path_err_recovery_time, print_off_int_undef)
+declare_def_handler(path_io_err_sample_time, set_off_int_undef)
+declare_def_snprint_defint(path_io_err_sample_time, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(path_io_err_sample_time, set_off_int_undef)
+declare_ovr_snprint(path_io_err_sample_time, print_off_int_undef)
+declare_hw_handler(path_io_err_sample_time, set_off_int_undef)
+declare_hw_snprint(path_io_err_sample_time, print_off_int_undef)
+declare_mp_handler(path_io_err_sample_time, set_off_int_undef)
+declare_mp_snprint(path_io_err_sample_time, print_off_int_undef)
+declare_def_handler(path_io_err_rate_threshold, set_off_int_undef)
+declare_def_snprint_defint(path_io_err_rate_threshold, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(path_io_err_rate_threshold, set_off_int_undef)
+declare_ovr_snprint(path_io_err_rate_threshold, print_off_int_undef)
+declare_hw_handler(path_io_err_rate_threshold, set_off_int_undef)
+declare_hw_snprint(path_io_err_rate_threshold, print_off_int_undef)
+declare_mp_handler(path_io_err_rate_threshold, set_off_int_undef)
+declare_mp_snprint(path_io_err_rate_threshold, print_off_int_undef)
+declare_def_handler(path_io_err_recovery_time, set_off_int_undef)
+declare_def_snprint_defint(path_io_err_recovery_time, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(path_io_err_recovery_time, set_off_int_undef)
+declare_ovr_snprint(path_io_err_recovery_time, print_off_int_undef)
+declare_hw_handler(path_io_err_recovery_time, set_off_int_undef)
+declare_hw_snprint(path_io_err_recovery_time, print_off_int_undef)
+declare_mp_handler(path_io_err_recovery_time, set_off_int_undef)
+declare_mp_snprint(path_io_err_recovery_time, print_off_int_undef)
+
+
 static int
 def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
@@ -1443,6 +1472,9 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_recovery_time);
+	install_keyword("path_io_err_sample_time", &def_path_io_err_sample_time_handler, &snprint_def_path_io_err_sample_time);
+	install_keyword("path_io_err_rate_threshold", &def_path_io_err_rate_threshold_handler, &snprint_def_path_io_err_rate_threshold);
+	install_keyword("path_io_err_recovery_time", &def_path_io_err_recovery_time_handler, &snprint_def_path_io_err_recovery_time);
 
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
@@ -1530,6 +1562,9 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
+	install_keyword("path_io_err_sample_time", &hw_path_io_err_sample_time_handler, &snprint_hw_path_io_err_sample_time);
+	install_keyword("path_io_err_rate_threshold", &hw_path_io_err_rate_threshold_handler, &snprint_hw_path_io_err_rate_threshold);
+	install_keyword("path_io_err_recovery_time", &hw_path_io_err_recovery_time_handler, &snprint_hw_path_io_err_recovery_time);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_sublevel_end();
@@ -1563,6 +1598,9 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_recovery_time);
+	install_keyword("path_io_err_sample_time", &ovr_path_io_err_sample_time_handler, &snprint_ovr_path_io_err_sample_time);
+	install_keyword("path_io_err_rate_threshold", &ovr_path_io_err_rate_threshold_handler, &snprint_ovr_path_io_err_rate_threshold);
+	install_keyword("path_io_err_recovery_time", &ovr_path_io_err_recovery_time_handler, &snprint_ovr_path_io_err_recovery_time);
 
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
@@ -1595,6 +1633,9 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &mp_san_path_err_threshold_handler, &snprint_mp_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &mp_san_path_err_forget_rate_handler, &snprint_mp_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_recovery_time);
+	install_keyword("path_io_err_sample_time", &mp_path_io_err_sample_time_handler, &snprint_mp_path_io_err_sample_time);
+	install_keyword("path_io_err_rate_threshold", &mp_path_io_err_rate_threshold_handler, &snprint_mp_path_io_err_rate_threshold);
+	install_keyword("path_io_err_recovery_time", &mp_path_io_err_recovery_time_handler, &snprint_mp_path_io_err_recovery_time);
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
 	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
 	install_sublevel_end();
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
new file mode 100644
index 00000000..ebd9a594
--- /dev/null
+++ b/libmultipath/io_err_stat.c
@@ -0,0 +1,709 @@
+/*
+ * (C) Copyright HUAWEI Technology Corp. 2017, All Rights Reserved.
+ *
+ * io_err_stat.c
+ * version 1.0
+ *
+ * IO error stream statistic process for path failure event from kernel
+ *
+ * Author(s): Guan Junxiong 2017 <guanjunxiong@huawei.com>
+ *
+ * This file is released under the GPL version 2, or any later version.
+ */
+
+#include <unistd.h>
+#include <pthread.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+#include <libaio.h>
+#include <errno.h>
+#include <sys/mman.h>
+
+#include "vector.h"
+#include "memory.h"
+#include "checkers.h"
+#include "config.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "devmapper.h"
+#include "debug.h"
+#include "lock.h"
+#include "time-util.h"
+#include "io_err_stat.h"
+
+#define IOTIMEOUT_SEC			60
+#define FLAKY_PATHFAIL_THRESHOLD	2
+#define FLAKY_PATHFAIL_TIME_FRAME	60
+#define CONCUR_NR_EVENT			32
+
+#define io_err_stat_log(prio, fmt, args...) \
+	condlog(prio, "io error statistic: " fmt, ##args)
+
+
+struct io_err_stat_pathvec {
+	pthread_mutex_t mutex;
+	vector		pathvec;
+};
+
+struct dio_ctx {
+	struct timespec	io_starttime;
+	int		blksize;
+	unsigned char	*buf;
+	unsigned char	*ptr;
+	struct iocb	io;
+};
+
+struct io_err_stat_path {
+	char		devname[FILE_NAME_SIZE];
+	int		fd;
+	struct dio_ctx	**dio_ctx_array;
+	int		io_err_nr;
+	int		io_nr;
+	struct timespec	start_time;
+
+	int		total_time;
+	int		err_rate_threshold;
+};
+
+pthread_t		io_err_stat_thr;
+pthread_attr_t		io_err_stat_attr;
+
+static struct io_err_stat_pathvec *paths;
+struct vectors *vecs;
+io_context_t	ioctx;
+
+static void cancel_inflight_io(struct io_err_stat_path *pp);
+
+static void rcu_unregister(void *param)
+{
+	rcu_unregister_thread();
+}
+
+struct io_err_stat_path *find_err_path_by_dev(vector pathvec, char *dev)
+{
+	int i;
+	struct io_err_stat_path *pp;
+
+	if (!pathvec)
+		return NULL;
+	vector_foreach_slot(pathvec, pp, i)
+		if (!strcmp(pp->devname, dev))
+			return pp;
+
+	io_err_stat_log(4, "%s: not found in check queue", dev);
+
+	return NULL;
+}
+
+static int init_each_dio_ctx(struct dio_ctx *ct, int blksize,
+		unsigned long pgsize, int key)
+{
+	ct->buf = (unsigned char *)MALLOC(blksize + pgsize);
+	if (!ct->buf)
+		return 1;
+	ct->ptr = (unsigned char *)(((unsigned long)ct->buf +
+				pgsize - 1) & (~(pgsize - 1)));
+	ct->io_starttime.tv_sec = 0;
+	ct->io_starttime.tv_nsec = 0;
+
+	ct->io.key = key;
+
+	return 0;
+}
+
+static void deinit_each_dio_ctx(struct dio_ctx *ct)
+{
+	if (ct->buf)
+		FREE(ct->buf);
+}
+
+static int setup_directio_ctx(struct io_err_stat_path *p, int idx)
+{
+	unsigned long pgsize = getpagesize();
+	char fpath[FILE_NAME_SIZE+6];
+	int blksize;
+	int i;
+	int base;
+
+	snprintf(fpath, FILE_NAME_SIZE, "/dev/%s", p->devname);
+	if (p->fd < 0)
+		p->fd = open(fpath, O_RDONLY | O_DIRECT);
+	if (p->fd < 0)
+		return 1;
+
+	p->dio_ctx_array = MALLOC(sizeof(struct dio_ctx) * CONCUR_NR_EVENT);
+	if (!p->dio_ctx_array)
+		goto fail_close;
+
+	if (ioctl(p->fd, BLKBSZGET, &blksize) < 0) {
+		io_err_stat_log(4, "%s:cannot get blocksize, set default 512",
+				p->devname);
+		blksize = 512;
+	}
+	/*
+	 * Sanity check for block size
+	 */
+	if (blksize > 4096)
+		blksize = 4096;
+	if (!blksize)
+		goto free_pdctx;
+
+	base = idx * CONCUR_NR_EVENT;
+	for (i=0; i < CONCUR_NR_EVENT; i++) {
+		if (init_each_dio_ctx(p->dio_ctx_array[i], blksize, pgsize,
+					base + i))
+			goto deinit;
+	}
+	return 0;
+
+deinit:
+	for (i=0; i < CONCUR_NR_EVENT; i++) {
+		deinit_each_dio_ctx(p->dio_ctx_array[i]);
+	}
+free_pdctx:
+	FREE(p->dio_ctx_array);
+fail_close:
+	close(p->fd);
+
+	return 1;
+}
+
+static void destroy_directio_ctx(struct io_err_stat_path *p)
+{
+	int i;
+
+	if (!p || !p->dio_ctx_array)
+		return;
+	cancel_inflight_io(p);
+
+	for (i=0; i < CONCUR_NR_EVENT; i++) {
+		deinit_each_dio_ctx(p->dio_ctx_array[i]);
+	}
+
+	FREE(p->dio_ctx_array);
+	if (p->fd > 0)
+		close(p->fd);
+}
+
+static struct io_err_stat_path *alloc_io_err_stat_path(void)
+{
+	struct io_err_stat_path *p;
+
+	p = (struct io_err_stat_path *)MALLOC(sizeof(*p));
+	if (!p)
+		return NULL;
+
+	memset(p->devname, 0, sizeof(p->devname));
+	p->io_err_nr = 0;
+	p->io_nr = 0;
+	p->total_time = 0;
+	p->start_time.tv_sec = 0;
+	p->start_time.tv_nsec = 0;
+	p->err_rate_threshold = 0;
+	p->fd = -1;
+
+	return p;
+}
+
+static void free_io_err_stat_path(struct io_err_stat_path *p)
+{
+	FREE(p);
+}
+
+static struct io_err_stat_pathvec *alloc_pathvec(void)
+{
+	struct io_err_stat_pathvec *p;
+	int r;
+
+	p = (struct io_err_stat_pathvec *)MALLOC(sizeof(*p));
+	if (!p)
+		return NULL;
+	p->pathvec = vector_alloc();
+	if (!p->pathvec)
+		goto out_free_struct_pathvec;
+	r = pthread_mutex_init(&p->mutex, NULL);
+	if (r)
+		goto out_free_member_pathvec;
+
+	return p;
+
+out_free_member_pathvec:
+	vector_free(p->pathvec);
+out_free_struct_pathvec:
+	FREE(p);
+	return NULL;
+}
+
+static void free_io_err_pathvec(struct io_err_stat_pathvec *p)
+{
+	struct io_err_stat_path *path;
+	int i;
+
+	if (!p)
+		return;
+	pthread_mutex_destroy(&p->mutex);
+	if (!p->pathvec) {
+		vector_foreach_slot(p->pathvec, path, i) {
+			destroy_directio_ctx(path);
+			free_io_err_stat_path(path);
+		}
+		vector_free(p->pathvec);
+	}
+	FREE(p);
+}
+
+/*
+ * return value
+ * 0: enqueue OK
+ * 1: fails because of internal error
+ * 2: fails because of existing already
+ */
+static int enqueue_io_err_stat_by_path(struct path *path)
+{
+	struct io_err_stat_path *p;
+	int v_size;
+
+	pthread_mutex_lock(&paths->mutex);
+	p = find_err_path_by_dev(paths->pathvec, path->dev);
+	if (p) {
+		pthread_mutex_unlock(&paths->mutex);
+		return 2;
+	}
+	v_size = VECTOR_SIZE(paths->pathvec);
+	pthread_mutex_unlock(&paths->mutex);
+
+	p = alloc_io_err_stat_path();
+	if (!p)
+		return 1;
+
+	memcpy(p->devname, path->dev, sizeof(p->devname));
+	p->total_time = path->mpp->path_io_err_sample_time;
+	p->err_rate_threshold = path->mpp->path_io_err_rate_threshold;
+
+	if (setup_directio_ctx(p, v_size))
+		goto free_ioerr_path;
+	pthread_mutex_lock(&paths->mutex);
+	if (!vector_alloc_slot(paths->pathvec))
+		goto unlock_destroy;
+	vector_set_slot(paths->pathvec, p);
+	pthread_mutex_unlock(&paths->mutex);
+
+	io_err_stat_log(2, "%s: enqueue path %s to check",
+			path->mpp->alias, path->dev);
+	return 0;
+
+unlock_destroy:
+	pthread_mutex_unlock(&paths->mutex);
+	destroy_directio_ctx(p);
+free_ioerr_path:
+	free_io_err_stat_path(p);
+
+	return 1;
+}
+
+int io_err_stat_handle_pathfail(struct path *path)
+{
+	struct timespec curr_time;
+
+	if (path->io_err_disable_reinstate) {
+		io_err_stat_log(3, "%s: reinstate is already disabled",
+				path->dev);
+		return 1;
+	}
+	if (path->io_err_pathfail_cnt == -1) {
+		return 1;
+	}
+
+	if (!path->mpp)
+		return 1;
+	if (path->mpp->path_io_err_sample_time <= 0 ||
+		path->mpp->path_io_err_recovery_time <= 0 ||
+		path->mpp->path_io_err_rate_threshold < 0) {
+		io_err_stat_log(4, "%s: parameter not set", path->mpp->alias);
+	}
+
+	/*
+	 * The test should only be started for paths that have failed
+	 * repeatedly in a certain time frame, so that we have reason
+	 * to assume they're flaky. Without bother the admin to configure
+	 * the repeated count threshold and time frame, we assume a path
+	 * which fails at least twice within 60 seconds is flaky.
+	 */
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return 1;
+	if(path->io_err_pathfail_cnt == 0) {
+		path->io_err_pathfail_cnt++;
+		path->io_err_pathfail_starttime = curr_time.tv_sec;
+		io_err_stat_log(5, "%s: start path flakiness pre-check",
+				path->dev);
+		return 0;
+	}
+	if ((curr_time.tv_sec - path->io_err_pathfail_cnt) >
+			FLAKY_PATHFAIL_TIME_FRAME) {
+		path->io_err_pathfail_cnt = 0;
+		io_err_stat_log(5, "%s: reset path flakiness pre-check",
+				path->dev);
+		return 0;
+	}
+	path->io_err_pathfail_cnt++;
+	if (path->io_err_pathfail_cnt >= FLAKY_PATHFAIL_THRESHOLD) {
+		path->io_err_pathfail_cnt = -1;
+		return enqueue_io_err_stat_by_path(path);
+	}
+
+	return 0;
+}
+
+int hit_io_err_recovery_time(struct path *pp)
+{
+	struct timespec curr_time;
+	int r;
+
+	if (pp->io_err_disable_reinstate == 0)
+		return 1;
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return 1;
+	if (pp->mpp->nr_active <= 0) {
+		io_err_stat_log(2, "%s: recover path early", pp->dev);
+		goto recover;
+	}
+	if ((curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
+			pp->mpp->path_io_err_recovery_time) {
+		io_err_stat_log(2, "%s: recover path after %d seconds",
+				pp->dev, pp->mpp->path_io_err_sample_time);
+		/*
+		 * to reschedule io error checking again
+		 * if the path is good enough, we claim it is good
+		 * and can be reinsated as soon as possible in the
+		 * check_path routine.
+		 */
+		pp->io_err_pathfail_cnt = -1;
+		pp->io_err_disable_reinstate = curr_time.tv_sec;
+		r = enqueue_io_err_stat_by_path(pp);
+		/*
+		 * Enqueue fails because of internel error.
+		 * In this case , we recover this path
+		 * Or else,  return 1 to set path state to PATH_DELAYED
+		 */
+		if (r == 1)
+			goto recover;
+	}
+
+	return 1;
+
+recover:
+	pp->io_err_pathfail_cnt = 0;
+	pp->io_err_disable_reinstate = 0;
+	pp->tick = 1;
+	return 0;
+}
+
+static int delete_io_err_stat_by_addr(struct io_err_stat_path *p)
+{
+	int i;
+
+	i = find_slot(paths->pathvec, p);
+	if (i != -1)
+		vector_del_slot(paths->pathvec, i);
+
+	destroy_directio_ctx(p);
+	free_io_err_stat_path(p);
+
+	return 0;
+}
+
+static void account_async_io_state(struct io_err_stat_path *pp, int rc)
+{
+	switch (rc) {
+	case PATH_DOWN:
+	case PATH_TIMEOUT:
+		pp->io_err_nr++;
+		break;
+	case PATH_UNCHECKED:
+	case PATH_UP:
+	case PATH_PENDING:
+		break;
+	default:
+		break;
+	}
+}
+
+static int poll_io_err_stat(struct vectors *vecs, struct io_err_stat_path *pp)
+{
+	struct timespec currtime, difftime;
+	struct path *path;
+	double err_rate;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &currtime) != 0)
+		return 1;
+	timespecsub(&currtime, &pp->start_time, &difftime);
+	if (difftime.tv_sec < pp->total_time)
+		return 0;
+
+	io_err_stat_log(4, "check end for %s", pp->devname);
+
+	err_rate = pp->io_nr == 0 ? 0: (pp->io_err_nr * 1000.0f) / pp->io_nr;
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
+	path = find_path_by_dev(vecs->pathvec, pp->devname);
+
+	if (!path) {
+		io_err_stat_log(4, "path %s not found'", pp->devname);
+	} else if ( err_rate <= pp->err_rate_threshold) {
+		io_err_stat_log(4, "%s: (%d/%d) not hit threshold",
+				pp->devname, pp->io_err_nr, pp->io_nr);
+	} else if (path->mpp && path->mpp->nr_active > 1) {
+		dm_fail_path(path->mpp->alias, path->dev_t);
+		update_queue_mode_del_path(path->mpp);
+		io_err_stat_log(2, "%s: proactively fail dm path %s",
+				path->mpp->alias, path->dev);
+		path->io_err_disable_reinstate = 1;
+		path->io_err_dis_reinstate_time = currtime.tv_sec;
+		io_err_stat_log(3, "%s: to disable %s reinstate",
+				path->mpp->alias, path->dev);
+
+		/*
+		 * schedule path check as soon as possible to
+		 * update path state to delayed state
+		 */
+		path->tick = 1;
+	} else {
+		io_err_stat_log(4, "%s: do nothing", pp->devname);
+	}
+	lock_cleanup_pop(vecs->lock);
+
+	delete_io_err_stat_by_addr(pp);
+
+	return 0;
+}
+
+static int send_each_aync_io(struct dio_ctx *ct, int fd, char *dev)
+{
+	int rc = -1;
+
+	if (ct->io_starttime.tv_nsec == 0 &&
+			ct->io_starttime.tv_sec == 0) {
+		struct iocb *ios[1] = { &ct->io };
+
+		if (clock_gettime(CLOCK_MONOTONIC, &ct->io_starttime) != 0) {
+			ct->io_starttime.tv_sec = 0;
+			ct->io_starttime.tv_nsec = 0;
+			return rc;
+		}
+		memset(&ct->io, 0, sizeof(struct iocb));
+		io_prep_pread(&ct->io, fd, ct->ptr, ct->blksize, 0);
+		if (io_submit(ioctx, 1, ios) != 1) {
+			io_err_stat_log(5, "%s: io_submit error %i",
+					dev, errno);
+			return rc;
+		}
+	}
+	rc = 0;
+
+	return rc;
+}
+
+static void send_batch_async_ios(struct io_err_stat_path *pp)
+{
+	int i;
+	struct dio_ctx *ct;
+
+	for (i = 0; i < CONCUR_NR_EVENT; i++) {
+		ct = pp->dio_ctx_array[i];
+		if(!send_each_aync_io(ct, pp->fd, pp->devname))
+			pp->io_nr ++;
+	}
+	if (pp->start_time.tv_sec == 0 && pp->start_time.tv_nsec == 0 &&
+		clock_gettime(CLOCK_MONOTONIC, &pp->start_time)) {
+		pp->start_time.tv_sec = 0;
+		pp->start_time.tv_nsec = 0;
+	}
+
+	return;
+}
+
+static int try_to_cancel_timeout_io(struct dio_ctx *ct, struct timespec *t,
+		char *dev)
+{
+	struct timespec	difftime;
+	struct io_event	event;
+	int		rc = PATH_UNCHECKED;
+	int		r;
+
+	timespecsub(t, &ct->io_starttime, &difftime);
+	if (difftime.tv_sec > IOTIMEOUT_SEC) {
+		struct iocb *ios[1] = { &ct->io };
+
+		io_err_stat_log(5, "%s: abort check on timeout", dev);
+		r = io_cancel(ioctx, ios[0], &event);
+		if (r) {
+			io_err_stat_log(5, "%s: io_cancel error %i",
+					dev, errno);
+		}
+		else{
+			ct->io_starttime.tv_sec = 0;
+			ct->io_starttime.tv_nsec = 0;
+		}
+		rc = PATH_TIMEOUT;
+	} else {
+		rc = PATH_PENDING;
+	}
+
+	return rc;
+}
+
+static void handle_async_io_timeout(void)
+{
+	struct io_err_stat_path *pp;
+	struct timespec curr_time;
+	int		rc = PATH_UNCHECKED;
+	int		i, j;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0) {
+		return;
+	}
+	vector_foreach_slot(paths->pathvec, pp, i) {
+		for (j = 0; j < CONCUR_NR_EVENT; j++) {
+			rc = try_to_cancel_timeout_io(pp->dio_ctx_array[j],
+					&curr_time, pp->devname);
+			account_async_io_state(pp, rc);
+		}
+	}
+}
+
+static void cancel_inflight_io(struct io_err_stat_path *pp)
+{
+	struct io_event event;
+	int i, r;
+
+	for (i = 0; i < CONCUR_NR_EVENT; i++) {
+		struct dio_ctx *ct = pp->dio_ctx_array[i];
+		struct iocb *ios[1] = { &ct->io };
+
+		if (ct->io_starttime.tv_sec == 0
+				&& ct->io_starttime.tv_nsec == 0)
+			continue;
+		io_err_stat_log(5, "%s: abort infligh io",
+				pp->devname);
+		r = io_cancel(ioctx, ios[0], &event);
+		if (r)
+			io_err_stat_log(5, "%s: io_cancel error %i",
+					pp->devname, errno);
+		else{
+			ct->io_starttime.tv_sec = 0;
+			ct->io_starttime.tv_nsec = 0;
+		}
+	}
+}
+
+static inline int handle_done_dio_ctx(struct dio_ctx *ct, struct io_event *ev)
+{
+	ct->io_starttime.tv_sec = 0;
+	ct->io_starttime.tv_nsec = 0;
+	return (ev->res == ct->blksize) ? PATH_UP : PATH_DOWN;
+}
+
+static void handle_async_io_done_event(struct io_event *io_evt)
+{
+	struct	io_err_stat_path *pp;
+	struct	dio_ctx *ct;
+	int	rc = PATH_UNCHECKED;
+	int	i, j;
+
+	vector_foreach_slot(paths->pathvec, pp, i) {
+		for (j = 0; j < CONCUR_NR_EVENT; j++) {
+			ct = pp->dio_ctx_array[j];
+			if (ct->io.key == io_evt->obj->key) {
+				rc = handle_done_dio_ctx(ct, io_evt);
+				account_async_io_state(pp, rc);
+			}
+		}
+	}
+}
+
+static void process_async_ios_event(int timeout_secs, char *dev)
+{
+	struct io_event events[CONCUR_NR_EVENT];
+	int		i, n;
+	struct timespec	timeout = { .tv_sec = timeout_secs };
+
+	errno = 0;
+	n = io_getevents(ioctx, 1L, CONCUR_NR_EVENT, events, &timeout);
+	if (n < 0) {
+		io_err_stat_log(3, "%s: async io events returned %d (errno=%s)",
+				dev, n, strerror(errno));
+	} else if (n == 0L) {
+		handle_async_io_timeout();
+	} else {
+		for (i = 0; i < n; i++)
+			handle_async_io_done_event(&events[i]);
+	}
+}
+
+static void service_paths(void)
+{
+	struct io_err_stat_path *pp;
+	int i;
+
+	pthread_mutex_lock(&paths->mutex);
+	vector_foreach_slot(paths->pathvec, pp, i) {
+		send_batch_async_ios(pp);
+		process_async_ios_event(IOTIMEOUT_SEC, pp->devname);
+		poll_io_err_stat(vecs, pp);
+	}
+	pthread_mutex_unlock(&paths->mutex);
+}
+
+static void *io_err_stat_loop(void *data)
+{
+	vecs = (struct vectors *)data;
+	pthread_cleanup_push(rcu_unregister, NULL);
+	rcu_register_thread();
+
+	mlockall(MCL_CURRENT | MCL_FUTURE);
+	while (1) {
+		service_paths();
+		usleep(100000);
+	}
+
+	pthread_cleanup_pop(1);
+	return NULL;
+}
+
+int start_io_err_stat_thread(void *data)
+{
+	if (io_setup(CONCUR_NR_EVENT, &ioctx) != 0) {
+		io_err_stat_log(4, "io_setup failed");
+		return 1;
+	}
+	paths = alloc_pathvec();
+	if (!paths)
+		goto destroy_ctx;
+
+	if (pthread_create(&io_err_stat_thr, &io_err_stat_attr,
+				io_err_stat_loop, data)) {
+		io_err_stat_log(0, "cannot create io_error statistic thread");
+		goto out_free;
+	}
+	io_err_stat_log(3, "thread started");
+	return 0;
+
+out_free:
+	free_io_err_pathvec(paths);
+destroy_ctx:
+	io_destroy(ioctx);
+	io_err_stat_log(0, "failed to start io_error statistic thread");
+	return 1;
+}
+
+void stop_io_err_stat_thread(void)
+{
+	pthread_cancel(io_err_stat_thr);
+	pthread_kill(io_err_stat_thr, SIGUSR2);
+	free_io_err_pathvec(paths);
+	io_destroy(ioctx);
+}
diff --git a/libmultipath/io_err_stat.h b/libmultipath/io_err_stat.h
new file mode 100644
index 00000000..97685617
--- /dev/null
+++ b/libmultipath/io_err_stat.h
@@ -0,0 +1,15 @@
+#ifndef _IO_ERR_STAT_H
+#define _IO_ERR_STAT_H
+
+#include "vector.h"
+#include "lock.h"
+
+
+extern pthread_attr_t io_err_stat_attr;
+
+int start_io_err_stat_thread(void *data);
+void stop_io_err_stat_thread(void);
+int io_err_stat_handle_pathfail(struct path *path);
+int hit_io_err_recovery_time(struct path *pp);
+
+#endif /* _IO_ERR_STAT_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 175fbe11..9d2c3c09 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -731,6 +731,7 @@ out:
 	return 0;
 
 }
+
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
@@ -761,6 +762,7 @@ out:
 	return 0;
 
 }
+
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp)
 {
 	char *origin, buff[12];
@@ -776,6 +778,57 @@ out:
 	return 0;
 
 }
+
+int select_path_io_err_sample_time(struct config *conf, struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(path_io_err_sample_time);
+	mp_set_ovr(path_io_err_sample_time);
+	mp_set_hwe(path_io_err_sample_time);
+	mp_set_conf(path_io_err_sample_time);
+	mp_set_default(path_io_err_sample_time, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->path_io_err_sample_time);
+	condlog(3, "%s: path_io_err_sample_time = %s %s", mp->alias, buff,
+			origin);
+	return 0;
+}
+
+int select_path_io_err_rate_threshold(struct config *conf, struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(path_io_err_rate_threshold);
+	mp_set_ovr(path_io_err_rate_threshold);
+	mp_set_hwe(path_io_err_rate_threshold);
+	mp_set_conf(path_io_err_rate_threshold);
+	mp_set_default(path_io_err_rate_threshold, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->path_io_err_rate_threshold);
+	condlog(3, "%s: path_io_err_rate_threshold = %s %s", mp->alias, buff,
+			origin);
+	return 0;
+
+}
+
+int select_path_io_err_recovery_time(struct config *conf, struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(path_io_err_recovery_time);
+	mp_set_ovr(path_io_err_recovery_time);
+	mp_set_hwe(path_io_err_recovery_time);
+	mp_set_conf(path_io_err_recovery_time);
+	mp_set_default(path_io_err_recovery_time, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->path_io_err_recovery_time);
+	condlog(3, "%s: path_io_err_recovery_time = %s %s", mp->alias, buff,
+			origin);
+	return 0;
+
+}
+
 int select_skip_kpartx (struct config *conf, struct multipath * mp)
 {
 	char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index f8e96d85..1b2b5714 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -28,6 +28,9 @@ int select_max_sectors_kb (struct config *conf, struct multipath * mp);
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp);
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp);
+int select_path_io_err_sample_time(struct config *conf, struct multipath *mp);
+int select_path_io_err_rate_threshold(struct config *conf, struct multipath *mp);
+int select_path_io_err_recovery_time(struct config *conf, struct multipath *mp);
 void reconcile_features_with_options(const char *id, char **features,
 				     int* no_path_retry,
 				     int *retain_hwhandler);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 8ea984d9..1ab8cb9b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -235,6 +235,10 @@ struct path {
 	time_t dis_reinstate_time;
 	int disable_reinstate;
 	int san_path_err_forget_rate;
+	time_t io_err_dis_reinstate_time;
+	int io_err_disable_reinstate;
+	int io_err_pathfail_cnt;
+	int io_err_pathfail_starttime;
 	/* configlet pointers */
 	struct hwentry * hwe;
 };
@@ -269,6 +273,9 @@ struct multipath {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_rate_threshold;
+	int path_io_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	int force_readonly;
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index eb44da56..56de1320 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -904,8 +904,8 @@ char *uevent_get_dm_name(struct uevent *uev)
 	int i;
 
 	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DM_NAME", 6) &&
-		    strlen(uev->envp[i]) > 7) {
+		if (!strncmp(uev->envp[i], "DM_NAME", 7) &&
+		    strlen(uev->envp[i]) > 8) {
 			p = MALLOC(strlen(uev->envp[i] + 8) + 1);
 			strcpy(p, uev->envp[i] + 8);
 			break;
@@ -913,3 +913,35 @@ char *uevent_get_dm_name(struct uevent *uev)
 	}
 	return p;
 }
+
+char *uevent_get_dm_path(struct uevent *uev)
+{
+	char *p = NULL;
+	int i;
+
+	for (i = 0; uev->envp[i] != NULL; i++) {
+		if (!strncmp(uev->envp[i], "DM_PATH", 7) &&
+		    strlen(uev->envp[i]) > 8) {
+			p = MALLOC(strlen(uev->envp[i] + 8) + 1);
+			strcpy(p, uev->envp[i] + 8);
+			break;
+		}
+	}
+	return p;
+}
+
+char *uevent_get_dm_action(struct uevent *uev)
+{
+	char *p = NULL;
+	int i;
+
+	for (i = 0; uev->envp[i] != NULL; i++) {
+		if (!strncmp(uev->envp[i], "DM_ACTION", 9) &&
+		    strlen(uev->envp[i]) > 10) {
+			p = MALLOC(strlen(uev->envp[i] + 10) + 1);
+			strcpy(p, uev->envp[i] + 10);
+			break;
+		}
+	}
+	return p;
+}
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 61a42071..6f5af0af 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -37,5 +37,7 @@ int uevent_get_major(struct uevent *uev);
 int uevent_get_minor(struct uevent *uev);
 int uevent_get_disk_ro(struct uevent *uev);
 char *uevent_get_dm_name(struct uevent *uev);
+char *uevent_get_dm_path(struct uevent *uev);
+char *uevent_get_dm_action(struct uevent *uev);
 
 #endif /* _UEVENT_H */
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index d9ac279f..51490e33 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -849,6 +849,49 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B path_io_err_sample_time
+One of the three parameters of supporting path check based on accounting IO
+error such as intermittent error. If it is set to a value greater than 0,
+when a path fail event occurs due to an IO error, multipathd will enqueue this
+path into a queue of which members are sent a couple of continous direct
+reading aio at a fixed sample rate of 10HZ. The IO accounting process for a
+path will last for \fIpath_io_err_sample_time\fR. If the rate of IO error on
+a particular path is greater than the \fIpath_io_err_rate_threshold\fR, then
+the path will not reinstate for \fIpath_io_err_rate_threshold\fR seconds unless
+there is only one active path.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B path_io_err_rate_threshold
+The error rate threshold as a permillage (1/1000). One of the three parameters
+of supporting path check based on accounting IO error such as intermittent
+error. Refer to \fIpath_io_err_sample_time\fR. If the rate of IO errors on a
+particular path is greater than this parameter, then the path will not
+reinstate for \fIpath_io_err_rate_threshold\fR seconds unless there is only one
+active path.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B path_io_err_recovery_time
+One of the three parameters of supporting path check based on accounting IO
+error such as intermittent error. Refer to \fIpath_io_err_sample_time\fR. If
+this parameter is set to a positive value, the path which has many error will
+not reinsate till \fIpath_io_err_recovery_time\fR seconds.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
 .B delay_watch_checks
 If set to a value greater than 0, multipathd will watch paths that have
 recently become valid for this many checks. If they fail again while they are
diff --git a/multipathd/main.c b/multipathd/main.c
index 4be2c579..5758cdd1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -84,6 +84,7 @@ int uxsock_timeout;
 #include "cli_handlers.h"
 #include "lock.h"
 #include "waiter.h"
+#include "io_err_stat.h"
 #include "wwids.h"
 #include "../third-party/valgrind/drd.h"
 
@@ -1050,6 +1051,41 @@ out:
 }
 
 static int
+uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
+{
+	char *action = NULL, *devt = NULL;
+	struct path *pp;
+	int r;
+
+	action = uevent_get_dm_action(uev);
+	if (!action)
+		return 1;
+	if (strncmp(action, "PATH_FAILED", 11))
+		goto out;
+	devt = uevent_get_dm_path(uev);
+	if (!devt) {
+		condlog(3, "%s: No DM_PATH in uevent", uev->kernel);
+		goto out;
+	}
+
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
+	pp = find_path_by_devt(vecs->pathvec, devt);
+	r = io_err_stat_handle_pathfail(pp);
+	lock_cleanup_pop(vecs->lock);
+
+	if (r)
+		condlog(3, "io_err_stat: fails to enqueue %s", pp->dev);
+	FREE(devt);
+	FREE(action);
+	return 0;
+out:
+	FREE(action);
+	return 1;
+}
+
+static int
 map_discovery (struct vectors * vecs)
 {
 	struct multipath * mpp;
@@ -1134,6 +1170,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	if (!strncmp(uev->kernel, "dm-", 3)) {
 		if (!strncmp(uev->action, "change", 6)) {
 			r = uev_add_map(uev, vecs);
+			uev_pathfail_check(uev, vecs);
 			goto out;
 		}
 		if (!strncmp(uev->action, "remove", 6)) {
@@ -1553,6 +1590,7 @@ static int check_path_reinstate_state(struct path * pp) {
 		condlog(2, "%s : hit error threshold. Delaying path reinstatement", pp->dev);
 		pp->dis_reinstate_time = curr_time.tv_sec;
 		pp->disable_reinstate = 1;
+
 		return 1;
 	} else {
 		return 0;
@@ -1684,6 +1722,16 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		return 1;
 	}
 
+	if (pp->io_err_disable_reinstate && hit_io_err_recovery_time(pp)) {
+		pp->state = PATH_DELAYED;
+		/*
+		 * to reschedule as soon as possible,so that this path can
+		 * be recoverd in time
+		 */
+		pp->tick = 1;
+		return 1;
+	}
+
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	     pp->wait_checks > 0) {
 		if (pp->mpp->nr_active > 0) {
@@ -2377,6 +2425,7 @@ child (void * param)
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
+	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 1);
 
 	if (logsink == 1) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
@@ -2499,6 +2548,10 @@ child (void * param)
 	/*
 	 * start threads
 	 */
+	rc = start_io_err_stat_thread(vecs);
+	if (rc)
+		goto failed;
+
 	if ((rc = pthread_create(&check_thr, &misc_attr, checkerloop, vecs))) {
 		condlog(0,"failed to create checker loop thread: %d", rc);
 		goto failed;
@@ -2548,6 +2601,8 @@ child (void * param)
 	remove_maps_and_stop_waiters(vecs);
 	unlock(&vecs->lock);
 
+	stop_io_err_stat_thread();
+
 	pthread_cancel(check_thr);
 	pthread_cancel(uevent_thr);
 	pthread_cancel(uxlsnr_thr);
@@ -2593,6 +2648,7 @@ child (void * param)
 	udev_unref(udev);
 	udev = NULL;
 	pthread_attr_destroy(&waiter_attr);
+	pthread_attr_destroy(&io_err_stat_attr);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.11.1
