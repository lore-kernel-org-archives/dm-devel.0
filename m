From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource exhaustion
Date: Sat, 7 Jan 2017 20:56:52 +0100
Message-ID: <20170107195651.GI4153@soda.linbit>
References: <877f67lrnw.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f67lrnw.fsf@notabene.neil.brown.name>
 <20160719090024.GB20868@soda.linbit>
Sender: linux-bcache-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, NeilBrown <neilb@suse.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>, Jack Wang <jack.wang.usish@gmail.com>, Michael Wang <yun>
List-Id: dm-devel.ids

On Sat, Jan 07, 2017 at 10:01:07AM +1100, NeilBrown wrote:
> On Sat, Jan 07 2017, Mike Snitzer wrote:
> > On Fri, Jan 06 2017 at 12:34pm -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> On Fri, 6 Jan 2017, Mikulas Patocka wrote:
> >> > On Wed, 4 Jan 2017, Mike Snitzer wrote:
> >> > > On Wed, Jan 04 2017 at 12:12am -0500,
> >> > > NeilBrown <neilb@suse.com> wrote:
...

> >> > And with the above above patch, the snapshot deadlock bug still happens.
> >
> > That is really unfortunate.  Would be useful to dig in and understand
> > why.  Because ordering of the IO in generic_make_request() really should
> > take care of it.
> 
> I *think* you might be able to resolve this by changing
> __split_and_process_bio() to only ever perform a single split.  No
> looping.
> i.e. if the bio is too big to handle directly, then split off the front
> to a new bio, which you bio_chain to the original.  The original then
> has bio_advance() called to stop over the front, then
> generic_make_request() so it is queued.
> Then the code proceeds to __clone_and_map_data_bio() on the front that
> got split off.
> When that completes it *doesn't* loop round, but returns into
> generic_make_request() which does the looping and makes sure to handle
> the lowest-level bio next.
> 
> something vaguely like this:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3086da5664f3..06ee0960e415 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1216,6 +1216,14 @@ static int __split_and_process_non_flush(struct clone_info *ci)
>  
>  	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
>  
> +	if (len < ci->sector_count) {
> +		struct bio *split = bio_split(bio, len, GFP_NOIO, fs_bio_set);
> +		bio_chain(split, bio);
> +		generic_make_request(bio);
> +		bio = split;
> +		ci->sector_count = len;
> +	}
> +
>  	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
>  	if (r < 0)
>  		return r;
> 
> though I haven't tested, and the change (if it works) should probably be
> more fully integrated into surrounding code.
> 
> You probably don't want to use "fs_bio_set" either - a target-local
> pool would be best.
> 
> NeilBrown

Which is pretty much what I suggested in this thread
back in July already, see below.

Cheers,
	Lars

On Tue, Jul 19, 2016 at 11:00:24AM +0200, Lars Ellenberg wrote:
...

> > > C.  [1/3] block: flush queued bios when process blocks to avoid deadlock
> > > 	by Mikulas Patocka: https://patchwork.kernel.org/patch/9204125/
> > > 		(was https://patchwork.kernel.org/patch/7398411/)
> 
> As it stands now,
> this is yet an other issue, but related.
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
