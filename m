From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH RESEND] md: Make flush bios explicitely sync
Date: Wed, 24 May 2017 16:22:36 -0700
Message-ID: <20170524232236.yrmslb4upgoa7kxb@kernel.org>
References: <20170524114013.14130-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170524114013.14130-1-jack@suse.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 24, 2017 at 01:40:13PM +0200, Jan Kara wrote:
> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_{FUA|PREFLUSH|...}
> definitions.  generic_make_request_checks() however strips REQ_FUA and
> REQ_PREFLUSH flags from a bio when the storage doesn't report volatile
> write cache and thus write effectively becomes asynchronous which can
> lead to performance regressions
> 
> Fix the problem by making sure all bios which are synchronous are
> properly marked with REQ_SYNC.

Hi,

DM and MD are different trees, so probably you should separate them to 2
patches. For the md part (md.c, raid5-cache.c), some placed which use REQ_FUA
are missed, like raid5.c and raid5-ppl.c

Can't remember if others asked the question in your first post, sorry, but why
we don't add REQ_SYNC in generic_make_request_checks() if we are going to
stripe REQ_FUA, REQ_PREFLUSH. That will be less error prone.

Thanks,
Shaohua

> CC: linux-raid@vger.kernel.org
> CC: Shaohua Li <shli@kernel.org>
> CC: Mike Snitzer <snitzer@redhat.com>
> CC: dm-devel@redhat.com
> Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/md/dm-snap-persistent.c | 3 ++-
>  drivers/md/md.c                 | 2 +-
>  drivers/md/raid5-cache.c        | 4 ++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> Guys, I don't know enough about DM/MD to judge whether I've identified all the
> places that want REQ_SYNC right. Can you please have a look?
> 
> diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
> index b93476c3ba3f..b92ab4cb0710 100644
> --- a/drivers/md/dm-snap-persistent.c
> +++ b/drivers/md/dm-snap-persistent.c
> @@ -741,7 +741,8 @@ static void persistent_commit_exception(struct dm_exception_store *store,
>  	/*
>  	 * Commit exceptions to disk.
>  	 */
> -	if (ps->valid && area_io(ps, REQ_OP_WRITE, REQ_PREFLUSH | REQ_FUA))
> +	if (ps->valid && area_io(ps, REQ_OP_WRITE,
> +				 REQ_SYNC | REQ_PREFLUSH | REQ_FUA))
>  		ps->valid = 0;
>  
>  	/*
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 10367ffe92e3..212a6777ff31 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -765,7 +765,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>  	    test_bit(FailFast, &rdev->flags) &&
>  	    !test_bit(LastDev, &rdev->flags))
>  		ff = MD_FAILFAST;
> -	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA | ff;
> +	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA | ff;
>  
>  	atomic_inc(&mddev->pending_writes);
>  	submit_bio(bio);
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 4c00bc248287..0a7af8b0a80a 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1782,7 +1782,7 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
>  	mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
>  					     mb, PAGE_SIZE));
>  	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, REQ_OP_WRITE,
> -			  REQ_FUA, false)) {
> +			  REQ_SYNC | REQ_FUA, false)) {
>  		__free_page(page);
>  		return -EIO;
>  	}
> @@ -2388,7 +2388,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  		mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
>  						     mb, PAGE_SIZE));
>  		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
> -			     REQ_OP_WRITE, REQ_FUA, false);
> +			     REQ_OP_WRITE, REQ_SYNC | REQ_FUA, false);
>  		sh->log_start = ctx->pos;
>  		list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
>  		atomic_inc(&log->stripe_in_journal_count);
> -- 
> 2.12.0
> 
