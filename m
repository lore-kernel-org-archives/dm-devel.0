From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/10] block: kill merge_bvec_fn() completely
Date: Wed, 6 May 2015 09:26:37 +0200
Message-ID: <20150506072637.GB23083@lst.de>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org> <1430203717-13307-8-git-send-email-mlin@kernel.org> <20150429080919.342fddfd@notabene.brown> <5547241B.1040903@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5547241B.1040903@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

> -static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
> +static int __chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)

Call it raid5_read_one_chunk or something similar descriptive?

>  {
>  	struct r5conf *conf = mddev->private;
>  	int dd_idx;
> @@ -4718,7 +4718,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
>  	sector_t end_sector;
>  
>  	if (!in_chunk_boundary(mddev, raid_bio)) {
> -		pr_debug("chunk_aligned_read : non aligned\n");
> +		pr_debug("__chunk_aligned_read : non aligned\n");

Switch to __func__?

> +static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
> +{
> +	struct bio *split;
> +
> +	do {
> +		sector_t sector = raid_bio->bi_iter.bi_sector;
> +		unsigned chunk_sects = mddev->chunk_sectors;
> +
> +		unsigned sectors = chunk_sects -
> +			(likely(is_power_of_2(chunk_sects))
> +			 ? (sector & (chunk_sects-1))
> +			 : sector_div(sector, chunk_sects));

This would be a lot more readable with a good old if.

>  	if (rw == READ && mddev->degraded == 0 &&
>  	     mddev->reshape_position == MaxSector &&
> -	     chunk_aligned_read(mddev,bi))
> +	     (!(bi = chunk_aligned_read(mddev, bi))))
>  		return;

	if (rw == READ && mddev->degraded == 0 &&
	    mddev->reshape_position == MaxSector) {
		bi = chunk_aligned_read(mddev, bi);
		if (!bi)
			return;
	}
