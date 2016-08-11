From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource
 exhaustion
Date: Wed, 10 Aug 2016 21:16:52 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608102103040.10662@mail.ewheeler.net>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com> <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com> <20160711141042.GY13335@soda.linbit> <87lh17efap.fsf@notabene.neil.brown.name> <alpine.LRH.2.11.1607121834220.16228@mail.ewheeler.net>
 <20160713023232.GA6034@redhat.com> <20160719090024.GB20868@soda.linbit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160719090024.GB20868@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Eric Wheeler <bcache@lists.ewheeler.net>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Tue, 19 Jul 2016, Lars Ellenberg wrote:
> On Tue, Jul 12, 2016 at 10:32:33PM -0400, Mike Snitzer wrote:
> > On Tue, Jul 12 2016 at 10:18pm -0400,
> > Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > 
> > > On Tue, 12 Jul 2016, NeilBrown wrote:
> > > 
> > > > On Tue, Jul 12 2016, Lars Ellenberg wrote:
> > > > ....
> > > > >
> > > > > Instead, I suggest to distinguish between recursive calls to
> > > > > generic_make_request(), and pushing back the remainder part in
> > > > > blk_queue_split(), by pointing current->bio_lists to a
> > > > > 	struct recursion_to_iteration_bio_lists {
> > > > > 		struct bio_list recursion;
> > > > > 		struct bio_list queue;
> > > > > 	}
> > > > >
> > > > > By providing each q->make_request_fn() with an empty "recursion"
> > > > > bio_list, then merging any recursively submitted bios to the
> > > > > head of the "queue" list, we can make the recursion-to-iteration
> > > > > logic in generic_make_request() process deepest level bios first,
> > > > > and "sibling" bios of the same level in "natural" order.
> > > > >
> > > > > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > > > > Signed-off-by: Roland Kammerer <roland.kammerer@linbit.com>
> > > > 
> > > > Reviewed-by: NeilBrown <neilb@suse.com>
> > > > 
> > > > Thanks again for doing this - I think this is a very significant
> > > > improvement and could allow other simplifications.
> > > 
> > > Thank you Lars for all of this work!  
> > > 
> > > It seems like there have been many 4.3+ blockdev stacking issues and this 
> > > will certainly address some of those (maybe all of them?).  (I think we 
> > > hit this while trying drbd in 4.4 so we dropped back to 4.1 without 
> > > issue.)  It would be great to hear 4.4.y stable pick this up if 
> > > compatible.
> > > 
> > > 
> > > Do you believe that this patch would solve any of the proposals by others 
> > > since 4.3 related to bio splitting/large bios?  I've been collecting a 
> > > list, none of which appear have landed yet as of 4.7-rc7 (but correct me 
> > > if I'm wrong):

[... cut unrelated A,B ... ]

> > > C.  [1/3] block: flush queued bios when process blocks to avoid deadlock
> > > 	by Mikulas Patocka: https://patchwork.kernel.org/patch/9204125/
> > > 		(was https://patchwork.kernel.org/patch/7398411/)
> 
> As it stands now, this is yet an other issue, but related.
> 
> From the link above:
> 
> | ** Here is the dm-snapshot deadlock that was observed:
> | 
> | 1) Process A sends one-page read bio to the dm-snapshot target. The bio
> | spans snapshot chunk boundary and so it is split to two bios by device
> | mapper.
> | 
> | 2) Device mapper creates the first sub-bio and sends it to the snapshot
> | driver.
> | 
> | 3) The function snapshot_map calls track_chunk (that allocates a
> | structure
> | dm_snap_tracked_chunk and adds it to tracked_chunk_hash) and then remaps
> | the bio to the underlying device and exits with DM_MAPIO_REMAPPED.
> | 
> | 4) The remapped bio is submitted with generic_make_request, but it isn't
> | issued - it is added to current->bio_list instead.
> | 
> | 5) Meanwhile, process B (dm's kcopyd) executes pending_complete for the
> | chunk affected be the first remapped bio, it takes down_write(&s->lock)
> | and then loops in __check_for_conflicting_io, waiting for
> | dm_snap_tracked_chunk created in step 3) to be released.
> | 
> | 6) Process A continues, it creates a second sub-bio for the rest of the
> | original bio.
> 
> Aha.
> Here is the relation.
> If "A" had only ever processed "just the chunk it can handle now",
> and "pushed back" the rest of the incoming bio,
> it could rely on all deeper level bios to have been submitted already.
> 
> But this does not look like it easily fits into the current DM model.
> 
> | 7) snapshot_map is called for this new bio, it waits on
> | down_write(&s->lock) that is held by Process B (in step 5).
> 
> There is an other suggestion:
> Use down_trylock (or down_timeout),
> and if it fails, push back the currently to-be-processed bio.
> We can introduce a new bio helper for that.
> Kind of what blk_queue_split() does with my patch applied.
> 
> Or even better, ignore the down_trylock suggestion,
> simply not iterate over all pieces first,
> but process one piece, and return back the the
> iteration in generic_make_request.
> 
> A bit of conflict here may be that DM has all its own
> split and clone and queue magic, and wants to process
> "all of the bio" before returning back to generic_make_request().
> 
> To change that, __split_and_process_bio() and all its helpers
> would need to learn to "push back" (pieces of) the bio they are
> currently working on, and not push back via "DM_ENDIO_REQUEUE",
> but by bio_list_add_head(&current->bio_lists->queue, piece_to_be_done_later).
> 
> Then, after they processed each piece,
> *return* all the way up to the top-level generic_make_request(),
> where the recursion-to-iteration logic would then
> make sure that all deeper level bios, submitted via
> recursive calls to generic_make_request() will be processed, before the
> next, pushed back, piece of the "original incoming" bio.
> 
> And *not* do their own iteration over all pieces first.
> 
> Probably not as easy as dropping the while loop,
> using bio_advance, and pushing that "advanced" bio back to
> current->...queue?
> 
> static void __split_and_process_bio(struct mapped_device *md,
> 				    struct dm_table *map, struct bio *bio)
> ...
> 		ci.bio = bio;
> 		ci.sector_count = bio_sectors(bio);
> 		while (ci.sector_count && !error)
> 			error = __split_and_process_non_flush(&ci);
> ...
> 		error = __split_and_process_non_flush(&ci);
> 		if (ci.sector_count)
> 			bio_advance()
> 			bio_list_add_head(&current->bio_lists->queue, )
> ...
> 
> Something like that, maybe?
> Just a thought.

Hello all,

Has anyone been able to make progress with resolution to this issue?  

Might the suggestions from Lars help solve BZ# 119841?
	https://bugzilla.kernel.org/show_bug.cgi?id=119841

--
Eric Wheeler
