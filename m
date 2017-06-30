From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from atomic to
 percpu
Date: Fri, 30 Jun 2017 09:08:01 +0800
Message-ID: <20170630010759.GB8305@ming.t460p>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
 <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
 <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk>
 <CACVXFVPvbJ1vD5-7aBeNQ6D6bDvhhd8aQQJ++vVZwJ5AM8TMjg@mail.gmail.com>
 <dc7cf367-534d-d9fc-27b1-7cfd5edcb74c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dc7cf367-534d-d9fc-27b1-7cfd5edcb74c@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 29, 2017 at 12:31:05PM -0500, Brian King wrote:
> On 06/29/2017 11:25 AM, Ming Lei wrote:
> > On Thu, Jun 29, 2017 at 11:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >> On 06/29/2017 02:40 AM, Ming Lei wrote:
> >>> On Thu, Jun 29, 2017 at 5:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 06/28/2017 03:12 PM, Brian King wrote:
> >>>>> This patch converts the in_flight counter in struct hd_struct from a
> >>>>> pair of atomics to a pair of percpu counters. This eliminates a couple
> >>>>> of atomics from the hot path. When running this on a Power system, to
> >>>>> a single null_blk device with 80 submission queues, irq mode 0, with
> >>>>> 80 fio jobs, I saw IOPs go from 1.5M IO/s to 11.4 IO/s.
> >>>>
> >>>> This has been done before, but I've never really liked it. The reason is
> >>>> that it means that reading the part stat inflight count now has to
> >>>> iterate over every possible CPU. Did you use partitions in your testing?
> >>>> How many CPUs were configured? When I last tested this a few years ago
> >>>> on even a quad core nehalem (which is notoriously shitty for cross-node
> >>>> latencies), it was a net loss.
> >>>
> >>> One year ago, I saw null_blk's IOPS can be decreased to 10%
> >>> of non-RQF_IO_STAT on a dual socket ARM64(each CPU has
> >>> 96 cores, and dual numa nodes) too, the performance can be
> >>> recovered basically if per numa-node counter is introduced and
> >>> used in this case, but the patch was never posted out.
> >>> If anyone is interested in that, I can rebase the patch on current
> >>> block tree and post out. I guess the performance issue might be
> >>> related with system cache coherency implementation more or less.
> >>> This issue on ARM64 can be observed with the following userspace
> >>> atomic counting test too:
> >>>
> >>>        http://kernel.ubuntu.com/~ming/test/cache/
> >>
> >> How well did the per-node thing work? Doesn't seem to me like it would
> > 
> > Last time, on ARM64, I remembered that the IOPS was basically recovered,
> > but now I don't have a such machine to test. Could Brian test the attached patch
> > to see if it works on big Power machine?
> > 
> > And the idea is simple, just make the atomic counter per-node.
> 
> I tried loading the patch and get an oops right away on boot. Haven't been able to 
> debug anything yet. This is on top of an older kernel, so not sure if that is
> the issue or not. I can try upstream and see if i have different results...
> 
> [-1;-1fUbuntu 16.04[-1;-1f.  .  .  .Unable to handle kernel paging request for data at address 0xc00031313a333532
> Faulting instruction address: 0xc0000000002552c4
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=1024 NUMA 
> PowerNV
> Modules linked in: dm_round_robin vmx_crypto powernv_rng leds_powernv powernv_op_panel led_class rng_core dm_multipath autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq multipath dm_mirror dm_region_hash dm_log cxlflash bnx2x mdio libcrc32c nvme nvme_core lpfc cxl crc_t10dif crct10dif_generic crct10dif_common
> CPU: 9 PID: 3485 Comm: multipathd Not tainted 4.9.10-dirty #7
> task: c000000fba0d0000 task.stack: c000000fb8a1c000
> NIP: c0000000002552c4 LR: c000000000255274 CTR: 0000000000000000
> REGS: c000000fb8a1f350 TRAP: 0300   Not tainted  (4.9.10-dirty)
> MSR: 900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24028848  XER: 00000000
> CFAR: c000000000008a60 DAR: c00031313a333532 DSISR: 40000000 SOFTE: 1 
> GPR00: c0000000001f8980 c000000fb8a1f5d0 c000000000f24300 c000000fc4007c00 
> GPR04: 00000000024000c0 c0000000002fc0ac 000000000000025d c000000fc5d346e0 
> GPR08: 0000000fc50d6000 0000000000000000 c00031313a333532 c000000fbc836240 
> GPR12: 0000000000002200 c00000000ff02400 00003fff79cfebf0 0000000000000000 
> GPR16: 00000000c138fd03 000001003a12bf70 00003fff79ae75e0 00003fff79d269e8 
> GPR20: 0000000000000001 00003fff79cfebf0 000001003a393aa0 00003fff79d067b8 
> GPR24: 0000000000000000 c000000000b04948 000000000000a1ff c0000000002fc0ac 
> GPR28: 00000000024000c0 0000000000000007 c0000000002fc0ac c000000fc4007c00 
> NIP [c0000000002552c4] __kmalloc_track_caller+0x94/0x2f0
> LR [c000000000255274] __kmalloc_track_caller+0x44/0x2f0
> Call Trace:
> [c000000fb8a1f5d0] [c000000fb8a1f610] 0xc000000fb8a1f610 (unreliable)
> [c000000fb8a1f620] [c0000000001f8980] kstrdup+0x50/0xb0
> [c000000fb8a1f660] [c0000000002fc0ac] __kernfs_new_node+0x4c/0x140
> [c000000fb8a1f6b0] [c0000000002fd9f4] kernfs_new_node+0x34/0x80
> [c000000fb8a1f6e0] [c000000000300708] kernfs_create_link+0x38/0xf0
> [c000000fb8a1f720] [c000000000301cb8] sysfs_do_create_link_sd.isra.0+0xa8/0x160
> [c000000fb8a1f770] [c00000000054a658] device_add+0x2b8/0x740
> [c000000fb8a1f830] [c00000000054ae58] device_create_groups_vargs+0x178/0x190
> [c000000fb8a1f890] [c0000000001fcd70] bdi_register+0x80/0x1d0
> [c000000fb8a1f8c0] [c0000000001fd244] bdi_register_owner+0x44/0x80
> [c000000fb8a1f940] [c000000000453bbc] device_add_disk+0x1cc/0x500
> [c000000fb8a1f9f0] [c000000000764dec] dm_create+0x33c/0x5f0
> [c000000fb8a1fa90] [c00000000076d9ac] dev_create+0x8c/0x3e0
> [c000000fb8a1fb40] [c00000000076d1fc] ctl_ioctl+0x38c/0x580
> [c000000fb8a1fd20] [c00000000076d410] dm_ctl_ioctl+0x20/0x30
> [c000000fb8a1fd40] [c0000000002799ac] do_vfs_ioctl+0xcc/0x8f0
> [c000000fb8a1fde0] [c00000000027a230] SyS_ioctl+0x60/0xc0
> [c000000fb8a1fe30] [c00000000000bfe0] system_call+0x38/0xfc
> Instruction dump:
> 39290008 7cc8482a e94d0030 e9230000 7ce95214 7d49502a e9270010 2faa0000 
> 419e007c 2fa90000 419e0074 e93f0022 <7f4a482a> 39200000 88ad023a 992d023a 
> ---[ end trace dcdac2d3f668d033 ]---
>

Thanks for the test!

Looks there is one double free in patch, could you test the new one?

---
diff --git a/block/partition-generic.c b/block/partition-generic.c
index c5ec8246e25e..bd6644bf9643 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -140,8 +140,9 @@ ssize_t part_inflight_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%8u %8u\n", atomic_read(&p->in_flight[0]),
-		atomic_read(&p->in_flight[1]));
+	return sprintf(buf, "%8u %8u\n",
+		pnode_counter_read_all(&p->in_flight[0]),
+		pnode_counter_read_all(&p->in_flight[1]));
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 96bd13e581cd..aac0b2235410 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -521,7 +521,7 @@ static void start_io_acct(struct dm_io *io)
 	cpu = part_stat_lock();
 	part_round_stats(cpu, &dm_disk(md)->part0);
 	part_stat_unlock();
-	atomic_set(&dm_disk(md)->part0.in_flight[rw],
+	pnode_counter_set(&dm_disk(md)->part0.in_flight[rw],
 		atomic_inc_return(&md->pending[rw]));
 
 	if (unlikely(dm_stats_used(&md->stats)))
@@ -550,7 +550,7 @@ static void end_io_acct(struct dm_io *io)
 	 * a flush.
 	 */
 	pending = atomic_dec_return(&md->pending[rw]);
-	atomic_set(&dm_disk(md)->part0.in_flight[rw], pending);
+	pnode_counter_set(&dm_disk(md)->part0.in_flight[rw], pending);
 	pending += atomic_read(&md->pending[rw^0x1]);
 
 	/* nudge anyone waiting on suspend queue */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e619fae2f037..40c9bc74a120 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
 #include <linux/uuid.h>
+#include <linux/pernode_counter.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -120,7 +121,7 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	atomic_t in_flight[2];
+	struct pnode_counter in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
 #else
@@ -364,21 +365,22 @@ static inline void free_part_stats(struct hd_struct *part)
 
 static inline void part_inc_in_flight(struct hd_struct *part, int rw)
 {
-	atomic_inc(&part->in_flight[rw]);
+	pnode_counter_inc(&part->in_flight[rw]);
 	if (part->partno)
-		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
+		pnode_counter_inc(&part_to_disk(part)->part0.in_flight[rw]);
 }
 
 static inline void part_dec_in_flight(struct hd_struct *part, int rw)
 {
-	atomic_dec(&part->in_flight[rw]);
+	pnode_counter_dec(&part->in_flight[rw]);
 	if (part->partno)
-		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
+		pnode_counter_dec(&part_to_disk(part)->part0.in_flight[rw]);
 }
 
 static inline int part_in_flight(struct hd_struct *part)
 {
-	return atomic_read(&part->in_flight[0]) + atomic_read(&part->in_flight[1]);
+	return pnode_counter_read_all(&part->in_flight[0]) + \
+		pnode_counter_read_all(&part->in_flight[1]);
 }
 
 static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)
@@ -627,11 +629,34 @@ extern ssize_t part_fail_store(struct device *dev,
 			       const char *buf, size_t count);
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
+static inline int hd_counter_init(struct hd_struct *part)
+{
+	if (pnode_counter_init(&part->in_flight[0], GFP_KERNEL))
+		return -ENOMEM;
+	if (pnode_counter_init(&part->in_flight[1], GFP_KERNEL)) {
+		pnode_counter_deinit(&part->in_flight[0]);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static inline void hd_counter_deinit(struct hd_struct *part)
+{
+	pnode_counter_deinit(&part->in_flight[0]);
+	pnode_counter_deinit(&part->in_flight[1]);
+}
+
 static inline int hd_ref_init(struct hd_struct *part)
 {
+	if (hd_counter_init(part))
+		return -ENOMEM;
+
 	if (percpu_ref_init(&part->ref, __delete_partition, 0,
-				GFP_KERNEL))
+				GFP_KERNEL)) {
+		hd_counter_deinit(part);
 		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -659,6 +684,7 @@ static inline void hd_free_part(struct hd_struct *part)
 {
 	free_part_stats(part);
 	free_part_info(part);
+	hd_counter_deinit(part);
 	percpu_ref_exit(&part->ref);
 }
 
diff --git a/include/linux/pernode_counter.h b/include/linux/pernode_counter.h
new file mode 100644
index 000000000000..e95b5f2d1d9c
--- /dev/null
+++ b/include/linux/pernode_counter.h
@@ -0,0 +1,117 @@
+#ifndef _LINUX_PERNODE_COUNTER_H
+#define _LINUX_PERNODE_COUNTER_H
+/*
+ * A simple per node atomic counter for use in block io accounting.
+ */
+
+#include <linux/smp.h>
+#include <linux/percpu.h>
+#include <linux/types.h>
+#include <linux/gfp.h>
+
+struct node_counter {
+	atomic_t counter_in_node;
+};
+
+struct pnode_counter {
+	struct node_counter * __percpu  *counter;
+	struct node_counter **nodes;
+};
+
+static inline int pnode_counter_init(struct pnode_counter *pnc, gfp_t gfp)
+{
+	struct node_counter **nodes;
+	int i, j, cpu;
+
+	nodes = kzalloc(nr_node_ids * sizeof(struct node_counter *), gfp);
+	if (!nodes)
+		goto err_nodes;
+
+	for_each_node(i) {
+		nodes[i] = kzalloc_node(sizeof(struct node_counter), gfp, i);
+		if (!nodes[i])
+			goto err_node_counter;
+	}
+
+	pnc->counter = alloc_percpu_gfp(struct node_counter *, gfp);
+	if (!pnc->counter)
+		goto err_node_counter;
+
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(pnc->counter, cpu) = nodes[cpu_to_node(cpu)];
+
+	pnc->nodes = nodes;
+
+	return 0;
+
+ err_node_counter:
+	for (j = 0; j < i; j++)
+		kfree(nodes[j]);
+	kfree(nodes);
+ err_nodes:
+	return -ENOMEM;
+}
+
+static inline void pnode_counter_deinit(struct pnode_counter *pnc)
+{
+	int i;
+
+	for_each_node(i) {
+		struct node_counter *node = pnc->nodes[i];
+
+		kfree(node);
+	}
+	free_percpu(pnc->counter);
+	kfree(pnc->nodes);
+}
+
+static inline void pnode_counter_inc(struct pnode_counter *pnc)
+{
+	struct node_counter *node = this_cpu_read(*pnc->counter);
+
+	atomic_inc(&node->counter_in_node);
+}
+
+static inline void pnode_counter_inc_cpu(struct pnode_counter *pnc, int cpu)
+{
+	struct node_counter *node = *per_cpu_ptr(pnc->counter, cpu);
+
+	atomic_inc(&node->counter_in_node);
+}
+
+static inline void pnode_counter_dec(struct pnode_counter *pnc)
+{
+	struct node_counter *node = this_cpu_read(*pnc->counter);
+
+	atomic_dec(&node->counter_in_node);
+}
+
+static inline void pnode_counter_dec_cpu(struct pnode_counter *pnc, int cpu)
+{
+	struct node_counter *node = *per_cpu_ptr(pnc->counter, cpu);
+
+	atomic_dec(&node->counter_in_node);
+}
+
+static inline void pnode_counter_set(struct pnode_counter *pnc, int val)
+{
+	int i;
+	struct node_counter *node = this_cpu_read(*pnc->counter);
+
+	for_each_node(i)
+		atomic_set(&pnc->nodes[i]->counter_in_node, 0);
+	atomic_set(&node->counter_in_node, val);
+}
+
+static inline long pnode_counter_read_all(struct pnode_counter *pnc)
+{
+	int i;
+	long val = 0;
+
+	for_each_node(i)
+		val += atomic_read(&pnc->nodes[i]->counter_in_node);
+
+	return val;
+}
+
+#endif /* _LINUX_PERNODE_COUNTER_H */


Thanks,
Ming
