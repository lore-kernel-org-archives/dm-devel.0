From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm statistics (updated)
Date: Thu, 28 Feb 2013 18:46:37 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1302281844380.29714@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the updated statistics patch. (you also need patch "[PATCH 1/2] 
dm-ioctl: enhanced messages" that I already posted)

Mikulas

---

dm statistics

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/dm-statistics.txt |   63 +++
 drivers/md/Makefile                           |    2 
 drivers/md/dm-ioctl.c                         |  176 +++++++---
 drivers/md/dm-stats.c                         |  443 ++++++++++++++++++++++++++
 drivers/md/dm-stats.h                         |   41 ++
 drivers/md/dm.c                               |   57 +++
 drivers/md/dm.h                               |    8 
 7 files changed, 747 insertions(+), 43 deletions(-)

Index: linux-3.8-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-ioctl.c	2013-03-01 00:42:56.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-ioctl.c	2013-03-01 00:43:27.000000000 +0100
@@ -1451,50 +1451,137 @@ static int table_status(struct dm_ioctl 
 	return 0;
 }
 
-struct dm_message_output_callback {
-	struct dm_ioctl *param;
-	size_t param_size;
-};
+static bool message_test_overflow(char *result, unsigned maxlen)
+{
+	return !maxlen || strlen(result) + 1 >= maxlen;
+}
 
-static int dm_output_message_string(struct dm_message_output_callback *c,
-				    const char *string)
+static int message_stats_create(struct mapped_device *md,
+				unsigned argc, char **argv,
+				char *result, unsigned maxlen)
 {
-	size_t len;
-	char *p;
-	if (c->param->flags & DM_BUFFER_FULL_FLAG)
-		return -1;
-	if (!(c->param->flags & DM_MESSAGE_OUT_FLAG)) {
-		p = get_result_buffer(c->param, c->param_size, &len);
-		if (!len) {
-			c->param->flags |= DM_BUFFER_FULL_FLAG;
-			return -1;
-		}
-		*p = 0;
-		c->param->data_size = c->param->data_start + 1;
-		c->param->flags |= DM_MESSAGE_OUT_FLAG;
-	}
-	p = (char *)c->param + c->param->data_size - 1;
-	len = strlen(string);
-	if (c->param->data_size + len > c->param_size) {
-		c->param->flags |= DM_BUFFER_FULL_FLAG;
-		c->param->flags &= ~DM_MESSAGE_OUT_FLAG;
-		return -1;
-	}
-	c->param->data_size += len;
-	strcpy(p, string);
-	return 0;
+	int id;
+	char dummy;
+	unsigned long long start, end, step;
+	unsigned div;
+
+	if (dm_request_based(md))
+		return -EOPNOTSUPP;
+
+	if (argc != 3)
+		return -EINVAL;
+
+	if (!strcmp(argv[1], "-")) {
+		start = 0;
+		end = dm_get_size(md);
+		if (!end)
+			end = 1;
+	} else if (sscanf(argv[1], "%llu-%llu%c", &start, &end, &dummy) != 2 ||
+		   start != (sector_t)start || end != (sector_t)end)
+		return -EINVAL;
+
+	if (start >= end)
+		return -EINVAL;
+
+	if (sscanf(argv[2], "/%u%c", &div, &dummy) == 1) {
+		step = end - start;
+		if (do_div(step, div))
+			step++;
+		if (!step)
+			step = 1;
+	} else if (sscanf(argv[2], "%llu%c", &step, &dummy) != 1 ||
+		   step != (sector_t)step || !step)
+		return -EINVAL;
+
+	/*
+	 * If a buffer overflow happens after we created the region,
+	 * it's too late (the userspace would retry with a larger
+	 * buffer, but the region id that caused the overflow is already
+	 * leaked).
+	 * So we must detect buffer overflow in advance.
+	 */
+	snprintf(result, maxlen, "%d", INT_MAX);
+	if (message_test_overflow(result, maxlen))
+		return 1;
+
+	id = dm_stats_create(dm_get_stats(md), start, end, step,
+			     dm_internal_suspend, dm_internal_resume,
+			     md);
+
+	if (id < 0)
+		return id;
+
+	snprintf(result, maxlen, "%d", id);
+
+	return 1;
+}
+
+static int message_stats_delete(struct mapped_device *md,
+				unsigned argc, char **argv)
+{
+	int id;
+	char dummy;
+
+	if (dm_request_based(md))
+		return -EOPNOTSUPP;
+
+	if (argc != 2)
+		return -EINVAL;
+
+	if (sscanf(argv[1], "%d%c", &id, &dummy) != 1 || id < 0)
+		return -EINVAL;
+
+	return dm_stats_delete(dm_get_stats(md), id);
+}
+
+static int message_stats_print(struct mapped_device *md,
+			       unsigned argc, char **argv, bool clear,
+			       char *result, unsigned maxlen)
+{
+	int id;
+	char dummy;
+
+	if (dm_request_based(md))
+		return -EOPNOTSUPP;
+
+	if (argc != 2)
+		return -EINVAL;
+
+	if (sscanf(argv[1], "%d%c", &id, &dummy) != 1 || id < 0)
+		return -EINVAL;
+
+	return dm_stats_print(dm_get_stats(md), id, clear, result, maxlen);
 }
 
 /*
  * Process device-mapper dependent messages.
- * Returns a number <= 0 if message was processed by device mapper.
- * Returns 1 if message should be delivered to the target.
+ * Returns a number <= 1 if message was processed by device mapper.
+ * Returns 2 if message should be delivered to the target.
  */
-static int message_for_md(struct mapped_device *md,
-			  struct dm_message_output_callback *c,
-			  unsigned argc, char **argv)
+static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
+			  char *result, unsigned maxlen)
 {
-	return 1;
+	int r;
+
+	if (!strcasecmp(argv[0], "@stats_create")) {
+		r = message_stats_create(md, argc, argv, result, maxlen);
+	} else if (!strcasecmp(argv[0], "@stats_delete")) {
+		r = message_stats_delete(md, argc, argv);
+	} else if (!strcasecmp(argv[0], "@stats_print")) {
+		r = message_stats_print(md, argc, argv, false, result, maxlen);
+	} else if (!strcasecmp(argv[0], "@stats_print_clear")) {
+		r = message_stats_print(md, argc, argv, true, result, maxlen);
+	} else {
+		return 2;
+	}
+
+	if (r == -EOPNOTSUPP)
+		DMWARN("Statistics are only supported for bio based devices");
+
+	if (r == -EINVAL)
+		DMWARN("Invalid parameters for message %s", argv[0]);
+
+	return r;
 }
 
 /*
@@ -1509,7 +1596,8 @@ static int target_message(struct dm_ioct
 	struct dm_target *ti;
 	struct dm_target_msg *tmsg = (void *) param + param->data_start;
 	int srcu_idx;
-	struct dm_message_output_callback c = { param, param_size };
+	size_t maxlen;
+	char *result = get_result_buffer(param, param_size, &maxlen);
 
 	md = find_device(param);
 	if (!md)
@@ -1533,8 +1621,8 @@ static int target_message(struct dm_ioct
 		goto out_argv;
 	}
 
-	r = message_for_md(md, &c, argc, argv);
-	if (r <= 0)
+	r = message_for_md(md, argc, argv, result, maxlen);
+	if (r <= 1)
 		goto out_argv;
 
 	table = dm_get_live_table(md, &srcu_idx);
@@ -1562,8 +1650,14 @@ static int target_message(struct dm_ioct
  out_argv:
 	kfree(argv);
  out:
-	if (!(param->flags & (DM_MESSAGE_OUT_FLAG | DM_BUFFER_FULL_FLAG)))
-		param->data_size = 0;
+	if (r == 1) {
+		param->flags |= DM_MESSAGE_OUT_FLAG;
+		if (message_test_overflow(result, maxlen))
+			param->flags |= DM_BUFFER_FULL_FLAG;
+		else
+			param->data_size = param->data_start + strlen(result) + 1;
+		r = 0;
+	}
 	dm_put(md);
 	return r;
 }
Index: linux-3.8-fast/drivers/md/Makefile
===================================================================
--- linux-3.8-fast.orig/drivers/md/Makefile	2013-03-01 00:42:56.000000000 +0100
+++ linux-3.8-fast/drivers/md/Makefile	2013-03-01 00:43:27.000000000 +0100
@@ -3,7 +3,7 @@
 #
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o
+		   dm-ioctl.o dm-stats.o dm-io.o dm-kcopyd.o dm-sysfs.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
Index: linux-3.8-fast/drivers/md/dm-stats.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.8-fast/drivers/md/dm-stats.c	2013-03-01 00:43:27.000000000 +0100
@@ -0,0 +1,443 @@
+#include <linux/errno.h>
+#include <linux/numa.h>
+#include <linux/slab.h>
+#include <linux/rculist.h>
+#include <linux/threads.h>
+#include <linux/preempt.h>
+#include <linux/irqflags.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/bio.h>
+#include <linux/device-mapper.h>
+
+#include "dm-stats.h"
+
+static volatile int dm_stat_need_rcu_barrier;
+
+struct dm_stat_percpu {
+	unsigned long sectors[2];
+	unsigned long ios[2];
+	unsigned long ticks[2];
+	unsigned long io_ticks;
+	unsigned long time_in_queue;
+};
+
+struct dm_stat_shared {
+	atomic_t in_flight[2];
+	unsigned long stamp;
+	struct dm_stat_percpu tmp;
+};
+
+struct dm_stat {
+	struct list_head list_entry;
+	int id;
+	size_t n_entries;
+	sector_t start;
+	sector_t end;
+	sector_t step;
+	struct rcu_head rcu_head;
+	struct dm_stat_percpu *stat_percpu[NR_CPUS];
+	struct dm_stat_shared stat_shared[0];
+};
+
+static void *kvzalloc(size_t alloc_size, int node)
+{
+	void *p;
+	if (alloc_size <= KMALLOC_MAX_SIZE) {
+		p = kzalloc_node(alloc_size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN, node);
+		if (p)
+			return p;
+	}
+	return vzalloc_node(alloc_size, node);
+}
+
+static void kvfree(void *ptr)
+{
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else
+		kfree(ptr);
+}
+
+static void dm_stat_free(struct rcu_head *head)
+{
+	struct dm_stat *m = container_of(head, struct dm_stat, rcu_head);
+	int cpu;
+	for_each_possible_cpu(cpu)
+		kvfree(m->stat_percpu[cpu]);
+	kvfree(m);
+}
+
+static int dm_stat_in_flight(struct dm_stat_shared *s)
+{
+	return atomic_read(&s->in_flight[0]) + atomic_read(&s->in_flight[1]);
+}
+
+void dm_stats_init_device(struct dm_stats *st)
+{
+	mutex_init(&st->mutex);
+	INIT_LIST_HEAD(&st->list);
+}
+
+void dm_stats_exit_device(struct dm_stats *st)
+{
+	size_t ni;
+	while (!list_empty(&st->list)) {
+		struct dm_stat *m = container_of(st->list.next, struct dm_stat, list_entry);
+		list_del(&m->list_entry);
+		for (ni = 0; ni < m->n_entries; ni++) {
+			struct dm_stat_shared *s = &m->stat_shared[ni];
+			if (dm_stat_in_flight(s)) {
+				printk(KERN_CRIT "dm-stats: leaked in-flight counter at index %lu (start %llu, end %llu, step %llu): reads %d, writes %d\n",
+					(unsigned long)ni,
+					(unsigned long long)m->start,
+					(unsigned long long)m->end,
+					(unsigned long long)m->step,
+					atomic_read(&s->in_flight[0]),
+					atomic_read(&s->in_flight[1])
+				);
+				BUG();
+			}
+		}
+		dm_stat_free(&m->rcu_head);
+	}
+}
+
+int dm_stats_create(struct dm_stats *st, sector_t start, sector_t end,
+		    sector_t step,
+		    void (*suspend_callback)(struct mapped_device *),
+		    void (*resume_callback)(struct mapped_device *),
+		    struct mapped_device *md)
+{
+	struct list_head *l;
+	struct dm_stat *s;
+	sector_t n_entries;
+	size_t ni;
+	size_t shared_alloc_size;
+	size_t percpu_alloc_size;
+	int cpu;
+	int ret_id;
+
+	if (end < start || !step)
+		return -EINVAL;
+
+	n_entries = end - start;
+	if (sector_div(n_entries, step))
+		n_entries++;
+
+	if (n_entries != (size_t)n_entries || !(n_entries + 1))
+		return -EOVERFLOW;
+
+	shared_alloc_size = sizeof(struct dm_stat) + (size_t)n_entries * sizeof(struct dm_stat_shared);
+	if ((shared_alloc_size - sizeof(struct dm_stat)) / sizeof(struct dm_stat_shared) != n_entries)
+		return -EOVERFLOW;
+
+	percpu_alloc_size = (size_t)n_entries * sizeof(struct dm_stat_percpu);
+	if (percpu_alloc_size / sizeof(struct dm_stat_percpu) != n_entries)
+		return -EOVERFLOW;
+
+	s = kvzalloc(shared_alloc_size, NUMA_NO_NODE);
+	if (!s)
+		return -ENOMEM;
+
+	s->n_entries = n_entries;
+	s->start = start;
+	s->end = end;
+	s->step = step;
+	s->id = 0;
+
+	for (ni = 0; ni < n_entries; ni++) {
+		atomic_set(&s->stat_shared[ni].in_flight[0], 0);
+		atomic_set(&s->stat_shared[ni].in_flight[1], 0);
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct dm_stat_percpu *pc = kvzalloc(percpu_alloc_size, cpu_to_node(cpu));
+		if (!pc) {
+			dm_stat_free(&s->rcu_head);
+			return -ENOMEM;
+		}
+		s->stat_percpu[cpu] = pc;
+	}
+
+	/*
+	 * Suspend/resume to make sure there is no i/o in flight,
+	 * so that newly created statistics will be exact.
+	 *
+	 * (note: we couldn't suspend earlier because we must not
+	 * allocate memory while suspended)
+	 */
+	suspend_callback(md);
+
+	mutex_lock(&st->mutex);
+	list_for_each(l, &st->list) {
+		struct dm_stat *m = container_of(l, struct dm_stat, list_entry);
+		if (m->id < s->id)
+			BUG();
+		if (m->id > s->id)
+			break;
+		if (s->id == INT_MAX) {
+			mutex_unlock(&st->mutex);
+			resume_callback(md);
+			return -ENFILE;
+		}
+		s->id++;
+	}
+	ret_id = s->id;
+	list_add_tail_rcu(&s->list_entry, l);
+	mutex_unlock(&st->mutex);
+
+	resume_callback(md);
+
+	return ret_id;
+}
+
+static struct dm_stat *dm_stats_find(struct dm_stats *st, int id)
+{
+	struct dm_stat *m;
+
+	mutex_lock(&st->mutex);
+
+	list_for_each_entry(m, &st->list, list_entry) {
+		if (m->id > id)
+			break;
+		if (m->id == id)
+			return m;
+	}
+
+	mutex_unlock(&st->mutex);
+
+	return NULL;
+}
+
+int dm_stats_delete(struct dm_stats *st, int id)
+{
+	struct dm_stat *m;
+	int cpu;
+
+	m = dm_stats_find(st, id);
+	if (!m)
+		return -ENOENT;
+
+	list_del_rcu(&m->list_entry);
+	mutex_unlock(&st->mutex);
+
+	/*
+	 * vfree can't be called from RCU callback
+	 */
+	for_each_possible_cpu(cpu)
+		if (is_vmalloc_addr(m->stat_percpu))
+			goto do_sync_free;
+	if (is_vmalloc_addr(m)) {
+do_sync_free:
+		synchronize_rcu_expedited();
+		dm_stat_free(&m->rcu_head);
+	} else {
+		dm_stat_need_rcu_barrier = 1;
+		call_rcu(&m->rcu_head, dm_stat_free);
+	}
+	return 0;
+}
+
+static void dm_stat_round(struct dm_stat_shared *s, struct dm_stat_percpu *p)
+{
+	/*
+	 * This is racy, but so is part_round_stats_single.
+	 */
+	unsigned long now = jiffies;
+	unsigned inf;
+	if (now == s->stamp)
+		return;
+	inf = dm_stat_in_flight(s);
+	if (inf) {
+		p->io_ticks += now - s->stamp;
+		p->time_in_queue += inf * (now - s->stamp);
+	}
+	s->stamp = now;
+}
+
+static void dm_stat_for_entry(struct dm_stat *m, size_t entry,
+			      unsigned long bi_rw, unsigned len, bool end,
+			      unsigned long duration)
+{
+	unsigned long idx = bi_rw & REQ_WRITE;
+	struct dm_stat_shared *s = &m->stat_shared[entry];
+	struct dm_stat_percpu *p;
+
+	/*
+	 * For strict correctness we should use local_irq_disable/enable
+	 * instead of preempt_disable/enable.
+	 *
+	 * This is racy if the driver finishes bios from non-interrupt
+	 * context as well as from interrupt context or from more different
+	 * interrupts.
+	 *
+	 * However, the race only results in not counting some events,
+	 * so it is acceptable.
+	 *
+	 * part_stat_lock()/part_stat_unlock() have this race too.
+	 */
+	preempt_disable();
+	p = &m->stat_percpu[smp_processor_id()][entry];
+
+	if (!end) {
+		dm_stat_round(s, p);
+		atomic_inc(&s->in_flight[idx]);
+	} else {
+		dm_stat_round(s, p);
+		atomic_dec(&s->in_flight[idx]);
+		p->sectors[idx] += len;
+		p->ios[idx] += 1;
+		p->ticks[idx] += duration;
+	}
+
+	preempt_enable();
+}
+
+static bool dm_stats_should_drop_bio(struct bio *bio)
+{
+	return !bio->bi_size;
+}
+
+void dm_stats_bio(struct dm_stats *st, struct bio *bio, bool end,
+		  unsigned long duration)
+{
+	struct dm_stat *m;
+	sector_t end_sector;
+
+	if (unlikely(dm_stats_should_drop_bio(bio)))
+		return;
+
+	end_sector = bio->bi_sector + bio_sectors(bio);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(m, &st->list, list_entry) {
+		sector_t rel_sector, offset;
+		unsigned todo;
+		size_t entry;
+		if (end_sector <= m->start || bio->bi_sector >= m->end)
+			continue;
+		if (unlikely(bio->bi_sector < m->start)) {
+			rel_sector = 0;
+			todo = end_sector - m->start;
+		} else {
+			rel_sector = bio->bi_sector - m->start;
+			todo = end_sector - bio->bi_sector;
+		}
+		if (unlikely(end_sector > m->end))
+			todo -= end_sector - m->end;
+		offset = sector_div(rel_sector, m->step);
+		entry = rel_sector;
+		do {
+			unsigned fragment_len;
+			BUG_ON(entry >= m->n_entries);
+			fragment_len = todo;
+			if (fragment_len > m->step - offset)
+				fragment_len = m->step - offset;
+			dm_stat_for_entry(m, entry, bio->bi_rw, fragment_len,
+					  end, duration);
+			todo -= fragment_len;
+			entry++;
+			offset = 0;
+		} while (unlikely(todo != 0));
+	}
+
+	rcu_read_unlock();
+}
+
+int dm_stats_print(struct dm_stats *st, int id, bool clear,
+		   char *result, unsigned maxlen)
+{
+	unsigned sz = 0;
+	struct dm_stat *m;
+	size_t x;
+	sector_t start, end;
+
+	m = dm_stats_find(st, id);
+	if (!m)
+		return -ENOENT;
+
+	start = m->start;
+
+	for (x = 0; x < m->n_entries; x++, start = end) {
+		int cpu;
+		struct dm_stat_shared *s = &m->stat_shared[x];
+		struct dm_stat_percpu *p;
+
+		end = start + m->step;
+		if (unlikely(end > m->end))
+			end = m->end;
+
+		local_irq_disable();
+		p = &m->stat_percpu[smp_processor_id()][x];
+		dm_stat_round(s, p);
+		local_irq_enable();
+
+		memset(&s->tmp, 0, sizeof s->tmp);
+		for_each_possible_cpu(cpu) {
+			p = &m->stat_percpu[cpu][x];
+			s->tmp.sectors[0] += p->sectors[0];
+			s->tmp.sectors[1] += p->sectors[1];
+			s->tmp.ios[0] += p->ios[0];
+			s->tmp.ios[1] += p->ios[1];
+			s->tmp.ticks[0] += p->ticks[0];
+			s->tmp.ticks[1] += p->ticks[1];
+			s->tmp.io_ticks += p->io_ticks;
+			s->tmp.time_in_queue += p->time_in_queue;
+		}
+
+		DMEMIT("%llu-%llu %lu %u %lu %lu %lu %u %lu %lu %d %lu %lu\n",
+			(unsigned long long)start,
+			(unsigned long long)end,
+			s->tmp.ios[0],
+			0U,
+			s->tmp.sectors[0],
+			s->tmp.ticks[0],
+			s->tmp.ios[1],
+			0U,
+			s->tmp.sectors[1],
+			s->tmp.ticks[1],
+			dm_stat_in_flight(s),
+			s->tmp.io_ticks,
+			s->tmp.time_in_queue
+		);
+		if (unlikely(sz + 1 >= maxlen))
+			goto buffer_overflow;
+	}
+
+	if (clear) {
+		for (x = 0; x < m->n_entries; x++) {
+			struct dm_stat_shared *s = &m->stat_shared[x];
+			struct dm_stat_percpu *p;
+			local_irq_disable();
+			p = &m->stat_percpu[smp_processor_id()][x];
+			p->sectors[0] -= s->tmp.sectors[0];
+			p->sectors[1] -= s->tmp.sectors[1];
+			p->ios[0] -= s->tmp.ios[0];
+			p->ios[1] -= s->tmp.ios[1];
+			p->ticks[0] -= s->tmp.ticks[0];
+			p->ticks[1] -= s->tmp.ticks[1];
+			p->io_ticks -= s->tmp.io_ticks;
+			p->time_in_queue -= s->tmp.time_in_queue;
+			local_irq_enable();
+		}
+	}
+
+buffer_overflow:
+	mutex_unlock(&st->mutex);
+
+	return 1;
+}
+
+int __init dm_stats_init(void)
+{
+	dm_stat_need_rcu_barrier = 0;
+	return 0;
+}
+
+void dm_stats_exit(void)
+{
+	if (dm_stat_need_rcu_barrier)
+		rcu_barrier();
+}
Index: linux-3.8-fast/drivers/md/dm-stats.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.8-fast/drivers/md/dm-stats.h	2013-03-01 00:43:27.000000000 +0100
@@ -0,0 +1,41 @@
+#ifndef DM_STATS_H
+#define DM_STATS_H
+
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/genhd.h>
+
+int dm_stats_init(void);
+void dm_stats_exit(void);
+
+struct dm_stats {
+	struct mutex mutex;
+	struct list_head list;	/* list of struct dm_stat */
+};
+
+void dm_stats_init_device(struct dm_stats *st);
+void dm_stats_exit_device(struct dm_stats *st);
+
+struct mapped_device;
+
+int dm_stats_create(struct dm_stats *st, sector_t start, sector_t end,
+		    sector_t step,
+		    void (*suspend_callback)(struct mapped_device *),
+		    void (*resume_callback)(struct mapped_device *),
+		    struct mapped_device *md);
+int dm_stats_delete(struct dm_stats *st, int id);
+
+void dm_stats_bio(struct dm_stats *st, struct bio *bio, bool end,
+		  unsigned long duration);
+
+int dm_stats_print(struct dm_stats *st, int id, bool clear,
+		   char *result, unsigned maxlen);
+
+static inline bool dm_stats_used(struct dm_stats *st)
+{
+	return !list_empty(&st->list);
+}
+
+#endif
Index: linux-3.8-fast/drivers/md/dm.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm.c	2013-03-01 00:42:57.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm.c	2013-03-01 00:43:27.000000000 +0100
@@ -176,6 +176,8 @@ struct mapped_device {
 
 	struct bio_set *bs;
 
+	struct dm_stats stats;
+
 	/*
 	 * Event handling.
 	 */
@@ -284,6 +286,7 @@ static int (*_inits[])(void) __initdata 
 	dm_io_init,
 	dm_kcopyd_init,
 	dm_interface_init,
+	dm_stats_init,
 };
 
 static void (*_exits[])(void) = {
@@ -294,6 +297,7 @@ static void (*_exits[])(void) = {
 	dm_io_exit,
 	dm_kcopyd_exit,
 	dm_interface_exit,
+	dm_stats_exit,
 };
 
 static int __init dm_init(void)
@@ -402,6 +406,16 @@ int dm_lock_for_deletion(struct mapped_d
 	return r;
 }
 
+sector_t dm_get_size(struct mapped_device *md)
+{
+	return get_capacity(md->disk);
+}
+
+struct dm_stats *dm_get_stats(struct mapped_device *md)
+{
+	return &md->stats;
+}
+
 static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
@@ -486,6 +500,9 @@ static void start_io_acct(struct dm_io *
 	part_stat_unlock();
 	atomic_set(&dm_disk(md)->part0.in_flight[rw],
 		atomic_inc_return(&md->pending[rw]));
+
+	if (unlikely(dm_stats_used(&md->stats)))
+		dm_stats_bio(&md->stats, io->bio, false, 0);
 }
 
 static void end_io_acct(struct dm_io *io)
@@ -501,6 +518,9 @@ static void end_io_acct(struct dm_io *io
 	part_stat_add(cpu, &dm_disk(md)->part0, ticks[rw], duration);
 	part_stat_unlock();
 
+	if (unlikely(dm_stats_used(&md->stats)))
+		dm_stats_bio(&md->stats, bio, true, duration);
+
 	/*
 	 * After this is decremented the bio must not be touched if it is
 	 * a flush.
@@ -1481,7 +1501,7 @@ static void _dm_request(struct request_q
 	return;
 }
 
-static int dm_request_based(struct mapped_device *md)
+int dm_request_based(struct mapped_device *md)
 {
 	return blk_queue_stackable(md->queue);
 }
@@ -1946,6 +1966,8 @@ static struct mapped_device *alloc_dev(i
 	md->flush_bio.bi_bdev = md->bdev;
 	md->flush_bio.bi_rw = WRITE_FLUSH;
 
+	dm_stats_init_device(&md->stats);
+
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
 	old_md = idr_replace(&_minor_idr, md, minor);
@@ -1999,6 +2021,7 @@ static void free_dev(struct mapped_devic
 
 	put_disk(md->disk);
 	blk_cleanup_queue(md->queue);
+	dm_stats_exit_device(&md->stats);
 	module_put(THIS_MODULE);
 	kfree(md);
 }
@@ -2673,6 +2696,38 @@ out:
 	return r;
 }
 
+/*
+ * Internal suspend/resume works like userspace-driven suspend. It waits
+ * until all bios finish and prevents issuing new bios to the target drivers.
+ * It may be used only from the kernel.
+ *
+ * Internal suspend holds md->suspend_lock, which prevents interaction with
+ * userspace-driven suspend.
+ */
+
+void dm_internal_suspend(struct mapped_device *md)
+{
+	mutex_lock(&md->suspend_lock);
+	if (dm_suspended_md(md))
+		return;
+
+	set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
+	synchronize_srcu(&md->io_barrier);
+	flush_workqueue(md->wq);
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+}
+
+void dm_internal_resume(struct mapped_device *md)
+{
+	if (dm_suspended_md(md))
+		goto done;
+
+	dm_queue_flush(md);
+
+done:
+	mutex_unlock(&md->suspend_lock);
+}
+
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
Index: linux-3.8-fast/drivers/md/dm.h
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm.h	2013-03-01 00:42:56.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm.h	2013-03-01 00:43:27.000000000 +0100
@@ -16,6 +16,8 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 
+#include "dm-stats.h"
+
 /*
  * Suspend feature flags
  */
@@ -146,10 +148,16 @@ void dm_destroy(struct mapped_device *md
 void dm_destroy_immediate(struct mapped_device *md);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
+int dm_request_based(struct mapped_device *md);
+sector_t dm_get_size(struct mapped_device *md);
+struct dm_stats *dm_get_stats(struct mapped_device *md);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 		      unsigned cookie);
 
+void dm_internal_suspend(struct mapped_device *md);
+void dm_internal_resume(struct mapped_device *md);
+
 int dm_io_init(void);
 void dm_io_exit(void);
 
Index: linux-3.8-fast/Documentation/device-mapper/dm-statistics.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.8-fast/Documentation/device-mapper/dm-statistics.txt	2013-03-01 00:43:27.000000000 +0100
@@ -0,0 +1,63 @@
+dm statistics
+=============
+
+Device mapper can calculate I/O statistics on various regions of the
+device.
+
+Each region specifies a starting sector, ending sector and step.
+Individual statistics will be collected for each step-sized area between
+starting and ending sector.
+
+Each region is identified by a region id, it is integer number that is
+uniquely assigned when creating the region. The region number must be
+supplied when querying statistics about the region or deleting the
+region. Unique region ids enable multiple userspace programs to request
+and process statistics without stepping over each other's data.
+
+Messages
+========
+
+@stats_create <range> <step>
+<range>
+	"-" - whole device
+	"<start>-<end>" - a specified range in 512-byte sectors
+<step>
+	"<number>" - the number of sectors in each area
+	"/<number>" - the range is subdivided into the specified number
+			of areas
+@stats_create message creates new region and returns the region id.
+
+@stats_print <id>
+<id>
+	region id returned from @stats_create
+@stats_print message returns statistics, each area is represented by one
+line in this form:
+<starting sector>-<ending sector> counters
+Counters have the same meaning as /sys/block/*/stat or /proc/diskstats
+The counter of merged requests is always zero because merging has no
+meaning in device mapper.
+
+@stats_print_clear <id>
+<id>
+	region id returned from @stats_create
+@stats_print_clear prints the counters (like @stats_print) and clears
+all the counters except the in-flight i/o counters.
+
+@stats_delete <id>
+<id>
+	region id returned from @stats_create
+Deletes the range with the specified id.
+
+Example
+=======
+
+Subdivide the logical volume vg1/lv into 100 pieces and start collecting
+statistics on them:
+dmsetup message vg1-lv 0 @stats_create - /100
+
+Print the statistics:
+dmsetup message vg1-lv 0 @stats_print 0
+
+Delete the statistics:
+dmsetup message vg1-lv 0 @stats_delete 0
+
