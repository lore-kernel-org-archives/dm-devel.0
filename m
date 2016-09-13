From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Tue, 13 Sep 2016 09:39:59 -0400
Message-ID: <20160913133959.GA22833@redhat.com>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160913084520.GA5012@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alasdair Kergon <agk@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 13 2016 at  4:45am -0400,
Peter Zijlstra <peterz@infradead.org> wrote:

> Hi all,
> 
> While grepping for PREEMPT_VOLUNTARY I ran into dm_bufio_cond_resched()
> and wondered WTH it was about.
> 
> Is there anything wrong with the below patch?

No, I'll pick it up for 4.9 merge.  Mikulas added it for sparc or
something.  I cannot recall _the_ reason (I wasn't maintaining DM back
then) but at the time both Alasdair and Joe Thornber reasoned that it
needed to go -- and that if it was really needed that it should be done
in terms of a proper patch to sched.h, etc.

So I'm not sure how this dm-bufio local cond_resched() wrapper still got
in... happy to take your patch.

Please respond with whatever SOB you'd like applied to the patch header.

Thanks,
Mike
