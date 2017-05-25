From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RESEND] md: Make flush bios explicitely sync
Date: Thu, 25 May 2017 10:11:31 +0200
Message-ID: <20170525081131.GA28950@quack2.suse.cz>
References: <20170524114013.14130-1-jack@suse.cz>
 <20170524232236.yrmslb4upgoa7kxb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170524232236.yrmslb4upgoa7kxb@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed 24-05-17 16:22:36, Shaohua Li wrote:
> On Wed, May 24, 2017 at 01:40:13PM +0200, Jan Kara wrote:
> > Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> > synchronous" removed REQ_SYNC flag from WRITE_{FUA|PREFLUSH|...}
> > definitions.  generic_make_request_checks() however strips REQ_FUA and
> > REQ_PREFLUSH flags from a bio when the storage doesn't report volatile
> > write cache and thus write effectively becomes asynchronous which can
> > lead to performance regressions
> > 
> > Fix the problem by making sure all bios which are synchronous are
> > properly marked with REQ_SYNC.
> 
> DM and MD are different trees, so probably you should separate them to 2
> patches.

OK, I can do that.

> For the md part (md.c, raid5-cache.c), some placed which use REQ_FUA
> are missed, like raid5.c and raid5-ppl.c

So ops_run_io() in raid5.c only copy REQ_FUA from some internal raid5
flags. My thinking was that we want to just propagate whatever we were
instructed to do here.

The case in ppl_write_empty_header() is clearly missed, I'll fix that.
Thanks. I'm not quite sure about ppl_submit_iounit() - I don't see a place
where we are waiting for those bios to complete. If it is likely to happen
soon after bio submission, we should add REQ_SYNC there.

> Can't remember if others asked the question in your first post, sorry,
> but why we don't add REQ_SYNC in generic_make_request_checks() if we are
> going to stripe REQ_FUA, REQ_PREFLUSH. That will be less error prone.

Well, strictly speaking users of REQ_FUA do not necessarily have to use
REQ_SYNC. These are two different orthogonal things - one is a request for
bypassing disk cache, the other is a hint to the IO scheduler that there is
someone waiting for the IO to complete. Most of the time you wait for
REQ_FUA request immediately but I can see some uses in filesystems
where we might want to submit REQ_FUA request in the background (like when
doing background cleaning of the journal).

								Honza

> > CC: linux-raid@vger.kernel.org
> > CC: Shaohua Li <shli@kernel.org>
> > CC: Mike Snitzer <snitzer@redhat.com>
> > CC: dm-devel@redhat.com
> > Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  drivers/md/dm-snap-persistent.c | 3 ++-
> >  drivers/md/md.c                 | 2 +-
> >  drivers/md/raid5-cache.c        | 4 ++--
> >  3 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > Guys, I don't know enough about DM/MD to judge whether I've identified all the
> > places that want REQ_SYNC right. Can you please have a look?
> > 
> > diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
> > index b93476c3ba3f..b92ab4cb0710 100644
> > --- a/drivers/md/dm-snap-persistent.c
> > +++ b/drivers/md/dm-snap-persistent.c
> > @@ -741,7 +741,8 @@ static void persistent_commit_exception(struct dm_exception_store *store,
> >  	/*
> >  	 * Commit exceptions to disk.
> >  	 */
> > -	if (ps->valid && area_io(ps, REQ_OP_WRITE, REQ_PREFLUSH | REQ_FUA))
> > +	if (ps->valid && area_io(ps, REQ_OP_WRITE,
> > +				 REQ_SYNC | REQ_PREFLUSH | REQ_FUA))
> >  		ps->valid = 0;
> >  
> >  	/*
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 10367ffe92e3..212a6777ff31 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -765,7 +765,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
> >  	    test_bit(FailFast, &rdev->flags) &&
> >  	    !test_bit(LastDev, &rdev->flags))
> >  		ff = MD_FAILFAST;
> > -	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA | ff;
> > +	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA | ff;
> >  
> >  	atomic_inc(&mddev->pending_writes);
> >  	submit_bio(bio);
> > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> > index 4c00bc248287..0a7af8b0a80a 100644
> > --- a/drivers/md/raid5-cache.c
> > +++ b/drivers/md/raid5-cache.c
> > @@ -1782,7 +1782,7 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
> >  	mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
> >  					     mb, PAGE_SIZE));
> >  	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, REQ_OP_WRITE,
> > -			  REQ_FUA, false)) {
> > +			  REQ_SYNC | REQ_FUA, false)) {
> >  		__free_page(page);
> >  		return -EIO;
> >  	}
> > @@ -2388,7 +2388,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
> >  		mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
> >  						     mb, PAGE_SIZE));
> >  		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
> > -			     REQ_OP_WRITE, REQ_FUA, false);
> > +			     REQ_OP_WRITE, REQ_SYNC | REQ_FUA, false);
> >  		sh->log_start = ctx->pos;
> >  		list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
> >  		atomic_inc(&log->stripe_in_journal_count);
> > -- 
> > 2.12.0
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
