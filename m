From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH] multipath-tools: intermittent IO error
	accounting to improve reliability
Date: Tue, 22 Aug 2017 18:07:59 +0800
Message-ID: <1503396479-12692-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: guanjunxiong@huawei.com, chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

This patch adds a new method of path state checking based on accounting
IO error. This is useful in many scenarios such as intermittent IO error
an a path due to network congestion, or a shaky link.

Three parameters are added for the admin: "path_io_err_sample_time",
"path_io_err_num_threshold" and "path_io_err_recovery_time".
If path_io_err_sample_time and path_io_err_recovery_time are set to a
value greater than 0, when a path fail event occurs due to an IO error,
multipathd will enqueue this path into a queue of which each member is
sent direct reading asynchronous io at a fixed sample rate of 100HZ. The
IO accounting process for a path will last for path_io_err_sample_time.
If the number of IO error on a particular path is greater than the
path_io_err_num_threshold, then the path will not reinstate for

This helps us place the path in delayed state if we hit a lot of
intermittent IO errors on a particular path due to network/target
issues and isolate such degraded path and allow the admin to rectify
the errors on a path.

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/Makefile      |   5 +-
 libmultipath/config.h      |   9 +
 libmultipath/configure.c   |   3 +
 libmultipath/dict.c        |  41 ++++
 libmultipath/io_err_stat.c | 522 +++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/io_err_stat.h |  16 ++
 libmultipath/propsel.c     |  53 +++++
 libmultipath/propsel.h     |   3 +
 libmultipath/structs.h     |   5 +
 libmultipath/uevent.c      |  36 +++-
 libmultipath/uevent.h      |   2 +
 multipath/multipath.conf.5 |  42 ++++
 multipathd/main.c          |  56 +++++
 13 files changed, 789 insertions(+), 4 deletions(-)
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
index ffc69b5f..347ff5ba 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -75,6 +75,9 @@ struct hwentry {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_num_threshold;
+	int path_io_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	char * bl_product;
@@ -106,6 +109,9 @@ struct mpentry {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_num_threshold;
+	int path_io_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	uid_t uid;
@@ -155,6 +161,9 @@ struct config {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_num_threshold;
+	int path_io_err_recovery_time;
 	int uxsock_timeout;
 	int strict_timing;
 	int retrigger_tries;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 74b6f52a..ee3318df 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -298,6 +298,9 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_san_path_err_threshold(conf, mpp);
 	select_san_path_err_forget_rate(conf, mpp);
 	select_san_path_err_recovery_time(conf, mpp);
+	select_path_io_err_sample_time(conf, mpp);
+	select_path_io_err_num_threshold(conf, mpp);
+	select_path_io_err_recovery_time(conf, mpp);
 	select_skip_kpartx(conf, mpp);
 	select_max_sectors_kb(conf, mpp);
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 9dc10904..540f5019 100644
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
+declare_def_handler(path_io_err_num_threshold, set_off_int_undef)
+declare_def_snprint_defint(path_io_err_num_threshold, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(path_io_err_num_threshold, set_off_int_undef)
+declare_ovr_snprint(path_io_err_num_threshold, print_off_int_undef)
+declare_hw_handler(path_io_err_num_threshold, set_off_int_undef)
+declare_hw_snprint(path_io_err_num_threshold, print_off_int_undef)
+declare_mp_handler(path_io_err_num_threshold, set_off_int_undef)
+declare_mp_snprint(path_io_err_num_threshold, print_off_int_undef)
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
+	install_keyword("path_io_err_num_threshold", &def_path_io_err_num_threshold_handler, &snprint_def_path_io_err_num_threshold);
+	install_keyword("path_io_err_recovery_time", &def_path_io_err_recovery_time_handler, &snprint_def_path_io_err_recovery_time);
 
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
@@ -1530,6 +1562,9 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
+	install_keyword("path_io_err_sample_time", &hw_path_io_err_sample_time_handler, &snprint_hw_path_io_err_sample_time);
+	install_keyword("path_io_err_num_threshold", &hw_path_io_err_num_threshold_handler, &snprint_hw_path_io_err_num_threshold);
+	install_keyword("path_io_err_recovery_time", &hw_path_io_err_recovery_time_handler, &snprint_hw_path_io_err_recovery_time);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_sublevel_end();
@@ -1563,6 +1598,9 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_recovery_time);
+	install_keyword("path_io_err_sample_time", &ovr_path_io_err_sample_time_handler, &snprint_ovr_path_io_err_sample_time);
+	install_keyword("path_io_err_num_threshold", &ovr_path_io_err_num_threshold_handler, &snprint_ovr_path_io_err_num_threshold);
+	install_keyword("path_io_err_recovery_time", &ovr_path_io_err_recovery_time_handler, &snprint_ovr_path_io_err_recovery_time);
 
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
@@ -1595,6 +1633,9 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &mp_san_path_err_threshold_handler, &snprint_mp_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &mp_san_path_err_forget_rate_handler, &snprint_mp_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_recovery_time);
+	install_keyword("path_io_err_sample_time", &mp_path_io_err_sample_time_handler, &snprint_mp_path_io_err_sample_time);
+	install_keyword("path_io_err_num_threshold", &mp_path_io_err_num_threshold_handler, &snprint_mp_path_io_err_num_threshold);
+	install_keyword("path_io_err_recovery_time", &mp_path_io_err_recovery_time_handler, &snprint_mp_path_io_err_recovery_time);
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
 	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
 	install_sublevel_end();
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
new file mode 100644
index 00000000..b48a996a
--- /dev/null
+++ b/libmultipath/io_err_stat.c
@@ -0,0 +1,522 @@
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
+#define IOTIMEOUT_SEC 60
+
+#define io_err_stat_log(prio, fmt, args...) \
+	condlog(prio, "io error statistic: " fmt, ##args)
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
+	io_context_t	ioctx;
+	struct iocb	io;
+};
+
+struct io_err_stat_path {
+	char		devname[FILE_NAME_SIZE];
+	int		fd;
+	struct dio_ctx	*pd_ctx;
+	int		io_err_nr;
+	int		io_nr;
+	struct timespec	start_time;
+
+	int		total_time;
+	int		err_num_threshold;
+};
+
+pthread_t		io_err_stat_thr;
+pthread_attr_t		io_err_stat_attr;
+
+static struct io_err_stat_pathvec *paths;
+struct vectors *vecs;
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
+static int setup_directio_ctx(struct io_err_stat_path *p)
+{
+	unsigned long pgsize = getpagesize();
+	char fpath[FILE_NAME_SIZE+6];
+
+	snprintf(fpath, FILE_NAME_SIZE, "/dev/%s", p->devname);
+	if (p->fd < 0)
+		p->fd = open(fpath, O_RDONLY | O_DIRECT);
+	if (p->fd < 0)
+		return 1;
+
+	p->pd_ctx = MALLOC(sizeof(struct dio_ctx));
+	if (!p->pd_ctx)
+		goto fail_close;
+	if (io_setup(1, &p->pd_ctx->ioctx) != 0) {
+		io_err_stat_log(4, "io_setup failed for %s", fpath);
+		goto free_pdctx;
+	}
+
+	if (ioctl(p->fd, BLKBSZGET, &p->pd_ctx->blksize) < 0) {
+		io_err_stat_log(4, "cannot get blocksize, set default");
+		p->pd_ctx->blksize = 512;
+	}
+	/*
+	 * Sanity check for block size
+	 */
+	if (p->pd_ctx->blksize > 4096)
+		p->pd_ctx->blksize = 4096;
+	if (!p->pd_ctx->blksize)
+		goto io_destr;
+
+	p->pd_ctx->buf = (unsigned char *)MALLOC(p->pd_ctx->blksize + pgsize);
+	if (!p->pd_ctx->buf)
+		goto io_destr;
+
+	p->pd_ctx->ptr = (unsigned char *)(((unsigned long)p->pd_ctx->buf +
+				pgsize - 1) & (~(pgsize - 1)));
+
+	return 0;
+
+io_destr:
+	io_destroy(p->pd_ctx->ioctx);
+free_pdctx:
+	FREE(p->pd_ctx);
+fail_close:
+	close(p->fd);
+
+	return 1;
+}
+
+static void destroy_directio_ctx(struct io_err_stat_path *p)
+{
+	if (!p || !p->pd_ctx)
+		return;
+
+	if (p->pd_ctx->buf)
+		FREE(p->pd_ctx->buf);
+	if (p->pd_ctx->ioctx)
+		io_destroy(p->pd_ctx->ioctx);
+	FREE(p->pd_ctx);
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
+	p->err_num_threshold = 0;
+	p->fd = -1;
+
+	return p;
+}
+
+static void free_io_err_stat_path(struct io_err_stat_path *p)
+{
+	if (p)
+		FREE(p);
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
+int enqueue_io_err_stat_by_path(struct path *path)
+{
+	struct io_err_stat_path *p;
+
+	if (path->io_err_disable_reinstate) {
+		io_err_stat_log(3, "%s: reinstate is already disabled",
+				path->dev);
+		return 1;
+	}
+
+	if (!path->mpp)
+		return 1;
+	if (path->mpp->path_io_err_sample_time <= 0 ||
+		path->mpp->path_io_err_recovery_time <= 0 ||
+		path->mpp->path_io_err_num_threshold < 0) {
+		io_err_stat_log(4, "%s: parameter not set", path->mpp->alias);
+		return 1;
+	}
+
+	pthread_mutex_lock(&paths->mutex);
+	p = find_err_path_by_dev(paths->pathvec, path->dev);
+	if (p) {
+		pthread_mutex_unlock(&paths->mutex);
+		return 1;
+	}
+	pthread_mutex_unlock(&paths->mutex);
+
+	p = alloc_io_err_stat_path();
+	if (!p)
+		return 1;
+
+	memcpy(p->devname, path->dev, sizeof(p->devname));
+	p->total_time = path->mpp->path_io_err_sample_time;
+	p->err_num_threshold = path->mpp->path_io_err_num_threshold;
+
+	if (setup_directio_ctx(p))
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
+int hit_io_err_recovery_time(struct path *pp)
+{
+	struct timespec curr_time;
+
+	if (pp->io_err_disable_reinstate == 0)
+		return 1;
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return 1;
+	if (pp->mpp->nr_active == 0) {
+		io_err_stat_log(2, "%s: recover path early", pp->dev);
+		goto recover;
+	}
+	if ((curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
+			pp->mpp->path_io_err_recovery_time) {
+		io_err_stat_log(2, "%s: recover path after %d seconds",
+				pp->dev, pp->mpp->path_io_err_sample_time);
+		goto recover;
+	}
+
+	return 1;
+
+recover:
+	pp->io_err_disable_reinstate = 0;
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
+static int check_async_io(struct vectors *vecs, struct io_err_stat_path *pp,
+			int rc)
+{
+	struct timespec currtime, difftime;
+	struct path *path;
+
+	switch (rc) {
+	case PATH_UNCHECKED:
+		break;
+	case PATH_UP:
+		break;
+	case PATH_DOWN:
+		pp->io_err_nr++;
+		break;
+	case PATH_TIMEOUT:
+		pp->io_err_nr++;
+		break;
+	case PATH_PENDING:
+		break;
+	default:
+		break;
+	}
+
+	if (clock_gettime(CLOCK_MONOTONIC, &currtime) != 0)
+		return 1;
+	timespecsub(&currtime, &pp->start_time, &difftime);
+	if (difftime.tv_sec < pp->total_time)
+		return 0;
+
+	io_err_stat_log(3, "check end for %s", pp->devname);
+
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
+	path = find_path_by_dev(vecs->pathvec, pp->devname);
+
+	if (!path) {
+		io_err_stat_log(3, "path %s not found'", pp->devname);
+	} else if (pp->io_err_nr <= pp->err_num_threshold) {
+		io_err_stat_log(3, "%s: (%d/%d) not hit threshold",
+				pp->devname, pp->io_err_nr, pp->io_nr);
+	} else if (path->mpp && path->mpp->nr_active > 1) {
+		dm_fail_path(path->mpp->alias, path->dev_t);
+		update_queue_mode_del_path(path->mpp);
+		io_err_stat_log(2, "%s: proacively fail dm path %s",
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
+		io_err_stat_log(3, "%s: do nothing", pp->devname);
+	}
+	lock_cleanup_pop(vecs->lock);
+
+	delete_io_err_stat_by_addr(pp);
+
+	return 0;
+}
+
+static int send_async_io(struct io_err_stat_path *pp, int timeout_secs)
+{
+	struct timespec	timeout = { .tv_nsec = 5 };
+	struct timespec curr_time, difftime;
+	struct io_event event;
+	int		rc = PATH_UNCHECKED;
+	long		r;
+
+	struct dio_ctx *ct = pp->pd_ctx;
+
+	if (!ct)
+		return rc;
+
+	if (ct->io_starttime.tv_nsec == 0 &&
+			ct->io_starttime.tv_sec == 0) {
+		struct iocb *ios[1] = { &ct->io };
+
+		memset(&ct->io, 0, sizeof(struct iocb));
+		io_prep_pread(&ct->io, pp->fd, ct->ptr, ct->blksize, 0);
+		if (io_submit(ct->ioctx, 1, ios) != 1) {
+			io_err_stat_log(3, "%s: io_submit error %i",
+					pp->devname, errno);
+			return rc;
+		}
+
+		if (clock_gettime(CLOCK_MONOTONIC, &ct->io_starttime) != 0) {
+			ct->io_starttime.tv_sec = 0;
+			ct->io_starttime.tv_nsec = 0;
+		}
+
+		if (pp->start_time.tv_sec == 0 && pp->start_time.tv_nsec == 0 &&
+			clock_gettime(CLOCK_MONOTONIC, &pp->start_time)) {
+			pp->start_time.tv_sec = 0;
+			pp->start_time.tv_nsec = 0;
+			return rc;
+		}
+		pp->io_nr++;
+	}
+
+	errno = 0;
+	r = io_getevents(ct->ioctx, 1L, 1L, &event, &timeout);
+	if (r < 0) {
+		io_err_stat_log(3, "%s: async io events returned %d (errno=%s)",
+				pp->devname, r, strerror(errno));
+		ct->io_starttime.tv_sec = 0;
+		ct->io_starttime.tv_nsec = 0;
+		rc = PATH_UNCHECKED;
+	} else if (r < 1L) {
+		if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+			curr_time.tv_sec = 0;
+		timespecsub(&curr_time, &ct->io_starttime, &difftime);
+
+		if (difftime.tv_sec > timeout_secs) {
+			struct iocb *ios[1] = { &ct->io };
+
+			io_err_stat_log(3, "%s: abort check on timeout",
+					pp->devname);
+			r = io_cancel(ct->ioctx, ios[0], &event);
+			if (r)
+				io_err_stat_log(3, "%s: io_cancel error %i",
+						pp->devname, errno);
+			else{
+				ct->io_starttime.tv_sec = 0;
+				ct->io_starttime.tv_nsec = 0;
+			}
+			rc = PATH_TIMEOUT;
+		} else {
+			rc = PATH_PENDING;
+		}
+	} else {
+		ct->io_starttime.tv_sec = 0;
+		ct->io_starttime.tv_nsec = 0;
+		rc = (event.res == ct->blksize) ? PATH_UP : PATH_DOWN;
+	}
+
+	return rc;
+}
+
+static void service_paths(void)
+{
+	struct io_err_stat_path *pp;
+	int i, rc;
+
+	pthread_mutex_lock(&paths->mutex);
+	vector_foreach_slot(paths->pathvec, pp, i) {
+		rc = send_async_io(pp, IOTIMEOUT_SEC);
+		check_async_io(vecs, pp, rc);
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
+		usleep(10000); //TODO FIXME  impact perf
+	}
+
+	pthread_cleanup_pop(1);
+	return NULL;
+}
+
+int start_io_err_stat_thread(void *data)
+{
+	paths = alloc_pathvec();
+	if (!paths)
+		return 1;
+
+	if (pthread_create(&io_err_stat_thr, &io_err_stat_attr,
+				io_err_stat_loop, data)) {
+		io_err_stat_log(0, "cannot create io_error statistic thread");
+		goto out;
+	}
+	io_err_stat_log(3, "thread started");
+	return 0;
+out:
+	free_io_err_pathvec(paths);
+	io_err_stat_log(0, "failed to start io_error statistic thread");
+	return 1;
+}
+
+void stop_io_err_stat_thread(void)
+{
+	pthread_cancel(io_err_stat_thr);
+	pthread_kill(io_err_stat_thr, SIGUSR2);
+
+	free_io_err_pathvec(paths);
+}
+
diff --git a/libmultipath/io_err_stat.h b/libmultipath/io_err_stat.h
new file mode 100644
index 00000000..20010785
--- /dev/null
+++ b/libmultipath/io_err_stat.h
@@ -0,0 +1,16 @@
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
+
+int enqueue_io_err_stat_by_path(struct path *path);
+int hit_io_err_recovery_time(struct path *pp);
+
+#endif /* _IO_ERR_STAT_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 175fbe11..9335777d 100644
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
+int select_path_io_err_num_threshold(struct config *conf, struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(path_io_err_num_threshold);
+	mp_set_ovr(path_io_err_num_threshold);
+	mp_set_hwe(path_io_err_num_threshold);
+	mp_set_conf(path_io_err_num_threshold);
+	mp_set_default(path_io_err_num_threshold, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->path_io_err_num_threshold);
+	condlog(3, "%s: path_io_err_num_threshold = %s %s", mp->alias, buff,
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
index f8e96d85..181bd5e5 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -28,6 +28,9 @@ int select_max_sectors_kb (struct config *conf, struct multipath * mp);
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp);
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp);
+int select_path_io_err_sample_time(struct config *conf, struct multipath *mp);
+int select_path_io_err_num_threshold(struct config *conf, struct multipath *mp);
+int select_path_io_err_recovery_time(struct config *conf, struct multipath *mp);
 void reconcile_features_with_options(const char *id, char **features,
 				     int* no_path_retry,
 				     int *retain_hwhandler);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 8ea984d9..f02cfdb9 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -235,6 +235,8 @@ struct path {
 	time_t dis_reinstate_time;
 	int disable_reinstate;
 	int san_path_err_forget_rate;
+	time_t io_err_dis_reinstate_time;
+	int io_err_disable_reinstate;
 	/* configlet pointers */
 	struct hwentry * hwe;
 };
@@ -269,6 +271,9 @@ struct multipath {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int path_io_err_sample_time;
+	int path_io_err_num_threshold;
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
index d9ac279f..6133d17d 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -849,6 +849,48 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B path_io_err_sample_time
+One of the three parameters of supporting path check based on accounting IO
+error such as intermittent error. If it is set to a value greater than 0,
+when a path fail event occurs due to an IO error, multipathd will enqueue this
+path into a queue of which members are sent direct reading aio at a fixed
+sample rate of 100HZ. The IO accounting process for a path will last for
+\fIpath_io_err_sample_time\fR. If the number of IO error on a particular path
+is greater than the \fIpath_io_err_num_threshold\fR, then the path will not
+reinstate for \fIpath_io_err_num_threshold\fR seconds unless there is only one
+active path.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B path_io_err_num_threshold
+One of the three parameters of supporting path check based on accounting IO
+error such as intermittent error. Refer to \fIpath_io_err_sample_time\fR. If
+the number of IO errors on a particular path is greater than this parameter,
+then the path will not reinstate for \fIpath_io_err_num_threshold\fR seconds
+unless there is only one active path.
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
index 4be2c579..d12e6fae 100644
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
+	r = enqueue_io_err_stat_by_path(pp);
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
