From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] dm stats: report histogram of latencies
Date: Tue, 9 Jun 2015 17:22:05 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506091721430.1545@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Coly Li <colyli@gmail.com>
Cc: Tao Ma <boyu.mt@taobao.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Robin Dong <sanbai@alibaba-inc.com>
List-Id: dm-devel.ids

This patch adds an option to dm statistics to collect and report the
histogram of latencies.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/statistics.txt |   21 ++-
 drivers/md/dm-stats.c                      |  201 +++++++++++++++++++++++++----
 2 files changed, 196 insertions(+), 26 deletions(-)

Index: linux-4.1-rc7/drivers/md/dm-stats.c
===================================================================
--- linux-4.1-rc7.orig/drivers/md/dm-stats.c	2015-06-08 16:38:43.000000000 +0200
+++ linux-4.1-rc7/drivers/md/dm-stats.c	2015-06-08 17:02:01.000000000 +0200
@@ -29,6 +29,7 @@ struct dm_stat_percpu {
 	unsigned long long io_ticks[2];
 	unsigned long long io_ticks_total;
 	unsigned long long time_in_queue;
+	unsigned long long *histogram;
 };
 
 struct dm_stat_shared {
@@ -45,11 +46,14 @@ struct dm_stat {
 	sector_t start;
 	sector_t end;
 	sector_t step;
+	unsigned n_histogram_entries;
+	unsigned long long *histogram_boundaries;
 	const char *program_id;
 	const char *aux_data;
 	struct rcu_head rcu_head;
 	size_t shared_alloc_size;
 	size_t percpu_alloc_size;
+	size_t histogram_alloc_size;
 	struct dm_stat_percpu *stat_percpu[NR_CPUS];
 	struct dm_stat_shared stat_shared[0];
 };
@@ -176,8 +180,11 @@ static void dm_stat_free(struct rcu_head
 
 	kfree(s->program_id);
 	kfree(s->aux_data);
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
 		dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+	}
+	dm_kvfree(s->stat_shared[0].tmp.histogram, s->histogram_alloc_size);
 	dm_kvfree(s, s->shared_alloc_size);
 }
 
