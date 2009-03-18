From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/3] dm-mpath: add service-time oriented dynamic
	load balancer
Date: Wed, 18 Mar 2009 17:40:28 +0900
Message-ID: <49C0B37C.2020305@ct.jp.nec.com>
References: <49C0B222.9010600@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C0B222.9010600@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds a service time oriented dynamic load balancer,
dm-service-time, which selects a path with the shortest estimated
service time for the incoming I/O.
The service time is estimated by dividing the in-flight I/O size
with performance value of each path.

The performance value can be given as a table argument at the table
loading time.  If no performance value is given, all paths are
recognized as equal performance.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/Kconfig           |    9 +
 drivers/md/Makefile          |    1 
 drivers/md/dm-service-time.c |  301 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 311 insertions(+)

Index: 2.6.29-rc8/drivers/md/dm-service-time.c
===================================================================
--- /dev/null
+++ 2.6.29-rc8/drivers/md/dm-service-time.c
@@ -0,0 +1,301 @@
+/*
+ * Copyright (C) 2007-2009 NEC Corporation.  All Rights Reserved.
+ *
+ * Module Author: Kiyoshi Ueda
+ *
+ * This file is released under the GPL.
+ *
+ * Throughput oriented path selector.
+ */
+
+#include "dm.h"
+#include "dm-path-selector.h"
+
+#define DM_MSG_PREFIX	"multipath service-time"
+#define ST_MIN_IO	1
+#define ST_VERSION	"0.1.0"
+
+struct selector {
+	struct list_head valid_paths;
+	struct list_head failed_paths;
+};
+
+struct path_info {
+	struct list_head list;
+	struct dm_path *path;
+	unsigned int repeat_count;
+	size_t perf;
+	atomic_t in_flight_size;	/* Total size of in-flight I/Os */
+};
+
+static struct selector *alloc_selector(void)
+{
+	struct selector *s = kmalloc(sizeof(*s), GFP_KERNEL);
+
+	if (s) {
+		INIT_LIST_HEAD(&s->valid_paths);
+		INIT_LIST_HEAD(&s->failed_paths);
+	}
+
+	return s;
+}
+
+static int st_create(struct path_selector *ps, unsigned argc, char **argv)
+{
+	struct selector *s = alloc_selector();
+
+	if (!s)
+		return -ENOMEM;
+
+	ps->context = s;
+	return 0;
+}
+
+static void free_paths(struct list_head *paths)
+{
+	struct path_info *pi, *next;
+
+	list_for_each_entry_safe(pi, next, paths, list) {
+		list_del(&pi->list);
+		kfree(pi);
+	}
+}
+
+static void st_destroy(struct path_selector *ps)
+{
+	struct selector *s = (struct selector *) ps->context;
+
+	free_paths(&s->valid_paths);
+	free_paths(&s->failed_paths);
+	kfree(s);
+	ps->context = NULL;
+}
+
+static int st_status(struct path_selector *ps, struct dm_path *path,
+		     status_type_t type, char *result, unsigned int maxlen)
+{
+	int sz = 0;
+	struct path_info *pi;
+
+	if (!path)
+		DMEMIT("0 ");
+	else {
+		pi = path->pscontext;
+
+		switch (type) {
+		case STATUSTYPE_INFO:
+			DMEMIT("%u %lu ", atomic_read(&pi->in_flight_size),
+			       pi->perf);
+			break;
+		case STATUSTYPE_TABLE:
+			DMEMIT("%u %lu ", pi->repeat_count, pi->perf);
+			break;
+		}
+	}
+
+	return sz;
+}
+
+static int st_add_path(struct path_selector *ps, struct dm_path *path,
+		       int argc, char **argv, char **error)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi;
+	unsigned int repeat_count = ST_MIN_IO;
+	size_t perf = 1;
+
+	if (argc > 2) {
+		*error = "service-time ps: incorrect number of arguments";
+		return -EINVAL;
+	}
+
+	/* First path argument is number of I/Os before switching path. */
+	if ((argc > 0) && (sscanf(argv[0], "%u", &repeat_count) != 1)) {
+		*error = "service-time ps: invalid repeat count";
+		return -EINVAL;
+	}
+
+	/*
+	 * Second path argument is a relative performance value.
+	 * If 0 is given, the path isn't used while other paths having
+	 * a positive value are available.
+	 */
+	if ((argc == 2) && (sscanf(argv[1], "%lu", &perf) != 1)) {
+		*error = "service-time ps: invalid performance value";
+		return -EINVAL;
+	}
+
+	/* allocate the path */
+	pi = kmalloc(sizeof(*pi), GFP_KERNEL);
+	if (!pi) {
+		*error = "service-time ps: Error allocating path context";
+		return -ENOMEM;
+	}
+
+	pi->path = path;
+	pi->repeat_count = repeat_count;
+	pi->perf = perf;
+	atomic_set(&pi->in_flight_size, 0);
+
+	path->pscontext = pi;
+
+	list_add_tail(&pi->list, &s->valid_paths);
+
+	return 0;
+}
+
+static void st_fail_path(struct path_selector *ps, struct dm_path *path)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi = path->pscontext;
+
+	list_move(&pi->list, &s->failed_paths);
+}
+
+static int st_reinstate_path(struct path_selector *ps, struct dm_path *path)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi = path->pscontext;
+
+	list_move_tail(&pi->list, &s->valid_paths);
+
+	return 0;
+}
+
+/*
+ * Returns:
+ * < 0 : pi1 is better
+ * 0   : no difference between pi1 and pi2
+ * > 0 : pi2 is better
+ */
+static int st_compare_load(struct path_info *pi1, struct path_info *pi2,
+			   size_t incoming)
+{
+	size_t sz1, sz2;
+
+	sz1 = atomic_read(&pi1->in_flight_size);
+	sz2 = atomic_read(&pi2->in_flight_size);
+
+	/*
+	 * Case 1: Both have same performace value. Choose less loaded path.
+	 */
+	if (pi1->perf == pi2->perf)
+		return sz1 - sz2;
+
+	/*
+	 * Case 2a: Both have same load. Choose higher performance path.
+	 * Case 2b: One path has no performance value. Choose the other one.
+	 */
+	if (sz1 == sz2 || !pi1->perf || !pi2->perf)
+		return pi2->perf - pi1->perf;
+
+	/*
+	 * Case 3: Calculate service time. Choose faster path.
+	 *         if ((sz1+incoming)/pi1->perf < (sz2+incoming)/pi2->perf) pi1
+	 *         if ((sz1+incoming)/pi1->perf > (sz2+incoming)/pi2->perf) pi2
+	 */
+	sz1 += incoming;
+	sz2 += incoming;
+	while (sz1 && sz2 && (sz1 < pi1->perf) && (sz2 < pi2->perf)) {
+		/* Size is not big enough to compare by division. Shift up */
+		sz1 <<= 2;
+		sz2 <<= 2;
+	}
+	do_div(sz1, pi1->perf);
+	do_div(sz2, pi2->perf);
+
+	if (sz1 != sz2)
+		return sz1 - sz2;
+
+	/*
+	 * Case 4: Service time is equal. Choose higher performance path.
+	 */
+	return pi2->perf - pi1->perf;
+}
+
+static struct dm_path *st_select_path(struct path_selector *ps,
+				      unsigned *repeat_count, size_t nr_bytes)
+{
+	struct selector *s = (struct selector *) ps->context;
+	struct path_info *pi = NULL, *best = NULL;
+
+	if (list_empty(&s->valid_paths))
+		return NULL;
+
+	/* Change preferred (first in list) path to evenly balance. */
+	list_move_tail(s->valid_paths.next, &s->valid_paths);
+
+	list_for_each_entry(pi, &s->valid_paths, list)
+		if (!best || (st_compare_load(pi, best, nr_bytes) < 0))
+			best = pi;
+
+	if (!best)
+		return NULL;
+
+	*repeat_count = best->repeat_count;
+
+	return best->path;
+}
+
+static int st_start_io(struct path_selector *ps, struct dm_path *path,
+		       size_t nr_bytes)
+{
+	struct path_info *pi = path->pscontext;
+
+	atomic_add(nr_bytes, &pi->in_flight_size);
+
+	return 0;
+}
+
+static int st_end_io(struct path_selector *ps, struct dm_path *path,
+		     size_t nr_bytes)
+{
+	struct path_info *pi = path->pscontext;
+
+	atomic_sub(nr_bytes, &pi->in_flight_size);
+
+	return 0;
+}
+
+static struct path_selector_type st_ps = {
+	.name		= "service-time",
+	.module		= THIS_MODULE,
+	.table_args	= 2,
+	.info_args	= 2,
+	.create		= st_create,
+	.destroy	= st_destroy,
+	.status		= st_status,
+	.add_path	= st_add_path,
+	.fail_path	= st_fail_path,
+	.reinstate_path	= st_reinstate_path,
+	.select_path	= st_select_path,
+	.start_io	= st_start_io,
+	.end_io		= st_end_io,
+};
+
+static int __init dm_st_init(void)
+{
+	int r = dm_register_path_selector(&st_ps);
+
+	if (r < 0)
+		DMERR("register failed %d", r);
+
+	DMINFO("version " ST_VERSION " loaded");
+
+	return r;
+}
+
+static void __exit dm_st_exit(void)
+{
+	int r = dm_unregister_path_selector(&st_ps);
+
+	if (r < 0)
+		DMERR("unregister failed %d", r);
+}
+
+module_init(dm_st_init);
+module_exit(dm_st_exit);
+
+MODULE_DESCRIPTION(DM_NAME " throughput oriented path selector");
+MODULE_AUTHOR("Kiyoshi Ueda <k-ueda@ct.jp.nec.com>");
+MODULE_LICENSE("GPL");
Index: 2.6.29-rc8/drivers/md/Makefile
===================================================================
--- 2.6.29-rc8.orig/drivers/md/Makefile
+++ 2.6.29-rc8/drivers/md/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
+obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
Index: 2.6.29-rc8/drivers/md/Kconfig
===================================================================
--- 2.6.29-rc8.orig/drivers/md/Kconfig
+++ 2.6.29-rc8/drivers/md/Kconfig
@@ -283,6 +283,15 @@ config DM_MULTIPATH_QL
 
 	  If unsure, say N.
 
+config DM_MULTIPATH_ST
+	tristate "I/O Path Selector based on the service time"
+	depends on DM_MULTIPATH
+	---help---
+	  This path selector is a dynamic load balancer which selects
+	  a path to complete the incoming I/O with the shortest time.
+
+	  If unsure, say N.
+
 config DM_DELAY
 	tristate "I/O delaying target (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
