From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH 1/2 V5] multipath-tools: intermittent IO error
	accounting to improve reliability
Date: Thu, 21 Sep 2017 16:07:58 +0800
Message-ID: <1505981279-11288-2-git-send-email-guanjunxiong@huawei.com>
References: <1505981279-11288-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505981279-11288-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, mmandala@Brocade.com
Cc: guanjunxiong@huawei.com, chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

This patch adds a new method of path state checking based on accounting
IO error. This is useful in many scenarios such as intermittent IO error
an a path due to network congestion, or a shaky link.

Four parameters are added for the admin:"marginal_path_double_failed_time",
marginal_path_err_sample_time", "marginal_path_err_rate_threshold" and
"marginal_path_err_recheck_gap_time". If marginal_path_err_sample_time are set no
less than 120 and marginal_path_err_recheck_gap_time are set to a value greater
than 0, when path failing events occur twice in marginal_path_double_failed_time
second due to an IO error, multipathd will fail the path and enqueue this
path into a queue of which each member is sent a couple of continuous direct
reading asynchronous IOs at a fixed sample rate of 10HZ. The IO accounting
process for a path will last for marginal_path_err_sample_time. If the IO error
rate on a particular path is greater than the marginal_path_err_rate_threshold,
then the path will not reinstate for recover_time seconds unless there is
only one active path.

If recover_time expires, we will reschedule this IO error checking process.
If the path is good enough, we will claim it good. Or else the path will
keep failed.

