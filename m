From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [RFC] block: fix blk_queue_split() resource exhaustion
Date: Tue, 28 Jun 2016 10:45:36 +0200
Message-ID: <20160628084534.GI3239@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <CACVXFVOtzcPpmg9Z_P6xN99dW=Sb_cCQNd-VcP0s5Nk0yHbwXQ@mail.gmail.com>
 <20160624142711.GF3239@soda.linbit>
 <CACVXFVMtMi9WXYQLa3_XZi7W8ZsJe1GnnTLX+7tRMhFAMUSHtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVMtMi9WXYQLa3_XZi7W8ZsJe1GnnTLX+7tRMhFAMUSHtA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Sat, Jun 25, 2016 at 05:30:29PM +0800, Ming Lei wrote:
> On Fri, Jun 24, 2016 at 10:27 PM, Lars Ellenberg
> <lars.ellenberg@linbit.com> wrote:
> > On Fri, Jun 24, 2016 at 07:36:57PM +0800, Ming Lei wrote:
> >> >
> >> > This is not a theoretical problem.
> >> > At least int DRBD, and an unfortunately high IO concurrency wrt. the
> >> > "max-buffers" setting, without this patch we have a reproducible deadlock.
> >>
> >> Is there any log about the deadlock? And is there any lockdep warning
> >> if it is enabled?
> >
> > In DRBD, to avoid potentially very long internal queues as we wait for
> > our replication peer device and local backend, we limit the number of
> > in-flight bios we accept, and block in our ->make_request_fn() if that
> > number exceeds a configured watermark ("max-buffers").
> >
> > Works fine, as long as we could assume that once our make_request_fn()
> > returns, any bios we "recursively" submitted against the local backend
> > would be dispatched. Which used to be the case.
> >
> > commit 54efd50 block: make generic_make_request handle arbitrarily sized bios
> > introduced blk_queue_split(), which will split any bio that is
> > violating the queue limits into a smaller piece to be processed
> > right away, and queue the "rest" on current->bio_list to be
> > processed by the iteration in generic_make_request() once the
> > current ->make_request_fn() returns.
> >
> > Before that, any user was supposed to go through bio_add_page(),
> > which would call our merge bvec function, and that should already
> > be sufficient to not violate queue limits.
> >
> > Previously, typically the next in line bio to be processed would
> > be the cloned one we passed down to our backend device, which in
> > case of further stacking devices (e.g. logical volume, raid1 or
> > similar) may again push further bios on that list.
> > All of which would simply be processed in turn.
> 
> Could you clarify if the issue is triggered in drbd without dm/md involved?
> Or the issue is always triggered with dm/md over drbd?
> 
> As Mike mentioned, there is one known issue with dm-snapshot.


The issue can always be triggered, even if only DRBD is involved.

> If your ->make_request_fn() is called several times, each time
> at least you should dispatch one bio returnd from blk_queue_split(),
> so I don't understand why even one bio isn't dispatched out.

I'll try to "visualize" the mechanics of "my" deadlock here.

Just to clarify the effect, assume we had a driver that
for $reasons would limit the number of in-flight IO to
one single bio.

=== before bio_queue_split()

Previously, if something would want to read some range of blocks,
it would allocate a bio, call bio_add_page() a number of times,
and once the bio was "full", call generic_make_request(),
and fill the next bio, then submit that one.

Stacking: "single_in_flight" (q1) -> "sda" (q2)

  generic_make_request(bio)	current->bio_list	in-flight
   B_orig_1				NULL		0
    q1->make_request_fn(B_orig_1)	empty
    							1
	recursive call, queues:		B_1_remapped
    iterative call:
    q2->make_request_fn(B_1_remapped)	empty
    		-> actually dispatched to hardware
  return of generic_make_request(B_orig_1).
   B_orig_2
    q1->make_request_fn(B_orig_1)
    							1
	blocks, waits for in-flight to drop
	...
	completion of B_orig_1				0

	recursive call, queues:		B_2_remapped
    iterative call:
    q2->make_request_fn(B_2_remapped)	empty
    		-> actually dispatched to hardware
  return of generic_make_request(B_orig_2).


=== with bio_queue_split()

Now, uppser layers buils one large bio.

  generic_make_request(bio)	current->bio_list	in-flight
   B_orig				NULL		0
    q1->make_request_fn(B_orig)		empty
    blk_queue_split(B_orig) splits into
    					B_orig_r1
    B_orig_s1
    							1
	recursive call, queues:		B_orig_r1, B_s1_remapped
    iterative call:
    q1->make_request_fn(B_orig_r1)	B_s1_remapped
	blocks, waits for in-flight to drop
	...
	which never happens,
	because B_s1_remapped has not even been submitted to q2 yet,
	let alone dispatched to hardware.


Obviously we don't limit ourselves to just one request, but with larger
incoming bios, with the number of times we split them, with the number
of stacking layers below us, or even layers below us that *also*
call blk_queue_split (or equivalent open coded clone and split)
themselves to split even further, things get worse.

    Lars

