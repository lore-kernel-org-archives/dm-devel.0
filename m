From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Mon, 19 Sep 2016 12:47:52 +0200
Message-ID: <20160919104752.GV5016@twins.programming.kicks-ass.net>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
 <alpine.LRH.2.02.1609190542150.15526@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1609190542150.15526@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 19, 2016 at 05:49:07AM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 13 Sep 2016, Peter Zijlstra wrote:
> 
> > Hi all,
> > 
> > While grepping for PREEMPT_VOLUNTARY I ran into dm_bufio_cond_resched()
> > and wondered WTH it was about.
> 
> cond_resched() calls _cond_resched() even if when we have a preemptive 
> kernel - with preemptive kernel, calling cond_resched is pointless because 
> rescheduling is done peemtively.
> 
> So, I added that dm_bufio_cond_resched(), that does nothing on peemptive 
> kernels (and also on PREEMPT_NONE kernels where the user doesn't care 
> about latency).
> 
> What is the reason why cond_resched() tests for rescheduling with 
> preemptive kernel? Why should I use cond_resched() in that case?

Because every body else does too. 'Fixing' something like that in the dm
code is entirely the wrong place. Also, you loose out on the
might_sleep() warning implied in it.

As it happens, I have a patch fixing that somewhere, let me try and get
it merged.

But thanks for the reminder, I'll go write a Changelog for this so that
people can commit.
