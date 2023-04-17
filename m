Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B4FC77B7A
	for <dm-devel@archiver.kernel.org>; Mon, 17 Apr 2023 17:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681752838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EmeNgffwgxWUnUA99iY6u9aoEGbv9TRlhqiED4a1f5A=;
	b=GUUNJ6ozzTohp/+hNuR2Xn+ZMKccWKFGZtfQvn/ovlTzWjZKxMkn9w0yjghx696xUmpaIg
	5dF7gi6rq3GGOMrI2XcQHSW7mD2CD4ef9aQ0izYYsudjeSVgAiFiK4f4+vOIa3YPJXFGlg
	C8gjhzea/KOxXvK6EvS6qah4gJBUWnU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-AnAeE527OlKysCDwFGqkDA-1; Mon, 17 Apr 2023 13:33:57 -0400
X-MC-Unique: AnAeE527OlKysCDwFGqkDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A8BA85A588;
	Mon, 17 Apr 2023 17:33:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4845B40C6E6E;
	Mon, 17 Apr 2023 17:33:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 08551194658C;
	Mon, 17 Apr 2023 17:33:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A3EA1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Apr 2023 17:33:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 72C862166B29; Mon, 17 Apr 2023 17:33:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B3662166B26
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 17:33:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B4B48314EB
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 17:33:46 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-V7FrTO0JOGGI5ZSj25bgmQ-1; Mon, 17 Apr 2023 13:33:45 -0400
X-MC-Unique: V7FrTO0JOGGI5ZSj25bgmQ-1
Received: by mail-qv1-f71.google.com with SMTP id
 qf10-20020a0562144b8a00b005e7c60f8fe0so13073279qvb.6
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 10:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681752824; x=1684344824;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Jm85SSVaopQAxnU3x7Lrot1DU+GlbD9SOLxgFW9cj5k=;
 b=WinSFafDBrc0A7cPeP5BVm2p1o6azJVhnPA9IdWdpaiFe3G3XtPwe5JVCiLt3UANQR
 Plx7LDtxSMJD4GsEsDhA2APq+SLk4JLDrrTlbdXTwC6kkaijcvJU6D8YHjIbXkhR5HmU
 J8FEMkE4lIWlfzG8e3uU2kePNW2hwnjxXlsvDsd4irsnYxvNfx+K9XauJmGMyPVU2YvB
 qAGcTyGDtwyLq1qJ5YNvFJp5044hEdLAK0Qtxn4FZ9NcRwp7/ea8r+lDVvyeJ3AT8DUU
 YUENb5MZMYliHRoARiH4icDF7LoSzNOFNgaMSsC8ZrkPzlcWWtbmxaPtMCsyt47+DSfL
 g2fA==
X-Gm-Message-State: AAQBX9eX1ptYJdQh2ntUvUGT4pq+qihvLfO19mWEwQFycHLJDkm7zF/I
 069mKdPRZ+VjWipuDc6AMf9m+blvhBEOSwR3Yit5jtoHHU7LVboJNky2pzzcelcYA18sXUeM/Po
 igkyCFJZlLKHo10s=
X-Received: by 2002:a05:622a:1746:b0:3ec:e29f:6f4f with SMTP id
 l6-20020a05622a174600b003ece29f6f4fmr13735681qtk.33.1681752824524; 
 Mon, 17 Apr 2023 10:33:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZygDANXtkSDESQaT+/nlutXw5EifsNXMDbt5vvWnxrF6WrCl5NaVCG+oOnpCy/E82arPOA9Q==
X-Received: by 2002:a05:622a:1746:b0:3ec:e29f:6f4f with SMTP id
 l6-20020a05622a174600b003ece29f6f4fmr13735633qtk.33.1681752824192; 
 Mon, 17 Apr 2023 10:33:44 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 p24-20020a05620a22f800b0074a2467f541sm3337263qki.35.2023.04.17.10.33.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 17 Apr 2023 10:33:43 -0700 (PDT)
Date: Mon, 17 Apr 2023 13:35:46 -0400
From: Brian Foster <bfoster@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZD2DcvyHdNmkdwr1@bfoster>
References: <20221229071647.437095-1-sarthakkukreti@chromium.org>
 <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230414000219.92640-2-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230414000219.92640-2-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v3 1/3] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 sarthakkukreti@google.com, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 13, 2023 at 05:02:17PM -0700, Sarthak Kukreti wrote:
> Introduce block request REQ_OP_PROVISION. The intent of this request
> is to request underlying storage to preallocate disk space for the given
> block range. Block devices that support this capability will export
> a provision limit within their request queues.
> 
> This patch also adds the capability to call fallocate() in mode 0
> on block devices, which will send REQ_OP_PROVISION to the block
> device for the specified range,
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  block/blk-core.c          |  5 ++++
>  block/blk-lib.c           | 53 +++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         | 18 +++++++++++++
>  block/blk-settings.c      | 19 ++++++++++++++
>  block/blk-sysfs.c         |  8 ++++++
>  block/bounce.c            |  1 +
>  block/fops.c              | 14 ++++++++---
>  include/linux/bio.h       |  6 +++--
>  include/linux/blk_types.h |  5 +++-
>  include/linux/blkdev.h    | 16 ++++++++++++
>  10 files changed, 138 insertions(+), 7 deletions(-)
> 
...
> diff --git a/block/fops.c b/block/fops.c
> index d2e6be4e3d1c..f82da2fb8af0 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -625,7 +625,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
>  	int error;
>  
>  	/* Fail if we don't recognize the flags. */
> -	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
> +	if (mode != 0 && mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
>  		return -EOPNOTSUPP;
>  
>  	/* Don't go off the end of the device. */
> @@ -649,11 +649,17 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
>  	filemap_invalidate_lock(inode->i_mapping);
>  
>  	/* Invalidate the page cache, including dirty pages. */
> -	error = truncate_bdev_range(bdev, file->f_mode, start, end);
> -	if (error)
> -		goto fail;
> +	if (mode != 0) {
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end);
> +		if (error)
> +			goto fail;
> +	}
>  
>  	switch (mode) {
> +	case 0:
> +		error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
> +					       len >> SECTOR_SHIFT, GFP_KERNEL);
> +		break;