@@ -231,6 +238,8 @@ void dm_stats_cleanup(struct dm_stats *s
 
 static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 			   sector_t step, unsigned stat_flags,
+			   unsigned n_histogram_entries,
+			   unsigned long long *histogram_boundaries,
 			   const char *program_id, const char *aux_data,
 			   void (*suspend_callback)(struct mapped_device *),
 			   void (*resume_callback)(struct mapped_device *),
@@ -242,6 +251,7 @@ static int dm_stats_create(struct dm_sta
 	size_t ni;
 	size_t shared_alloc_size;
 	size_t percpu_alloc_size;
+	size_t histogram_alloc_size;
 	struct dm_stat_percpu *p;
 	int cpu;
 	int ret_id;
@@ -265,7 +275,11 @@ static int dm_stats_create(struct dm_sta
 	if (percpu_alloc_size / sizeof(struct dm_stat_percpu) != n_entries)
 		return -EOVERFLOW;
 
-	if (!check_shared_memory(shared_alloc_size + num_possible_cpus() * percpu_alloc_size))
+	histogram_alloc_size = (n_histogram_entries + 1) * (size_t)n_entries * sizeof(unsigned long long);
+	if (histogram_alloc_size / (n_histogram_entries + 1) != (size_t)n_entries * sizeof(unsigned long long))
+		return -EOVERFLOW;
+
+	if (!check_shared_memory(shared_alloc_size + histogram_alloc_size + num_possible_cpus() * (percpu_alloc_size + histogram_alloc_size)))
 		return -ENOMEM;
 
 	s = dm_kvzalloc(shared_alloc_size, NUMA_NO_NODE);
@@ -279,6 +293,14 @@ static int dm_stats_create(struct dm_sta
 	s->step = step;
 	s->shared_alloc_size = shared_alloc_size;
 	s->percpu_alloc_size = percpu_alloc_size;
+	s->histogram_alloc_size = histogram_alloc_size;
+
+	s->n_histogram_entries = n_histogram_entries;
+	s->histogram_boundaries = kmemdup(histogram_boundaries, s->n_histogram_entries * sizeof(unsigned long long), GFP_KERNEL);
+	if (!s->histogram_boundaries) {
+		r = -ENOMEM;
+		goto out;
+	}
 
 	s->program_id = kstrdup(program_id, GFP_KERNEL);
 	if (!s->program_id) {
@@ -296,6 +318,19 @@ static int dm_stats_create(struct dm_sta
 		atomic_set(&s->stat_shared[ni].in_flight[WRITE], 0);
 	}
 
+	if (s->n_histogram_entries) {
+		unsigned long long *hi;
+		hi = dm_kvzalloc(s->histogram_alloc_size, NUMA_NO_NODE);
+		if (!hi) {
+			r = -ENOMEM;
+			goto out;
+		}
+		for (ni = 0; ni < n_entries; ni++) {
+			s->stat_shared[ni].tmp.histogram = hi;
+			hi += s->n_histogram_entries + 1;
+		}
+	}
+
 	for_each_possible_cpu(cpu) {
 		p = dm_kvzalloc(percpu_alloc_size, cpu_to_node(cpu));
 		if (!p) {
@@ -303,6 +338,18 @@ static int dm_stats_create(struct dm_sta
 			goto out;
 		}
 		s->stat_percpu[cpu] = p;
+		if (s->n_histogram_entries) {
+			unsigned long long *hi;
+			hi = dm_kvzalloc(s->histogram_alloc_size, cpu_to_node(cpu));
+			if (!hi) {
+				r = -ENOMEM;
+				goto out;
+			}
+			for (ni = 0; ni < n_entries; ni++) {
+				p[ni].histogram = hi;
+				hi += s->n_histogram_entries + 1;
+			}
+		}
 	}
 
 	/*
@@ -380,9 +427,11 @@ static int dm_stats_delete(struct dm_sta
 	 * vfree can't be called from RCU callback
 	 */
 	for_each_possible_cpu(cpu)
-		if (is_vmalloc_addr(s->stat_percpu))
+		if (is_vmalloc_addr(s->stat_percpu) ||
+		    is_vmalloc_addr(s->stat_percpu[cpu][0].histogram))
 			goto do_sync_free;
-	if (is_vmalloc_addr(s)) {
+	if (is_vmalloc_addr(s) ||
+	    is_vmalloc_addr(s->stat_shared[0].tmp.histogram)) {
 do_sync_free:
 		synchronize_rcu_expedited();
 		dm_stat_free(&s->rcu_head);
@@ -490,15 +539,32 @@ static void dm_stat_for_entry(struct dm_
 		dm_stat_round(s, shared, p);
 		atomic_inc(&shared->in_flight[idx]);
 	} else {
+		unsigned long long duration;
 		dm_stat_round(s, shared, p);
 		atomic_dec(&shared->in_flight[idx]);
 		p->sectors[idx] += len;
 		p->ios[idx] += 1;
 		p->merges[idx] += stats_aux->merged;
-		if (!(s->stat_flags & STAT_PRECISE_TIMESTAMPS))
+		if (!(s->stat_flags & STAT_PRECISE_TIMESTAMPS)) {
 			p->ticks[idx] += duration_jiffies;
-		else
+			duration = jiffies_to_msecs(duration_jiffies);
+		} else {
 			p->ticks[idx] += stats_aux->duration_ns;
+			duration = stats_aux->duration_ns;
+		}
+		if (s->n_histogram_entries) {
+			unsigned lo = 0, hi = s->n_histogram_entries + 1;
+			while (lo + 1 < hi) {
+				unsigned mid = (lo + hi) / 2;
+				if (s->histogram_boundaries[mid - 1] > duration) {
+					hi = mid;
+				} else {
+					lo = mid;
+				}
+
+			}
+			p->histogram[lo]++;
+		}
 	}
 
 #if BITS_PER_LONG == 32
@@ -604,7 +670,22 @@ static void __dm_stat_init_temporary_per
 	dm_stat_round(s, shared, p);
 	local_irq_enable();
 
-	memset(&shared->tmp, 0, sizeof(shared->tmp));
+	shared->tmp.sectors[READ] = 0;
+	shared->tmp.sectors[WRITE] = 0;
+	shared->tmp.ios[READ] = 0;
+	shared->tmp.ios[WRITE] = 0;
+	shared->tmp.merges[READ] = 0;
+	shared->tmp.merges[WRITE] = 0;
+	shared->tmp.ticks[READ] = 0;
+	shared->tmp.ticks[WRITE] = 0;
+	shared->tmp.io_ticks[READ] = 0;
+	shared->tmp.io_ticks[WRITE] = 0;
+	shared->tmp.io_ticks_total = 0;
+	shared->tmp.time_in_queue = 0;
+
+	if (s->n_histogram_entries)
+		memset(shared->tmp.histogram, 0, (s->n_histogram_entries + 1) * sizeof(unsigned long long));
+
 	for_each_possible_cpu(cpu) {
 		p = &s->stat_percpu[cpu][x];
 		shared->tmp.sectors[READ] += ACCESS_ONCE(p->sectors[READ]);
@@ -619,6 +700,11 @@ static void __dm_stat_init_temporary_per
 		shared->tmp.io_ticks[WRITE] += ACCESS_ONCE(p->io_ticks[WRITE]);
 		shared->tmp.io_ticks_total += ACCESS_ONCE(p->io_ticks_total);
 		shared->tmp.time_in_queue += ACCESS_ONCE(p->time_in_queue);
+		if (s->n_histogram_entries) {
+			unsigned i;
+			for (i = 0; i < s->n_histogram_entries + 1; i++)
+				shared->tmp.histogram[i] += ACCESS_ONCE(p->histogram[i]);
+		}
 	}
 }
 
@@ -648,6 +734,15 @@ static void __dm_stat_clear(struct dm_st
 		p->io_ticks_total -= shared->tmp.io_ticks_total;
 		p->time_in_queue -= shared->tmp.time_in_queue;
 		local_irq_enable();
+		if (s->n_histogram_entries) {
+			unsigned i;
+			for (i = 0; i < s->n_histogram_entries + 1; i++) {
+				local_irq_disable();
+				p = &s->stat_percpu[smp_processor_id()][x];
+				p->histogram[i] -= shared->tmp.histogram[i];
+				local_irq_enable();
+			}
+		}
 	}
 }
 
@@ -737,7 +832,7 @@ static int dm_stats_print(struct dm_stat
 
 		__dm_stat_init_temporary_percpu_totals(shared, s, x);
 
-		DMEMIT("%llu+%llu %llu %llu %llu %llu %llu %llu %llu %llu %d %llu %llu %llu %llu\n",
+		DMEMIT("%llu+%llu %llu %llu %llu %llu %llu %llu %llu %llu %d %llu %llu %llu %llu",
 		       (unsigned long long)start,
 		       (unsigned long long)step,
 		       shared->tmp.ios[READ],
@@ -753,6 +848,13 @@ static int dm_stats_print(struct dm_stat
 		       dm_jiffies_to_msec64(s, shared->tmp.time_in_queue),
 		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[READ]),
 		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[WRITE]));
+		if (s->n_histogram_entries) {
+			unsigned i;
+			for (i = 0; i < s->n_histogram_entries + 1; i++) {
+				DMEMIT("%s%llu", !i ? " " : ":", shared->tmp.histogram[i]);
+			}
+		}
+		DMEMIT("\n");
 
 		if (unlikely(sz + 1 >= maxlen))
 			goto buffer_overflow;
@@ -794,10 +896,46 @@ static int dm_stats_set_aux(struct dm_st
 	return 0;
 }
 
+static int parse_histogram(const char *h, unsigned *n_histogram_entries, unsigned long long **histogram_boundaries)
+{
+	const char *q;
+	unsigned n;
+	unsigned long long last;
+
+	*n_histogram_entries = 1;
+	for (q = h; *q; q++)
+		if (*q == ',')
+			(*n_histogram_entries)++;
+
+	*histogram_boundaries = kmalloc(*n_histogram_entries * sizeof(unsigned long long), GFP_KERNEL);
+	if (!*histogram_boundaries)
+		return -ENOMEM;
+
+	n = 0;
+	last = 0;
+	while (1) {
+		unsigned long long hi;
+		int s;
+		char ch;
+		s = sscanf(h, "%llu%c", &hi, &ch);
+		if (!s || (s == 2 && ch != ','))
+			return -EINVAL;
+		if (hi <= last)
+			return -EINVAL;
+		last = hi;
+		(*histogram_boundaries)[n] = hi;
+		if (s == 1)
+			return 0;
+		h = strchr(h, ',') + 1;
+		n++;
+	}
+}
+
 static int message_stats_create(struct mapped_device *md,
 				unsigned argc, char **argv,
 				char *result, unsigned maxlen)
 {
+	int r;
 	int id;
 	char dummy;
 	unsigned long long start, end, len, step;
@@ -805,6 +943,9 @@ static int message_stats_create(struct m
 	const char *program_id, *aux_data;
 	unsigned stat_flags = 0;
 
+	unsigned n_histogram_entries = 0;
+	unsigned long long *histogram_boundaries = NULL;
+
 	struct dm_arg_set as, as_backup;
 	const char *a;
 	unsigned feature_args;
@@ -815,7 +956,7 @@ static int message_stats_create(struct m
 	 */
 
 	if (argc < 3)
-		return -EINVAL;
+		goto ret_einval;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -829,11 +970,11 @@ static int message_stats_create(struct m
 			len = 1;
 	} else if (sscanf(a, "%llu+%llu%c", &start, &len, &dummy) != 2 ||
 		   start != (sector_t)start || len != (sector_t)len)
-		return -EINVAL;
+		goto ret_einval;
 
 	end = start + len;
 	if (start >= end)
-		return -EINVAL;
+		goto ret_einval;
 
 	a = dm_shift_arg(&as);
 	if (sscanf(a, "/%u%c", &divisor, &dummy) == 1) {
@@ -846,7 +987,7 @@ static int message_stats_create(struct m
 			step = 1;
 	} else if (sscanf(a, "%llu%c", &step, &dummy) != 1 ||
 		   step != (sector_t)step || !step)
-		return -EINVAL;
+		goto ret_einval;
 
 	as_backup = as;
 	a = dm_shift_arg(&as);
@@ -854,11 +995,16 @@ static int message_stats_create(struct m
 		while (feature_args--) {
 			a = dm_shift_arg(&as);
 			if (!a)
-				return -EINVAL;
+				goto ret_einval;
 			if (!strcasecmp(a, "precise_timestamps"))
 				stat_flags |= STAT_PRECISE_TIMESTAMPS;
-			else
-				return -EINVAL;
+			else if (!strncasecmp(a, "histogram:", 10)) {
+				if (n_histogram_entries)
+					goto ret_einval;
+				if ((r = parse_histogram(a + 10, &n_histogram_entries, &histogram_boundaries)))
+					goto ret;
+			} else
+				goto ret_einval;
 		}
 	} else {
 		as = as_backup;
@@ -876,7 +1022,7 @@ static int message_stats_create(struct m
 		aux_data = a;
 
 	if (as.argc)
-		return -EINVAL;
+		goto ret_einval;
 
 	/*
 	 * If a buffer overflow happens after we created the region,
@@ -885,17 +1031,28 @@ static int message_stats_create(struct m
 	 * leaked).  So we must detect buffer overflow in advance.
 	 */
 	snprintf(result, maxlen, "%d", INT_MAX);
-	if (dm_message_test_buffer_overflow(result, maxlen))
-		return 1;
+	if (dm_message_test_buffer_overflow(result, maxlen)) {
+		r = 1;
+		goto ret;
+	}
 
-	id = dm_stats_create(dm_get_stats(md), start, end, step, stat_flags, program_id, aux_data,
+	id = dm_stats_create(dm_get_stats(md), start, end, step, stat_flags, n_histogram_entries, histogram_boundaries, program_id, aux_data,
 			     dm_internal_suspend_fast, dm_internal_resume_fast, md);
-	if (id < 0)
-		return id;
+	if (id < 0) {
+		r = id;
+		goto ret;
+	}
 
 	snprintf(result, maxlen, "%d", id);
 
-	return 1;
+	r = 1;
+	goto ret;
+
+ret_einval:
+	r = -EINVAL;
+ret:
+	kfree(histogram_boundaries);
+	return r;
 }
 
 static int message_stats_delete(struct mapped_device *md,
Index: linux-4.1-rc7/Documentation/device-mapper/statistics.txt
===================================================================
--- linux-4.1-rc7.orig/Documentation/device-mapper/statistics.txt	2015-06-08 17:02:11.000000000 +0200
+++ linux-4.1-rc7/Documentation/device-mapper/statistics.txt	2015-06-08 17:08:49.000000000 +0200
@@ -13,9 +13,10 @@ the range specified.
 The I/O statistics counters for each step-sized area of a region are
 in the same format as /sys/block/*/stat or /proc/diskstats (see:
 Documentation/iostats.txt).  But two extra counters (12 and 13) are
-provided: total time spent reading and writing.  All these counters may
-be accessed by sending the @stats_print message to the appropriate DM
-device via dmsetup.
+provided: total time spent reading and writing.  When the histogram
+argument is used, the 14th parameter is reported that represents the
+histogram of latencies.  All these counters may be accessed by sending
+the @stats_print message to the appropriate DM device via dmsetup.
 
 The reported times are in milliseconds and the granularity depends on
 the kernel ticks.  When the option precise_timestamps is used, the
@@ -60,10 +61,22 @@ Messages
 	<optional_arguments>
 	  The following optional arguments are supported
 	  precise_timestamps - use precise timer with nanosecond resolution
-	  	instead of the "jiffies" variable.  When this argument is
+		instead of the "jiffies" variable.  When this argument is
 		used, the resulting times are in nanoseconds instead of
 		milliseconds.  Precise timestamps are a little bit slower
 		to obtain than jiffies-based timestamps.
+	  histogram:n1,n2,n3,n4,... - collect histogram of latencies.  The
+		numbers n1, n2, etc are times that represent the boundaries
+		of the histogram.  If precise_timestamps is not used, the
+		times are in milliseconds, otherwise they are in
+		nanoseconds.  For each range, the kernel will report the
+		number of requests that completed within this range. For
+		example, if we use "histogram:10,20,30", the kernel will
+		report four numbers a:b:c:d. a is the number of requests
+		that took 0-10 ms to complete, b is the number of requests
+		that took 10-20 ms to complete, c is the number of requests
+		that took 20-30 ms to complete and d is the number of
+		requests that took more than 30 ms to complete.
 
 	<program_id>
 	  An optional parameter.  A name that uniquely identifies
