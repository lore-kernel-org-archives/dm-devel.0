From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] sched: make struct task_struct::state 32-bit
Date: Mon, 2 Sep 2019 23:51:55 -0700
Message-ID: <20190903065155.GA28322@infradead.org>
References: <20190902210558.GA23013@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190902210558.GA23013@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, aarcange@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids

On Tue, Sep 03, 2019 at 12:05:58AM +0300, Alexey Dobriyan wrote:
> 32-bit accesses are shorter than 64-bit accesses on x86_64.
> Nothing uses 64-bitness of ->state.
> 
> Space savings are ~2KB on F30 kernel config.

I guess we'd save even more when moving from a volatile to
WRITE_ONCE/READ_ONCE..
