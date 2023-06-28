Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1E3EB64D9
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971621;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9z4CbyckA7QH2gtLHBMFZTCeaSr4BkvxRRvyD/GESKw=;
	b=D7KhzEFc6p3AY+AKAq8nUBaLFX7yyKMFmSyRZifYktDyWB0I0WF6COQB0OJ5j5q0HnANaz
	urAy75U26vDEQevlhhcNq3mVMmXDqJidRHoKcZc8D/qrSM7t77VrbEwlbCxGYyAvqeQ5NF
	107bzwndBDA47GQUqqhbZSnHib3afQw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-jCqAZlgZPSqXY_52TXYwRQ-1; Mon, 10 Jul 2023 02:46:58 -0400
X-MC-Unique: jCqAZlgZPSqXY_52TXYwRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C719185A794;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2125540C206F;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EDB6C19465A3;
	Mon, 10 Jul 2023 06:46:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 861451946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Jun 2023 06:45:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53AB22166B26; Wed, 28 Jun 2023 06:45:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B04F2166B25
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 06:45:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26C82858F1E
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 06:45:39 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-33mJmpm0MXWafUf85k5tjg-1; Wed, 28 Jun 2023 02:45:35 -0400
X-MC-Unique: 33mJmpm0MXWafUf85k5tjg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9DEDE61311;
 Wed, 28 Jun 2023 06:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3ADC433C8;
 Wed, 28 Jun 2023 06:45:31 +0000 (UTC)
Message-ID: <e1b0c3d4-1f47-9b12-fdf3-190a9c6b427e@kernel.org>
Date: Wed, 28 Jun 2023 15:45:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184010epcas5p4bb6581408d9b67bbbcad633fb26689c9@epcas5p4.samsung.com>
 <20230627183629.26571-3-nj.shetty@samsung.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230627183629.26571-3-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH v13 2/9] block: Add copy offload support
 infrastructure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-nvme@lists.infradead.org, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, djwong@kernel.org,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, martin.petersen@oracle.com,
 linux-fsdevel@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/28/23 03:36, Nitesh Shetty wrote:
> Introduce blkdev_copy_offload which takes similar arguments as
> copy_file_range and performs copy offload between two bdevs.

I am confused... I thought it was discussed to only allow copy offload only
within a single bdev for now... Did I missi something ?

