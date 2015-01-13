From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm + blk-mq soft lockup complaint
Date: Tue, 13 Jan 2015 15:28:03 +0100
Message-ID: <54B52B73.7040807@sandisk.com>
References: <54B3F78D.2020704@kernel.dk> <54B3FE89.200@sandisk.com>
	<54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<20150112191138.GC21518@redhat.com>
	<20150112202113.GA23234@redhat.com> <54B50F9D.2040000@sandisk.com>
	<20150113141746.GA30411@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150113141746.GA30411@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On 01/13/15 15:18, Mike Snitzer wrote:
> On Tue, Jan 13 2015 at  7:29am -0500,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>> However, I hit another issue while running I/O on top of a multipath
>> device (on a kernel with lockdep and SLUB memory poisoning enabled):
>>
>> NMI watchdog: BUG: soft lockup - CPU#7 stuck for 23s! [kdmwork-253:0:3116]
>> CPU: 7 PID: 3116 Comm: kdmwork-253:0 Tainted: G        W      3.19.0-rc4-debug+ #1
>> Call Trace:
>>  [<ffffffff8118e4be>] kmem_cache_alloc+0x28e/0x2c0
>>  [<ffffffff81346aca>] alloc_iova_mem+0x1a/0x20
>>  [<ffffffff81342c8e>] alloc_iova+0x2e/0x250
>>  [<ffffffff81344b65>] intel_alloc_iova+0x95/0xd0
>>  [<ffffffff81348a15>] intel_map_sg+0xc5/0x260
>>  [<ffffffffa07e0661>] srp_queuecommand+0xa11/0xc30 [ib_srp]
>>  [<ffffffffa001698e>] scsi_dispatch_cmd+0xde/0x5a0 [scsi_mod]
>>  [<ffffffffa0017480>] scsi_queue_rq+0x630/0x700 [scsi_mod]
>>  [<ffffffff8125683d>] __blk_mq_run_hw_queue+0x1dd/0x370
>>  [<ffffffff81256aae>] blk_mq_alloc_request+0xde/0x150
>>  [<ffffffff8124bade>] blk_get_request+0x2e/0xe0
>>  [<ffffffffa07ebd0f>] __multipath_map.isra.15+0x1cf/0x210 [dm_multipath]
>>  [<ffffffffa07ebd6a>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
>>  [<ffffffffa044abb5>] map_tio_request+0x1d5/0x3a0 [dm_mod]
>>  [<ffffffff81075d16>] kthread_worker_fn+0x86/0x1b0
>>  [<ffffffff81075c0f>] kthread+0xef/0x110
>>  [<ffffffff814db42c>] ret_from_fork+0x7c/0xb0
> 
> Unfortunate.  Is this still with a 16MB backing device or is it real
> hardware?  Can you share the workload so that myself and/or Keith could
> try to reproduce?
 
Hello Mike,

This is still with a 16MB RAM disk as backing device. The fio job I
used to trigger this was as follows:

dev=/dev/sdc
fio --bs=4K --ioengine=libaio --rw=randread --buffered=0 --numjobs=12   \
    --iodepth=128 --iodepth_batch=64 --iodepth_batch_complete=64        \
    --thread --norandommap --loops=$((2**31)) --runtime=60              \
    --group_reporting --gtod_reduce=1 --name=$dev --filename=$dev       \
    --invalidate=1

Bart.
 
