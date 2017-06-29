From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from atomic to
 percpu
Date: Thu, 29 Jun 2017 12:42:01 -0600
Message-ID: <8f4ff428-e158-0df5-cf54-ae3cdea7ad1f@kernel.dk>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
 <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
 <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk>
 <07ba10a8-6369-c1bc-dc9a-b550d9394c22@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <07ba10a8-6369-c1bc-dc9a-b550d9394c22@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 06/29/2017 10:00 AM, Jens Axboe wrote:
> On 06/29/2017 09:58 AM, Jens Axboe wrote:
>> On 06/29/2017 02:40 AM, Ming Lei wrote:
>>> On Thu, Jun 29, 2017 at 5:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 06/28/2017 03:12 PM, Brian King wrote:
>>>>> This patch converts the in_flight counter in struct hd_struct from a
>>>>> pair of atomics to a pair of percpu counters. This eliminates a couple
>>>>> of atomics from the hot path. When running this on a Power system, to
>>>>> a single null_blk device with 80 submission queues, irq mode 0, with
>>>>> 80 fio jobs, I saw IOPs go from 1.5M IO/s to 11.4 IO/s.
>>>>
>>>> This has been done before, but I've never really liked it. The reason is
>>>> that it means that reading the part stat inflight count now has to
>>>> iterate over every possible CPU. Did you use partitions in your testing?
>>>> How many CPUs were configured? When I last tested this a few years ago
>>>> on even a quad core nehalem (which is notoriously shitty for cross-node
>>>> latencies), it was a net loss.
>>>
>>> One year ago, I saw null_blk's IOPS can be decreased to 10%
>>> of non-RQF_IO_STAT on a dual socket ARM64(each CPU has
>>> 96 cores, and dual numa nodes) too, the performance can be
>>> recovered basically if per numa-node counter is introduced and
>>> used in this case, but the patch was never posted out.
>>> If anyone is interested in that, I can rebase the patch on current
>>> block tree and post out. I guess the performance issue might be
>>> related with system cache coherency implementation more or less.
>>> This issue on ARM64 can be observed with the following userspace
>>> atomic counting test too:
>>>
>>>        http://kernel.ubuntu.com/~ming/test/cache/
>>
>> How well did the per-node thing work? Doesn't seem to me like it would
>> go far enough. And per CPU is too much. One potential improvement would
>> be to change the part_stat_read() to just loop online CPUs, instead of
>> all possible CPUs. When CPUs go on/offline, use that as the slow path to
>> ensure the stats are sane. Often there's a huge difference between
>> NR_CPUS configured and what the system has. As Brian states, RH ships
>> with 2048, while I doubt a lot of customers actually run that...
>>
>> Outside of coming up with a more clever data structure that is fully
>> CPU topology aware, one thing that could work is just having X cache
>> line separated read/write inflight counters per node, where X is some
>> suitable value (like 4). That prevents us from having cross node
>> traffic, and it also keeps the cross cpu traffic fairly low. That should
>> provide a nice balance between cost of incrementing the inflight
>> counting, and the cost of looping for reading it.
>>
>> And that brings me to the next part...
>>
>>>> I do agree that we should do something about it, and it's one of those
>>>> items I've highlighted in talks about blk-mq on pending issues to fix
>>>> up. It's just not great as it currently stands, but I don't think per
>>>> CPU counters is the right way to fix it, at least not for the inflight
>>>> counter.
>>>
>>> Yeah, it won't be a issue for non-mq path, and for blk-mq path, maybe
>>> we can use some blk-mq knowledge(tagset?) to figure out the
>>> 'in_flight' counter. I thought about it before, but never got a
>>> perfect solution, and looks it is a bit hard, :-)
>>
>> The tags are already a bit spread out, so it's worth a shot. That would
>> remove the need to do anything in the inc/dec path, as the tags already
>> do that. The inlight count could be easily retrieved with
>> sbitmap_weight(). The only issue here is that we need separate read and
>> write counters, and the weight would obviously only get us the total
>> count. But we can have a slower path for that, just iterate the tags and
>> count them. The fast path only cares about total count.
>>
>> Let me try that out real quick.
> 
> Well, that only works for whole disk stats, of course... There's no way
> around iterating the tags and checking for this to truly work.