I would think we'd want to support any combination of
FALLOC_FL_KEEP_SIZE and FALLOC_FL_UNSHARE_RANGE..? All of the other
commands support the former modifier, for one. It also looks like if
somebody attempts to invoke with mode == FALLOC_FL_KEEP_SIZE, even with
the current upstream code that would perform the bdev truncate before
returning -EOPNOTSUPP. That seems like a bit of an unfortunate side
effect to me.

WRT to unshare, if the PROVISION request is always going to imply an
unshare (which seems reasonable to me), there's probably no reason to
-EOPNOTSUPP if a caller explicitly passes UNSHARE_RANGE.

Brian

>  	case FALLOC_FL_ZERO_RANGE:
>  	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
>  		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index d766be7152e1..9820b3b039f2 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -57,7 +57,8 @@ static inline bool bio_has_data(struct bio *bio)
>  	    bio->bi_iter.bi_size &&
>  	    bio_op(bio) != REQ_OP_DISCARD &&
>  	    bio_op(bio) != REQ_OP_SECURE_ERASE &&
> -	    bio_op(bio) != REQ_OP_WRITE_ZEROES)
> +	    bio_op(bio) != REQ_OP_WRITE_ZEROES &&
> +	    bio_op(bio) != REQ_OP_PROVISION)
>  		return true;
>  
>  	return false;
> @@ -67,7 +68,8 @@ static inline bool bio_no_advance_iter(const struct bio *bio)
>  {
>  	return bio_op(bio) == REQ_OP_DISCARD ||
>  	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
> -	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
> +	       bio_op(bio) == REQ_OP_WRITE_ZEROES ||
> +	       bio_op(bio) == REQ_OP_PROVISION;
>  }
>  
>  static inline void *bio_data(struct bio *bio)
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 99be590f952f..27bdf88f541c 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -385,7 +385,10 @@ enum req_op {
>  	REQ_OP_DRV_IN		= (__force blk_opf_t)34,
>  	REQ_OP_DRV_OUT		= (__force blk_opf_t)35,
>  
> -	REQ_OP_LAST		= (__force blk_opf_t)36,
> +	/* request device to provision block */
> +	REQ_OP_PROVISION        = (__force blk_opf_t)37,
> +
> +	REQ_OP_LAST		= (__force blk_opf_t)38,
>  };
>  
>  enum req_flag_bits {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 941304f17492..239e2f418b6e 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -303,6 +303,7 @@ struct queue_limits {
>  	unsigned int		discard_granularity;
>  	unsigned int		discard_alignment;
>  	unsigned int		zone_write_granularity;
> +	unsigned int		max_provision_sectors;
>  
>  	unsigned short		max_segments;
>  	unsigned short		max_integrity_segments;
> @@ -921,6 +922,8 @@ extern void blk_queue_max_discard_sectors(struct request_queue *q,
>  		unsigned int max_discard_sectors);
>  extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
>  		unsigned int max_write_same_sectors);
> +extern void blk_queue_max_provision_sectors(struct request_queue *q,
> +		unsigned int max_provision_sectors);
>  extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
>  extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
>  		unsigned int max_zone_append_sectors);
> @@ -1060,6 +1063,9 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp);
>  
> +extern int blkdev_issue_provision(struct block_device *bdev, sector_t sector,
> +		sector_t nr_sects, gfp_t gfp_mask);
> +
>  #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
>  #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
>  
> @@ -1139,6 +1145,11 @@ static inline unsigned short queue_max_discard_segments(const struct request_que
>  	return q->limits.max_discard_segments;
>  }
>  
> +static inline unsigned short queue_max_provision_sectors(const struct request_queue *q)
> +{
> +	return q->limits.max_provision_sectors;
> +}
> +
>  static inline unsigned int queue_max_segment_size(const struct request_queue *q)
>  {
>  	return q->limits.max_segment_size;
> @@ -1281,6 +1292,11 @@ static inline bool bdev_nowait(struct block_device *bdev)
>  	return test_bit(QUEUE_FLAG_NOWAIT, &bdev_get_queue(bdev)->queue_flags);
>  }
>  
> +static inline unsigned int bdev_max_provision_sectors(struct block_device *bdev)
> +{
> +	return bdev_get_queue(bdev)->limits.max_provision_sectors;
> +}
> +
>  static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
>  {
>  	return blk_queue_zoned_model(bdev_get_queue(bdev));
> -- 
> 2.40.0.634.g4ca3ef3211-goog
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

