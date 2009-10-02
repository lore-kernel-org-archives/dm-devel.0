From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 10:53:29 +0200
Message-ID: <1254473609.6378.24.camel@marge.simson.net>
References: <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
	 <1254341139.7695.36.camel@marge.simson.net>
	 <20090930202447.GA28236@redhat.com>
	 <1254382405.7595.9.camel@marge.simson.net>
	 <20091001185816.GU14918@kernel.dk>
	 <1254464628.7158.101.camel@marge.simson.net>
	 <20091002080417.GG14918@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753858AbZJBIxh@vger.kernel.org>
In-Reply-To: <20091002080417.GG14918@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-10-02 at 10:04 +0200, Jens Axboe wrote:
> On Fri, Oct 02 2009, Mike Galbraith wrote:

> > If we're in the idle window and doing the async drain thing, we've at
> > the spot where Vivek's patch helps a ton.  Seemed like a great time to
> > limit the size of any io that may land in front of my sync reader to
> > plain "you are not alone" quantity.
> 
> You can't be in the idle window and doing async drain at the same time,
> the idle window doesn't start until the sync queue has completed a
> request. Hence my above rant on device interference.

I'll take your word for it.

        /*
         * Drain async requests before we start sync IO
         */
        if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])

Looked about the same to me as..
 
	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);

..where Vivek prevented turning 1 into 0, so I stamped it ;-)

> > Dunno, I was just tossing rocks and sticks at it.
> > 
> > I don't really understand the reasoning behind overloading:  I can see
> > that allows cutting thicker slabs for the disk, but with the streaming
> > writer vs reader case, seems only the writers can do that.  The reader
> > is unlikely to be alone isn't it?  Seems to me that either dd, a flusher
> > thread or kjournald is going to be there with it, which gives dd a huge
> > advantage.. it has two proxies to help it squabble over disk, konsole
> > has none.
> 
> That is true, async queues have a huge advantage over sync ones. But
> sync vs async is only part of it, any combination of queued sync, queued
> sync random etc have different ramifications on behaviour of the
> individual queue.
> 
> It's not hard to make the latency good, the hard bit is making sure we
> also perform well for all other scenarios.

Yeah, that's why I'm trying to be careful about what I say, I know full
well this ain't easy to get right.  I'm not even thinking of submitting
anything, it's just diagnostic testing.

WRT my who can overload theory, I instrumented for my own edification.

Overload totally forbidden, stamps ergo disabled.

fairness=0  11.3 avg  (ie == virgin source)
fairness=1   2.8 avg

Back to virgin settings, instrument who is overloading during sequences of..
        echo 2 > /proc/sys/vm/drop_caches
        sh -c "perf stat -- konsole -e exit" 2>&1|tee -a $LOGFILE
..with dd continually running.

1 second counts for above.
...
[  916.585880] od_sync: 0  od_async: 87  reject_sync: 0  reject_async: 37
[  917.662585] od_sync: 0  od_async: 126  reject_sync: 0  reject_async: 53
[  918.732872] od_sync: 0  od_async: 96  reject_sync: 0  reject_async: 22
[  919.743730] od_sync: 0  od_async: 75  reject_sync: 0  reject_async: 15
[  920.914549] od_sync: 0  od_async: 81  reject_sync: 0  reject_async: 17
[  921.988198] od_sync: 0  od_async: 123  reject_sync: 0  reject_async: 30
...minutes long

(reject == fqq->dispatched >= 4 * max_dispatch)

Doing the same with firefox, I did see the burst below one time, dunno
what triggered that.  I watched 6 runs, and only saw such a burst once.
Typically, numbers are the same as konsole, with a very rare 4 or
5 for sync sneaking in.

[ 1988.177758] od_sync: 0  od_async: 104  reject_sync: 0  reject_async: 48
[ 1992.291779] od_sync: 19  od_async: 83  reject_sync: 0  reject_async: 82
[ 1993.300850] od_sync: 79  od_async: 0  reject_sync: 28  reject_async: 0
[ 1994.313327] od_sync: 147  od_async: 104  reject_sync: 90  reject_async: 16
[ 1995.378025] od_sync: 14  od_async: 45  reject_sync: 0  reject_async: 2
[ 1996.456871] od_sync: 15  od_async: 74  reject_sync: 1  reject_async: 7
[ 1997.611226] od_sync: 0  od_async: 84  reject_sync: 0  reject_async: 14

Never noticed a sync overload watching a make -j4 for a couple minutes.
