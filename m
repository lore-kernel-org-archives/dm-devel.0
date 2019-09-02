From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 00:02:38 +0100
Message-ID: <7b94004e-4a65-462b-cd6b-5cbd23d607bf@arm.com>
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

Hi,

On 02/09/2019 22:05, Alexey Dobriyan wrote:
> 32-bit accesses are shorter than 64-bit accesses on x86_64.
> Nothing uses 64-bitness of ->state.
> 
> Space savings are ~2KB on F30 kernel config.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---

Interestingly this has been volatile long since forever (or 2002, which is
my take on "forever" given the history tree), although the task states
seem to have never gone above 0x1000 (the current TASK_STATE_MAX).

[...]

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -643,7 +643,7 @@ struct task_struct {
>  	struct thread_info		thread_info;
>  #endif
>  	/* -1 unrunnable, 0 runnable, >0 stopped: */
> -	volatile long			state;
> +	volatile int			state;

This leads to having some padding after this field (w/o randomization):

struct task_struct {
	struct thread_info         thread_info;          /*     0    24 */
	volatile int               state;                /*    24     4 */

	/* XXX 4 bytes hole, try to pack */

	void *                     stack;                /*    32     8 */

Though seeing as this is also the boundary of the randomized layout we can't
really do much better without changing the boundary itself. So much for
cacheline use :/

Anyway, task_struct doesn't shrink but we can cut some corners in the asm,
I guess that's fine?

[...]
