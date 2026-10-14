Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B20D5012A5
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 13:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983762; cv=none; b=SP02Wo7C3Gx2ryqdmHy5HRdtaCyrnJzHWM6sWlitpoGzONLIbfOjo8SLlpoJULYrbmgzH6H1TWklqkmsD4w+KKsX2rHDznS9JP4mytkZwPrhZG/NqfixZPDtHKGLoTVHj2+gzvAc9Zv9UQovqfeIvJm9KzD6rbH4H9Yabho0edQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983762; c=relaxed/simple;
	bh=7hZHAYbEqX6vEEqDO7Z4wh4Ze6H9SBXsRpCf48HHToI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/bBbC7lB832gw2dz/6RCMyrgFy77p4oJHprAk89Mahod8MlZmE2QDLqA/9Do2MKI+RKY3U2OUXe9hJga5iX0NtBcL6RbVdtjt0iquSJz2mbuhGvIX2nY0QOxHQlqfVU+A9mRofSCHU6xw6gMA3kcaAAwsEPuADZpPC2hY4yYXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7236968B05; Wed, 14 Oct 2026 15:15:54 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:15:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v11 04/13] block: introduce dma map backed bio type
Message-ID: <20261014131554.GA16467@lst.de>
References: <cover.1791975048.git.asml.silence@gmail.com> <39b964cf7510f42755188563da63d3d5acaf2aa9.1791975048.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b964cf7510f42755188563da63d3d5acaf2aa9.1791975048.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 14, 2026 at 12:02:02PM +0100, Pavel Begunkov wrote:
> Premapped buffers don't require a generic bio_vec since these have
> already been dma mapped. Repurpose the bi_io_vec space to store dmabuf
> maps as they are mutually exclusive.
> 
> The bio splitting differs from the normal path because it's already
> pre-mapped and for the block layer it's just an offset into the dma-buf.
> The actual segmentation is only available to the importer driver and not
> the block layer, however, it doesn't contain alignment gaps and we don't
> have to check it. For the same reason we can't precisely split by the
> number of segments, but we use ->min_seg_shift stored in the map to
> calculate the minimum number of bytes a request consisting of
> lim->max_segments full segments can cover and split by that. It's
> stricter and can add extra splitting. E.g. for a {4K, 4G} segmentation,
> the min segment size is 4K, and we'll split it into bios of
> (4K * lim->max_segments) bytes each, but it should be good enough for
> now to cover the most popular use cases.
> 
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  block/bio.c               | 15 +++++++++--
>  block/blk-merge.c         | 52 +++++++++++++++++++++++++++++++++++++++
>  block/blk-mq.c            |  6 +++++
>  block/fops.c              |  2 +-
>  include/linux/bio.h       |  9 ++++---
>  include/linux/blk-mq.h    |  7 ++++++
>  include/linux/blk_types.h | 14 ++++++++++-
>  include/linux/bvec.h      |  3 ++-
>  8 files changed, 99 insertions(+), 9 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index b48091c7663f..1e0d9714c541 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -881,7 +881,11 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
>  	bio->bi_write_stream = bio_src->bi_write_stream;
>  	bio->bi_bvec_gap_bit = bio_src->bi_bvec_gap_bit;
>  	bio->bi_iter = bio_src->bi_iter;
> -	bio->bi_io_vec = bio_src->bi_io_vec;
> +
> +	if (op_is_dmabuf(bio->bi_opf))
> +		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
> +	else
> +		bio->bi_io_vec = bio_src->bi_io_vec;
>  
>  	if (bio->bi_bdev) {
>  		if (bio->bi_bdev == bio_src->bi_bdev &&
> @@ -1204,16 +1208,23 @@ EXPORT_SYMBOL_GPL(__bio_release_pages);
>  
>  bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
>  {
> -	if (!iov_iter_is_bvec(iter))
> +	if (!iov_iter_is_bvec(iter) && !iov_iter_is_dmabuf_map(iter))
>  		return false;
>  
>  	WARN_ON_ONCE(bio->bi_max_vecs);
>  
> +	static_assert(offsetof(struct bio, bi_io_vec) ==
> +		      offsetof(struct bio, bi_dmabuf_map));
> +	static_assert(offsetof(struct iov_iter, bvec) ==
> +		      offsetof(struct iov_iter, dmabuf_map));
> +
>  	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
>  	bio->bi_iter.bi_idx = 0;
>  	bio->bi_iter.bi_offset = iter->iov_offset;
>  	bio->bi_iter.bi_size = iov_iter_count(iter);
>  	bio_set_flag(bio, BIO_CLONED);
> +	if (iov_iter_is_dmabuf_map(iter))
> +		bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
>  	return true;
>  }
>  
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 258a726071d1..501ddc01c449 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -9,6 +9,7 @@
>  #include <linux/blk-integrity.h>
>  #include <linux/part_stat.h>
>  #include <linux/blk-cgroup.h>
> +#include <linux/dma-buf-io.h>
>  
>  #include <trace/events/block.h>
>  
> @@ -319,6 +320,41 @@ static inline unsigned int bvec_seg_gap(struct bio_vec *bvprv,
>  	return bv->bv_offset | (bvprv->bv_offset + bvprv->bv_len);
>  }
>  
> +static inline int bio_split_io_at_dmabuf(struct bio *bio,
> +		const struct queue_limits *lim, unsigned *segs,
> +		unsigned max_bytes, unsigned len_align_mask,
> +		unsigned start_align_mask)
> +{
> +	unsigned bytes = min(bio->bi_iter.bi_size, max_bytes);
> +	unsigned seg_shift = bio->bi_dmabuf_map->min_seg_shift;
> +	unsigned offset = bio->bi_iter.bi_offset & ((1U << seg_shift) - 1);
> +	u64 max_segs_bytes;
> +
> +	/*
> +	 * dma-buf maps don't expose the underlying segmentation, but they're
> +	 * guaranteed to not have alignment gaps, we only need to check the
> +	 * start and length alignment.
> +	 */
> +	if ((bio->bi_iter.bi_offset & start_align_mask) ||
> +	    (bio->bi_iter.bi_size & len_align_mask))
> +		return -EINVAL;
> +
> +	/* Presented as a single contiguous range into the dma-buf */
> +	*segs = 1;
> +
> +	/*
> +	 * Limit by the number of segments by using the minimal segment size.
> +	 * Any I/O consisting of N full segments should be able to cover at
> +	 * least N multiplied by the segment size. It's stricter than walking
> +	 * the segments and might cause extra splitting.
> +	 */
> +	max_segs_bytes = (u64)lim->max_segments << seg_shift;
> +	bytes = min_t(u64, bytes, max_segs_bytes - offset);
> +	if (bytes != bio->bi_iter.bi_size)
> +		return bytes;
> +	return 0;
> +}
> +
>  /**
>   * bio_split_io_at - check if and where to split a bio
>   * @bio:  [in] bio to be split
> @@ -346,6 +382,19 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
>  		len_align_mask |= (bc->bc_key->crypto_cfg.data_unit_size - 1);
>  	}
>  
> +	if (op_is_dmabuf(bio->bi_opf)) {
> +		int ret;
> +
> +		ret = bio_split_io_at_dmabuf(bio, lim, &nsegs, max_bytes,
> +					     len_align_mask, start_align_mask);
> +		if (ret < 0)
> +			return ret;
> +		if (!ret)
> +			goto out;
> +		bytes = ret;
> +		goto split;
> +	}
> +
>  	bio_for_each_bvec(bv, bio, iter) {
>  		if (bv.bv_offset & start_align_mask ||
>  		    bv.bv_len & len_align_mask)
> @@ -376,6 +425,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
>  		bvprvp = &bvprv;
>  	}
>  
> +out:
>  	*segs = nsegs;
>  	bio->bi_bvec_gap_bit = ffs(gaps);
>  	return 0;
> @@ -493,6 +543,8 @@ unsigned int blk_recalc_rq_segments(struct request *rq)
>  
>  	if (!rq->bio)
>  		return 0;
> +	if (op_is_dmabuf(rq->bio->bi_opf))
> +		return 1;
>  
>  	switch (bio_op(rq->bio)) {
>  	case REQ_OP_DISCARD:
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e929f94b25c7..1b7f8cbbda8b 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3150,6 +3150,12 @@ void blk_mq_submit_bio(struct bio *bio)
>  		goto queue_exit;
>  	}
>  
> +	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
> +		bdev_has_integrity_csum(bio->bi_bdev))) {
> +		bio_endio_status(bio, BLK_STS_NOTSUPP);

Wrong indentation, conditions are never indented the same level as
the following code block, even with the weirdest preferences.

/me note the patch from Anuj on the list actually got this right..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
