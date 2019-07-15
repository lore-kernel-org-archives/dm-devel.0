From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm snapshot: add optional discard support
	features
Date: Mon, 15 Jul 2019 14:06:54 -0400
Message-ID: <20190715180654.GA15315@redhat.com>
References: <20190703162504.GA34397@lobo>
	<fb809628-40e3-245a-dda4-034eee9a931b@arrikto.com>
	<20190711203611.GA51041@lobo> <20190711204633.GA51116@lobo>
	<321dff9f-a55c-e6ac-4a18-2e9eda0d05fe@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <321dff9f-a55c-e6ac-4a18-2e9eda0d05fe@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, John Dorminy <jdorminy@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 12 2019 at  9:40am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Hi Mike,
> 
> I have reviewed the patch. A few comments below.

Thanks, my email filtering caused this mail to miss my INBOX (still yet
to reason through why).  So I'm just seeing this now.

> On 7/11/19 11:46 PM, Mike Snitzer wrote:
> > @@ -1839,10 +1925,43 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
> >  		goto out_unlock;
> >  	}
> >  
> > +	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
> > +		if (s->discard_passdown_origin && dm_bio_get_target_bio_nr(bio)) {
> > +			/*
> > +			 * passdown discard to origin (without triggering
> > +			 * snapshot exceptions via do_origin; doing so would
> > +			 * defeat the goal of freeing space in origin that is
> > +			 * implied by the "discard_passdown_origin" feature)
> > +			 */
> > +			bio_set_dev(bio, s->origin->bdev);
> > +			track_chunk(s, bio, chunk);
> Why track_chunk() is needed here?
> 
> We track snapshot reads redirected to the origin to ensure that the
> origin will not be written while the reads are in-flight, thus returning
> corrupted data. Also, we track writes to a merging snapshot, which are
> redirected to the COW device, to ensure we don't merge these COW chunks
> before the writes finish.
> 
> I am probably missing something, but I can't understand why we need to
> track the discard to the origin.

I followed how reads are remapped to origin when remapping the discard
destined for origin because a competing write to origin could trigger
copyout that undermines the intent behind passing down the discard to
the origin.  That said, even if the write is withheld until the discard
completes that write triggered copyout could still undermine that intent.

But for this usecase, the origin wouldn't even be mounted (and is
incapable of being written due to it being full).  So I quickly stopped
caring and was only interested in ensuring do crash would occur in the
face of this hypotehtical concurrent access.

> > @@ -2198,6 +2324,22 @@ static int snapshot_iterate_devices(struct dm_target *ti,
> >  	return r;
> >  }
> >  > +static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
> > +{
> > +	struct dm_snapshot *snap = ti->private;
> > +
> > +	if (snap->discard_zeroes_cow) {
> > +		struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
> > +
> 
> I think the following:
> 
> > +		(void) __find_snapshots_sharing_cow(snap, &snap_src, &snap_dest, NULL);
> > +		if (snap_src && snap_dest)
> > +			snap = snap_src;
> > +
> > +		/* All discards are split on chunk_size boundary */
> > +		limits->discard_granularity = snap->store->chunk_size;
> > +		limits->max_discard_sectors = snap->store->chunk_size;
> 
> should be:
> 
> 	down_read(&_origins_lock);
> 
> 	(void) __find_snapshots_sharing_cow(snap, &snap_src, &snap_dest, NULL);
> 	if (snap_src && snap_dest)
> 		snap = snap_src;
> 
> 	/* All discards are split on chunk_size boundary */
> 	limits->discard_granularity = snap->store->chunk_size;
> 	limits->max_discard_sectors = snap->store->chunk_size;
> 
> 	up_read(&_origins_lock);
> 
> Taking _origins_lock protects us against:
> 
> 	* Concurrent modification of the _origins hash table by
> 	  register/unregister_snapshot().
> 	* snapshot_dtr() unregistering snap_src and freeing the relevant
> 	  resources, e.g., snap_src->store.

I agree, will stage incremental fix.

> One final note. The discard features can also be used by the
> snapshot-merge target. But, snapshot_merge_map() is not doing anything
> special about discards. They are treated like normal writes.

Another oversight, but the usecase of async discards coming in after the
merge has started (while very much possible) is not the intended
workflow.
 
> For chunks that reside in the origin this means that the discard will be
> passed down to it using do_origin(). Although this could trigger
> exceptions to other snapshots, I think that for the use case these features
> are trying to solve there is going to be only one active snapshot. Otherwise,
> if we have multiple snapshots, discard_passdown_origin would mean that
> discarding one snapshot could affect/corrupt the rest of the snapshots.

Yes, there should probably be a negative check to ensure there is only 1
active snapshot.  The quirky nature of dm-snap.c's snapshot exception
store handover is what teased out the need for me to even care about
multiple "snapshot" or "snapshot-merge" devices sharing the same cow in
the context of snapshot_io_hints() -- I triggered the need to account
for this in followup testing that did:

(snapshot active with table: "0 2097152 snapshot 253:0 253:2 P 8")
echo "0 2097152 snapshot 253:0 253:2 P 8 2 discard_zeroes_cow discard_passdown_origin" | dmsetup load test-snap
dmsetup suspend test-snap
dmsetup resume test-snap

This reload triggers handover.  That handover caused chunk_size to be 0
thanks to snapshiot_ctr()'s: s->store->chunk_size = 0; which caused
snapshot_io_hints() to incorrectly set the 2 discard limits to 0.

> For the not-yet-merged, remapped chunks the discard will be redirected to
> the COW device, so discard_zeroes_cow is not really zeroing COW in this
> case, it is discarding it.
> 
> Also, if both discard_zeroes_cow and discard_passdown_origin are enabled,
> the relevant chunk, either in origin or in COW, will be discarded twice.

snapshot_merge_map() does need to account for discards, not doing so was
an oversight due to the narrow usecase I was catering to (again, only 1
snapshot and all IO meant to free space having been completed before
merge is started).  I'll fix this up as well.

Thanks again for your careful review Nikos, much appreciated!

Mike
