Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3E9C77B60
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680080251;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vdB5n8LjzQ6FPc+epFITc0WfV6ZIUN0W5noTFetgb7E=;
	b=RIzPq3VZ8ZeYZsRYqHXrQA3gzA4vLpaggO4oV900Vp1DGNB/HDZtH3u8GtWwQfktKJPBtT
	XEn354lMUmkoLJAah4gHmADstPMITmO2xG5Jt96t5bvoC/rlp9/KBmprCYaKFfSDbF/hyH
	TVdk5wnyN3LNHgC0+fs1zX7jj6s95EU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-ttLN1AWuPIGZ2zwgU3nIEg-1; Wed, 29 Mar 2023 04:57:28 -0400
X-MC-Unique: ttLN1AWuPIGZ2zwgU3nIEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CB79811E7C;
	Wed, 29 Mar 2023 08:57:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1656018EC2;
	Wed, 29 Mar 2023 08:57:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E7FC7194658D;
	Wed, 29 Mar 2023 08:57:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D207194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:57:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BF871402C06; Wed, 29 Mar 2023 08:57:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 23B30140EBF4
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:57:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC03B280D587
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:57:24 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-5G1ncAvEOmGe0XbaDIu-Bw-1; Wed, 29 Mar 2023 04:57:23 -0400
X-MC-Unique: 5G1ncAvEOmGe0XbaDIu-Bw-1
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; d="scan'208";a="331215023"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 16:56:19 +0800
IronPort-SDR: ehkFbcwezvFwooriuOuWffZq+ceMcX/e2GeIZ1zvPGRHKZzUhWZ8Se74vf71J6P0YBa8uneOJZ
 Jp/PfGS/kKfm+iYnpv0kunmb6kl5S1wSl2vYkAYvcyLPribOmbaYp45Am590SHGMRcPHrBGijF
 ZHJ6IhvupS8cCCUxtXpy/5et3o3vDujNyXBP4qPgaYRRL9zgIzti0sjiVKVNX9RJztU7gAcCOy
 tZ8FKonVY+57IkupSCpPcVnX3VvKbJ+q7x9fvwGpNWl5Zlvyc5CXId+YnEylTlUyRWrYhmj550
 5MU=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 01:12:29 -0700
IronPort-SDR: X74eeEndvy8nswry4ExDYxCQANcb2G7f37wfWWxX8JNeCIzDval15KCLEJUk44edinOw/ECO35
 1wvQZUHk9gq2YIkDNcptjsaMXuxnMaYNhDMi/kPK5AaIHVNla3/8XIYq4h23RLiMGQe+U4X4rO
 VviwZCL+u9dTv9xAFsoZeMxvVBFROF6YMqtrkkhKFLK/7oDRMcNaRQ08pqR0hcik2/sz6e2Bip
 0o2/0z3nCj09cwQLIpFSDUIlpJdlxcgPxa3qGKBKyTG11ixHnKidq3MEHuqFUrPAQtMmHSfliB
 LMs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 01:56:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PmgQC4HyDz1RtVn
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 01:56:19 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id bt05C28Q4UdS for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 01:56:16 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PmgQ50xR5z1RtVm;
 Wed, 29 Mar 2023 01:56:12 -0700 (PDT)
Message-ID: <6fd95345-ff8d-d18e-5dcf-1f34dae31770@opensource.wdc.com>
Date: Wed, 29 Mar 2023 17:56:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084226epcas5p28e667b25cbb5e4b0e884aa2ca89cbfff@epcas5p2.samsung.com>
 <20230327084103.21601-3-anuj20.g@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230327084103.21601-3-anuj20.g@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 2/9] block: Add copy offload support
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/27/23 17:40, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Introduce blkdev_issue_copy which takes similar arguments as
> copy_file_range and performs copy offload between two bdevs.
> Introduce REQ_COPY copy offload operation flag. Create a read-write
> bio pair with a token as payload and submitted to the device in order.
> Read request populates token with source specific information which
> is then passed with write request.
> This design is courtesy Mikulas Patocka's token based copy
> 
> Larger copy will be divided, based on max_copy_sectors limit.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  block/blk-lib.c           | 236 ++++++++++++++++++++++++++++++++++++++
>  block/blk.h               |   2 +
>  include/linux/blk_types.h |  25 ++++
>  include/linux/blkdev.h    |   3 +
>  4 files changed, 266 insertions(+)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e59c3069e835..cbc6882d1e7a 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -115,6 +115,242 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  }
>  EXPORT_SYMBOL(blkdev_issue_discard);
>  
> +/*
> + * For synchronous copy offload/emulation, wait and process all in-flight BIOs.
> + * This must only be called once all bios have been issued so that the refcount
> + * can only decrease. This just waits for all bios to make it through
> + * bio_copy_*_write_end_io. IO errors are propagated through cio->io_error.
> + */
> +static int cio_await_completion(struct cio *cio)

