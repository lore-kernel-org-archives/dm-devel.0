From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Wed, 24 Dec 2014 13:21:43 -0500
Message-ID: <20141224182143.GA12922@redhat.com>
References: <20141217230622.GC15390@redhat.com> <54943714.2040704@acm.org>
	<20141219153801.GA8697@redhat.com>
	<20141219171438.GA6347@redhat.com> <5498389D.6070909@acm.org>
	<20141222184910.GB8054@redhat.com> <54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
	<549AB979.4050302@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <549AB979.4050302@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Wed, Dec 24 2014 at  8:02am -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 12/23/14 22:42, Mike Snitzer wrote:
> > I've rebased with this fix folded into both the 'for-next' and
> > 'dm-for-3.20-blk-mq' branches of linux-dm.git
> 
> Thanks, that's appreciated. However, with this tree I ran into a
> different issue:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000002a0
> IP: [<ffffffff811b2d18>] blk_account_io_completion+0x48/0x90
> PGD 8150b6067 PUD 8150b4067 PMD 0 
> Oops: 0000 [#1] SMP 
...
> Call Trace:
>  <IRQ> 
>  [<ffffffff811b2d9a>] blk_update_request+0x3a/0x300
>  [<ffffffffa000902f>] scsi_end_request+0x2f/0x1e0 [scsi_mod]
>  [<ffffffffa000b451>] scsi_io_completion+0x101/0x690 [scsi_mod]
>  [<ffffffffa000124a>] scsi_finish_command+0xca/0x130 [scsi_mod]
>  [<ffffffffa000abff>] scsi_softirq_done+0x12f/0x160 [scsi_mod]
>  [<ffffffff811ba1de>] __blk_mq_complete_request_remote+0xe/0x10
>  [<ffffffff8109ea6d>] generic_smp_call_function_single_interrupt+0x5d/0x150
>  [<ffffffff8102c382>] smp_call_function_single_interrupt+0x22/0x40
>  [<ffffffff813e925a>] call_function_single_interrupt+0x6a/0x70
>  <EOI> 
>  [<ffffffff812f0b15>] ? cpuidle_enter_state+0x55/0xc0
>  [<ffffffff812f0b07>] ? cpuidle_enter_state+0x47/0xc0
>  [<ffffffff812f0c32>] cpuidle_enter+0x12/0x20
>  [<ffffffff81078bcc>] cpu_startup_entry+0x22c/0x2c0
>  [<ffffffff8102ca1d>] start_secondary+0x14d/0x170
> 
> (gdb) list *(blk_account_io_completion+0x48)
> 0xffffffff811b2d18 is in blk_account_io_completion (block/blk-core.c:2114).
> 2109                    struct hd_struct *part;
> 2110                    int cpu;
> 2111
> 2112                    cpu = part_stat_lock();
> 2113                    part = req->part;
> 2114                    part_stat_add(cpu, part, sectors[rw], bytes >> 9);
> 2115                    part_stat_unlock();
> 2116            }
> 2117    }
> 2118

This is odd considering blk-mq defaults to setting QUEUE_FLAG_IO_STAT,
so each request will have REQ_IO_STAT set.

I'm not sure what would account for this NULL pointer (my code appears
to be slightly different than yours but AFAICT req->part is NULL in your
crash, which shouldn't ever happen if IO stats are enabled).

Are you manually enabling/disabling IO stats via sysfs at all?
