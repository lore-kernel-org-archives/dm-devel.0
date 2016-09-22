From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Thu, 22 Sep 2016 22:59:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1609222257050.5640@nanos>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net> <20160913133959.GA22833@redhat.com> <20160919105325.GW5016@twins.programming.kicks-ass.net> <alpine.LRH.2.02.1609221645510.4447@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1609221645510.4447@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, 22 Sep 2016, Mikulas Patocka wrote:
> On Mon, 19 Sep 2016, Peter Zijlstra wrote:
> 
> > On Tue, Sep 13, 2016 at 09:39:59AM -0400, Mike Snitzer wrote:
> > > So I'm not sure how this dm-bufio local cond_resched() wrapper still got
> > > in... happy to take your patch.
> > > 
> > > Please respond with whatever SOB you'd like applied to the patch header.
> > 
> > Sorry, for the delay, here goes.
> 
> Why not change it to might_sleep()? - that would be almost equivalent to 

You mean might_resched(). might_sleep() is not even remotely equivalent.

> If we call the cond_resched() function in tight loops such as walking all 
> buffers in a list, there may be performance penalty due to the call, so 
> the call should be done only if it is really needed (i.e. in 
> CONFIG_PREEMPT_VOLUNTARY case).

Makes sense.

Thanks,

	tglx
