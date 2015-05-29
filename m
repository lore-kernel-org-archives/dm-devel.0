From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm: fix false alarm in free_rq_clone() for non
	blk-mq target
Date: Fri, 29 May 2015 00:29:06 +0000
Message-ID: <5567B2D2.5080907@ce.jp.nec.com>
References: <5566CAE8.4070404@ce.jp.nec.com>
	<20150528191457.GA26218@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150528191457.GA26218@redhat.com>
Content-Language: ja-JP
Content-ID: <A7B6AB3C4414F44597F151C1D42E3D83@gisp.nec.co.jp>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/29/15 04:14, Mike Snitzer wrote:
> On Thu, May 28 2015 at  3:59am -0400,
> Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:
> 
>> When stacking request-based dm device on non blk-mq device
>> and device-mapper target could not map the request
>> (error target is used, multipath target with all paths down, etc),
>> following warning will show up once:
>>
>>   WARNING: CPU: 7 PID: 0 at drivers/md/dm.c:1090 free_rq_clone+0x7a/0xf0
>>   CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.1.0-rc5+ #1
>>   ..
>>   Call Trace:
>>    <IRQ>  [<ffffffff81558095>] dump_stack+0x45/0x57
>>    [<ffffffff8105ef3a>] warn_slowpath_common+0x8a/0xc0
>>    [<ffffffff8105f02a>] warn_slowpath_null+0x1a/0x20
>>    [<ffffffffa020bf3a>] free_rq_clone+0x7a/0xf0 [dm_mod]
>>    [<ffffffffa020c7cc>] dm_softirq_done+0x13c/0x250 [dm_mod]
>>    [<ffffffff812b87a0>] blk_done_softirq+0x80/0xa0
>>    [<ffffffff81062f44>] __do_softirq+0xf4/0x2d0
>>    [<ffffffff81063425>] irq_exit+0x125/0x130
>>    [<ffffffff81037f05>] smp_call_function_single_interrupt+0x35/0x40
>>    [<ffffffff8156027e>] call_function_single_interrupt+0x6e/0x80
>>    <EOI>  [<ffffffff8104b576>] ? native_safe_halt+0x6/0x10
>>    [<ffffffff810b6348>] ? rcu_eqs_enter+0x68/0x90
>>    [<ffffffff8100d6fe>] default_idle+0x1e/0xc0
>>    [<ffffffff8100e1df>] arch_cpu_idle+0xf/0x20
>>    [<ffffffff810a269c>] cpu_startup_entry+0x2fc/0x3a0
>>    [<ffffffff81038892>] start_secondary+0x182/0x1b0
>>
>> The warning was added by commit aa6df8dd28c0 ("dm: fix free_rq_clone()
>> NULL pointer when requeueing unmapped request").
>>
>> But free_rq_clone() with clone->q == NULL is valid usage for non blk-mq
>> underlying device. Such a call can happen via dm_kill_unmapped_request().
> 
> dm_kill_unmapped_request() is called from the blk-mq error path too

Yes, but:

> (e.g. if clone_and_map_rq fails with an error).  So this isn't non
> blk-mq specific.

unmapped request does not have clone in the case of blk-mq?
(as the clone_and_map_rq() API suggests)

Then dm_softirq_done(orig) for dm_kill_unmapped_request() will fall
into 'if (!clone)' path.
Thus neither of dm_done(clone), dm_end_request(clone) nor free_rq_clone()
will be called.

> dm_kill_unmapped_request() sets REQ_FAILED, which dm_softirq_done()
> checks for and will set 'mapped' to false.  I think a proper fix is to
> pass 'mapped' into dm_end_request() and then pass it to free_rq_clone().
> Like so, what do you think?

So I don't think it's necessary to extend dm_end_request() with 'mapped'
parameter.

For blk-mq underlying device, we can (and should be able to) assume
unmapped request as not having clone.
It might be better to clear tio->clone in free_rq_clone().
Currently it doesn't seem matter because tio is not reused for non-mq DM
and always re-initialized for mq DM, though.

-- 
Jun'ichi Nomura, NEC Corporation

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1c62ed8..f252adc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1087,14 +1087,14 @@ static void free_rq_clone(struct request *clone, bool must_be_mapped)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 
-	WARN_ON_ONCE(must_be_mapped && !clone->q);
-
 	blk_rq_unprep_clone(clone);
 
-	if (md->type == DM_TYPE_MQ_REQUEST_BASED)
+	if (md->type == DM_TYPE_MQ_REQUEST_BASED) {
 		/* stacked on blk-mq queue(s) */
+		WARN_ON_ONCE(must_be_mapped && !clone->q);
 		tio->ti->type->release_clone_rq(clone);
+		tio->clone = NULL;
-	else if (!md->queue->mq_ops)
+	} else if (!md->queue->mq_ops)
 		/* request_fn queue stacked on request_fn queue(s) */
 		free_clone_request(md, clone);
 	/*
