From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 08:49:21 -0400
Message-ID: <20091002124921.GA4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200910021255.27689.czoccolo@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Oct 02, 2009 at 12:55:25PM +0200, Corrado Zoccolo wrote:
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

Actually I am not touching this code. Looking at the V10, I have not
changed anything here in idling code.

I think we are seeing latency improvements with fairness=1 because, CFQ
does pure roundrobin and once a seeky reader expires, it is put at the
end of the queue.

I retained the same behavior if fairness=0 but if fairness=1, then I don't
put the seeky reader at the end of queue, instead it gets vdisktime based
on the disk it has used. So it should get placed ahead of sync readers.

I think following is the code snippet in "elevator-fq.c" which is making a
difference.

        /*
         * We don't want to charge more than allocated slice otherwise
         * this
         * queue can miss one dispatch round doubling max latencies. On
         * the
         * other hand we don't want to charge less than allocated slice as
         * we stick to CFQ theme of queue loosing its share if it does not
         * use the slice and moves to the back of service tree (almost).
         */
        if (!ioq->efqd->fairness)
                queue_charge = allocated_slice;
 
So if a sync readers consumes 100ms and an seeky reader dispatches only
one request, then in CFQ, seeky reader gets to dispatch next request after
another 100ms.

With fairness=1, it should get a lower vdisktime when it comes with a new
request because its last slice usage was less (like CFS sleepers as mike
said). But this will make a difference only if there are more than one
processes in the system otherwise a vtime jump will take place by the time
seeky readers gets backlogged.

Anyway, once I started timestamping the queues and started keeping a cache
of expired queues, then any queue which got new request almost
immediately, should get a lower vdisktime assigned if it did not use the
full time slice in the previous dispatch round. Hence  with fairness=1,
seeky readers kind of get more share of disk (fair share), because these
are now placed ahead of streaming readers and hence get better latencies.

In short, most likely, better latencies are being experienced because
seeky reader is getting lower time stamp (vdisktime), because it did not
use its full time slice in previous dispatch round, and not because we kept
the idling enabled on seeky reader.

Thanks
Vivek

> Note that, even if we enable idling here, the cfq_arm_slice_timer will use
> a different idle window for seeky (2ms) than for normal I/O.
> 
> I think that the 2ms idle window is good for a single rotational SATA disk scenario,
> even if it supports NCQ. Realistic access times for those disks are still around 8ms
> (but it is proportional to seek lenght), and waiting 2ms to see if we get a nearby
> request may pay off, not only in latency and fairness, but also in throughput.
> 
> What we don't want to do is to enable idling for NCQ enabled SSDs
> (and this is already taken care in cfq_arm_slice_timer) or for hardware RAIDs.
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
> 
> Thanks,
> Corrado
> 
> >
> > --
> > Jens Axboe
> >
> 
> -- 
> __________________________________________________________________________
> 
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------
