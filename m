From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [dm-devel] [RFC] block: fix blk_queue_split() resource exhaustion
Date: Thu, 7 Jul 2016 14:39:37 +0200
Message-ID: <20160707123937.GK13335@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <871t36ggcr.fsf@notabene.neil.brown.name>
 <20160707081616.GH13335@soda.linbit>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160707081616.GH13335@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 07, 2016 at 10:16:16AM +0200, Lars Ellenberg wrote:
> > > Instead, I suggest to distinguish between recursive calls to
> > > generic_make_request(), and pushing back the remainder part in
> > > blk_queue_split(), by pointing current->bio_lists to a
> > > 	struct recursion_to_iteration_bio_lists {
> > > 		struct bio_list recursion;
> > > 		struct bio_list remainder;
> > > 	}
> > >
> > > To have all bios targeted to drivers lower in the stack processed before
> > > processing the next piece of a bio targeted at the higher levels,
> > > as long as queued bios resulting from recursion are available,
> > > they will continue to be processed in FIFO order.
> > > Pushed back bio-parts resulting from blk_queue_split() will be processed
> > > in LIFO order, one-by-one, whenever the recursion list becomes empty.
> > 
> > I really like this change.  It seems to precisely address the problem.
> > The "problem" being that requests for "this" device are potentially
> > mixed up with requests from underlying devices.
> > However I'm not sure it is quite general enough.
> > 
> > The "remainder" list is a stack of requests aimed at "this" level or
> > higher, and I think it will always exactly fit that description.
> > The "recursion" list needs to be a queue of requests aimed at the next
> > level down, and that doesn't quiet work, because once you start acting
> > on the first entry in that list, all the rest become "this" level.
> 
> Uhm, well,
> that's how it has been since you introduced this back in 2007, d89d879.
> And it worked.
> 
> > I think you can address this by always calling ->make_request_fn with an
> > empty "recursion", then after the call completes, splice the "recursion"
> > list that resulted (if any) on top of the "remainder" stack.
> > 
> > This way, the "remainder" stack is always "requests for lower-level
> > devices before request for upper level devices" and the "recursion"
> > queue is always "requests for devices below the current level".
> 
> Yes, I guess that would work as well,
> but may need "empirical proof" to check for performance regressions.
> 
> > I also really *don't* like the idea of punting to a separate thread - it
> > seems to be just delaying the problem.
> > 
> > Can you try move the bio_list_init(->recursion) call to just before
> > the ->make_request_fn() call, and adding
> >     bio_list_merge_head(->remainder, ->recursion)
> > just after?
> > (or something like that) and confirm it makes sense, and works?
> 
> Sure, will do.

Attached,
on top of the patch of my initial post.
Also fixes the issue for me.

> I'd suggest this would be a patch on its own though, on top of this one.
> Because it would change the order in which stacked bios are processed
> wrt the way it used to be since 2007 (my suggestion as is does not).
> 
> Which may change performance metrics.
> It may even improve some of them,
> or maybe it does nothing, but we don't know.
> 
> Thanks,
> 
>     Lars
> 

--2fHTh5uZTiUOsy+g
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-block-generic_make_request-recursive-bios-process-de.patch"

From 73254eae63786aca0af10e42e5b41465c90d8da8 Mon Sep 17 00:00:00 2001
From: Lars Ellenberg <lars.ellenberg@linbit.com>
Date: Thu, 7 Jul 2016 11:03:30 +0200
Subject: [PATCH] block: generic_make_request() recursive bios: process deepest
 levels first

By providing each q->make_request_fn() with an empty "recursion"
bio_list, then merging any recursively submitted bios to the
head of the "remainder" list, we can make the recursion-to-iteration
logic in generic_make_request() process deepest level bios first.

---

As suggested by Neil Brown while discussing
[RFC] block: fix blk_queue_split() resource exhaustion
https://lkml.org/lkml/2016/7/7/27

Stack: qA -> qB -> qC -> qD

=== Without this patch:

generic_make_request(bio_orig to qA)

	recursion: empty, remainder: empty
qA->make_request_fn(bio_orig)
	potential call to bio_queue_split()
	result: bio_S, bio_R
	recursion: empty, remainder: bio_R
	bio_S
	generic_make_request(bio_S to qB)
	recursion: bio_S, remainder: bio_R
<- return
pop:	recursion: empty, remainder: bio_R
qB->make_request_fn(bio_S)
	remap, maybe many clones because of striping
	generic_make_request(clones to qC)
	recursion: bio_C1, bio_C2, bio_C3
	remainder: bio_R
<- return
pop:	recursion: bio_C2, bio_C3,
	remainder: bio_R