Totally untested proof of concept for using the tags for this. I based
this on top of Brian's patch, so it includes his patch plus the
_double() stuff I did which is no longer really needed.


diff --git a/block/bio.c b/block/bio.c
index 9cf98b29588a..ec99d9ba0f33 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1737,7 +1737,7 @@ void generic_start_io_acct(int rw, unsigned long sectors,
 	part_round_stats(cpu, part);
 	part_stat_inc(cpu, part, ios[rw]);
 	part_stat_add(cpu, part, sectors[rw], sectors);
-	part_inc_in_flight(part, rw);
+	part_inc_in_flight(cpu, part, rw);
 
 	part_stat_unlock();
 }
@@ -1751,7 +1751,7 @@ void generic_end_io_acct(int rw, struct hd_struct *part,
 
 	part_stat_add(cpu, part, ticks[rw], duration);
 	part_round_stats(cpu, part);
-	part_dec_in_flight(part, rw);
+	part_dec_in_flight(cpu, part, rw);
 
 	part_stat_unlock();
 }
diff --git a/block/blk-core.c b/block/blk-core.c
index af393d5a9680..6ab2efbe940b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2434,8 +2434,13 @@ void blk_account_io_done(struct request *req)
 
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
-		part_round_stats(cpu, part);
-		part_dec_in_flight(part, rw);
+
+		if (req->q->mq_ops)
+			part_round_stats_mq(req->q, cpu, part);
+		else {
+			part_round_stats(cpu, part);
+			part_dec_in_flight(cpu, part, rw);
+		}
 
 		hd_struct_put(part);
 		part_stat_unlock();
@@ -2492,8 +2497,12 @@ void blk_account_io_start(struct request *rq, bool new_io)
 			part = &rq->rq_disk->part0;
 			hd_struct_get(part);
 		}
-		part_round_stats(cpu, part);
-		part_inc_in_flight(part, rw);
+		if (rq->q->mq_ops)
+			part_round_stats_mq(rq->q, cpu, part);
+		else {
+			part_round_stats(cpu, part);
+			part_inc_in_flight(cpu, part, rw);
+		}
 		rq->part = part;
 	}
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 99038830fb42..3b5eb2d4b964 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -634,7 +634,7 @@ static void blk_account_io_merge(struct request *req)
 		part = req->part;
 
 		part_round_stats(cpu, part);
-		part_dec_in_flight(part, rq_data_dir(req));
+		part_dec_in_flight(cpu, part, rq_data_dir(req));
 
 		hd_struct_put(part);
 		part_stat_unlock();
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d0be72ccb091..a7b897740c47 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -214,7 +214,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 		bitnr += tags->nr_reserved_tags;
 	rq = tags->rqs[bitnr];
 
-	if (rq->q == hctx->queue)
+	if (rq && rq->q == hctx->queue)
 		iter_data->fn(hctx, rq, iter_data->data, reserved);
 	return true;
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 05dfa3f270ae..cad4d2c26285 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -43,6 +43,58 @@ static LIST_HEAD(all_q_list);
 static void blk_mq_poll_stats_start(struct request_queue *q);
 static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb);
 