This helps us place the path in shaky state if we hit a lot of
intermittent IO errors on a particular path due to network/target
issues and isolate such degraded path and allow the admin to rectify
the errors on a path.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Muneendra Kumar M <mmandala@Brocade.com>
Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/Makefile      |   5 +-
 libmultipath/config.h      |  12 +
 libmultipath/configure.c   |   4 +
 libmultipath/dict.c        |  55 ++++
 libmultipath/io_err_stat.c | 744 +++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/io_err_stat.h |  15 +
 libmultipath/propsel.c     |  67 ++++
 libmultipath/propsel.h     |   4 +
 libmultipath/structs.h     |   8 +
 libmultipath/uevent.c      |  32 ++
 libmultipath/uevent.h      |   2 +
 multipath/multipath.conf.5 |  92 ++++++
 multipathd/main.c          |  64 ++++
 13 files changed, 1102 insertions(+), 2 deletions(-)
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
index ffc69b5f..9b4feb82 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -75,6 +75,10 @@ struct hwentry {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int marginal_path_err_sample_time;
+	int marginal_path_err_rate_threshold;
+	int marginal_path_err_recheck_gap_time;
+	int marginal_path_double_failed_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	char * bl_product;
@@ -106,6 +110,10 @@ struct mpentry {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int marginal_path_err_sample_time;
+	int marginal_path_err_rate_threshold;
+	int marginal_path_err_recheck_gap_time;
+	int marginal_path_double_failed_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	uid_t uid;
@@ -155,6 +163,10 @@ struct config {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int marginal_path_err_sample_time;
+	int marginal_path_err_rate_threshold;
+	int marginal_path_err_recheck_gap_time;
+	int marginal_path_double_failed_time;
 	int uxsock_timeout;
 	int strict_timing;
 	int retrigger_tries;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 74b6f52a..6a4df830 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -298,6 +298,10 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_san_path_err_threshold(conf, mpp);
 	select_san_path_err_forget_rate(conf, mpp);
 	select_san_path_err_recovery_time(conf, mpp);
+	select_marginal_path_err_sample_time(conf, mpp);
+	select_marginal_path_err_rate_threshold(conf, mpp);
+	select_marginal_path_err_recheck_gap_time(conf, mpp);
+	select_marginal_path_double_failed_time(conf, mpp);
 	select_skip_kpartx(conf, mpp);
 	select_max_sectors_kb(conf, mpp);
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 9dc10904..51edff4c 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1108,6 +1108,45 @@ declare_hw_handler(san_path_err_recovery_time, set_off_int_undef)
 declare_hw_snprint(san_path_err_recovery_time, print_off_int_undef)
 declare_mp_handler(san_path_err_recovery_time, set_off_int_undef)
 declare_mp_snprint(san_path_err_recovery_time, print_off_int_undef)
+declare_def_handler(marginal_path_err_sample_time, set_off_int_undef)
+declare_def_snprint_defint(marginal_path_err_sample_time, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(marginal_path_err_sample_time, set_off_int_undef)
+declare_ovr_snprint(marginal_path_err_sample_time, print_off_int_undef)
+declare_hw_handler(marginal_path_err_sample_time, set_off_int_undef)
+declare_hw_snprint(marginal_path_err_sample_time, print_off_int_undef)
+declare_mp_handler(marginal_path_err_sample_time, set_off_int_undef)
+declare_mp_snprint(marginal_path_err_sample_time, print_off_int_undef)
+declare_def_handler(marginal_path_err_rate_threshold, set_off_int_undef)
+declare_def_snprint_defint(marginal_path_err_rate_threshold, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(marginal_path_err_rate_threshold, set_off_int_undef)
+declare_ovr_snprint(marginal_path_err_rate_threshold, print_off_int_undef)
+declare_hw_handler(marginal_path_err_rate_threshold, set_off_int_undef)
+declare_hw_snprint(marginal_path_err_rate_threshold, print_off_int_undef)
+declare_mp_handler(marginal_path_err_rate_threshold, set_off_int_undef)
+declare_mp_snprint(marginal_path_err_rate_threshold, print_off_int_undef)
+declare_def_handler(marginal_path_err_recheck_gap_time, set_off_int_undef)
+declare_def_snprint_defint(marginal_path_err_recheck_gap_time, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(marginal_path_err_recheck_gap_time, set_off_int_undef)
+declare_ovr_snprint(marginal_path_err_recheck_gap_time, print_off_int_undef)
+declare_hw_handler(marginal_path_err_recheck_gap_time, set_off_int_undef)
+declare_hw_snprint(marginal_path_err_recheck_gap_time, print_off_int_undef)
+declare_mp_handler(marginal_path_err_recheck_gap_time, set_off_int_undef)
+declare_mp_snprint(marginal_path_err_recheck_gap_time, print_off_int_undef)
+declare_def_handler(marginal_path_double_failed_time, set_off_int_undef)
+declare_def_snprint_defint(marginal_path_double_failed_time, print_off_int_undef,
+			   DEFAULT_ERR_CHECKS)
+declare_ovr_handler(marginal_path_double_failed_time, set_off_int_undef)
+declare_ovr_snprint(marginal_path_double_failed_time, print_off_int_undef)
+declare_hw_handler(marginal_path_double_failed_time, set_off_int_undef)
+declare_hw_snprint(marginal_path_double_failed_time, print_off_int_undef)
+declare_mp_handler(marginal_path_double_failed_time, set_off_int_undef)
+declare_mp_snprint(marginal_path_double_failed_time, print_off_int_undef)
+
+
+
 static int
 def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
@@ -1443,6 +1482,10 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_recovery_time);
+	install_keyword("marginal_path_err_sample_time", &def_marginal_path_err_sample_time_handler, &snprint_def_marginal_path_err_sample_time);
+	install_keyword("marginal_path_err_rate_threshold", &def_marginal_path_err_rate_threshold_handler, &snprint_def_marginal_path_err_rate_threshold);
+	install_keyword("marginal_path_err_recheck_gap_time", &def_marginal_path_err_recheck_gap_time_handler, &snprint_def_marginal_path_err_recheck_gap_time);
+	install_keyword("marginal_path_double_failed_time", &def_marginal_path_double_failed_time_handler, &snprint_def_marginal_path_double_failed_time);
 
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
@@ -1530,6 +1573,10 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
+	install_keyword("marginal_path_err_sample_time", &hw_marginal_path_err_sample_time_handler, &snprint_hw_marginal_path_err_sample_time);
+	install_keyword("marginal_path_err_rate_threshold", &hw_marginal_path_err_rate_threshold_handler, &snprint_hw_marginal_path_err_rate_threshold);
+	install_keyword("marginal_path_err_recheck_gap_time", &hw_marginal_path_err_recheck_gap_time_handler, &snprint_hw_marginal_path_err_recheck_gap_time);
+	install_keyword("marginal_path_double_failed_time", &hw_marginal_path_double_failed_time_handler, &snprint_hw_marginal_path_double_failed_time);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_sublevel_end();
@@ -1563,6 +1610,10 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_recovery_time);
+	install_keyword("marginal_path_err_sample_time", &ovr_marginal_path_err_sample_time_handler, &snprint_ovr_marginal_path_err_sample_time);
+	install_keyword("marginal_path_err_rate_threshold", &ovr_marginal_path_err_rate_threshold_handler, &snprint_ovr_marginal_path_err_rate_threshold);
+	install_keyword("marginal_path_err_recheck_gap_time", &ovr_marginal_path_err_recheck_gap_time_handler, &snprint_ovr_marginal_path_err_recheck_gap_time);
+	install_keyword("marginal_path_double_failed_time", &ovr_marginal_path_double_failed_time_handler, &snprint_ovr_marginal_path_double_failed_time);
 
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
@@ -1595,6 +1646,10 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_threshold", &mp_san_path_err_threshold_handler, &snprint_mp_san_path_err_threshold);
 	install_keyword("san_path_err_forget_rate", &mp_san_path_err_forget_rate_handler, &snprint_mp_san_path_err_forget_rate);
 	install_keyword("san_path_err_recovery_time", &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_recovery_time);
+	install_keyword("marginal_path_err_sample_time", &mp_marginal_path_err_sample_time_handler, &snprint_mp_marginal_path_err_sample_time);
+	install_keyword("marginal_path_err_rate_threshold", &mp_marginal_path_err_rate_threshold_handler, &snprint_mp_marginal_path_err_rate_threshold);
+	install_keyword("marginal_path_err_recheck_gap_time", &mp_marginal_path_err_recheck_gap_time_handler, &snprint_mp_marginal_path_err_recheck_gap_time);
+	install_keyword("marginal_path_double_failed_time", &mp_marginal_path_double_failed_time_handler, &snprint_mp_marginal_path_double_failed_time);
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
 	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
 	install_sublevel_end();
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
new file mode 100644
index 00000000..f893e2e8
--- /dev/null
+++ b/libmultipath/io_err_stat.c
@@ -0,0 +1,744 @@
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
+#define TIMEOUT_NO_IO_NSEC		10000000 /*10ms = 10000000ns*/
+#define FLAKY_PATHFAIL_THRESHOLD	2
+#define CONCUR_NR_EVENT			32
+
+#define PATH_IO_ERR_IN_CHECKING		-1
+#define PATH_IO_ERR_IN_POLLING_RECHECK	-2
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
+	void		*buf;
+	struct iocb	io;
+};
+
+struct io_err_stat_path {
+	char		devname[FILE_NAME_SIZE];
+	int		fd;
+	struct dio_ctx	*dio_ctx_array;
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
+		unsigned long pgsize)
+{
+	ct->blksize = blksize;
+	if(posix_memalign(&ct->buf, pgsize, blksize))
+		return 1;
+	memset(ct->buf, 0, blksize);
+	ct->io_starttime.tv_sec = 0;
+	ct->io_starttime.tv_nsec = 0;
+
+	return 0;
+}
+
+static void deinit_each_dio_ctx(struct dio_ctx *ct)
+{
+	if (ct->buf)
+		free(ct->buf);
+}
+
+static int setup_directio_ctx(struct io_err_stat_path *p)
+{
+	unsigned long pgsize = getpagesize();
+	char fpath[PATH_MAX];
+	int blksize = 0;
+	int i;
+
+	if (snprintf(fpath, PATH_MAX, "/dev/%s", p->devname) >= PATH_MAX)
+		return 1;
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
+	if (!blksize)
+		goto free_pdctx;
+
+	for (i = 0; i < CONCUR_NR_EVENT; i++) {
+		if (init_each_dio_ctx(p->dio_ctx_array + i, blksize, pgsize))
+			goto deinit;
+	}
+	return 0;
+
+deinit:
+	for (i = 0; i < CONCUR_NR_EVENT; i++)
+		deinit_each_dio_ctx(p->dio_ctx_array + i);
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
+	for (i = 0; i < CONCUR_NR_EVENT; i++)
+		deinit_each_dio_ctx(p->dio_ctx_array + i);
+	FREE(p->dio_ctx_array);
+
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
+
+	pthread_mutex_lock(&paths->mutex);
+	p = find_err_path_by_dev(paths->pathvec, path->dev);
+	if (p) {
+		pthread_mutex_unlock(&paths->mutex);
+		return 2;
+	}
+	pthread_mutex_unlock(&paths->mutex);
+
+	p = alloc_io_err_stat_path();
+	if (!p)
+		return 1;
+
+	memcpy(p->devname, path->dev, sizeof(p->devname));
+	p->total_time = path->mpp->marginal_path_err_sample_time;
+	p->err_rate_threshold = path->mpp->marginal_path_err_rate_threshold;
+
+	if (setup_directio_ctx(p))
+		goto free_ioerr_path;
+	pthread_mutex_lock(&paths->mutex);
+	if (!vector_alloc_slot(paths->pathvec))
+		goto unlock_destroy;
+	vector_set_slot(paths->pathvec, p);
+	pthread_mutex_unlock(&paths->mutex);
+
+	if (!path->io_err_disable_reinstate) {
+		/*
+		 *fail the path in the kernel for the time of the to make
+		 *the test more reliable
+		 */
+		io_err_stat_log(3, "%s: fail dm path %s before checking",
+				path->mpp->alias, path->dev);
+		path->io_err_disable_reinstate = 1;
+		dm_fail_path(path->mpp->alias, path->dev_t);
+		update_queue_mode_del_path(path->mpp);
+
+		/*
+		 * schedule path check as soon as possible to
+		 * update path state to delayed state
+		 */
+		path->tick = 1;
+
+	}
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
+	int res;
+
+	if (path->io_err_disable_reinstate) {
+		io_err_stat_log(3, "%s: reinstate is already disabled",
+				path->dev);
+		return 1;
+	}
+	if (path->io_err_pathfail_cnt < 0)
+		return 1;
+
+	if (!path->mpp)
+		return 1;
+	if (path->mpp->nr_active <= 1)
+		return 1;
+	if (path->mpp->marginal_path_double_failed_time <= 0 ||
+		path->mpp->marginal_path_err_sample_time <= 0 ||
+		path->mpp->marginal_path_err_recheck_gap_time <= 0 ||
+		path->mpp->marginal_path_err_rate_threshold < 0) {
+		io_err_stat_log(4, "%s: parameter not set", path->mpp->alias);
+		return 1;
+	}
+	if (path->mpp->marginal_path_err_sample_time < (2 * IOTIMEOUT_SEC)) {
+		io_err_stat_log(2, "%s: marginal_path_err_sample_time should not less than %d",
+				path->mpp->alias, 2 * IOTIMEOUT_SEC);
+		return 1;
+	}
+	/*
+	 * The test should only be started for paths that have failed
+	 * repeatedly in a certain time frame, so that we have reason
+	 * to assume they're flaky. Without bother the admin to configure
+	 * the repeated count threshold and time frame, we assume a path
+	 * which fails at least twice within 60 seconds is flaky.
+	 */
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return 1;
+	if (path->io_err_pathfail_cnt == 0) {
+		path->io_err_pathfail_cnt++;
+		path->io_err_pathfail_starttime = curr_time.tv_sec;
+		io_err_stat_log(5, "%s: start path flakiness pre-checking",
+				path->dev);
+		return 0;
+	}
+	if ((curr_time.tv_sec - path->io_err_pathfail_starttime) >
+			path->mpp->marginal_path_double_failed_time) {
+		path->io_err_pathfail_cnt = 0;
+		path->io_err_pathfail_starttime = curr_time.tv_sec;
+		io_err_stat_log(5, "%s: restart path flakiness pre-checking",
+				path->dev);
+	}
+	path->io_err_pathfail_cnt++;
+	if (path->io_err_pathfail_cnt >= FLAKY_PATHFAIL_THRESHOLD) {
+		res = enqueue_io_err_stat_by_path(path);
+		if (!res)
+			path->io_err_pathfail_cnt = PATH_IO_ERR_IN_CHECKING;
+		else
+			path->io_err_pathfail_cnt = 0;
+	}
+
+	return 0;
+}
+
+int hit_io_err_recheck_time(struct path *pp)
+{
+	struct timespec curr_time;
+	int r;
+
+	if (pp->io_err_disable_reinstate == 0)
+		return 1;
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return 1;
+	if (pp->io_err_pathfail_cnt != PATH_IO_ERR_IN_POLLING_RECHECK)
+		return 1;
+	if (pp->mpp->nr_active <= 0) {
+		io_err_stat_log(2, "%s: recover path early", pp->dev);
+		goto recover;
+	}
+	if ((curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
+			pp->mpp->marginal_path_err_recheck_gap_time) {
+		io_err_stat_log(4, "%s: reschedule checking after %d seconds",
+				pp->dev,
+				pp->mpp->marginal_path_err_recheck_gap_time);
+		/*
+		 * to reschedule io error checking again
+		 * if the path is good enough, we claim it is good
+		 * and can be reinsated as soon as possible in the
+		 * check_path routine.
+		 */
+		pp->io_err_dis_reinstate_time = curr_time.tv_sec;
+		r = enqueue_io_err_stat_by_path(pp);
+		/*
+		 * Enqueue fails because of internal error.
+		 * In this case , we recover this path
+		 * Or else,  return 1 to set path state to PATH_SHAKY
+		 */
+		if (r == 1) {
+			io_err_stat_log(3, "%s: enqueue fails, to recover",
+					pp->dev);
+			goto recover;
+		}
+		else if (!r) {
+			pp->io_err_pathfail_cnt = PATH_IO_ERR_IN_CHECKING;
+		}
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
+	io_err_stat_log(4, "%s: check end", pp->devname);
+
+	err_rate = pp->io_nr == 0 ? 0 : (pp->io_err_nr * 1000.0f) / pp->io_nr;
+	io_err_stat_log(3, "%s: IO error rate (%.1f/1000)",
+			pp->devname, err_rate);
+	pthread_cleanup_push(cleanup_lock, &vecs->lock);
+	lock(&vecs->lock);
+	pthread_testcancel();
+	path = find_path_by_dev(vecs->pathvec, pp->devname);
+	if (!path) {
+		io_err_stat_log(4, "path %s not found'", pp->devname);
+	} else if (err_rate <= pp->err_rate_threshold) {
+		path->io_err_pathfail_cnt = 0;
+		path->io_err_disable_reinstate = 0;
+		io_err_stat_log(3, "%s: (%d/%d) good to enable reinstating",
+				pp->devname, pp->io_err_nr, pp->io_nr);
+		/*
+		 * schedule path check as soon as possible to
+		 * update path state. Do NOT reinstate dm path here
+		 */
+		path->tick = 1;
+
+	} else if (path->mpp && path->mpp->nr_active > 1) {
+		io_err_stat_log(3, "%s: keep failing the dm path %s",
+				path->mpp->alias, path->dev);
+		path->io_err_pathfail_cnt = PATH_IO_ERR_IN_POLLING_RECHECK;
+		path->io_err_disable_reinstate = 1;
+		path->io_err_dis_reinstate_time = currtime.tv_sec;
+		io_err_stat_log(3, "%s: disable reinstating of %s",
+				path->mpp->alias, path->dev);
+	} else {
+		path->io_err_pathfail_cnt = 0;
+		path->io_err_disable_reinstate = 0;
+		io_err_stat_log(3, "%s: there is orphan path, enable reinstating",
+				pp->devname);
+	}
+	lock_cleanup_pop(vecs->lock);
+
+	delete_io_err_stat_by_addr(pp);
+
+	return 0;
+}
+
+static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
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
+		io_prep_pread(&ct->io, fd, ct->buf, ct->blksize, 0);
+		if (io_submit(ioctx, 1, ios) != 1) {
+			io_err_stat_log(5, "%s: io_submit error %i",
+					dev, errno);
+			return rc;
+		}
+		rc = 0;
+	}
+
+	return rc;
+}
+
+static void send_batch_async_ios(struct io_err_stat_path *pp)
+{
+	int i;
+	struct dio_ctx *ct;
+	struct timespec currtime, difftime;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &currtime) != 0)
+		return;
+	/*
+	 * Give a free time for all IO to complete or timeout
+	 */
+	if (pp->start_time.tv_sec != 0) {
+		timespecsub(&currtime, &pp->start_time, &difftime);
+		if (difftime.tv_sec + IOTIMEOUT_SEC >= pp->total_time)
+			return;
+	}
+
+	for (i = 0; i < CONCUR_NR_EVENT; i++) {
+		ct = pp->dio_ctx_array + i;
+		if (!send_each_async_io(ct, pp->fd, pp->devname))
+			pp->io_nr++;
+	}
+	if (pp->start_time.tv_sec == 0 && pp->start_time.tv_nsec == 0 &&
+		clock_gettime(CLOCK_MONOTONIC, &pp->start_time)) {
+		pp->start_time.tv_sec = 0;
+		pp->start_time.tv_nsec = 0;
+	}
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
+	if (ct->io_starttime.tv_sec == 0)
+		return rc;
+	timespecsub(t, &ct->io_starttime, &difftime);
+	if (difftime.tv_sec > IOTIMEOUT_SEC) {
+		struct iocb *ios[1] = { &ct->io };
+
+		io_err_stat_log(5, "%s: abort check on timeout", dev);
+		r = io_cancel(ioctx, ios[0], &event);
+		if (r)
+			io_err_stat_log(5, "%s: io_cancel error %i",
+					dev, errno);
+		ct->io_starttime.tv_sec = 0;
+		ct->io_starttime.tv_nsec = 0;
+		rc = PATH_TIMEOUT;
+	} else {
+		rc = PATH_PENDING;
+	}
+
+	return rc;
+}
+
+static void poll_async_io_timeout(void)
+{
+	struct io_err_stat_path *pp;
+	struct timespec curr_time;
+	int		rc = PATH_UNCHECKED;
+	int		i, j;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return;
+	vector_foreach_slot(paths->pathvec, pp, i) {
+		for (j = 0; j < CONCUR_NR_EVENT; j++) {
+			rc = try_to_cancel_timeout_io(pp->dio_ctx_array + j,
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
+		struct dio_ctx *ct = pp->dio_ctx_array + i;
+		struct iocb *ios[1] = { &ct->io };
+
+		if (ct->io_starttime.tv_sec == 0
+				&& ct->io_starttime.tv_nsec == 0)
+			continue;
+		io_err_stat_log(5, "%s: abort infligh io",
+				pp->devname);
+		r = io_cancel(ioctx, ios[0], &event);
+		if (r)
+			io_err_stat_log(5, "%s: io_cancel error %d, %i",
+					pp->devname, r, errno);
+		ct->io_starttime.tv_sec = 0;
+		ct->io_starttime.tv_nsec = 0;
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
+	struct io_err_stat_path *pp;
+	struct dio_ctx *ct;
+	int rc = PATH_UNCHECKED;
+	int i, j;
+
+	vector_foreach_slot(paths->pathvec, pp, i) {
+		for (j = 0; j < CONCUR_NR_EVENT; j++) {
+			ct = pp->dio_ctx_array + j;
+			if (&ct->io == io_evt->obj) {
+				rc = handle_done_dio_ctx(ct, io_evt);
+				account_async_io_state(pp, rc);
+				return;
+			}
+		}
+	}
+}
+
+static void process_async_ios_event(int timeout_nsecs, char *dev)
+{
+	struct io_event events[CONCUR_NR_EVENT];
+	int		i, n;
+	struct timespec	timeout = { .tv_nsec = timeout_nsecs };
+
+	errno = 0;
+	n = io_getevents(ioctx, 1L, CONCUR_NR_EVENT, events, &timeout);
+	if (n < 0) {
+		io_err_stat_log(3, "%s: async io events returned %d (errno=%s)",
+				dev, n, strerror(errno));
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
+		process_async_ios_event(TIMEOUT_NO_IO_NSEC, pp->devname);
+		poll_async_io_timeout();
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
index 00000000..bbf31b4f
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
+int hit_io_err_recheck_time(struct path *pp);
+
+#endif /* _IO_ERR_STAT_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 175fbe11..19929970 100644
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
@@ -776,6 +778,71 @@ out:
 	return 0;
 
 }
+
+int select_marginal_path_err_sample_time(struct config *conf, struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(marginal_path_err_sample_time);
+	mp_set_ovr(marginal_path_err_sample_time);
+	mp_set_hwe(marginal_path_err_sample_time);
+	mp_set_conf(marginal_path_err_sample_time);
+	mp_set_default(marginal_path_err_sample_time, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->marginal_path_err_sample_time);
+	condlog(3, "%s: marginal_path_err_sample_time = %s %s", mp->alias, buff,
+			origin);
+	return 0;
+}
+
+int select_marginal_path_err_rate_threshold(struct config *conf, struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(marginal_path_err_rate_threshold);
+	mp_set_ovr(marginal_path_err_rate_threshold);
+	mp_set_hwe(marginal_path_err_rate_threshold);
+	mp_set_conf(marginal_path_err_rate_threshold);
+	mp_set_default(marginal_path_err_rate_threshold, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->marginal_path_err_rate_threshold);
+	condlog(3, "%s: marginal_path_err_rate_threshold = %s %s", mp->alias, buff,
+			origin);
+	return 0;
+}
+
+int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(marginal_path_err_recheck_gap_time);
+	mp_set_ovr(marginal_path_err_recheck_gap_time);
+	mp_set_hwe(marginal_path_err_recheck_gap_time);
+	mp_set_conf(marginal_path_err_recheck_gap_time);
+	mp_set_default(marginal_path_err_recheck_gap_time, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->marginal_path_err_recheck_gap_time);
+	condlog(3, "%s: marginal_path_err_recheck_gap_time = %s %s", mp->alias, buff,
+			origin);
+	return 0;
+}
+
+int select_marginal_path_double_failed_time(struct config *conf,struct multipath *mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(marginal_path_double_failed_time);
+	mp_set_ovr(marginal_path_double_failed_time);
+	mp_set_hwe(marginal_path_double_failed_time);
+	mp_set_conf(marginal_path_double_failed_time);
+	mp_set_default(marginal_path_double_failed_time, DEFAULT_ERR_CHECKS);
+out:
+	print_off_int_undef(buff, 12, &mp->marginal_path_double_failed_time);
+	condlog(3, "%s: marginal_path_double_failed_time = %s %s", mp->alias, buff,
+			origin);
+	return 0;
+}
+
 int select_skip_kpartx (struct config *conf, struct multipath * mp)
 {
 	char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index f8e96d85..202ff0b9 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -28,6 +28,10 @@ int select_max_sectors_kb (struct config *conf, struct multipath * mp);
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp);
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp);
+int select_marginal_path_err_sample_time(struct config *conf, struct multipath *mp);
+int select_marginal_path_err_rate_threshold(struct config *conf, struct multipath *mp);
+int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multipath *mp);
+int select_marginal_path_double_failed_time(struct config *conf,struct multipath *mp);
 void reconcile_features_with_options(const char *id, char **features,
 				     int* no_path_retry,
 				     int *retain_hwhandler);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 8ea984d9..a02b28fe 100644
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
@@ -269,6 +273,10 @@ struct multipath {
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
+	int marginal_path_err_sample_time;
+	int marginal_path_err_rate_threshold;
+	int marginal_path_err_recheck_gap_time;
+	int marginal_path_double_failed_time;
 	int skip_kpartx;
 	int max_sectors_kb;
 	int force_readonly;
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index eb44da56..e74e3dad 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
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
index d9ac279f..47dca456 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -849,6 +849,74 @@ The default is: \fBno\fR
 .
 .
 .TP
+.B marginal_path_double_failed_time
+One of the four parameters of supporting path check based on accounting IO
+error such as intermittent error. When a path failed event occurs twice in
+\fImarginal_path_double_failed_time\fR seconds due to an IO error and all the
+other three parameters are set, multipathd will fail the path and enqueue
+this path into a queue of which members are sent a couple of continuous
+direct reading asynchronous IOs at a fixed sample rate of 10HZ to start IO
+error accounting process.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B marginal_path_err_sample_time
+One of the four parameters of supporting path check based on accounting IO
+error such as intermittent error. If it is set to a value no less than 120,
+when a path fail event occurs twice in \fImarginal_path_double_failed_time\fR
+second due to an IO error, multipathd will fail the path and enqueue this
+path into a queue of which members are sent a couple of continuous direct
+reading asynchronous IOs at a fixed sample rate of 10HZ to start the IO
+accounting process for the path will last for
+\fImarginal_path_err_sample_time\fR.
+If the rate of IO error on a particular path is greater than the
+\fImarginal_path_err_rate_threshold\fR, then the path will not reinstate for
+\fImarginal_path_err_rate_threshold\fR seconds unless there is only one
+active path. After \fImarginal_path_err_recheck_gap_time\fR expires, the path
+will be requeueed for rechecking. If checking result is good enough, the
+path will be reinstated.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B marginal_path_err_rate_threshold
+The error rate threshold as a permillage (1/1000). One of the four parameters
+of supporting path check based on accounting IO error such as intermittent
+error. Refer to \fImarginal_path_err_sample_time\fR. If the rate of IO errors
+on a particular path is greater than this parameter, then the path will not
+reinstate for \fImarginal_path_err_rate_threshold\fR seconds unless there is
+only one active path.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
+.B marginal_path_err_recheck_gap_time
+One of the four parameters of supporting path check based on accounting IO
+error such as intermittent error. Refer to
+\fImarginal_path_err_sample_time\fR. If this parameter is set to a positive
+value, the failed path of  which the IO error rate is larger than
+\fImarginal_path_err_rate_threshold\fR will be kept in failed state for
+\fImarginal_path_err_recheck_gap_time\fR seconds. When
+\fImarginal_path_err_recheck_gap_time\fR seconds expires, the path will be
+requeueed for checking. If checking result is good enough, the path will be
+reinstated, or else it will keep failed.
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
@@ -1119,6 +1187,14 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .TP
 .B san_path_err_recovery_time
 .TP
+.B marginal_path_err_sample_time
+.TP
+.B marginal_path_err_rate_threshold
+.TP
+.B marginal_path_err_recheck_gap_time
+.TP
+.B marginal_path_double_failed_time
+.TP
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
@@ -1246,6 +1322,14 @@ section:
 .TP
 .B san_path_err_recovery_time
 .TP
+.B marginal_path_err_sample_time
+.TP
+.B marginal_path_err_rate_threshold
+.TP
+.B marginal_path_err_recheck_gap_time
+.TP
+.B marginal_path_double_failed_time
+.TP
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
@@ -1318,6 +1402,14 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B san_path_err_recovery_time
 .TP
+.B marginal_path_err_sample_time
+.TP
+.B marginal_path_err_rate_threshold
+.TP
+.B marginal_path_err_recheck_gap_time
+.TP
+.B marginal_path_double_failed_time
+.TP
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
diff --git a/multipathd/main.c b/multipathd/main.c
index 4be2c579..39df0320 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -84,6 +84,7 @@ int uxsock_timeout;
 #include "cli_handlers.h"
 #include "lock.h"
 #include "waiter.h"
+#include "io_err_stat.h"
 #include "wwids.h"
 #include "../third-party/valgrind/drd.h"
 
@@ -1050,6 +1051,42 @@ out:
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
+		condlog(3, "io_err_stat: %s: cannot handle pathfail uevent",
+				pp->dev);
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
@@ -1134,6 +1171,14 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	if (!strncmp(uev->kernel, "dm-", 3)) {
 		if (!strncmp(uev->action, "change", 6)) {
 			r = uev_add_map(uev, vecs);
+
+			/*
+			 * the kernel-side dm-mpath issues a PATH_FAILED event
+			 * when it encounters a path IO error. It is reason-
+			 * able be the entry of path IO error accounting pro-
+			 * cess.
+			 */
+			uev_pathfail_check(uev, vecs);
 			goto out;
 		}
 		if (!strncmp(uev->action, "remove", 6)) {
@@ -1553,6 +1598,7 @@ static int check_path_reinstate_state(struct path * pp) {
 		condlog(2, "%s : hit error threshold. Delaying path reinstatement", pp->dev);
 		pp->dis_reinstate_time = curr_time.tv_sec;
 		pp->disable_reinstate = 1;
+
 		return 1;
 	} else {
 		return 0;
@@ -1684,6 +1730,16 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		return 1;
 	}
 
+	if (pp->io_err_disable_reinstate && hit_io_err_recheck_time(pp)) {
+		pp->state = PATH_SHAKY;
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
@@ -2377,6 +2433,7 @@ child (void * param)
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
+	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 1);
 
 	if (logsink == 1) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
@@ -2499,6 +2556,10 @@ child (void * param)
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
@@ -2548,6 +2609,8 @@ child (void * param)
 	remove_maps_and_stop_waiters(vecs);
 	unlock(&vecs->lock);
 
+	stop_io_err_stat_thread();
+
 	pthread_cancel(check_thr);
 	pthread_cancel(uevent_thr);
 	pthread_cancel(uxlsnr_thr);
@@ -2593,6 +2656,7 @@ child (void * param)
 	udev_unref(udev);
 	udev = NULL;
 	pthread_attr_destroy(&waiter_attr);
+	pthread_attr_destroy(&io_err_stat_attr);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.11.1