qC->make_request_fn(bio_C1)
	remap, ...
	generic_make_request(clones to qD)
	recursion: bio_C2, bio_C3, bio_D1_1, bio_D1_2
	remainder: bio_R
<- return
pop:	recursion: bio_C3, bio_D1_1, bio_D1_2
	remainder: bio_R
qC->make_request_fn(bio_C2)
	recursion: bio_C3, bio_D1_1, bio_D1_2, bio_D2_1, bio_D2_2
	remainder: bio_R
<- return
pop:	recursion: bio_D1_1, bio_D1_2, bio_D2_1, bio_D2_2
	remainder: bio_R
qC->make_request_fn(bio_C3)
...

=== With this patch:

generic_make_request(bio_orig to qA)

	recursion: empty, remainder: empty
qA->make_request_fn(bio_orig)
	potential call to bio_queue_split()
	result: bio_S, bio_R
	recursion: empty, remainder: bio_R
	bio_S
	generic_make_request(bio_S to qB)
	recursion: bio_S, remainder: bio_R
<- return
merge_head:
	recursion: empty, remainder: bio_S, bio_R
pop:	recursion: empty, remainder: bio_R
qB->make_request_fn(bio_S)
	remap, maybe many clones because of striping
	generic_make_request(clones to qC)
	recursion: bio_C1, bio_C2, bio_C3
	remainder: bio_R
<- return
merge_head:
	recursion: empty
	remainder: bio_C1, bio_C2, bio_C3, bio_R
pop:	remainder: bio_C2, bio_C3, bio_R
qC->make_request_fn(bio_C1)
	remap, ...
	generic_make_request(clones to qD)
	recursion: bio_D1_1, bio_D1_2
	remainder: bio_C2, bio_C3, bio_R
<- return
merge_head:
	recursion: empty
	remainder: bio_D1_1, bio_D1_2, bio_C2, bio_C3, bio_R
pop
qC->make_request_fn(bio_D1_1)
	remainder: bio_D1_2, bio_C2, bio_C3, bio_R
...
---
 block/bio.c      | 17 ++++++++++++++---
 block/blk-core.c | 10 +++++-----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2ffcea0..92733ce 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -366,13 +366,17 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	 */
 
 	bio_list_init(&punt);
-	bio_list_init(&nopunt);
 
+	bio_list_init(&nopunt);
 	while ((bio = bio_list_pop(&current->bio_lists->recursion)))
 		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
-
 	current->bio_lists->recursion = nopunt;
 
+	bio_list_init(&nopunt);
+	while ((bio = bio_list_pop(&current->bio_lists->remainder)))
+		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
+	current->bio_lists->remainder = nopunt;
+
 	spin_lock(&bs->rescue_lock);
 	bio_list_merge(&bs->rescue_list, &punt);
 	spin_unlock(&bs->rescue_lock);
@@ -380,6 +384,13 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	queue_work(bs->rescue_workqueue, &bs->rescue_work);
 }
 
+static bool current_has_pending_bios(void)
+{
+	return current->bio_lists &&
+		(!bio_list_empty(&current->bio_lists->recursion) ||
+		 !bio_list_empty(&current->bio_lists->remainder));
+}
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -459,7 +470,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		 * workqueue before we retry with the original gfp_flags.
 		 */
 
-		if (current->bio_lists && !bio_list_empty(&current->bio_lists->recursion))
+		if (current_has_pending_bios())
 			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
diff --git a/block/blk-core.c b/block/blk-core.c
index f03ff4c..675131b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2070,22 +2070,22 @@ blk_qc_t generic_make_request(struct bio *bio)
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_lists_on_stack.recursion);
 	bio_list_init(&bio_lists_on_stack.remainder);
 	current->bio_lists = &bio_lists_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
 		if (likely(blk_queue_enter(q, false) == 0)) {
+			bio_list_init(&bio_lists_on_stack.recursion);
 			ret = q->make_request_fn(q, bio);
-
 			blk_queue_exit(q);
+			bio_list_merge_head(&bio_lists_on_stack.remainder,
+					&bio_lists_on_stack.recursion);
+			/* XXX bio_list_init(&bio_lists_on_stack.recursion); */
 		} else {
 			bio_io_error(bio);
 		}
-		bio = bio_list_pop(&current->bio_lists->recursion);
-		if (!bio)
-			bio = bio_list_pop(&current->bio_lists->remainder);
+		bio = bio_list_pop(&current->bio_lists->remainder);
 	} while (bio);
 	current->bio_lists = NULL; /* deactivate */
 
-- 
1.9.1


--2fHTh5uZTiUOsy+g--
