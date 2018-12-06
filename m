From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 5/7] block: switch to per-cpu in-flight
	counters
Date: Thu,  6 Dec 2018 11:41:20 -0500
Message-ID: <20181206164122.2166-6-snitzer@redhat.com>
References: <20181206164122.2166-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181206164122.2166-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Now when part_round_stats is gone, we can switch to per-cpu in-flight
counters.

We use the local-atomic type local_t, so that if part_inc_in_flight or
part_dec_in_flight is reentrantly called from an interrupt, the value will
be correct.

The other counters could be corrupted due to reentrant interrupt, but the
corruption only results in slight counter skew - the in_flight counter
must be exact, so it needs local_t.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/genhd.c         | 43 +++++++++++++++++++++++++++++++++----------
 include/linux/genhd.h | 29 ++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cdf174d7d329..9827a2c05db7 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -50,9 +50,9 @@ void part_inc_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
 	if (queue_is_mq(q))
 		return;
 
-	atomic_inc(&part->in_flight[rw]);
+	part_stat_local_inc(part, in_flight[rw]);
 	if (part->partno)
-		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
+		part_stat_local_inc(&part_to_disk(part)->part0, in_flight[rw]);
 }
 
 void part_dec_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
@@ -60,38 +60,61 @@ void part_dec_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
 	if (queue_is_mq(q))
 		return;
 
-	atomic_dec(&part->in_flight[rw]);
+	part_stat_local_dec(part, in_flight[rw]);
 	if (part->partno)
-		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
+		part_stat_local_dec(&part_to_disk(part)->part0, in_flight[rw]);
 }
 
 void part_in_flight(struct request_queue *q, struct hd_struct *part,
 		    unsigned int inflight[2])
 {
+	int cpu;
+
 	if (queue_is_mq(q)) {
 		blk_mq_in_flight(q, part, inflight);
 		return;
 	}
 
-	inflight[0] = atomic_read(&part->in_flight[0]) +
-			atomic_read(&part->in_flight[1]);
+	inflight[0] = 0;
+	for_each_possible_cpu(cpu) {
+		inflight[0] += part_stat_local_read_cpu(part, in_flight[0], cpu) +
+			       part_stat_local_read_cpu(part, in_flight[1], cpu);
+	}
+	if ((int)inflight[0] < 0)
+		inflight[0] = 0;
+
 	if (part->partno) {
 		part = &part_to_disk(part)->part0;
-		inflight[1] = atomic_read(&part->in_flight[0]) +
-				atomic_read(&part->in_flight[1]);
+		inflight[1] = 0;
+		for_each_possible_cpu(cpu) {
+			inflight[1] += part_stat_local_read_cpu(part, in_flight[0], cpu) +
+				       part_stat_local_read_cpu(part, in_flight[1], cpu);
+		}
+		if ((int)inflight[1] < 0)
+			inflight[1] = 0;
 	}
 }
 
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2])
 {
+	int cpu;
+
 	if (queue_is_mq(q)) {
 		blk_mq_in_flight_rw(q, part, inflight);
 		return;
 	}
 
-	inflight[0] = atomic_read(&part->in_flight[0]);
-	inflight[1] = atomic_read(&part->in_flight[1]);
+	inflight[0] = 0;
+	inflight[1] = 0;
+	for_each_possible_cpu(cpu) {
+		inflight[0] += part_stat_local_read_cpu(part, in_flight[0], cpu);
+		inflight[1] += part_stat_local_read_cpu(part, in_flight[1], cpu);
+	}
+	if ((int)inflight[0] < 0)
+		inflight[0] = 0;
+	if ((int)inflight[1] < 0)
+		inflight[1] = 0;
 }
 
 struct hd_struct *__disk_get_part(struct gendisk *disk, int partno)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 838c2a7a40c5..636b4f687e35 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -17,6 +17,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/uuid.h>
 #include <linux/blk_types.h>
+#include <asm/local.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -89,6 +90,7 @@ struct disk_stats {
 	unsigned long merges[NR_STAT_GROUPS];
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
+	local_t in_flight[2];
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
@@ -122,7 +124,6 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	atomic_t in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
 #else
@@ -295,8 +296,11 @@ extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 #define part_stat_lock()	({ rcu_read_lock(); get_cpu(); })
 #define part_stat_unlock()	do { put_cpu(); rcu_read_unlock(); } while (0)
 
-#define __part_stat_add(part, field, addnd)				\
-	(per_cpu_ptr((part)->dkstats, smp_processor_id())->field += (addnd))
+#define part_stat_get_cpu(part, field, cpu)					\
+	(per_cpu_ptr((part)->dkstats, (cpu))->field)
+
+#define part_stat_get(part, field)					\
+	part_stat_get_cpu(part, field, smp_processor_id())
 
 #define part_stat_read(part, field)					\
 ({									\
@@ -333,10 +337,9 @@ static inline void free_part_stats(struct hd_struct *part)
 #define part_stat_lock()	({ rcu_read_lock(); 0; })
 #define part_stat_unlock()	rcu_read_unlock()
 
-#define __part_stat_add(part, field, addnd)				\
-	((part)->dkstats.field += addnd)
-
-#define part_stat_read(part, field)	((part)->dkstats.field)
+#define part_stat_get(part, field)		((part)->dkstats.field)
+#define part_stat_get_cpu(part, field, cpu)	part_stat_get(part, field)
+#define part_stat_read(part, field)		part_stat_get(part, field)
 
 static inline void part_stat_set_all(struct hd_struct *part, int value)
 {
@@ -362,6 +365,9 @@ static inline void free_part_stats(struct hd_struct *part)
 	 part_stat_read(part, field[STAT_WRITE]) +			\
 	 part_stat_read(part, field[STAT_DISCARD]))
 
+#define __part_stat_add(part, field, addnd)				\
+	(part_stat_get(part, field) += (addnd))
+
 #define part_stat_add(part, field, addnd)	do {			\
 	__part_stat_add((part), field, addnd);				\
 	if ((part)->partno)						\
@@ -376,6 +382,15 @@ static inline void free_part_stats(struct hd_struct *part)
 #define part_stat_sub(gendiskp, field, subnd)				\
 	part_stat_add(gendiskp, field, -subnd)
 
+#define part_stat_local_dec(gendiskp, field)				\
+	local_dec(&(part_stat_get(gendiskp, field)))
+#define part_stat_local_inc(gendiskp, field)				\
+	local_inc(&(part_stat_get(gendiskp, field)))
+#define part_stat_local_read(gendiskp, field)				\
+	local_read(&(part_stat_get(gendiskp, field)))
+#define part_stat_local_read_cpu(gendiskp, field, cpu)			\
+	local_read(&(part_stat_get_cpu(gendiskp, field, cpu)))
+
 void part_in_flight(struct request_queue *q, struct hd_struct *part,
 		    unsigned int inflight[2]);
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
-- 
2.15.0
