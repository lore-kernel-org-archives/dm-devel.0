From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Fri, 23 Sep 2016 14:26:07 +0200
Message-ID: <20160923122607.GK5008@twins.programming.kicks-ass.net>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
 <20160913133959.GA22833@redhat.com>
 <20160919105325.GW5016@twins.programming.kicks-ass.net>
 <alpine.LRH.2.02.1609221645510.4447@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.20.1609222257050.5640@nanos>
 <20160923073435.GL2794@worktop>
 <alpine.DEB.2.20.1609230956540.5640@nanos>
 <1474633030.4025.11.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474633030.4025.11.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 23, 2016 at 02:17:10PM +0200, Mike Galbraith wrote:
> On Fri, 2016-09-23 at 10:00 +0200, Thomas Gleixner wrote:
> > On Fri, 23 Sep 2016, Peter Zijlstra wrote:
> 
> > > Is anybody still using PREEMPT_NONE? Most workloads also care about
> > > latency to some extend. Lots of code has explicit cond_resched() and
> > > doesn't worry.
> > 
> > Dunno. But I bet there are workloads which love it.
> 
> SUSE definitely uses it.  I had presumed that was enterprise standard.

Hmm, I thought most distros defaulted to PREEMPT_VOLUNTARY.
