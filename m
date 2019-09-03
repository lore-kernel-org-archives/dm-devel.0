From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 18:29:06 +0100
Message-ID: <d8ad0be1-4ed7-df74-d415-2b1c9a44bac7@arm.com>
References: <20190902210558.GA23013@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190902210558.GA23013@avx2>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>, mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids

On 02/09/2019 22:05, Alexey Dobriyan wrote:
> 32-bit accesses are shorter than 64-bit accesses on x86_64.
> Nothing uses 64-bitness of ->state.
> 
> Space savings are ~2KB on F30 kernel config.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  arch/ia64/kernel/perfmon.c   |    4 ++--
>  block/blk-mq.c               |    2 +-
>  drivers/md/dm.c              |    4 ++--
>  fs/userfaultfd.c             |    2 +-
>  include/linux/sched.h        |    6 +++---
>  include/linux/sched/debug.h  |    2 +-
>  include/linux/sched/signal.h |    2 +-
>  kernel/freezer.c             |    2 +-
>  kernel/kthread.c             |    4 ++--
>  kernel/locking/mutex.c       |    6 +++---
>  kernel/locking/semaphore.c   |    2 +-
>  kernel/rcu/rcutorture.c      |    4 ++--
>  kernel/rcu/tree_stall.h      |    6 +++---
>  kernel/sched/core.c          |    8 ++++----
>  lib/syscall.c                |    2 +-
>  15 files changed, 28 insertions(+), 28 deletions(-)
> 

It looks like you missed a few places. There's a long prev_state in
sched/core.c::finish_task_switch() for instance.

I suppose that's where coccinelle oughta help but I'm really not fluent
in that. Is there a way to make it match p.state accesses with p task_struct?
And if so, can we make it change the type of the variable being read from
/ written to?

How did you come up with this changeset, did you pickaxe for some regexp?

[...]