+struct mq_inflight {
+	struct hd_struct *part;
+	unsigned int inflight;
+};
+
+static void blk_mq_check_inflight(struct blk_mq_hw_ctx *hctx,
+				  struct request *rq, void *priv,
+				  bool reserved)
+{
+	struct mq_inflight *mi = priv;
+
+	if (rq->part == mi->part &&
+	    test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
+		mi->inflight++;
+}
+
+unsigned long part_in_flight_mq(struct request_queue *q,
+				struct hd_struct *part)
+{
+	struct mq_inflight mi = { .part = part, .inflight = 0 };
+
+	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
+	return mi.inflight;
+}
+
+static void __part_round_stats_mq(struct request_queue *q, int cpu,
+				  struct hd_struct *part, unsigned long now)
+{
+	unsigned long inflight;
+
+	if (now == part->stamp)
+		return;
+
+	inflight = part_in_flight_mq(q, part);
+	if (inflight) {
+		__part_stat_add(cpu, part, time_in_queue,
+				inflight * (now - part->stamp));
+		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
+	}
+	part->stamp = now;
+}
+
+void part_round_stats_mq(struct request_queue *q, int cpu,
+			 struct hd_struct *part)
+{
+	unsigned long now = jiffies;
+
+	if (part->partno)
+		__part_round_stats_mq(q, cpu, &part_to_disk(part)->part0, now);
+	__part_round_stats_mq(q, cpu, part, now);
+}
+
 static int blk_mq_poll_stats_bkt(const struct request *rq)
 {
 	int ddir, bytes, bucket;
diff --git a/block/blk.h b/block/blk.h
index 01ebb8185f6b..4803289467ac 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -264,6 +264,11 @@ static inline void req_set_nomerge(struct request_queue *q, struct request *req)
 		q->last_merge = NULL;
 }
 
+extern void part_round_stats_mq(struct request_queue *q, int cpu,
+					struct hd_struct *part);
+extern unsigned long part_in_flight_mq(struct request_queue *q,
+					struct hd_struct *part);
+
 /*
  * Internal io_context interface
  */
diff --git a/block/genhd.c b/block/genhd.c
index 7f520fa25d16..8ec19773ce68 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1204,6 +1204,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	struct disk_part_iter piter;
 	struct hd_struct *hd;
 	char buf[BDEVNAME_SIZE];
+	unsigned long inflight;
 	int cpu;
 
 	/*
@@ -1217,10 +1218,17 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		cpu = part_stat_lock();
-		part_round_stats(cpu, hd);
+		if (gp->queue->mq_ops)
+			part_round_stats_mq(gp->queue, cpu, hd);
+		else
+			part_round_stats(cpu, hd);
 		part_stat_unlock();
+		if (gp->queue->mq_ops)
+			inflight = part_in_flight_mq(gp->queue, hd);
+		else
+			inflight = part_in_flight(hd);
 		seq_printf(seqf, "%4d %7d %s %lu %lu %lu "
-			   "%u %lu %lu %lu %u %u %u %u\n",
+			   "%u %lu %lu %lu %u %lu %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[READ]),
@@ -1231,7 +1239,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   part_stat_read(hd, merges[WRITE]),
 			   part_stat_read(hd, sectors[WRITE]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[WRITE])),
-			   part_in_flight(hd),
+			   inflight,
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
 			);
diff --git a/block/partition-generic.c b/block/partition-generic.c
index c5ec8246e25e..94aa92c3c010 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -19,6 +19,7 @@
 #include <linux/blktrace_api.h>
 
 #include "partitions/check.h"
+#include "blk.h"
 
 #ifdef CONFIG_BLK_DEV_MD
 extern void md_autodetect_dev(dev_t dev);
@@ -111,16 +112,27 @@ static ssize_t part_discard_alignment_show(struct device *dev,
 ssize_t part_stat_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
+	struct gendisk *disk = dev_to_disk(dev);
 	struct hd_struct *p = dev_to_part(dev);
+	unsigned long inflight;
 	int cpu;
 
 	cpu = part_stat_lock();
-	part_round_stats(cpu, p);
+	if (disk->queue->mq_ops)
+		part_round_stats_mq(disk->queue, cpu, p);
+	else
+		part_round_stats(cpu, p);
 	part_stat_unlock();
+
+	if (disk->queue->mq_ops)
+		inflight = part_in_flight_mq(disk->queue, p);
+	else
+		inflight = part_in_flight(p);
+
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
-		"%8u %8u %8u"
+		"%8lu %8u %8u"
 		"\n",
 		part_stat_read(p, ios[READ]),
 		part_stat_read(p, merges[READ]),
@@ -130,7 +142,7 @@ ssize_t part_stat_show(struct device *dev,
 		part_stat_read(p, merges[WRITE]),
 		(unsigned long long)part_stat_read(p, sectors[WRITE]),
 		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
-		part_in_flight(p),
+		inflight,
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
@@ -140,8 +152,8 @@ ssize_t part_inflight_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%8u %8u\n", atomic_read(&p->in_flight[0]),
-		atomic_read(&p->in_flight[1]));
+	return sprintf(buf, "%8lu %8lu\n", part_stat_read(p, in_flight[0]),
+		part_stat_read(p, in_flight[1]));
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 402946035308..1034abffd10d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -517,9 +517,9 @@ static void start_io_acct(struct dm_io *io)
 
 	cpu = part_stat_lock();
 	part_round_stats(cpu, &dm_disk(md)->part0);
+	part_inc_in_flight(cpu, &dm_disk(md)->part0, rw);
+	atomic_inc(&md->pending[rw]);
 	part_stat_unlock();
-	atomic_set(&dm_disk(md)->part0.in_flight[rw],
-		atomic_inc_return(&md->pending[rw]));
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
@@ -532,7 +532,7 @@ static void end_io_acct(struct dm_io *io)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->bio;
 	unsigned long duration = jiffies - io->start_time;
-	int pending;
+	int pending, cpu;
 	int rw = bio_data_dir(bio);
 
 	generic_end_io_acct(rw, &dm_disk(md)->part0, io->start_time);
@@ -546,9 +546,11 @@ static void end_io_acct(struct dm_io *io)
 	 * After this is decremented the bio must not be touched if it is
 	 * a flush.
 	 */
+	cpu = part_stat_lock();
 	pending = atomic_dec_return(&md->pending[rw]);
-	atomic_set(&dm_disk(md)->part0.in_flight[rw], pending);
+	part_dec_in_flight(cpu, &dm_disk(md)->part0, rw);
 	pending += atomic_read(&md->pending[rw^0x1]);
+	part_stat_unlock();
 
 	/* nudge anyone waiting on suspend queue */
 	if (!pending)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e619fae2f037..d050a509bdd4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -87,6 +87,7 @@ struct disk_stats {
 	unsigned long ticks[2];
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
+	unsigned long in_flight[2];
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
@@ -120,7 +121,6 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	atomic_t in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
 #else
@@ -292,6 +292,17 @@ extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 #define __part_stat_add(cpu, part, field, addnd)			\
 	(per_cpu_ptr((part)->dkstats, (cpu))->field += (addnd))
 
+#define part_stat_read_double(part, field1, field2)					\
+({									\
+	typeof((part)->dkstats->field1) res = 0;				\
+	unsigned int _cpu;						\
+	for_each_possible_cpu(_cpu) {					\
+		res += per_cpu_ptr((part)->dkstats, _cpu)->field1;	\
+		res += per_cpu_ptr((part)->dkstats, _cpu)->field2;	\
+	}								\
+	res;								\
+})
+
 #define part_stat_read(part, field)					\
 ({									\
 	typeof((part)->dkstats->field) res = 0;				\
@@ -362,23 +373,23 @@ static inline void free_part_stats(struct hd_struct *part)
 #define part_stat_sub(cpu, gendiskp, field, subnd)			\
 	part_stat_add(cpu, gendiskp, field, -subnd)
 
-static inline void part_inc_in_flight(struct hd_struct *part, int rw)
+static inline void part_inc_in_flight(int cpu, struct hd_struct *part, int rw)
 {
-	atomic_inc(&part->in_flight[rw]);
+	part_stat_inc(cpu, part, in_flight[rw]);
 	if (part->partno)
-		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
+		part_stat_inc(cpu, &part_to_disk(part)->part0, in_flight[rw]);
 }
 
-static inline void part_dec_in_flight(struct hd_struct *part, int rw)
+static inline void part_dec_in_flight(int cpu, struct hd_struct *part, int rw)
 {
-	atomic_dec(&part->in_flight[rw]);
+	part_stat_dec(cpu, part, in_flight[rw]);
 	if (part->partno)
-		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
+		part_stat_dec(cpu, &part_to_disk(part)->part0, in_flight[rw]);
 }
 
-static inline int part_in_flight(struct hd_struct *part)
+static inline unsigned long part_in_flight(struct hd_struct *part)
 {
-	return atomic_read(&part->in_flight[0]) + atomic_read(&part->in_flight[1]);
+	return part_stat_read_double(part, in_flight[0], in_flight[1]);
 }
 
 static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)

-- 
Jens Axboe