> Introduce REQ_OP_COPY_DST, REQ_OP_COPY_SRC operation.
> Issue REQ_OP_COPY_DST with destination info along with taking a plug.
> This flows till request layer and waits for src bio to get merged.
> Issue REQ_OP_COPY_SRC with source info and this bio reaches request
> layer and merges with dst request.
> For any reason, if request comes to driver with either only one of src/dst
> info we fail the copy offload.
> 
> Larger copy will be divided, based on max_copy_sectors limit.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>  block/blk-core.c          |   5 ++
>  block/blk-lib.c           | 177 ++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         |  21 +++++
>  block/blk.h               |   9 ++
>  block/elevator.h          |   1 +
>  include/linux/bio.h       |   4 +-
>  include/linux/blk_types.h |  21 +++++
>  include/linux/blkdev.h    |   4 +
>  8 files changed, 241 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 99d8b9812b18..e6714391c93f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -796,6 +796,11 @@ void submit_bio_noacct(struct bio *bio)
>  		if (!q->limits.max_write_zeroes_sectors)
>  			goto not_supported;
>  		break;
> +	case REQ_OP_COPY_SRC:
> +	case REQ_OP_COPY_DST:
> +		if (!blk_queue_copy(q))
> +			goto not_supported;
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e59c3069e835..10c3eadd5bf6 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -115,6 +115,183 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  }
>  EXPORT_SYMBOL(blkdev_issue_discard);
>  
> +/*
> + * For synchronous copy offload/emulation, wait and process all in-flight BIOs.
> + * This must only be called once all bios have been issued so that the refcount
> + * can only decrease. This just waits for all bios to make it through
> + * blkdev_copy_(offload/emulate)_(read/write)_endio.
> + */
> +static ssize_t blkdev_copy_wait_io_completion(struct cio *cio)
> +{
> +	ssize_t ret;
> +
> +	if (cio->endio)
> +		return 0;
> +
> +	if (atomic_read(&cio->refcount)) {
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +		blk_io_schedule();
> +	}
> +
> +	ret = cio->comp_len;
> +	kfree(cio);
> +
> +	return ret;
> +}
> +
> +static void blkdev_copy_offload_read_endio(struct bio *bio)
> +{
> +	struct cio *cio = bio->bi_private;
> +	sector_t clen;
> +
> +	if (bio->bi_status) {
> +		clen = (bio->bi_iter.bi_sector << SECTOR_SHIFT) - cio->pos_out;
> +		cio->comp_len = min_t(sector_t, clen, cio->comp_len);
> +	}
> +	bio_put(bio);
> +
> +	if (!atomic_dec_and_test(&cio->refcount))
> +		return;
> +	if (cio->endio) {
> +		cio->endio(cio->private, cio->comp_len);
> +		kfree(cio);
> +	} else
> +		blk_wake_io_task(cio->waiter);

Curly brackets around else missing.

> +}
> +
> +/*
> + * __blkdev_copy_offload	- Use device's native copy offload feature.
> + * we perform copy operation by sending 2 bio.
> + * 1. We take a plug and send a REQ_OP_COPY_DST bio along with destination
> + * sector and length. Once this bio reaches request layer, we form a request and
> + * wait for src bio to arrive.
> + * 2. We issue REQ_OP_COPY_SRC bio along with source sector and length. Once
> + * this bio reaches request layer and find a request with previously sent
> + * destination info we merge the source bio and return.
> + * 3. Release the plug and request is sent to driver
> + *
> + * Returns the length of bytes copied or error if encountered
> + */
> +static ssize_t __blkdev_copy_offload(
> +		struct block_device *bdev_in, loff_t pos_in,
> +		struct block_device *bdev_out, loff_t pos_out,
> +		size_t len, cio_iodone_t endio, void *private, gfp_t gfp_mask)
> +{
> +	struct cio *cio;
> +	struct bio *read_bio, *write_bio;
> +	sector_t rem, copy_len, max_copy_len;
> +	struct blk_plug plug;
> +
> +	cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
> +	if (!cio)
> +		return -ENOMEM;
> +	atomic_set(&cio->refcount, 0);
> +	cio->waiter = current;
> +	cio->endio = endio;
> +	cio->private = private;
> +
> +	max_copy_len = min(bdev_max_copy_sectors(bdev_in),
> +			bdev_max_copy_sectors(bdev_out)) << SECTOR_SHIFT;

According to patch 1, this can end up being 0, so the loop below will be infinite.

> +
> +	cio->pos_in = pos_in;
> +	cio->pos_out = pos_out;
> +	/* If there is a error, comp_len will be set to least successfully
> +	 * completed copied length
> +	 */
> +	cio->comp_len = len;
> +	for (rem = len; rem > 0; rem -= copy_len) {
> +		copy_len = min(rem, max_copy_len);
> +
> +		write_bio = bio_alloc(bdev_out, 0, REQ_OP_COPY_DST, gfp_mask);
> +		if (!write_bio)
> +			goto err_write_bio_alloc;
> +		write_bio->bi_iter.bi_size = copy_len;
> +		write_bio->bi_iter.bi_sector = pos_out >> SECTOR_SHIFT;
> +
> +		blk_start_plug(&plug);
> +		read_bio = blk_next_bio(write_bio, bdev_in, 0, REQ_OP_COPY_SRC,
> +						gfp_mask);
> +		read_bio->bi_iter.bi_size = copy_len;
> +		read_bio->bi_iter.bi_sector = pos_in >> SECTOR_SHIFT;
> +		read_bio->bi_end_io = blkdev_copy_offload_read_endio;
> +		read_bio->bi_private = cio;
> +
> +		atomic_inc(&cio->refcount);
> +		submit_bio(read_bio);
> +		blk_finish_plug(&plug);
> +		pos_in += copy_len;
> +		pos_out += copy_len;
> +	}
> +
> +	return blkdev_copy_wait_io_completion(cio);
> +
> +err_write_bio_alloc:
> +	cio->comp_len = min_t(sector_t, cio->comp_len, (len - rem));
> +	if (!atomic_read(&cio->refcount)) {
> +		kfree(cio);
> +		return -ENOMEM;
> +	}
> +	return blkdev_copy_wait_io_completion(cio);
> +}
> +
> +static inline ssize_t blkdev_copy_sanity_check(
> +	struct block_device *bdev_in, loff_t pos_in,
> +	struct block_device *bdev_out, loff_t pos_out,
> +	size_t len)
> +{
> +	unsigned int align = max(bdev_logical_block_size(bdev_out),
> +					bdev_logical_block_size(bdev_in)) - 1;
> +
> +	if (bdev_read_only(bdev_out))
> +		return -EPERM;
> +
> +	if ((pos_in & align) || (pos_out & align) || (len & align) || !len ||
> +		len >= COPY_MAX_BYTES)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * @bdev_in:	source block device
> + * @pos_in:	source offset
> + * @bdev_out:	destination block device
> + * @pos_out:	destination offset
> + * @len:	length in bytes to be copied
> + * @endio:	endio function to be called on completion of copy operation,
> + *		for synchronous operation this should be NULL
> + * @private:	endio function will be called with this private data, should be
> + *		NULL, if operation is synchronous in nature
> + * @gfp_mask:   memory allocation flags (for bio_alloc)
> + *
> + * Returns the length of bytes copied or error if encountered
> + *
> + * Description:
> + *	Copy source offset from source block device to destination block
> + *	device. If copy offload is not supported or fails, fallback to
> + *	emulation. Max total length of copy is limited to COPY_MAX_BYTES
> + */
> +ssize_t blkdev_copy_offload(
> +		struct block_device *bdev_in, loff_t pos_in,
> +		struct block_device *bdev_out, loff_t pos_out,
> +		size_t len, cio_iodone_t endio, void *private, gfp_t gfp_mask)
> +{
> +	struct request_queue *q_in = bdev_get_queue(bdev_in);
> +	struct request_queue *q_out = bdev_get_queue(bdev_out);
> +	ssize_t ret;
> +
> +	ret = blkdev_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len);
> +	if (ret)
> +		return ret;
> +
> +	if (blk_queue_copy(q_in) && blk_queue_copy(q_out))
> +		ret = __blkdev_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
> +			   len, endio, private, gfp_mask);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(blkdev_copy_offload);
> +
>  static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>  		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
>  		struct bio **biop, unsigned flags)
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 65e75efa9bd3..bfd86c54df22 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -922,6 +922,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
>  	if (!rq_mergeable(rq) || !bio_mergeable(bio))
>  		return false;
>  
> +	if ((req_op(rq) == REQ_OP_COPY_DST) && (bio_op(bio) == REQ_OP_COPY_SRC))
> +		return true;
> +
>  	if (req_op(rq) != bio_op(bio))
>  		return false;
>  
> @@ -951,6 +954,8 @@ enum elv_merge blk_try_merge(struct request *rq, struct bio *bio)
>  {
>  	if (blk_discard_mergable(rq))
>  		return ELEVATOR_DISCARD_MERGE;
> +	else if (blk_copy_offload_mergable(rq, bio))
> +		return ELEVATOR_COPY_OFFLOAD_MERGE;
>  	else if (blk_rq_pos(rq) + blk_rq_sectors(rq) == bio->bi_iter.bi_sector)
>  		return ELEVATOR_BACK_MERGE;
>  	else if (blk_rq_pos(rq) - bio_sectors(bio) == bio->bi_iter.bi_sector)
> @@ -1053,6 +1058,20 @@ static enum bio_merge_status bio_attempt_discard_merge(struct request_queue *q,
>  	return BIO_MERGE_FAILED;
>  }
>  
> +static enum bio_merge_status bio_attempt_copy_offload_merge(
> +	struct request_queue *q, struct request *req, struct bio *bio)
> +{
> +	if (req->__data_len != bio->bi_iter.bi_size)
> +		return BIO_MERGE_FAILED;
> +
> +	req->biotail->bi_next = bio;
> +	req->biotail = bio;
> +	req->nr_phys_segments = blk_rq_nr_phys_segments(req) + 1;
> +	req->__data_len += bio->bi_iter.bi_size;
> +
> +	return BIO_MERGE_OK;
> +}
> +
>  static enum bio_merge_status blk_attempt_bio_merge(struct request_queue *q,
>  						   struct request *rq,
>  						   struct bio *bio,
> @@ -1073,6 +1092,8 @@ static enum bio_merge_status blk_attempt_bio_merge(struct request_queue *q,
>  		break;
>  	case ELEVATOR_DISCARD_MERGE:
>  		return bio_attempt_discard_merge(q, rq, bio);
> +	case ELEVATOR_COPY_OFFLOAD_MERGE:
> +		return bio_attempt_copy_offload_merge(q, rq, bio);
>  	default:
>  		return BIO_MERGE_NONE;
>  	}
> diff --git a/block/blk.h b/block/blk.h
> index 608c5dcc516b..440bfa148461 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -156,6 +156,13 @@ static inline bool blk_discard_mergable(struct request *req)
>  	return false;
>  }
>  
> +static inline bool blk_copy_offload_mergable(struct request *req,
> +					     struct bio *bio)
> +{
> +	return ((req_op(req) == REQ_OP_COPY_DST)  &&
> +		(bio_op(bio) == REQ_OP_COPY_SRC));
> +}
> +
>  static inline unsigned int blk_rq_get_max_segments(struct request *rq)
>  {
>  	if (req_op(rq) == REQ_OP_DISCARD)
> @@ -303,6 +310,8 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
>  		break;
>  	}
>  
> +	if (unlikely(op_is_copy(bio->bi_opf)))
> +		return false;
>  	/*
>  	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
>  	 * This is a quick and dirty check that relies on the fact that
> diff --git a/block/elevator.h b/block/elevator.h
> index 7ca3d7b6ed82..eec442bbf384 100644
> --- a/block/elevator.h
> +++ b/block/elevator.h
> @@ -18,6 +18,7 @@ enum elv_merge {
>  	ELEVATOR_FRONT_MERGE	= 1,
>  	ELEVATOR_BACK_MERGE	= 2,
>  	ELEVATOR_DISCARD_MERGE	= 3,
> +	ELEVATOR_COPY_OFFLOAD_MERGE	= 4,
>  };
>  
>  struct blk_mq_alloc_data;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c4f5b5228105..a2673f24e493 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -57,7 +57,9 @@ static inline bool bio_has_data(struct bio *bio)
>  	    bio->bi_iter.bi_size &&
>  	    bio_op(bio) != REQ_OP_DISCARD &&
>  	    bio_op(bio) != REQ_OP_SECURE_ERASE &&
> -	    bio_op(bio) != REQ_OP_WRITE_ZEROES)
> +	    bio_op(bio) != REQ_OP_WRITE_ZEROES &&
> +	    bio_op(bio) != REQ_OP_COPY_DST &&
> +	    bio_op(bio) != REQ_OP_COPY_SRC)
>  		return true;
>  
>  	return false;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 0bad62cca3d0..336146798e56 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -394,6 +394,9 @@ enum req_op {
>  	/* reset all the zone present on the device */
>  	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
>  
> +	REQ_OP_COPY_SRC		= (__force blk_opf_t)18,
> +	REQ_OP_COPY_DST		= (__force blk_opf_t)19,
> +
>  	/* Driver private requests */
>  	REQ_OP_DRV_IN		= (__force blk_opf_t)34,
>  	REQ_OP_DRV_OUT		= (__force blk_opf_t)35,
> @@ -482,6 +485,12 @@ static inline bool op_is_write(blk_opf_t op)
>  	return !!(op & (__force blk_opf_t)1);
>  }
>  
> +static inline bool op_is_copy(blk_opf_t op)
> +{
> +	return (((op & REQ_OP_MASK) == REQ_OP_COPY_SRC) ||
> +		((op & REQ_OP_MASK) == REQ_OP_COPY_DST));
> +}
> +
>  /*
>   * Check if the bio or request is one that needs special treatment in the
>   * flush state machine.
> @@ -541,4 +550,16 @@ struct blk_rq_stat {
>  	u64 batch;
>  };
>  
> +typedef void (cio_iodone_t)(void *private, int comp_len);
> +
> +struct cio {
> +	struct task_struct *waiter;     /* waiting task (NULL if none) */
> +	loff_t pos_in;
> +	loff_t pos_out;
> +	ssize_t comp_len;
> +	cio_iodone_t *endio;		/* applicable for async operation */
> +	void *private;			/* applicable for async operation */
> +	atomic_t refcount;
> +};
> +
>  #endif /* __LINUX_BLK_TYPES_H */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6098665953e6..963f5c97dec0 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1043,6 +1043,10 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
>  int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp);
> +ssize_t blkdev_copy_offload(
> +		struct block_device *bdev_in, loff_t pos_in,
> +		struct block_device *bdev_out, loff_t pos_out,
> +		size_t len, cio_iodone_t end_io, void *private, gfp_t gfp_mask);
>  
>  #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
>  #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

