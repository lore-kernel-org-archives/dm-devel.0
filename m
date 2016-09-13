From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Tue, 13 Sep 2016 14:49:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1609131448100.6233@nanos>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913084520.GA5012@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Ingo Molnar <mingo@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 13 Sep 2016, Peter Zijlstra wrote:

> Hi all,
> 
> While grepping for PREEMPT_VOLUNTARY I ran into dm_bufio_cond_resched()
> and wondered WTH it was about.
> 
> Is there anything wrong with the below patch?

Not at all, except that you forgot to add your SOB to it :)

Acked-by: Thomas Gleixner <tglx@linutronix.de>