Why not simply cio_wait_completion() ?

> +{
> +	int ret = 0;

No need for the initialization.

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

What about cio->io_error as the top comment mentions ? Looking at struct cio,
there is no io_error field.

> +	kfree(cio);
> +
> +	return ret;
> +}
> +
> +static void blk_copy_offload_write_end_io(struct bio *bio)
> +{
> +	struct copy_ctx *ctx = bio->bi_private;
> +	struct cio *cio = ctx->cio;
> +	sector_t clen;
> +
> +	if (bio->bi_status) {
> +		clen = (bio->bi_iter.bi_sector << SECTOR_SHIFT) - cio->pos_out;
> +		cio->comp_len = min_t(sector_t, clen, cio->comp_len);

I do not understand. You set the length only if there was an error ? What about
the OK case ? Is this to handle partial completions ? If yes, then please add a
comment.

> +	}
> +	__free_page(bio->bi_io_vec[0].bv_page);
> +	bio_put(bio);
> +
> +	kfree(ctx);
> +	if (atomic_dec_and_test(&cio->refcount)) {

Reverse this condition and return early.

> +		if (cio->endio) {
> +			cio->endio(cio->private, cio->comp_len);
> +			kfree(cio);
> +		} else
> +			blk_wake_io_task(cio->waiter);

Missing curly braces for the else.

> +	}
> +}
> +
> +static void blk_copy_offload_read_end_io(struct bio *read_bio)
> +{
> +	struct copy_ctx *ctx = read_bio->bi_private;
> +	struct cio *cio = ctx->cio;
> +	sector_t clen;
> +
> +	if (read_bio->bi_status) {
> +		clen = (read_bio->bi_iter.bi_sector << SECTOR_SHIFT)
> +				- cio->pos_in;
> +		cio->comp_len = min_t(sector_t, clen, cio->comp_len);
> +		__free_page(read_bio->bi_io_vec[0].bv_page);
> +		bio_put(ctx->write_bio);
> +		bio_put(read_bio);
> +		kfree(ctx);
> +		if (atomic_dec_and_test(&cio->refcount)) {
> +			if (cio->endio) {
> +				cio->endio(cio->private, cio->comp_len);
> +				kfree(cio);
> +			} else
> +				blk_wake_io_task(cio->waiter);

Missing curly braces for the else.

> +		}
> +		return;

So you do all this only if there was an error ? What about an OK bio completion
(bi_status == BLK_STS_OK) ?

> +	}
> +
> +	schedule_work(&ctx->dispatch_work);
> +	bio_put(read_bio);
> +}
> +
> +static void blk_copy_dispatch_work_fn(struct work_struct *work)
> +{
> +	struct copy_ctx *ctx = container_of(work, struct copy_ctx,
> +			dispatch_work);
> +
> +	submit_bio(ctx->write_bio);
> +}
> +
> +/*
> + * __blk_copy_offload	- Use device's native copy offload feature.
> + * we perform copy operation by sending 2 bio.
> + * 1. First we send a read bio with REQ_COPY flag along with a token and source
> + * and length. Once read bio reaches driver layer, device driver adds all the
> + * source info to token and does a fake completion.
> + * 2. Once read operation completes, we issue write with REQ_COPY flag with same
> + * token. In driver layer, token info is used to form a copy offload command.
> + *
> + * returns the length of bytes copied or negative error value
> + */
> +static int __blk_copy_offload(struct block_device *bdev_in, loff_t pos_in,
> +		struct block_device *bdev_out, loff_t pos_out, size_t len,
> +		cio_iodone_t end_io, void *private, gfp_t gfp_mask)
> +{
> +	struct cio *cio;
> +	struct copy_ctx *ctx;
> +	struct bio *read_bio, *write_bio;
> +	struct page *token;
> +	sector_t copy_len;
> +	sector_t rem, max_copy_len;
> +
> +	cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
> +	if (!cio)
> +		return -ENOMEM;
> +	atomic_set(&cio->refcount, 0);
> +	cio->waiter = current;
> +	cio->endio = end_io;
> +	cio->private = private;
> +
> +	max_copy_len = min(bdev_max_copy_sectors(bdev_in),
> +			bdev_max_copy_sectors(bdev_out)) << SECTOR_SHIFT;
> +
> +	cio->pos_in = pos_in;
> +	cio->pos_out = pos_out;
> +	cio->comp_len = len;
> +	for (rem = len; rem > 0; rem -= copy_len) {
> +		copy_len = min(rem, max_copy_len);
> +
> +		token = alloc_page(gfp_mask);
> +		if (unlikely(!token))
> +			goto err_token;
> +
> +		ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
> +		if (!ctx)
> +			goto err_ctx;
> +		read_bio = bio_alloc(bdev_in, 1, REQ_OP_READ | REQ_COPY
> +			| REQ_SYNC | REQ_NOMERGE, gfp_mask);
> +		if (!read_bio)
> +			goto err_read_bio;
> +		write_bio = bio_alloc(bdev_out, 1, REQ_OP_WRITE
> +			| REQ_COPY | REQ_SYNC | REQ_NOMERGE, gfp_mask);
> +		if (!write_bio)
> +			goto err_write_bio;
> +
> +		ctx->cio = cio;
> +		ctx->write_bio = write_bio;
> +		INIT_WORK(&ctx->dispatch_work, blk_copy_dispatch_work_fn);
> +
> +		__bio_add_page(read_bio, token, PAGE_SIZE, 0);
> +		read_bio->bi_iter.bi_size = copy_len;
> +		read_bio->bi_iter.bi_sector = pos_in >> SECTOR_SHIFT;
> +		read_bio->bi_end_io = blk_copy_offload_read_end_io;
> +		read_bio->bi_private = ctx;
> +
> +		__bio_add_page(write_bio, token, PAGE_SIZE, 0);
> +		write_bio->bi_iter.bi_size = copy_len;
> +		write_bio->bi_end_io = blk_copy_offload_write_end_io;
> +		write_bio->bi_iter.bi_sector = pos_out >> SECTOR_SHIFT;
> +		write_bio->bi_private = ctx;
> +
> +		atomic_inc(&cio->refcount);
> +		submit_bio(read_bio);
> +		pos_in += copy_len;
> +		pos_out += copy_len;
> +	}
> +
> +	/* Wait for completion of all IO's*/
> +	return cio_await_completion(cio);
> +
> +err_write_bio:
> +	bio_put(read_bio);
> +err_read_bio:
> +	kfree(ctx);
> +err_ctx:
> +	__free_page(token);
> +err_token:
> +	cio->comp_len = min_t(sector_t, cio->comp_len, (len - rem));

Why ? cio_wait_completion() return that, no ?

> +	return cio_await_completion(cio);
> +}
> +
> +static inline int blk_copy_sanity_check(struct block_device *bdev_in,
> +	loff_t pos_in, struct block_device *bdev_out, loff_t pos_out,
> +	size_t len)
> +{
> +	unsigned int align = max(bdev_logical_block_size(bdev_out),
> +					bdev_logical_block_size(bdev_in)) - 1;
> +
> +	if (bdev_read_only(bdev_out))
> +		return -EPERM;
> +
> +	if ((pos_in & align) || (pos_out & align) || (len & align) || !len ||
> +		len >= MAX_COPY_TOTAL_LENGTH)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static inline bool blk_check_copy_offload(struct request_queue *q_in,
> +		struct request_queue *q_out)
> +{
> +	return blk_queue_copy(q_in) && blk_queue_copy(q_out);
> +}

Not a very useful helper.

> +
> +/*
> + * @bdev_in:	source block device
> + * @pos_in:	source offset
> + * @bdev_out:	destination block device
> + * @pos_out:	destination offset
> + * @len:	length in bytes to be copied
> + * @end_io:	end_io function to be called on completion of copy operation,
> + *		for synchronous operation this should be NULL
> + * @private:	end_io function will be called with this private data, should be
> + *		NULL, if operation is synchronous in nature
> + * @gfp_mask:   memory allocation flags (for bio_alloc)
> + *
> + * Returns the length of bytes copied or a negative error value
> + *
> + * Description:
> + *	Copy source offset from source block device to destination block
> + *	device. length of a source range cannot be zero. Max total length of
> + *	copy is limited to MAX_COPY_TOTAL_LENGTH
> + */
> +int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
> +		      struct block_device *bdev_out, loff_t pos_out, size_t len,
> +		      cio_iodone_t end_io, void *private, gfp_t gfp_mask)
> +{
> +	struct request_queue *q_in = bdev_get_queue(bdev_in);
> +	struct request_queue *q_out = bdev_get_queue(bdev_out);
> +	int ret = -EINVAL;
> +
> +	ret = blk_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len);
> +	if (ret)
> +		return ret;
> +
> +	if (blk_check_copy_offload(q_in, q_out))
> +		ret = __blk_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
> +			   len, end_io, private, gfp_mask);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(blkdev_issue_copy);
> +
>  static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>  		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
>  		struct bio **biop, unsigned flags)
> diff --git a/block/blk.h b/block/blk.h
> index d65d96994a94..684b8fa121db 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -311,6 +311,8 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
>  		break;
>  	}
>  
> +	if (unlikely(op_is_copy(bio->bi_opf)))
> +		return false;
>  	/*
>  	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
>  	 * This is a quick and dirty check that relies on the fact that
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index a0e339ff3d09..7f586c4b9954 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -423,6 +423,7 @@ enum req_flag_bits {
>  	 */
>  	/* for REQ_OP_WRITE_ZEROES: */
>  	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
> +	__REQ_COPY,		/* copy request */
>  
>  	__REQ_NR_BITS,		/* stops here */
>  };
> @@ -452,6 +453,7 @@ enum req_flag_bits {
>  
>  #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
>  #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
> +#define REQ_COPY	((__force blk_opf_t)(1ULL << __REQ_COPY))
>  
>  #define REQ_FAILFAST_MASK \
>  	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
> @@ -478,6 +480,11 @@ static inline bool op_is_write(blk_opf_t op)
>  	return !!(op & (__force blk_opf_t)1);
>  }
>  
> +static inline bool op_is_copy(blk_opf_t op)
> +{
> +	return (op & REQ_COPY);

No need for the parenthesis.

> +}
> +
>  /*
>   * Check if the bio or request is one that needs special treatment in the
>   * flush state machine.
> @@ -537,4 +544,22 @@ struct blk_rq_stat {
>  	u64 batch;
>  };
>  
> +typedef void (cio_iodone_t)(void *private, int comp_len);

Not really needed I think.

> +
> +struct cio {
> +	struct task_struct *waiter;     /* waiting task (NULL if none) */
> +	atomic_t refcount;
> +	loff_t pos_in;
> +	loff_t pos_out;
> +	size_t comp_len;
> +	cio_iodone_t *endio;		/* applicable for async operation */
> +	void *private;			/* applicable for async operation */
> +};
> +
> +struct copy_ctx {
> +	struct cio *cio;
> +	struct work_struct dispatch_work;
> +	struct bio *write_bio;
> +};
> +
>  #endif /* __LINUX_BLK_TYPES_H */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 200338f2ec2e..1bb43697d43d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1054,6 +1054,9 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
>  int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp);
> +int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
> +		      struct block_device *bdev_out, loff_t pos_out, size_t len,
> +		      cio_iodone_t end_io, void *private, gfp_t gfp_mask);
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

