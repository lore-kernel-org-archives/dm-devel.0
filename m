From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 13:04:26 +0200
Message-ID: <20091002110426.GB28233@kernel.dk>
References: <200910021255.27689.czoccolo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757693AbZJBLEY@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200910021255.27689.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, riel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 02 2009, Corrado Zoccolo wrote:
> Hi Jens,
> On Fri, Oct 2, 2009 at 11:28 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Fri, Oct 02 2009, Ingo Molnar wrote:
> >>
> >> * Jens Axboe <jens.axboe@oracle.com> wrote:
> >>
> >
> > It's really not that simple, if we go and do easy latency bits, then
> > throughput drops 30% or more. You can't say it's black and white latency
> > vs throughput issue, that's just not how the real world works. The
> > server folks would be most unpleased.
> Could we be more selective when the latency optimization is introduced?
> 
> The code that is currently touched by Vivek's patch is:
>         if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>             (cfqd->hw_tag && CIC_SEEKY(cic)))
>                 enable_idle = 0;
> basically, when fairness=1, it becomes just:
>         if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle)
>                 enable_idle = 0;
> 
> Note that, even if we enable idling here, the cfq_arm_slice_timer will use
> a different idle window for seeky (2ms) than for normal I/O.
> 
> I think that the 2ms idle window is good for a single rotational SATA
> disk scenario, even if it supports NCQ. Realistic access times for
> those disks are still around 8ms (but it is proportional to seek
> lenght), and waiting 2ms to see if we get a nearby request may pay
> off, not only in latency and fairness, but also in throughput.

I agree, that change looks good.

> What we don't want to do is to enable idling for NCQ enabled SSDs
> (and this is already taken care in cfq_arm_slice_timer) or for hardware RAIDs.

Right, it was part of the bigger SSD optimization stuff I did a few
revisions back.

> If we agree that hardware RAIDs should be marked as non-rotational, then that
> code could become:
> 
>         if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
>             (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag && CIC_SEEKY(cic)))
>                 enable_idle = 0;
>         else if (sample_valid(cic->ttime_samples)) {
> 		unsigned idle_time = CIC_SEEKY(cic) ? CFQ_MIN_TT : cfqd->cfq_slice_idle;
> 		if (cic->ttime_mean > idle_time)
>                         enable_idle = 0;
>                 else
>                         enable_idle = 1;
>         }

Yes agree on that too. We probably should make a different flag for
hardware raids, telling the io scheduler that this device is really
composed if several others. If it's composited only by SSD's (or has a
frontend similar to that), then non-rotational applies.

But yes, we should pass that information down.

-- 
Jens Axboe
