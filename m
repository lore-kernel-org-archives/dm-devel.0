From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 17:12:05 +0100
Message-ID: <54B3F255.5080802@sandisk.com>
References: <alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com>
	<54B042FE.2000205@kernel.dk> <54B043FC.8000902@kernel.dk>
	<20150109214015.GA1032@redhat.com> <54B04E94.3010403@kernel.dk>
	<20150109222543.GA1190@redhat.com> <54B071DC.9000307@kernel.dk>
	<20150110014811.GA2384@redhat.com> <54B08779.2080705@kernel.dk>
	<20150110031057.GA2823@redhat.com>
	<54B3DE54.7090909@sandisk.com> <54B3EB4A.9090404@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54B3EB4A.9090404@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/12/15 16:42, Jens Axboe wrote:
> On 01/12/2015 07:46 AM, Bart Van Assche wrote:
>> bt_get: __bt_get() returned -1
>> queue_num=2, nr_tags=62, reserved_tags=0, bits_per_word=3
>> nr_free=62, nr_reserved=0, may_queue=0
>> active_queues=8
> 
> Can you add dumping of hctx->nr_active when this fails? You case is that 
> the may_queue logic says no-can-do, so it smells like the nr_active 
> accounting is wonky since you have supposedly no allocated tags, yet it 
> clearly thinks that you do.

Hello Jens,

The requested output is as follows:

bt_get: __bt_get() returned -1
queue_num=0, nr_tags=62, reserved_tags=0, bits_per_word=3
nr_free=62, nr_reserved=0, hctx->tags->active_queues=7,
hctx->nr_active=9, hctx_may_queue()=0
active_queues=7
CPU: 0 PID: 3111 Comm: kdmwork-253:6 Tainted: G        W
3.19.0-rc4-debug+ #1
Call Trace:
 [<ffffffff814d2763>] dump_stack+0x4c/0x65
 [<ffffffff81259dc7>] bt_get+0x97/0x1e0
 [<ffffffff8125a0af>] blk_mq_get_tag+0x9f/0xd0
 [<ffffffff8125522b>] __blk_mq_alloc_request+0x1b/0x210
 [<ffffffff81256a30>] blk_mq_alloc_request+0xa0/0x150
 [<ffffffff8124ba9e>] blk_get_request+0x2e/0xe0
 [<ffffffffa07d9d0f>] __multipath_map.isra.15+0x1cf/0x210 [dm_multipath]
 [<ffffffffa07d9d6a>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
 [<ffffffffa0350bb5>] map_tio_request+0x1d5/0x3a0 [dm_mod]
 [<ffffffff81075d16>] kthread_worker_fn+0x86/0x1b0
 [<ffffffff81075c0f>] kthread+0xef/0x110
 [<ffffffff814db4ec>] ret_from_fork+0x7c/0xb0

Bart.
