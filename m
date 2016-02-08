From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC PATCH] dm: fix excessive dm-mq context switching
Date: Mon, 8 Feb 2016 14:21:59 +0200
Message-ID: <56B88867.4060308@dev.mellanox.co.il>
References: <20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
	<20160204135420.GA18227@redhat.com> <20160205151334.GA82754@redhat.com>
	<20160205180515.GA25808@redhat.com> <20160205191909.GA25982@redhat.com>
	<56B7659C.8040601@dev.mellanox.co.il> <56B772D6.2090403@sandisk.com>
	<56B77444.3030106@dev.mellanox.co.il>
	<56B776DE.30101@dev.mellanox.co.il>
	<20160207172055.GA6477@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160207172055.GA6477@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids


>> The perf report is very similar to the one that started this effort..
>>
>> I'm afraid we'll need to resolve the per-target m->lock in order
>> to scale with NUMA...
>
> Could be.  Just for testing, you can try the 2 topmost commits I've put
> here (once applied both __multipath_map and multipath_busy won't have
> _any_ locking.. again, very much test-only):
>
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel2

Hi Mike,

So I still don't see the IOPs scale like I expected. With these two
patches applied I see ~670K IOPs while the perf output is different
and does not indicate a clear lock contention.

--
-   4.67%              fio  [kernel.kallsyms]        [k] 
blk_account_io_start
    - blk_account_io_start
       - 56.05% blk_insert_cloned_request
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
       - 43.94% blk_mq_bio_to_request
            blk_mq_make_request
            generic_make_request
            submit_bio
            do_blockdev_direct_IO
            __blockdev_direct_IO
            blkdev_direct_IO
            generic_file_read_iter
            blkdev_read_iter
            aio_run_iocb
            io_submit_one
            do_io_submit
            SyS_io_submit
            entry_SYSCALL_64_fastpath
          + io_submit
-   2.52%              fio  [dm_mod]                 [k] dm_mq_queue_rq
    - dm_mq_queue_rq
       - 99.16% __blk_mq_run_hw_queue
            blk_mq_run_hw_queue
            blk_mq_insert_requests
            blk_mq_flush_plug_list
            blk_flush_plug_list
            blk_finish_plug
            do_io_submit
            SyS_io_submit
            entry_SYSCALL_64_fastpath
          + io_submit
-   2.52%              fio  [dm_mod]                 [k] dm_mq_queue_rq
    - dm_mq_queue_rq
       - 99.16% __blk_mq_run_hw_queue
            blk_mq_run_hw_queue
            blk_mq_insert_requests
            blk_mq_flush_plug_list
            blk_flush_plug_list
            blk_finish_plug
            do_io_submit
            SyS_io_submit
            entry_SYSCALL_64_fastpath
          + io_submit
       + 0.84% blk_mq_run_hw_queue
-   2.46%              fio  [kernel.kallsyms]        [k] 
blk_mq_hctx_mark_pending
    - blk_mq_hctx_mark_pending
       - 99.79% blk_mq_insert_requests
            blk_mq_flush_plug_list
            blk_flush_plug_list
            blk_finish_plug
            do_io_submit
            SyS_io_submit
            entry_SYSCALL_64_fastpath
          + io_submit
-   2.07%      ksoftirqd/6  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
    - blk_mq_run_hw_queues
       - 99.70% rq_completed
            dm_done
            dm_softirq_done
            blk_done_softirq
          + __do_softirq
+   2.06%      ksoftirqd/0  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   2.02%      ksoftirqd/9  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   2.00%     ksoftirqd/20  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   2.00%     ksoftirqd/12  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.99%     ksoftirqd/11  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.97%     ksoftirqd/18  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.96%      ksoftirqd/1  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.95%     ksoftirqd/14  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.95%     ksoftirqd/13  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.94%      ksoftirqd/5  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.94%      ksoftirqd/8  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.93%      ksoftirqd/2  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.92%     ksoftirqd/21  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.92%     ksoftirqd/17  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.92%      ksoftirqd/7  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.91%     ksoftirqd/23  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.84%      ksoftirqd/4  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.81%     ksoftirqd/19  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.76%      ksoftirqd/3  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.76%     ksoftirqd/16  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.75%     ksoftirqd/15  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.74%     ksoftirqd/22  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.72%     ksoftirqd/10  [kernel.kallsyms]        [k] 
blk_mq_run_hw_queues
+   1.38%             perf  [kernel.kallsyms]        [k] 
copy_user_generic_string
+   1.20%              fio  [kernel.kallsyms]        [k] enqueue_task_fair
+   1.18%              fio  [kernel.kallsyms]        [k] part_round_stats
+   1.08%              fio  [kernel.kallsyms]        [k] enqueue_entity
+   1.07%              fio  [kernel.kallsyms]        [k] _raw_spin_lock
+   1.02%              fio  [kernel.kallsyms]        [k] 
__blk_mq_run_hw_queue
+   0.79%              fio  [dm_multipath]           [k] multipath_busy
+   0.57%              fio  [kernel.kallsyms]        [k] insert_work
+   0.54%              fio  [kernel.kallsyms]        [k] blk_flush_plug_list
--
