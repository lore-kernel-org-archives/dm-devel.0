From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Fri, 23 Sep 2016 11:26:58 +0200
Message-ID: <20160923092658.GA24285@gmail.com>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
 <20160913133959.GA22833@redhat.com>
 <20160919105325.GW5016@twins.programming.kicks-ass.net>
 <alpine.LRH.2.02.1609221645510.4447@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.20.1609222257050.5640@nanos>
 <20160923073435.GL2794@worktop>
 <alpine.DEB.2.20.1609230956540.5640@nanos>
 <20160923090524.GE5008@twins.programming.kicks-ass.net>
 <alpine.DEB.2.20.1609231111010.5640@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1609231111010.5640@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 23 Sep 2016, Peter Zijlstra wrote:
> > On Fri, Sep 23, 2016 at 10:00:37AM +0200, Thomas Gleixner wrote:
> > > On Fri, 23 Sep 2016, Peter Zijlstra wrote:
> > > > It is, might_sleep() implies might_resched(). In fact, that's all what
> > > > PREEMPT_VOLUNTARY is, make the might_sleep() debug test imply a resched
> > > > point.
> > > 
> > > Grr, how intuitive - NOT!
> > 
> > No, it actually makes sense. Because you 'obviously' only call
> > might_sleep() in contexts that should be able to sleep (if not, it'll
> > holler). So they're already placed right for preemption.
> 
> I disagree. might_sleep() is commonly known as a debug mechanism and it
> existed before the preemption stuff went in. So the easy way to sprinkle
> preemption points into the kernel was to hijack might_sleep(). I know it's
> historical, but that doesnt make it any more intuitive.

If we rename it to might_as_well_sleep() it becomes more intuitive! ;-)

Thanks,

	Ingo
