Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62804C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681918971;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YBCi+dzZe9EHbRFSfB9PuPhaXPgzUR1JqqMzsYdt0Fg=;
	b=WLGNo0NN/qCq6X08NGwuyQpqkbxD445Ob+FznFjC3kbtD8sgqigjQCSdEBK1kdXi9/b1Yh
	4xfl60t7TD6tXKvj8BQW6nGrDr1ppRulyEMtXyHEqIt+YvuPbCwpKrbZXcq4T0JE5xCenQ
	zRzD8IRzfhyPg5iwh2zp2uxd8QDkpHw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-i3G5K0fWP86iQ5F7NmC9bw-1; Wed, 19 Apr 2023 11:42:47 -0400
X-MC-Unique: i3G5K0fWP86iQ5F7NmC9bw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3A773C10C7C;
	Wed, 19 Apr 2023 15:42:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9C9B492C3F;
	Wed, 19 Apr 2023 15:42:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A207E19465B1;
	Wed, 19 Apr 2023 15:42:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF08119465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 15:42:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BB6A72026D25; Wed, 19 Apr 2023 15:42:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B302F2026D16
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 15:42:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90DAF811E7D
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 15:42:43 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-hXVOIU7dOv2cFKN6_9pT3g-1; Wed, 19 Apr 2023 11:42:42 -0400
X-MC-Unique: hXVOIU7dOv2cFKN6_9pT3g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 60EAA6290E;
 Wed, 19 Apr 2023 15:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27E8C4339B;
 Wed, 19 Apr 2023 15:36:11 +0000 (UTC)
Date: Wed, 19 Apr 2023 08:36:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <20230419153611.GE360885@frogsfrogsfrogs>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-2-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230418221207.244685-2-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v4 1/4] block: Introduce provisioning
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
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 18, 2023 at 03:12:04PM -0700, Sarthak Kukreti wrote:
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
>  block/fops.c              | 25 +++++++++++++-----
>  include/linux/bio.h       |  6 +++--
>  include/linux/blk_types.h |  5 +++-
>  include/linux/blkdev.h    | 16 ++++++++++++
>  10 files changed, 147 insertions(+), 9 deletions(-)
> 

<cut to the fallocate part; the block/ changes look fine to /me/ at
first glance, but what do I know... ;)>

> diff --git a/block/fops.c b/block/fops.c
> index d2e6be4e3d1c..e1775269654a 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -611,9 +611,13 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	return ret;
>  }
>  
> +#define	BLKDEV_FALLOC_FL_TRUNCATE				\

At first I thought from this name that you were defining a new truncate
mode for fallocate, then I realized that this is mask for deciding if we
/want/ to truncate the pagecache.

#define		BLKDEV_FALLOC_TRUNCATE_MASK ?

> +		(FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_ZERO_RANGE |	\

Ok, so discarding and writing zeroes truncates the page cache, makes
sense since we're "writing" directly to the block device.

> +		 FALLOC_FL_NO_HIDE_STALE)

Here things get tricky -- some of the FALLOC_FL mode bits are really an
opcode and cannot be specified together, whereas others select optional
behavior for certain opcodes.

IIRC, the mutually exclusive opcodes are:

	PUNCH_HOLE
	ZERO_RANGE
	COLLAPSE_RANGE
	INSERT_RANGE
	(none of the above, for allocation)

and the "variants on a theme are":

	KEEP_SIZE
	NO_HIDE_STALE
	UNSHARE_RANGE

not all of which are supported by all the opcodes.

Does it make sense to truncate the page cache if userspace passes in
mode == NO_HIDE_STALE?  There's currently no defined meaning for this
combination, but I think this means we'll truncate the pagecache before
deciding if we're actually going to issue any commands.

I think that's just a bug in the existing code -- it should be
validating that @mode is any of the supported combinations *before*
truncating the pagecache.

Otherwise you could have a mkfs program that starts writing new fs
metadata, decides to provision the storage (say for a logging region),
doesn't realize it's running on an old kernel, and then oops the
provision attempt fails but have we now shredded the pagecache and lost
all the writes?

--D

> +
>  #define	BLKDEV_FALLOC_FL_SUPPORTED					\
> -		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
> -		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
> +		(BLKDEV_FALLOC_FL_TRUNCATE | FALLOC_FL_KEEP_SIZE |	\
> +		 FALLOC_FL_UNSHARE_RANGE)
>  
>  static long blkdev_fallocate(struct file *file, int mode, loff_t start,
>  			     loff_t len)
> @@ -625,7 +629,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
>  	int error;
>  
>  	/* Fail if we don't recognize the flags. */
> -	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
> +	if (mode != 0 && mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
>  		return -EOPNOTSUPP;
>  
>  	/* Don't go off the end of the device. */
> @@ -649,11 +653,20 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
>  	filemap_invalidate_lock(inode->i_mapping);
>  
>  	/* Invalidate the page cache, including dirty pages. */
> -	error = truncate_bdev_range(bdev, file->f_mode, start, end);
> -	if (error)
> -		goto fail;
> +	if (mode & BLKDEV_FALLOC_FL_TRUNCATE) {
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end);
> +		if (error)
> +			goto fail;
> +	}
>  
>  	switch (mode) {
> +	case 0:
> +	case FALLOC_FL_UNSHARE_RANGE:
> +	case FALLOC_FL_KEEP_SIZE:
> +	case FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE:
> +		error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
> +					       len >> SECTOR_SHIFT, GFP_KERNEL);
> +		break;
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
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

