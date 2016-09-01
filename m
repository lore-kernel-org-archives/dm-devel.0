From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 15:35:28 -0400
Message-ID: <20160901193528.GA12407@redhat.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<82ff8574-8b73-8ba3-9098-741060f38fca@sandisk.com>
	<20160901031355.GB4741@redhat.com>
	<BLUPR02MB1683D3D8F604FEB429143A4381E20@BLUPR02MB1683.namprd02.prod.outlook.com>
	<20160901150503.GA11074@redhat.com>
	<ca45a2b1-99bc-1779-3b4f-a03343ccbd9a@sandisk.com>
	<20160901155051.GA11353@redhat.com>
	<20160901161253.GA11410@redhat.com>
	<e8cf7d03-82a6-cba3-60c4-c436ae3a24f7@sandisk.com>
	<20160901190505.GA12106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160901190505.GA12106@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Sep 01 2016 at  3:05pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Sep 01 2016 at  1:59pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > * A "if (!blk_queue_stopped(q))" test needs to be added in
> > dm_stop_queue() to avoid the following hang (that test was present
> > in my version of the patch that adds the
> > blk_mq_{freeze,unfreeze}_queue() calls):
> > 
> >     sysrq: SysRq : Show Blocked State
> >       task                        PC stack   pid father
> >     multipathd      D ffff8803c8d37b80     0  3242      1 0x00000000
> >     Call Trace:
> >      [<ffffffff81627087>] schedule+0x37/0x90
> >      [<ffffffff813097e1>] blk_mq_freeze_queue_wait+0x51/0xb0
> >      [<ffffffff8130be05>] blk_mq_freeze_queue+0x15/0x20
> >      [<ffffffffa034d882>] dm_stop_queue+0x62/0xc0 [dm_mod]
> >      [<ffffffffa0342a1b>] dm_swap_table+0x2fb/0x370 [dm_mod]
> >      [<ffffffffa0347875>] dev_suspend+0x95/0x220 [dm_mod]
> >      [<ffffffffa03480fc>] ctl_ioctl+0x1fc/0x550 [dm_mod]
> >      [<ffffffffa034845e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
> >      [<ffffffff811ee27f>] do_vfs_ioctl+0x8f/0x690
> >      [<ffffffff811ee8bc>] SyS_ioctl+0x3c/0x70
> >      [<ffffffff8162d125>] entry_SYSCALL_64_fastpath+0x18/0xa8
> 
> OK, I've adjusted accordingly and pushed dm-4.8 and dm-4.9 again (with
> force, sorry about that).

I'm testing the result.. needs more time.  I'll let you know once my
mptest-based testing passes.  (I think I'm holding the q->lock too
long in dm_mq_stop_queue()).
