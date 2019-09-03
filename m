From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [dm-devel] [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 09:13:26 +0200
Message-ID: <20190903071326.GV2369@hirez.programming.kicks-ass.net>
References: <20190902210558.GA23013@avx2>
 <20190903065155.GA28322@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190903065155.GA28322@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, mingo@redhat.com, aarcange@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids

On Mon, Sep 02, 2019 at 11:51:55PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 03, 2019 at 12:05:58AM +0300, Alexey Dobriyan wrote:
> > 32-bit accesses are shorter than 64-bit accesses on x86_64.
> > Nothing uses 64-bitness of ->state.
> > 
> > Space savings are ~2KB on F30 kernel config.
> 
> I guess we'd save even more when moving from a volatile to
> WRITE_ONCE/READ_ONCE..

I doubt it; pretty much all accesses really should be using that.

Not saying we shouldn't maybe do that; but that's going to be massive
churn.
