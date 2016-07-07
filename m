From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: fix blk_queue_split() resource exhaustion
Date: Thu, 7 Jul 2016 10:36:39 -0400
Message-ID: <20160707143637.GA2890@redhat.com>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: linux-block@vger.kernel.org, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Ming Lei <ming.lei@canonical.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 22 2016 at  4:22am -0400,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> For a long time, generic_make_request() converts recursion into
> iteration by queuing recursive arguments on current->bio_list.
> 
> This is convenient for stacking drivers,
> the top-most driver would take the originally submitted bio,
> and re-submit a re-mapped version of it, or one or more clones,
> or one or more new allocated bios to its backend(s). Which
> are then simply processed in turn, and each can again queue
> more "backend-bios" until we reach the bottom of the driver stack,
> and actually dispatch to the real backend device.
> 
> Any stacking driver ->make_request_fn() could expect that,
> once it returns, any backend-bios it submitted via recursive calls
> to generic_make_request() would now be processed and dispatched, before
> the current task would call into this driver again.
> 
> This is changed by commit
>   54efd50 block: make generic_make_request handle arbitrarily sized bios
> 
> Drivers may call blk_queue_split() inside their ->make_request_fn(),
> which may split the current bio into a front-part to be dealt with
> immediately, and a remainder-part, which may need to be split even
> further. That remainder-part will simply also be pushed to
> current->bio_list, and would end up being head-of-queue, in front
> of any backend-bios the current make_request_fn() might submit during
> processing of the fron-part.
> 
> Which means the current task would immediately end up back in the same
> make_request_fn() of the same driver again, before any of its backend
> bios have even been processed.
> 
> This can lead to resource starvation deadlock.
> Drivers could avoid this by learning to not need blk_queue_split(),
> or by submitting their backend bios in a different context (dedicated
> kernel thread, work_queue context, ...). Or by playing funny re-ordering
> games with entries on current->bio_list.
> 
> Instead, I suggest to distinguish between recursive calls to
> generic_make_request(), and pushing back the remainder part in
> blk_queue_split(), by pointing current->bio_lists to a
> 	struct recursion_to_iteration_bio_lists {
> 		struct bio_list recursion;
> 		struct bio_list remainder;
> 	}
> 
> To have all bios targeted to drivers lower in the stack processed before
> processing the next piece of a bio targeted at the higher levels,
> as long as queued bios resulting from recursion are available,
> they will continue to be processed in FIFO order.
> Pushed back bio-parts resulting from blk_queue_split() will be processed
> in LIFO order, one-by-one, whenever the recursion list becomes empty.
> 
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Roland Kammerer <roland.kammerer@linbit.com>

I've rebased this patch against Jens' for-4.8/core (resolved conflict in
blk-merge.c) and pushed the result to this wip2 branch, feel free to use
it to resubmit for inclusion if/when that is the way forward, see:

http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip2&id=36cee4b1ddef0a46562045b421792a847c570b6b
