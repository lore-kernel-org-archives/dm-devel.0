From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v4 06/13] dm snapshot: merge target should
 not allocate new exceptions
Date: Mon, 23 Nov 2009 02:34:04 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911230233090.12960@hs20-bc2-1.build.redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
	<1258748873-24185-7-git-send-email-snitzer@redhat.com>
	<20091120205416.GB9458@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091120205416.GB9458@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Fri, 20 Nov 2009, Mike Snitzer wrote:

> On Fri, Nov 20 2009 at  3:27pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > If a write request to a merging snapshot device is to be dispatched
> > directly to the origin (because the chunk is not remapped or was already
> > merged), snapshot_merge_map() must make exceptions in other snapshots.
> ...
> > +static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
> > +			      union map_info *map_context)
> > +{
> > +	struct dm_exception *e;
> > +	struct dm_snapshot *s = ti->private;
> > +	int r = DM_MAPIO_REMAPPED;
> > +	chunk_t chunk;
> > +
> > +	chunk = sector_to_chunk(s->store, bio->bi_sector);
> > +
> > +	down_read(&s->lock);
> > +
> > +	/* Full snapshots are not usable */
> > +	if (!s->valid) {
> > +		r = -EIO;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* If the block is already remapped - use that */
> > +	e = dm_lookup_exception(&s->complete, chunk);
> > +	if (e) {
> > +		remap_exception(s, e, bio, chunk);
> > +		goto out_unlock;
> > +	}
> > +
> > +	bio->bi_bdev = s->origin->bdev;
> > +
> > +	if (bio_rw(bio) == WRITE) {
> > +		up_write(&s->lock);
> > +		return do_origin(s->origin, bio);
> > +	}
> 
> OK, I caught this in review but clearly didn't refresh the patch; the
> above up_write() should be up_read().
> 
> Mike

Right.

BTW, this will be converted to a single lock (non-read-write) anyway, when 
those clustering patches will be applied.

Mikulas
