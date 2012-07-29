From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] Introduce percpu rw semaphores
Date: Sun, 29 Jul 2012 01:13:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz> <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
 <1343508252.2626.13184.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1343508252.2626.13184.camel@edumazet-glaptop>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org, lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Sat, 28 Jul 2012, Eric Dumazet wrote:

> On Sat, 2012-07-28 at 12:41 -0400, Mikulas Patocka wrote:
> > Introduce percpu rw semaphores
> > 
> > When many CPUs are locking a rw semaphore for read concurrently, cache
> > line bouncing occurs. When a CPU acquires rw semaphore for read, the
> > CPU writes to the cache line holding the semaphore. Consequently, the
> > cache line is being moved between CPUs and this slows down semaphore
> > acquisition.
> > 
> > This patch introduces new percpu rw semaphores. They are functionally
> > identical to existing rw semaphores, but locking the percpu rw semaphore
> > for read is faster and locking for write is slower.
> > 
> > The percpu rw semaphore is implemented as a percpu array of rw
> > semaphores, each semaphore for one CPU. When some thread needs to lock
> > the semaphore for read, only semaphore on the current CPU is locked for
> > read. When some thread needs to lock the semaphore for write, semaphores
> > for all CPUs are locked for write. This avoids cache line bouncing.
> > 
> > Note that the thread that is locking percpu rw semaphore may be
> > rescheduled, it doesn't cause bug, but cache line bouncing occurs in
> > this case.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> I am curious to see how this performs with 4096 cpus ?

Each cpu should have its own rw semaphore in its cache, so I don't see a 
problem there.

When you change block size, all 4096 rw semaphores are locked for write, 
but changing block size is not a performance sensitive operation.

> Really you shouldnt use rwlock in a path if this might hurt performance.
> 
> RCU is probably a better answer.

RCU is meaningless here. RCU allows lockless dereference of a pointer. 
Here the problem is not pointer dereference, the problem is that integer 
bd_block_size may change.

> (bdev->bd_block_size should be read exactly once )

Rewrite all direct and non-direct io code so that it reads block size just 
once ...

Mikulas
