From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Sun, 7 Feb 2016 18:54:54 +0200
Message-ID: <56B776DE.30101@dev.mellanox.co.il>
References: <20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com> <20160203182423.GA12913@redhat.com>
	<56B2F5BC.1010700@suse.de> <20160204135420.GA18227@redhat.com>
	<20160205151334.GA82754@redhat.com> <20160205180515.GA25808@redhat.com>
	<20160205191909.GA25982@redhat.com>
	<56B7659C.8040601@dev.mellanox.co.il>
	<56B772D6.2090403@sandisk.com> <56B77444.3030106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56B77444.3030106@dev.mellanox.co.il>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: dm-devel.ids


>> If so, can you check with e.g.
>> perf record -ags -e LLC-load-misses sleep 10 && perf report whether this
>> workload triggers perhaps lock contention ? What you need to look for in
>> the perf output is whether any functions occupy more than 10% CPU time.
>
> I will, thanks for the tip!

The perf report is very similar to the one that started this effort..

I'm afraid we'll need to resolve the per-target m->lock in order
to scale with NUMA...

-  17.33%              fio  [kernel.kallsyms]        [k] 
queued_spin_lock_slowpath
    - queued_spin_lock_slowpath
       - 52.09% _raw_spin_lock_irq
            __multipath_map
            multipath_clone_and_map
            map_request
            dm_mq_queue_rq
            __blk_mq_run_hw_queue
            blk_mq_run_hw_queue
            blk_mq_insert_requests
            blk_mq_flush_plug_list
            blk_flush_plug_list
            blk_finish_plug
            do_io_submit
            SyS_io_submit
            entry_SYSCALL_64_fastpath
          + io_submit
       - 46.87% _raw_spin_lock_irqsave
          - 99.97% multipath_busy
               dm_mq_queue_rq
               __blk_mq_run_hw_queue
               blk_mq_run_hw_queue
               blk_mq_insert_requests
               blk_mq_flush_plug_list
               blk_flush_plug_list
               blk_finish_plug
               do_io_submit
               SyS_io_submit
               entry_SYSCALL_64_fastpath
             + io_submit
+   4.99%              fio  [kernel.kallsyms]        [k] 
blk_account_io_start
+   3.93%              fio  [dm_multipath]           [k] __multipath_map
+   2.64%              fio  [dm_multipath]           [k] multipath_busy
+   2.38%              fio  [kernel.kallsyms]        [k] 
_raw_spin_lock_irqsave
+   2.31%              fio  [dm_mod]                 [k] dm_mq_queue_rq
+   2.25%              fio  [kernel.kallsyms]        [k] 
blk_mq_hctx_mark_pending
+   1.81%              fio  [kernel.kallsyms]        [k] blk_queue_enter
+   1.61%             perf  [kernel.kallsyms]        [k] 
copy_user_generic_string
+   1.40%              fio  [kernel.kallsyms]        [k] 
__blk_mq_run_hw_queue
+   1.26%              fio  [kernel.kallsyms]        [k] part_round_stats
+   1.14%              fio  [kernel.kallsyms]        [k] _raw_spin_lock_irq
+   0.96%              fio  [kernel.kallsyms]        [k] __bt_get
+   0.73%              fio  [kernel.kallsyms]        [k] enqueue_task_fair
+   0.71%              fio  [kernel.kallsyms]        [k] enqueue_entity
+   0.69%              fio  [dm_mod]                 [k] dm_start_request
+   0.60%      ksoftirqd/6  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   0.59%     ksoftirqd/10  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   0.59%              fio  [kernel.kallsyms]        [k] 
_raw_spin_unlock_irqrestore
+   0.58%     ksoftirqd/19  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   0.58%     ksoftirqd/18  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   0.58%     ksoftirqd/23  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
