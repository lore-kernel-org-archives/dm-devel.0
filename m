From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 21:19:20 +0300
Message-ID: <20190903181920.GA22358@avx2>
References: <20190902210558.GA23013@avx2>
 <d8ad0be1-4ed7-df74-d415-2b1c9a44bac7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d8ad0be1-4ed7-df74-d415-2b1c9a44bac7@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Schneider <valentin.schneider@arm.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 03, 2019 at 06:29:06PM +0100, Valentin Schneider wrote:
> On 02/09/2019 22:05, Alexey Dobriyan wrote:
> > 32-bit accesses are shorter than 64-bit accesses on x86_64.
> > Nothing uses 64-bitness of ->state.

> It looks like you missed a few places. There's a long prev_state in
> sched/core.c::finish_task_switch() for instance.
> 
> I suppose that's where coccinelle oughta help but I'm really not fluent
> in that. Is there a way to make it match p.state accesses with p task_struct?
> And if so, can we make it change the type of the variable being read from
> / written to?

Coccinelle is interesting: basic

	- foo
	+ bar

doesn't find "foo" in function arguments.

I'm scared of coccinelle.

> How did you come up with this changeset, did you pickaxe for some regexp?

No, manually, backtracking up to the call chain.
Maybe I missed a few places.
