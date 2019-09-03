From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 19:23:03 +0300
Message-ID: <20190903162303.GA2173@avx2>
References: <20190902210558.GA23013@avx2>
 <7b94004e-4a65-462b-cd6b-5cbd23d607bf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7b94004e-4a65-462b-cd6b-5cbd23d607bf@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Schneider <valentin.schneider@arm.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 03, 2019 at 12:02:38AM +0100, Valentin Schneider wrote:
> struct task_struct {
> 	struct thread_info         thread_info;          /*     0    24 */
> 	volatile int               state;                /*    24     4 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	void *                     stack;                /*    32     8 */
> 
> Though seeing as this is also the boundary of the randomized layout we can't
> really do much better without changing the boundary itself. So much for
> cacheline use :/

Cacheline use of task_struct is pretty hopeless because of all the ifdefs.
