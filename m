From: Jens Axboe <axboe@kernel.dk>
Subject: Re: kernel oops with blk-mq-sched latest
Date: Tue, 17 Jan 2017 05:00:47 -0800
Message-ID: <10ffc7ea-564f-8eb0-ee00-5c1277c7efc3@kernel.dk>
References: <b6ce1c64-3577-8f86-b6a4-44a3a4ad2cbc@suse.de>
 <55b21574-baf3-25d9-a920-299fa2d04d72@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <55b21574-baf3-25d9-a920-299fa2d04d72@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/17/2017 04:47 AM, Jens Axboe wrote:
> On 01/17/2017 12:57 AM, Hannes Reinecke wrote:
>> Hi Jens,
>>
>> I gave your latest patchset from
>>
>> git.kernel.dk/linux-block blk-mq-sched
>>
>> I see a kernel oops when shutting down:
>>
>> [ 2132.708929] systemd-shutdown[1]: Detaching DM devices.
>> [ 2132.965107] BUG: unable to handle kernel NULL pointer dereference at
>> 00000000
>> 00000001
>> [ 2133.037182] IP: dd_merged_requests+0x6/0x60
>> [ 2133.077816] PGD 0
>> [ 2133.077818]
>> [ 2133.113087] Oops: 0000 [#1] SMP
>> [ list of modules removed ]
>> [ 2133.925265] CPU: 20 PID: 1 Comm: systemd-shutdow Not tainted
>> 4.10.0-rc4+ #543
>> [ 2133.990034] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 09/18/2013
>> [ 2134.050522] task: ffff88042d614040 task.stack: ffffc90003150000
>> [ 2134.106915] RIP: 0010:dd_merged_requests+0x6/0x60
>> [ 2134.150593] RSP: 0018:ffffc90003153b18 EFLAGS: 00010002
>> [ 2134.198740] RAX: ffffffff81cc6de0 RBX: ffff8804296d5040 RCX:
>> 0000000000000001
>> [ 2134.262708] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
>> ffff8804296d5040
>> [ 2134.326987] RBP: ffffc90003153b30 R08: 0000000000000000 R09:
>> 0000000000000000
>> [ 2134.391054] R10: 0000000000000000 R11: 0001f8180001f815 R12:
>> 0000000000000000
>> [ 2134.456095] R13: ffff8804296d5040 R14: ffff8804099801f0 R15:
>> 0000000000000004
>> [ 2134.521196] FS:  00007fd64d3bf840(0000) GS:ffff88042f900000(0000)
>> knlGS:0000000000000000
>> [ 2134.595178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 2134.648637] CR2: 0000000000000001 CR3: 000000081b892000 CR4:
>> 00000000000406e0
>> [ 2134.713349] Call Trace:
>> [ 2134.737168]  ? elv_drain_elevator+0x29/0xa0
>> [ 2134.775821]  __blk_drain_queue+0x52/0x1a0
>> [ 2134.812473]  blk_queue_bypass_start+0x6e/0xa0
>> [ 2134.854009]  blkcg_deactivate_policy+0x30/0xf0
>> [ 2134.894993]  blk_throtl_exit+0x34/0x50
>> [ 2134.929450]  blkcg_exit_queue+0x35/0x40
>> [ 2134.965089]  blk_release_queue+0x33/0xe0
>> [ 2135.001364]  kobject_cleanup+0x63/0x170
>> [ 2135.037412]  kobject_put+0x25/0x50
>> [ 2135.068622]  blk_cleanup_queue+0x198/0x260
>> [ 2135.107780]  cleanup_mapped_device+0xb5/0xf0 [dm_mod]
>> [ 2135.154741]  __dm_destroy+0x1a5/0x290 [dm_mod]
>> [ 2135.195009]  dm_destroy+0x13/0x20 [dm_mod]
>> [ 2135.232149]  dev_remove+0xde/0x120 [dm_mod]
>> [ 2135.270184]  ? dev_suspend+0x210/0x210 [dm_mod]
>> [ 2135.311478]  ctl_ioctl+0x20b/0x510 [dm_mod]
>> [ 2135.349680]  ? terminate_walk+0xc3/0x140
>> [ 2135.385442]  ? kmem_cache_free+0x10/0x260
>> [ 2135.422315]  dm_ctl_ioctl+0x13/0x20 [dm_mod]
>>
>> Known issue?
> 
> Try with this, looks like we're calling the old bypass path for the new
> path, which is now triggering because q->elevator is true.

Should have grepped, there's one more path that uses the old bypass
path for q->mq_ops, potentially. This one handles that one, too.


diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8ba0af780e88..2630f64bed19 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1223,7 +1223,11 @@ int blkcg_activate_policy(struct request_queue *q,
 	if (blkcg_policy_enabled(q, pol))
 		return 0;
 
-	blk_queue_bypass_start(q);
+	if (q->mq_ops) {
+		blk_mq_freeze_queue(q);
+		blk_mq_quiesce_queue(q);
+	} else
+		blk_queue_bypass_start(q);
 pd_prealloc:
 	if (!pd_prealloc) {
 		pd_prealloc = pol->pd_alloc_fn(GFP_KERNEL, q->node);
@@ -1261,7 +1265,10 @@ int blkcg_activate_policy(struct request_queue *q,
 
 	spin_unlock_irq(q->queue_lock);
 out_bypass_end:
-	blk_queue_bypass_end(q);
+	if (q->mq_ops)
+		blk_mq_unfreeze_queue(q);
+	else
+		blk_queue_bypass_end(q);
 	if (pd_prealloc)
 		pol->pd_free_fn(pd_prealloc);
 	return ret;
@@ -1284,7 +1291,12 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	if (!blkcg_policy_enabled(q, pol))
 		return;
 
-	blk_queue_bypass_start(q);
+	if (q->mq_ops) {
+		blk_mq_freeze_queue(q);
+		blk_mq_quiesce_queue(q);
+	} else
+		blk_queue_bypass_start(q);
+
 	spin_lock_irq(q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
@@ -1304,7 +1316,11 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	}
 
 	spin_unlock_irq(q->queue_lock);
-	blk_queue_bypass_end(q);
+
+	if (q->mq_ops)
+		blk_mq_unfreeze_queue(q);
+	else
+		blk_queue_bypass_end(q);
 }
 EXPORT_SYMBOL_GPL(blkcg_deactivate_policy);
 
diff --git a/block/elevator.c b/block/elevator.c
index d14cb87e6564..464372840774 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -613,6 +613,9 @@ void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
 
+	if (WARN_ON_ONCE(q->mq_ops))
+		return;
+
 	lockdep_assert_held(q->queue_lock);
 
 	while (q->elevator->type->ops.sq.elevator_dispatch_fn(q, 1))

-- 
Jens Axboe

