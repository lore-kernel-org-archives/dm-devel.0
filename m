Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85186C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:44:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-R1VFmEcsOaOaVF--kBLW-Q-1; Tue, 08 Feb 2022 17:43:59 -0500
X-MC-Unique: R1VFmEcsOaOaVF--kBLW-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF8C5814416;
	Tue,  8 Feb 2022 22:43:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD9FD5DB8E;
	Tue,  8 Feb 2022 22:43:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BD6D182A8F5;
	Tue,  8 Feb 2022 22:43:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2187LahA022684 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Feb 2022 02:21:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 305F51121321; Tue,  8 Feb 2022 07:21:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B8E41121318
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 07:21:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C3D33C021AB
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 07:21:33 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-347-VZYfnFbeOWyuzxmVCNPZqA-1; Tue, 08 Feb 2022 02:21:30 -0500
X-MC-Unique: VZYfnFbeOWyuzxmVCNPZqA-1
X-IronPort-AV: E=Sophos;i="5.88,352,1635177600"; d="scan'208";a="304299399"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2022 15:21:29 +0800
IronPort-SDR: s339rcc+mPO4NopiLvC68I6SLPxzi7yhafEbdaDUev2ckyPnsp4tStE+BgqALifP26VHRp9p86
	Vrzhws4eEaX/G4tfijHRppxUSKAYWHatBYDO7HeiA1u35F9mfNpVAyuI+RpWn8u83l0J3R1cLT
	mq8FW/gBavgAXNAdOvR9E96Hgs3itHCGZUeUkgE7Oh8xGOMlFYMKUi8ZVeYj5ksrMsbExDea6O
	CSXY+FgNnvgrc+lAG/Vm3t2GeInB27Ui9ueAq+8DmKsSG4df9Q/blyKAUqmbwjrJkzDfyNztje
	l3PoviI25oou/D+GBlLSZi+B
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	07 Feb 2022 22:53:19 -0800
IronPort-SDR: 0rt1xF3OXa2hL3QQRqbXQ/Q6qJmQZpLCU8YhS6c+Ru/Ogeri9uDWO+ZqGLX1demehA4HxUSQCC
	iiKgweWylHiHQ2dUHCyr+Cbej0n9D9RWfSNAm1Rg7Kwa5laS52xnIMUl8XyBo88OzCIAgYOKNW
	xvdCM2p92jFX7kZxmIV/ecECJLaZCDBKLb8mLsu0hhPncOYY9bfDBUsy5x1BW+uJ54nCV8BuWZ
	UZdrJ/uiA510Sj8khXYP+IWE27QRsOxlQ4roCSvEckTuAel6v0Bz3I/xfusOunx/Xwq32PuR9K
	4cE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	07 Feb 2022 23:21:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JtDvr0ytMz1SVp3
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 23:21:28 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id EFbHM7TrC-Tf for <dm-devel@redhat.com>;
	Mon,  7 Feb 2022 23:21:25 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JtDvj1HkYz1Rwrw;
	Mon,  7 Feb 2022 23:21:20 -0800 (PST)
Message-ID: <2e976611-6ba1-f986-91ce-d7f59fe4dd47@opensource.wdc.com>
Date: Tue, 8 Feb 2022 16:21:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141918epcas5p4f9badc0c3f3f0913f091c850d2d3bd81@epcas5p4.samsung.com>
	<20220207141348.4235-4-nj.shetty@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220207141348.4235-4-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	axboe@kernel.dk, tytso@mit.edu, joshi.k@samsung.com,
	martin.petersen@oracle.com, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 03/10] block: Add copy offload support
	infrastructure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/7/22 23:13, Nitesh Shetty wrote:
> Introduce blkdev_issue_copy which supports source and destination bdevs,
> and a array of (source, destination and copy length) tuples.

s/a/an

> Introduce REQ_COP copy offload operation flag. Create a read-write

REQ_COPY ?

> bio pair with a token as payload and submitted to the device in order.
> the read request populates token with source specific information which
> is then passed with write request.
> Ths design is courtsey Mikulas Patocka<mpatocka@>'s token based copy

s/Ths design is courtsey/This design is courtesy of

> 
> Larger copy operation may be divided if necessary by looking at device
> limits.

may or will ?
by looking at -> depending on the ?

> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
> ---
>  block/blk-lib.c           | 216 ++++++++++++++++++++++++++++++++++++++
>  block/blk-settings.c      |   2 +
>  block/blk.h               |   2 +
>  include/linux/blk_types.h |  20 ++++
>  include/linux/blkdev.h    |   3 +
>  include/uapi/linux/fs.h   |  14 +++
>  6 files changed, 257 insertions(+)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 1b8ced45e4e5..3ae2c27b566e 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -135,6 +135,222 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  }
>  EXPORT_SYMBOL(blkdev_issue_discard);
>  
> +/*
> + * Wait on and process all in-flight BIOs.  This must only be called once
> + * all bios have been issued so that the refcount can only decrease.
> + * This just waits for all bios to make it through bio_copy_end_io. IO
> + * errors are propagated through cio->io_error.
> + */
> +static int cio_await_completion(struct cio *cio)
> +{
> +	int ret = 0;
> +
> +	while (atomic_read(&cio->refcount)) {
> +		cio->waiter = current;
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +		blk_io_schedule();
> +		/* wake up sets us TASK_RUNNING */
> +		cio->waiter = NULL;
> +		ret = cio->io_err;

Why is this in the loop ?

> +	}
> +	kvfree(cio);
> +
> +	return ret;
> +}
> +
> +static void bio_copy_end_io(struct bio *bio)
> +{
> +	struct copy_ctx *ctx = bio->bi_private;
> +	struct cio *cio = ctx->cio;
> +	sector_t clen;
> +	int ri = ctx->range_idx;
> +
> +	if (bio->bi_status) {
> +		cio->io_err = bio->bi_status;
> +		clen = (bio->bi_iter.bi_sector - ctx->start_sec) << SECTOR_SHIFT;
> +		cio->rlist[ri].comp_len = min_t(sector_t, clen, cio->rlist[ri].comp_len);
> +	}
> +	__free_page(bio->bi_io_vec[0].bv_page);
> +	kfree(ctx);
> +	bio_put(bio);
> +
> +	if (atomic_dec_and_test(&cio->refcount) && cio->waiter)
> +		wake_up_process(cio->waiter);

This looks racy: the cio->waiter test and wakeup are not atomic.

> +}
> +
> +/*
> + * blk_copy_offload	- Use device's native copy offload feature
> + * Go through user provide payload, prepare new payload based on device's copy offload limits.
> + */
> +int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
> +		struct range_entry *rlist, struct block_device *dst_bdev, gfp_t gfp_mask)
> +{
> +	struct request_queue *sq = bdev_get_queue(src_bdev);
> +	struct request_queue *dq = bdev_get_queue(dst_bdev);
> +	struct bio *read_bio, *write_bio;
> +	struct copy_ctx *ctx;
> +	struct cio *cio;
> +	struct page *token;
> +	sector_t src_blk, copy_len, dst_blk;
> +	sector_t remaining, max_copy_len = LONG_MAX;
> +	int ri = 0, ret = 0;
> +
> +	cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
> +	if (!cio)
> +		return -ENOMEM;
> +	atomic_set(&cio->refcount, 0);
> +	cio->rlist = rlist;
> +
> +	max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_sectors,
> +			(sector_t)dq->limits.max_copy_sectors);

sq->limits.max_copy_sectors is already by definition smaller than
LONG_MAX, so there is no need for the min3 here.

