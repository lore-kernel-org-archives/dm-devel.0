From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5/7] block: Find bio sector offset given idx and offset
Date: Wed, 1 Oct 2008 10:10:56 +0200
Message-ID: <20081001081056.GB19428@kernel.dk>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com> <1222846723-18213-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753879AbYJAIL2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1222846723-18213-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: neilb@suse.de, agk@sourceware.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 01 2008, Martin K. Petersen wrote:
> Helper function to find the sector offset in a bio given bvec index
> and page offset.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  fs/bio.c            |   34 ++++++++++++++++++++++++++++++++++
>  include/linux/bio.h |    1 +
>  2 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index e56e768..55ee2fd 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1300,6 +1300,40 @@ struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
>  	return bp;
>  }
>  
> +/**
> + *	bio_sector_offset - Find hardware sector offset in bio
> + *	@bio:		bio to inspect
> + *	@index:		bio_vec index
> + *	@offset:	offset in bv_page
> + *
> + *	Return the number of hardware sectors between beginning of bio
> + *	and an end point indicated by a bio_vec index and an offset
> + *	within that vector's page.
> + */
> +sector_t bio_sector_offset(struct bio *bio, unsigned short index,
> +			   unsigned int offset)
> +{
> +	struct bio_vec *bv;
> +	unsigned int sector_sz = bio->bi_bdev->bd_disk->queue->hardsect_size;
> +	sector_t sectors;
> +	int i;
> +
> +	sectors = 0;
> +
> +	BUG_ON(index >= bio->bi_vcnt);
> +
> +	bio_for_each_segment(bv, bio, i) {
> +		if (i == index) {
> +			if (offset > bv->bv_offset)
> +				sectors += (offset - bv->bv_offset) / sector_sz;
> +			return sectors;
> +		}
> +
> +		sectors += bv->bv_len / sector_sz;
> +	}
> +
> +	BUG();
> +}

Too may BUG's there, me thinks, and the interface looks fragile. What if
the bio is alreday done (bi_idx == bi_vcnt)? I'd prefer something ala:

sector_t bio_sector_offset(struct bio *bio, unsigned short index,
			   unsigned int offset)
{
	unsigned int sector_sz = queue_hardsect_size(bio->bi_bdev->bd_disk->queue);
	struct bio_vec *bv;
	sector_t sectors;
	int i;

	sectors = 0;

        /* total start of bio current start? */
#if 0
        if (index >= bio->bi_vcnt)
                index = bio->bi_vcnt - 1;

        __bio_for_each_segment(bv, bio, i, 0) {
#else
        if (index > bio->bi_idx)
                return 0;

	bio_for_each_segment(bv, bio, i) {
#endif
		if (i == index) {
			if (offset > bv->bv_offset)
				sectors += (offset - bv->bv_offset) / sector_sz;
                        break;
		}

		sectors += bv->bv_len / sector_sz;
	}

        return sectors;
}

Depending on which interface you want, pick one of the if/else parts :-)

-- 
Jens Axboe
