From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 5/7] block: switch to per-cpu in-flight
	counters
Date: Wed,  5 Dec 2018 15:24:31 -0500
Message-ID: <20181205202433.95823-6-snitzer@redhat.com>
References: <20181205202433.95823-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181205202433.95823-1-snitzer@redhat.com>
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
 block/genhd.c         | 49 ++++++++++++++++++++++++++++++++++---------
 include/linux/genhd.h |  3 ++-
 2 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cdf174d7d329..ffb9d416db64 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -47,51 +47,80 @@ static void disk_release_events(struct gendisk *disk);
 
 void part_inc_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
 {
+	int cpu;
+
 	if (queue_is_mq(q))
 		return;
 
-	atomic_inc(&part->in_flight[rw]);
+	cpu = smp_processor_id();
+	local_inc(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
 	if (part->partno)
-		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
+		local_inc(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
 }
 
 void part_dec_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
 {
+	int cpu;
+
 	if (queue_is_mq(q))
 		return;
 
-	atomic_dec(&part->in_flight[rw]);
+	cpu = smp_processor_id();
+	local_dec(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
 	if (part->partno)
-		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
+		local_dec(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
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
+		inflight[0] +=	local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
+				local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
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
+			inflight[1] +=	local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
+					local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
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
+		inflight[0] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]);
+		inflight[1] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
+	}
+	if ((int)inflight[0] < 0)
+		inflight[0] = 0;
+	if ((int)inflight[1] < 0)
+		inflight[1] = 0;
 }
 
 struct hd_struct *__disk_get_part(struct gendisk *disk, int partno)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 838c2a7a40c5..9489dcb7cc27 100644
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
-- 
2.18.0