> +	max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_range_sectors,
> +			(sector_t)dq->limits.max_copy_range_sectors) << SECTOR_SHIFT;> +
> +	for (ri = 0; ri < nr_srcs; ri++) {
> +		cio->rlist[ri].comp_len = rlist[ri].len;
> +		for (remaining = rlist[ri].len, src_blk = rlist[ri].src, dst_blk = rlist[ri].dst;
> +			remaining > 0;
> +			remaining -= copy_len, src_blk += copy_len, dst_blk += copy_len) {

This is unreadable.

> +			copy_len = min(remaining, max_copy_len);
> +
> +			token = alloc_page(gfp_mask);
> +			if (unlikely(!token)) {
> +				ret = -ENOMEM;
> +				goto err_token;
> +			}
> +
> +			read_bio = bio_alloc(src_bdev, 1, REQ_OP_READ | REQ_COPY | REQ_NOMERGE,
> +					gfp_mask);
> +			if (!read_bio) {
> +				ret = -ENOMEM;
> +				goto err_read_bio;
> +			}
> +			read_bio->bi_iter.bi_sector = src_blk >> SECTOR_SHIFT;
> +			read_bio->bi_iter.bi_size = copy_len;
> +			__bio_add_page(read_bio, token, PAGE_SIZE, 0);
> +			ret = submit_bio_wait(read_bio);
> +			if (ret) {
> +				bio_put(read_bio);
> +				goto err_read_bio;
> +			}
> +			bio_put(read_bio);
> +			ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
> +			if (!ctx) {
> +				ret = -ENOMEM;
> +				goto err_read_bio;
> +			}

This should be done before the read.

> +			ctx->cio = cio;
> +			ctx->range_idx = ri;
> +			ctx->start_sec = rlist[ri].src;
> +
> +			write_bio = bio_alloc(dst_bdev, 1, REQ_OP_WRITE | REQ_COPY | REQ_NOMERGE,
> +					gfp_mask);
> +			if (!write_bio) {
> +				ret = -ENOMEM;
> +				goto err_read_bio;
> +			}
> +
> +			write_bio->bi_iter.bi_sector = dst_blk >> SECTOR_SHIFT;
> +			write_bio->bi_iter.bi_size = copy_len;
> +			__bio_add_page(write_bio, token, PAGE_SIZE, 0);
> +			write_bio->bi_end_io = bio_copy_end_io;
> +			write_bio->bi_private = ctx;
> +			atomic_inc(&cio->refcount);
> +			submit_bio(write_bio);
> +		}
> +	}
> +
> +	/* Wait for completion of all IO's*/
> +	return cio_await_completion(cio);
> +
> +err_read_bio:
> +	__free_page(token);
> +err_token:
> +	rlist[ri].comp_len = min_t(sector_t, rlist[ri].comp_len, (rlist[ri].len - remaining));
> +
> +	cio->io_err = ret;
> +	return cio_await_completion(cio);
> +}
> +
> +static inline int blk_copy_sanity_check(struct block_device *src_bdev,
> +		struct block_device *dst_bdev, struct range_entry *rlist, int nr)
> +{
> +	unsigned int align_mask = max(
> +			bdev_logical_block_size(dst_bdev), bdev_logical_block_size(src_bdev)) - 1;
> +	sector_t len = 0;
> +	int i;
> +
> +	for (i = 0; i < nr; i++) {
> +		if (rlist[i].len)
> +			len += rlist[i].len;
> +		else
> +			return -EINVAL;
> +		if ((rlist[i].dst & align_mask) || (rlist[i].src & align_mask) ||
> +				(rlist[i].len & align_mask))
> +			return -EINVAL;
> +		rlist[i].comp_len = 0;
> +	}
> +
> +	if (!len && len >= MAX_COPY_TOTAL_LENGTH)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static inline bool blk_check_copy_offload(struct request_queue *src_q,
> +		struct request_queue *dest_q)
> +{
> +	if (dest_q->limits.copy_offload == BLK_COPY_OFFLOAD &&
> +			src_q->limits.copy_offload == BLK_COPY_OFFLOAD)
> +		return true;
> +
> +	return false;
> +}
> +
> +/*
> + * blkdev_issue_copy - queue a copy
> + * @src_bdev:	source block device
> + * @nr_srcs:	number of source ranges to copy
> + * @src_rlist:	array of source ranges
> + * @dest_bdev:	destination block device
> + * @gfp_mask:   memory allocation flags (for bio_alloc)
> + * @flags:	BLKDEV_COPY_* flags to control behaviour
> + *
> + * Description:
> + *	Copy source ranges from source block device to destination block device.
> + *	length of a source range cannot be zero.
> + */
> +int blkdev_issue_copy(struct block_device *src_bdev, int nr,
> +		struct range_entry *rlist, struct block_device *dest_bdev,
> +		gfp_t gfp_mask, int flags)
> +{
> +	struct request_queue *src_q = bdev_get_queue(src_bdev);
> +	struct request_queue *dest_q = bdev_get_queue(dest_bdev);
> +	int ret = -EINVAL;
> +
> +	if (!src_q || !dest_q)
> +		return -ENXIO;
> +
> +	if (!nr)
> +		return -EINVAL;
> +
> +	if (nr >= MAX_COPY_NR_RANGE)
> +		return -EINVAL;
> +
> +	if (bdev_read_only(dest_bdev))
> +		return -EPERM;
> +
> +	ret = blk_copy_sanity_check(src_bdev, dest_bdev, rlist, nr);
> +	if (ret)
> +		return ret;
> +
> +	if (blk_check_copy_offload(src_q, dest_q))
> +		ret = blk_copy_offload(src_bdev, nr, rlist, dest_bdev, gfp_mask);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(blkdev_issue_copy);
> +
>  /**
>   * __blkdev_issue_write_same - generate number of bios with same page
>   * @bdev:	target blockdev
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 818454552cf8..4c8d48b8af25 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -545,6 +545,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  	t->max_segment_size = min_not_zero(t->max_segment_size,
>  					   b->max_segment_size);
>  
> +	t->max_copy_sectors = min_not_zero(t->max_copy_sectors, b->max_copy_sectors);

Why min_not_zero ? If one of the underlying drive does not support copy
offload, you cannot report that the top drive does.

> +
>  	t->misaligned |= b->misaligned;
>  
>  	alignment = queue_limit_alignment_offset(b, start);
> diff --git a/block/blk.h b/block/blk.h
> index abb663a2a147..94d2b055750b 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -292,6 +292,8 @@ static inline bool blk_may_split(struct request_queue *q, struct bio *bio)
>  		break;
>  	}
>  
> +	if (unlikely(op_is_copy(bio->bi_opf)))
> +		return false;
>  	/*
>  	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
>  	 * This is a quick and dirty check that relies on the fact that
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 5561e58d158a..0a3fee8ad61c 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -418,6 +418,7 @@ enum req_flag_bits {
>  	/* for driver use */
>  	__REQ_DRV,
>  	__REQ_SWAP,		/* swapping request. */
> +	__REQ_COPY,		/* copy request*/
>  	__REQ_NR_BITS,		/* stops here */
>  };
>  
> @@ -442,6 +443,7 @@ enum req_flag_bits {
>  
>  #define REQ_DRV			(1ULL << __REQ_DRV)
>  #define REQ_SWAP		(1ULL << __REQ_SWAP)
> +#define REQ_COPY		(1ULL << __REQ_COPY)
>  
>  #define REQ_FAILFAST_MASK \
>  	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
> @@ -498,6 +500,11 @@ static inline bool op_is_discard(unsigned int op)
>  	return (op & REQ_OP_MASK) == REQ_OP_DISCARD;
>  }
>  
> +static inline bool op_is_copy(unsigned int op)
> +{
> +	return (op & REQ_COPY);
> +}
> +
>  /*
>   * Check if a bio or request operation is a zone management operation, with
>   * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
> @@ -532,4 +539,17 @@ struct blk_rq_stat {
>  	u64 batch;
>  };
>  
> +struct cio {
> +	atomic_t refcount;
> +	blk_status_t io_err;
> +	struct range_entry *rlist;
> +	struct task_struct *waiter;     /* waiting task (NULL if none) */
> +};
> +
> +struct copy_ctx {
> +	int range_idx;
> +	sector_t start_sec;
> +	struct cio *cio;
> +};
> +
>  #endif /* __LINUX_BLK_TYPES_H */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f63ae50f1de3..15597488040c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1120,6 +1120,9 @@ extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		struct bio **biop);
>  struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
>  		gfp_t gfp_mask);
> +int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
> +		struct range_entry *src_rlist, struct block_device *dest_bdev,
> +		gfp_t gfp_mask, int flags);
>  
>  #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
>  #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index bdf7b404b3e7..55bca8f6e8ed 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -64,6 +64,20 @@ struct fstrim_range {
>  	__u64 minlen;
>  };
>  
> +/* Maximum no of entries supported */
> +#define MAX_COPY_NR_RANGE	(1 << 12)
> +
> +/* maximum total copy length */
> +#define MAX_COPY_TOTAL_LENGTH	(1 << 21)
> +
> +/* Source range entry for copy */
> +struct range_entry {
> +	__u64 src;
> +	__u64 dst;
> +	__u64 len;
> +	__u64 comp_len;
> +};
> +
>  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
>  #define FILE_DEDUPE_RANGE_SAME		0
>  #define FILE_DEDUPE_RANGE_DIFFERS	1


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

