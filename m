From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm integrity: use init_completion instead of
 COMPLETION_INITIALIZER_ONSTACK
Date: Mon, 21 Aug 2017 12:13:54 -0400
Message-ID: <20170821161354.GA8375@redhat.com>
References: <20170815151242.2637861-1-arnd@arndb.de>
 <20170815151242.2637861-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170815151242.2637861-2-arnd@arndb.de>
Sender: linux-raid-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@kernel.org>, Byungchul Park <byungchul.park@lge.com>, Peter Zijlstra <peterz@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Aug 15 2017 at 11:11am -0400,
Arnd Bergmann <arnd@arndb.de> wrote:

> The new lockdep support for completions causeed the stack usage
> in dm-integrity to explode, in case of write_journal from 504 bytes
> to 1120 (using arm gcc-7.1.1):
> 
> drivers/md/dm-integrity.c: In function 'write_journal':
> drivers/md/dm-integrity.c:827:1: error: the frame size of 1120 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> The problem is that not only the size of 'struct completion' grows
> significantly, but we end up having multiple copies of it on the stack
> when we assign it from a local variable after the initial declaration.
> 
> COMPLETION_INITIALIZER_ONSTACK() is the right thing to use when we
> want to declare and initialize a completion on the stack. However,
> this driver doesn't do that and instead initializes the completion
> just before it is used.
> 
> In this case, init_completion() does the same thing more efficiently,
> and drops the stack usage for the function above down to 496 bytes.
> While the other functions in this file are not bad enough to cause
> a warning, they benefit equally from the change, so I do the change
> across the entire file. In the one place where we reuse a completion,
> I picked the cheaper reinit_completion() over init_completion().
> 
> Fixes: cd8084f91c02 ("locking/lockdep: Apply crossrelease to completions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> The patch causing this is currently part of linux-next, scheduled for
> 4.14, so it would be good to have this in the same release.

This looks good.  Please just stage it for 4.14 along with its
dependencies via whatever tree they are going in.

Acked-by: Mike Snitzer <snitzer@redhat.com>
