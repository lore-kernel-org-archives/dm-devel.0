From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] dm stats: support precise timestamps
Date: Tue, 9 Jun 2015 17:21:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
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

This patch makes it possible to use precise timestamps with nanosecond
granularity in dm statistics.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/statistics.txt |   25 ++++-
 drivers/md/dm-stats.c                      |  139 +++++++++++++++++++++--------
 drivers/md/dm-stats.h                      |    4 
 3 files changed, 125 insertions(+), 43 deletions(-)

Index: linux-4.1-rc7/drivers/md/dm-stats.c
===================================================================
--- linux-4.1-rc7.orig/drivers/md/dm-stats.c	2015-06-08 16:02:27.000000000 +0200
+++ linux-4.1-rc7/drivers/md/dm-stats.c	2015-06-08 16:38:43.000000000 +0200
@@ -33,13 +33,14 @@ struct dm_stat_percpu {
 
 struct dm_stat_shared {
 	atomic_t in_flight[2];
-	unsigned long stamp;
+	unsigned long long stamp;
 	struct dm_stat_percpu tmp;
 };
 
 struct dm_stat {
 	struct list_head list_entry;
 	int id;
+	unsigned stat_flags;
 	size_t n_entries;
 	sector_t start;
 	sector_t end;
@@ -53,6 +54,8 @@ struct dm_stat {
 	struct dm_stat_shared stat_shared[0];
 };
 
+#define STAT_PRECISE_TIMESTAMPS		1
+
 struct dm_stats_last_position {
 	sector_t last_sector;
 	unsigned last_rw;
@@ -227,7 +230,8 @@ void dm_stats_cleanup(struct dm_stats *s
 }
 
 static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
-			   sector_t step, const char *program_id, const char *aux_data,
+			   sector_t step, unsigned stat_flags,
+			   const char *program_id, const char *aux_data,
 			   void (*suspend_callback)(struct mapped_device *),
 			   void (*resume_callback)(struct mapped_device *),
 			   struct mapped_device *md)
@@ -268,6 +272,7 @@ static int dm_stats_create(struct dm_sta
 	if (!s)
 		return -ENOMEM;
 
+	s->stat_flags = stat_flags;
 	s->n_entries = n_entries;
 	s->start = start;
 	s->end = end;
@@ -417,15 +422,22 @@ static int dm_stats_list(struct dm_stats
 	return 1;
 }
 
-static void dm_stat_round(struct dm_stat_shared *shared, struct dm_stat_percpu *p)
+static void dm_stat_round(struct dm_stat *s, struct dm_stat_shared *shared,
+			  struct dm_stat_percpu *p)
 {
 	/*
 	 * This is racy, but so is part_round_stats_single.
 	 */
-	unsigned long now = jiffies;
-	unsigned in_flight_read;
-	unsigned in_flight_write;
-	unsigned long difference = now - shared->stamp;
+	unsigned long long now, difference;
+	unsigned in_flight_read, in_flight_write;
+
+	if (likely(!(s->stat_flags & STAT_PRECISE_TIMESTAMPS))) {
+		now = jiffies;
+	} else {
+		now = ktime_to_ns(ktime_get());
+	}
+
+	difference = now - shared->stamp;
 
 	if (!difference)
 		return;
@@ -443,8 +455,9 @@ static void dm_stat_round(struct dm_stat
 }
 
 static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
-			      unsigned long bi_rw, sector_t len, bool merged,
-			      bool end, unsigned long duration)
+			      unsigned long bi_rw, sector_t len,
+			      struct dm_stats_aux *stats_aux, bool end,
+			      unsigned long duration_jiffies)
 {
 	unsigned long idx = bi_rw & REQ_WRITE;
 	struct dm_stat_shared *shared = &s->stat_shared[entry];
@@ -474,15 +487,18 @@ static void dm_stat_for_entry(struct dm_
 	p = &s->stat_percpu[smp_processor_id()][entry];
 
 	if (!end) {
-		dm_stat_round(shared, p);
+		dm_stat_round(s, shared, p);
 		atomic_inc(&shared->in_flight[idx]);
 	} else {
-		dm_stat_round(shared, p);
+		dm_stat_round(s, shared, p);
 		atomic_dec(&shared->in_flight[idx]);
 		p->sectors[idx] += len;
 		p->ios[idx] += 1;
-		p->merges[idx] += merged;
-		p->ticks[idx] += duration;
+		p->merges[idx] += stats_aux->merged;
+		if (!(s->stat_flags & STAT_PRECISE_TIMESTAMPS))
+			p->ticks[idx] += duration_jiffies;
+		else
+			p->ticks[idx] += stats_aux->duration_ns;
 	}
 
 #if BITS_PER_LONG == 32
@@ -494,7 +510,7 @@ static void dm_stat_for_entry(struct dm_
 
 static void __dm_stat_bio(struct dm_stat *s, unsigned long bi_rw,
 			  sector_t bi_sector, sector_t end_sector,
-			  bool end, unsigned long duration,
+			  bool end, unsigned long duration_jiffies,
 			  struct dm_stats_aux *stats_aux)
 {
 	sector_t rel_sector, offset, todo, fragment_len;
@@ -523,7 +539,7 @@ static void __dm_stat_bio(struct dm_stat
 		if (fragment_len > s->step - offset)
 			fragment_len = s->step - offset;
 		dm_stat_for_entry(s, entry, bi_rw, fragment_len,
-				  stats_aux->merged, end, duration);
+				  stats_aux, end, duration_jiffies);
 		todo -= fragment_len;
 		entry++;
 		offset = 0;
@@ -532,11 +548,13 @@ static void __dm_stat_bio(struct dm_stat
 
 void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
 			 sector_t bi_sector, unsigned bi_sectors, bool end,
-			 unsigned long duration, struct dm_stats_aux *stats_aux)
+			 unsigned long duration_jiffies,
+			 struct dm_stats_aux *stats_aux)
 {
 	struct dm_stat *s;
 	sector_t end_sector;
 	struct dm_stats_last_position *last;
+	bool got_precise_time;
 
 	if (unlikely(!bi_sectors))
 		return;
@@ -560,8 +578,17 @@ void dm_stats_account_io(struct dm_stats
 
 	rcu_read_lock();
 
-	list_for_each_entry_rcu(s, &stats->list, list_entry)
-		__dm_stat_bio(s, bi_rw, bi_sector, end_sector, end, duration, stats_aux);
+	got_precise_time = false;
+	list_for_each_entry_rcu(s, &stats->list, list_entry) {
+		if (s->stat_flags & STAT_PRECISE_TIMESTAMPS && !got_precise_time) {
+			if (!end)
+				stats_aux->duration_ns = ktime_to_ns(ktime_get());
+			else
+				stats_aux->duration_ns = ktime_to_ns(ktime_get()) - stats_aux->duration_ns;
+			got_precise_time = true;
+		}
+		__dm_stat_bio(s, bi_rw, bi_sector, end_sector, end, duration_jiffies, stats_aux);
+	}
 
 	rcu_read_unlock();
 }
@@ -574,7 +601,7 @@ static void __dm_stat_init_temporary_per
 
 	local_irq_disable();
 	p = &s->stat_percpu[smp_processor_id()][x];
-	dm_stat_round(shared, p);
+	dm_stat_round(s, shared, p);
 	local_irq_enable();
 
 	memset(&shared->tmp, 0, sizeof(shared->tmp));
@@ -646,11 +673,15 @@ static int dm_stats_clear(struct dm_stat
 /*
  * This is like jiffies_to_msec, but works for 64-bit values.
  */
-static unsigned long long dm_jiffies_to_msec64(unsigned long long j)
+static unsigned long long dm_jiffies_to_msec64(struct dm_stat *s, unsigned long long j)
 {
-	unsigned long long result = 0;
+	unsigned long long result;
 	unsigned mult;
 
+	if (s->stat_flags & STAT_PRECISE_TIMESTAMPS)
+		return j;
+
+	result = 0;
 	if (j)
 		result = jiffies_to_msecs(j & 0x3fffff);
 	if (j >= 1 << 22) {
@@ -712,16 +743,16 @@ static int dm_stats_print(struct dm_stat
 		       shared->tmp.ios[READ],
 		       shared->tmp.merges[READ],
 		       shared->tmp.sectors[READ],
-		       dm_jiffies_to_msec64(shared->tmp.ticks[READ]),
+		       dm_jiffies_to_msec64(s, shared->tmp.ticks[READ]),
 		       shared->tmp.ios[WRITE],
 		       shared->tmp.merges[WRITE],
 		       shared->tmp.sectors[WRITE],
-		       dm_jiffies_to_msec64(shared->tmp.ticks[WRITE]),
+		       dm_jiffies_to_msec64(s, shared->tmp.ticks[WRITE]),
 		       dm_stat_in_flight(shared),
-		       dm_jiffies_to_msec64(shared->tmp.io_ticks_total),
-		       dm_jiffies_to_msec64(shared->tmp.time_in_queue),
-		       dm_jiffies_to_msec64(shared->tmp.io_ticks[READ]),
-		       dm_jiffies_to_msec64(shared->tmp.io_ticks[WRITE]));
+		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks_total),
+		       dm_jiffies_to_msec64(s, shared->tmp.time_in_queue),
+		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[READ]),
+		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[WRITE]));
 
 		if (unlikely(sz + 1 >= maxlen))
 			goto buffer_overflow;
@@ -772,21 +803,31 @@ static int message_stats_create(struct m
 	unsigned long long start, end, len, step;
 	unsigned divisor;
 	const char *program_id, *aux_data;
+	unsigned stat_flags = 0;
+
+	struct dm_arg_set as, as_backup;
+	const char *a;
+	unsigned feature_args;
 
 	/*
 	 * Input format:
-	 *   <range> <step> [<program_id> [<aux_data>]]
+	 *   <range> <step> [<extra_parameters> <parameters>] [<program_id> [<aux_data>]]
 	 */
 
-	if (argc < 3 || argc > 5)
+	if (argc < 3)
 		return -EINVAL;
 
-	if (!strcmp(argv[1], "-")) {
+	as.argc = argc;
+	as.argv = argv;
+	dm_consume_args(&as, 1);
+
+	a = dm_shift_arg(&as);
+	if (!strcmp(a, "-")) {
 		start = 0;
 		len = dm_get_size(md);
 		if (!len)
 			len = 1;
-	} else if (sscanf(argv[1], "%llu+%llu%c", &start, &len, &dummy) != 2 ||
+	} else if (sscanf(a, "%llu+%llu%c", &start, &len, &dummy) != 2 ||
 		   start != (sector_t)start || len != (sector_t)len)
 		return -EINVAL;
 
@@ -794,7 +835,8 @@ static int message_stats_create(struct m
 	if (start >= end)
 		return -EINVAL;
 
-	if (sscanf(argv[2], "/%u%c", &divisor, &dummy) == 1) {
+	a = dm_shift_arg(&as);
+	if (sscanf(a, "/%u%c", &divisor, &dummy) == 1) {
 		if (!divisor)
 			return -EINVAL;
 		step = end - start;
@@ -802,18 +844,39 @@ static int message_stats_create(struct m
 			step++;
 		if (!step)
 			step = 1;
-	} else if (sscanf(argv[2], "%llu%c", &step, &dummy) != 1 ||
+	} else if (sscanf(a, "%llu%c", &step, &dummy) != 1 ||
 		   step != (sector_t)step || !step)
 		return -EINVAL;
 
+	as_backup = as;
+	a = dm_shift_arg(&as);
+	if (a && sscanf(a, "%u%c", &feature_args, &dummy) == 1) {
+		while (feature_args--) {
+			a = dm_shift_arg(&as);
+			if (!a)
+				return -EINVAL;
+			if (!strcasecmp(a, "precise_timestamps"))
+				stat_flags |= STAT_PRECISE_TIMESTAMPS;
+			else
+				return -EINVAL;
+		}
+	} else {
+		as = as_backup;
+	}
+
 	program_id = "-";
 	aux_data = "-";
 
-	if (argc > 3)
-		program_id = argv[3];
+	a = dm_shift_arg(&as);
+	if (a)
+		program_id = a;
+
+	a = dm_shift_arg(&as);
+	if (a)
+		aux_data = a;
 
-	if (argc > 4)
-		aux_data = argv[4];
+	if (as.argc)
+		return -EINVAL;
 
 	/*
 	 * If a buffer overflow happens after we created the region,
@@ -825,7 +888,7 @@ static int message_stats_create(struct m
 	if (dm_message_test_buffer_overflow(result, maxlen))
 		return 1;
 
-	id = dm_stats_create(dm_get_stats(md), start, end, step, program_id, aux_data,
+	id = dm_stats_create(dm_get_stats(md), start, end, step, stat_flags, program_id, aux_data,
 			     dm_internal_suspend_fast, dm_internal_resume_fast, md);
 	if (id < 0)
 		return id;
Index: linux-4.1-rc7/drivers/md/dm-stats.h
===================================================================
--- linux-4.1-rc7.orig/drivers/md/dm-stats.h	2015-06-08 16:01:30.000000000 +0200
+++ linux-4.1-rc7/drivers/md/dm-stats.h	2015-06-08 16:02:27.000000000 +0200
@@ -18,6 +18,7 @@ struct dm_stats {
 
 struct dm_stats_aux {
 	bool merged;
+	unsigned long long duration_ns;
 };
 
 void dm_stats_init(struct dm_stats *st);
@@ -30,7 +31,8 @@ int dm_stats_message(struct mapped_devic
 
 void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
 			 sector_t bi_sector, unsigned bi_sectors, bool end,
-			 unsigned long duration, struct dm_stats_aux *aux);
+			 unsigned long duration_jiffies,
+			 struct dm_stats_aux *aux);
 
 static inline bool dm_stats_used(struct dm_stats *st)
 {
Index: linux-4.1-rc7/Documentation/device-mapper/statistics.txt
===================================================================
--- linux-4.1-rc7.orig/Documentation/device-mapper/statistics.txt	2015-06-08 16:38:59.000000000 +0200
+++ linux-4.1-rc7/Documentation/device-mapper/statistics.txt	2015-06-08 17:00:05.000000000 +0200
@@ -13,9 +13,13 @@ the range specified.
 The I/O statistics counters for each step-sized area of a region are
 in the same format as /sys/block/*/stat or /proc/diskstats (see:
 Documentation/iostats.txt).  But two extra counters (12 and 13) are
-provided: total time spent reading and writing in milliseconds.	 All
-these counters may be accessed by sending the @stats_print message to
-the appropriate DM device via dmsetup.
+provided: total time spent reading and writing.  All these counters may
+be accessed by sending the @stats_print message to the appropriate DM
+device via dmsetup.
+
+The reported times are in milliseconds and the granularity depends on
+the kernel ticks.  When the option precise_timestamps is used, the
+reported times are in nanoseconds.
 
 Each region has a corresponding unique identifier, which we call a
 region_id, that is assigned when the region is created.	 The region_id
@@ -33,7 +37,9 @@ memory is used by reading
 Messages
 ========
 
-    @stats_create <range> <step> [<program_id> [<aux_data>]]
+    @stats_create <range> <step>
+    		[<number_of_optional_arguments> <optional_arguments>...]
+		[<program_id> [<aux_data>]]
 
 	Create a new region and return the region_id.
 
@@ -48,6 +54,17 @@ Messages
 	  "/<number_of_areas>" - the range is subdivided into the specified
 				 number of areas.
 
+	<number_of_optional_arguments>
+	  The number of optional arguments
+
+	<optional_arguments>
+	  The following optional arguments are supported
+	  precise_timestamps - use precise timer with nanosecond resolution
+	  	instead of the "jiffies" variable.  When this argument is
+		used, the resulting times are in nanoseconds instead of
+		milliseconds.  Precise timestamps are a little bit slower
+		to obtain than jiffies-based timestamps.
+
 	<program_id>
 	  An optional parameter.  A name that uniquely identifies
 	  the userspace owner of the range.  This groups ranges together
