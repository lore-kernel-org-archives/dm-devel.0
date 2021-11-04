Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A04C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:28:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3399E610D0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3399E610D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-MIbhSoBbOfKe4zd0HUnk3w-1; Thu, 04 Nov 2021 13:28:12 -0400
X-MC-Unique: MIbhSoBbOfKe4zd0HUnk3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA50FBD52A;
	Thu,  4 Nov 2021 17:28:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC63319C79;
	Thu,  4 Nov 2021 17:28:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 087E34E58F;
	Thu,  4 Nov 2021 17:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4HQ6Ah004209 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 13:26:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CD44F2166B26; Thu,  4 Nov 2021 17:26:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7BBF2166B25
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:26:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E79728007B1
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:26:03 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-469-nSR1uk1VNAGPqMbG-r8qaA-1;
	Thu, 04 Nov 2021 13:26:00 -0400
X-MC-Unique: nSR1uk1VNAGPqMbG-r8qaA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id A43CB60EBC;
	Thu,  4 Nov 2021 17:25:58 +0000 (UTC)
Date: Thu, 4 Nov 2021 10:25:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20211104172558.GH2237511@magnolia>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-2-chaitanyak@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20211104064634.4481-2-chaitanyak@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, ebiggers@google.com, linux-nvme@lists.infradead.org,
	song@kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, adilger.kernel@dilger.ca,
	hch@lst.de, agk@redhat.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	dongli.zhang@oracle.com, willy@infradead.org, osandov@fb.com,
	danil.kipnis@cloud.ionos.com, idryomov@gmail.com,
	jinpu.wang@cloud.ionos.com, Chaitanya Kulkarni <kch@nvidia.com>,
	jejb@linux.ibm.com, josef@toxicpanda.com, ming.lei@redhat.com,
	linux-raid@vger.kernel.org, dsterba@suse.com,
	viro@zeniv.linux.org.uk, kbusch@kernel.org, sagi@grimberg.me,
	axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
	martin.petersen@oracle.com, clm@fb.com,
	johannes.thumshirn@wdc.com, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [RFC PATCH 1/8] block: add support for REQ_OP_VERIFY
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 03, 2021 at 11:46:27PM -0700, Chaitanya Kulkarni wrote:
> From: Chaitanya Kulkarni <kch@nvidia.com>
> 
> This adds a new block layer operation to offload verifying a range of
> LBAs. This support is needed in order to provide file systems and
> fabrics, kernel components to offload LBA verification when it is
> supported by the hardware controller. In case hardware offloading is
> not supported then we provide APIs to emulate the same. The prominent
> example of that is NVMe Verify command. We also provide an emulation of
> the same operation which can be used in case H/W does not support
> verify. This is still useful when block device is remotely attached e.g.
> using NVMeOF.
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-block |  14 ++
>  block/blk-core.c                      |   5 +
>  block/blk-lib.c                       | 192 ++++++++++++++++++++++++++
>  block/blk-merge.c                     |  19 +++
>  block/blk-settings.c                  |  17 +++
>  block/blk-sysfs.c                     |   8 ++
>  block/blk-zoned.c                     |   1 +
>  block/bounce.c                        |   1 +
>  block/ioctl.c                         |  35 +++++
>  include/linux/bio.h                   |  10 +-
>  include/linux/blk_types.h             |   2 +
>  include/linux/blkdev.h                |  31 +++++
>  include/uapi/linux/fs.h               |   1 +
>  13 files changed, 332 insertions(+), 4 deletions(-)
> 

(skipping to the ioctl part; I didn't see anything obviously weird in
the block/ changes)

> diff --git a/block/ioctl.c b/block/ioctl.c
> index d61d652078f4..5e1b3c4660bf 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -168,6 +168,39 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
>  			BLKDEV_ZERO_NOUNMAP);
>  }
>  
> +static int blk_ioctl_verify(struct block_device *bdev, fmode_t mode,
> +		unsigned long arg)
> +{
> +	uint64_t range[2];
> +	struct address_space *mapping;
> +	uint64_t start, end, len;
> +
> +	if (!(mode & FMODE_WRITE))
> +		return -EBADF;

Why does the fd have to be opened writable?  Isn't this a read test?

> +
> +	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
> +		return -EFAULT;
> +
> +	start = range[0];
> +	len = range[1];
> +	end = start + len - 1;
> +
> +	if (start & 511)
> +		return -EINVAL;
> +	if (len & 511)
> +		return -EINVAL;
> +	if (end >= (uint64_t)i_size_read(bdev->bd_inode))
> +		return -EINVAL;
> +	if (end < start)
> +		return -EINVAL;
> +
> +	/* Invalidate the page cache, including dirty pages */
> +	mapping = bdev->bd_inode->i_mapping;
> +	truncate_inode_pages_range(mapping, start, end);

Why do we need to invalidate the page cache to verify media?  Won't that
cause data loss if those pages were dirty and about to be flushed?

--D

> +
> +	return blkdev_issue_verify(bdev, start >> 9, len >> 9, GFP_KERNEL);
> +}
> +
>  static int put_ushort(unsigned short __user *argp, unsigned short val)
>  {
>  	return put_user(val, argp);
> @@ -460,6 +493,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
>  				BLKDEV_DISCARD_SECURE);
>  	case BLKZEROOUT:
>  		return blk_ioctl_zeroout(bdev, mode, arg);
> +	case BLKVERIFY:
> +		return blk_ioctl_verify(bdev, mode, arg);
>  	case BLKREPORTZONE:
>  		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
>  	case BLKRESETZONE:
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c74857cf1252..d660c37b7d6c 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -63,7 +63,8 @@ static inline bool bio_has_data(struct bio *bio)
>  	    bio->bi_iter.bi_size &&
>  	    bio_op(bio) != REQ_OP_DISCARD &&
>  	    bio_op(bio) != REQ_OP_SECURE_ERASE &&
> -	    bio_op(bio) != REQ_OP_WRITE_ZEROES)
> +	    bio_op(bio) != REQ_OP_WRITE_ZEROES &&
> +	    bio_op(bio) != REQ_OP_VERIFY)
>  		return true;
>  
>  	return false;
> @@ -73,8 +74,8 @@ static inline bool bio_no_advance_iter(const struct bio *bio)
>  {
>  	return bio_op(bio) == REQ_OP_DISCARD ||
>  	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
> -	       bio_op(bio) == REQ_OP_WRITE_SAME ||
> -	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
> +	       bio_op(bio) == REQ_OP_WRITE_ZEROES ||
> +	       bio_op(bio) == REQ_OP_VERIFY;
>  }
>  
>  static inline bool bio_mergeable(struct bio *bio)
> @@ -198,7 +199,7 @@ static inline unsigned bio_segments(struct bio *bio)
>  	struct bvec_iter iter;
>  
>  	/*
> -	 * We special case discard/write same/write zeroes, because they
> +	 * We special case discard/write same/write zeroes/verify, because they
>  	 * interpret bi_size differently:
>  	 */
>  
> @@ -206,6 +207,7 @@ static inline unsigned bio_segments(struct bio *bio)
>  	case REQ_OP_DISCARD:
>  	case REQ_OP_SECURE_ERASE:
>  	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_VERIFY:
>  		return 0;
>  	case REQ_OP_WRITE_SAME:
>  		return 1;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 1bc6f6a01070..8877711c4c56 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -366,6 +366,8 @@ enum req_opf {
>  	REQ_OP_SECURE_ERASE	= 5,
>  	/* write the same sector many times */
>  	REQ_OP_WRITE_SAME	= 7,
> +	/* verify the sectors */
> +	REQ_OP_VERIFY		= 8,
>  	/* write the zero filled sector many times */
>  	REQ_OP_WRITE_ZEROES	= 9,
>  	/* Open a zone */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 0dea268bd61b..99c41d90584b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -334,6 +334,7 @@ struct queue_limits {
>  	unsigned int		max_hw_discard_sectors;
>  	unsigned int		max_write_same_sectors;
>  	unsigned int		max_write_zeroes_sectors;
> +	unsigned int		max_verify_sectors;
>  	unsigned int		max_zone_append_sectors;
>  	unsigned int		discard_granularity;
>  	unsigned int		discard_alignment;
> @@ -621,6 +622,7 @@ struct request_queue {
>  #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
>  #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
>  #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
> +#define QUEUE_FLAG_VERIFY	30	/* supports Verify */
>  
>  #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_SAME_COMP) |		\
> @@ -667,6 +669,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
>  #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
>  #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
>  #define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
> +#define blk_queue_verify(q)	test_bit(QUEUE_FLAG_VERIFY, &(q)->queue_flags)
>  
>  extern void blk_set_pm_only(struct request_queue *q);
>  extern void blk_clear_pm_only(struct request_queue *q);
> @@ -814,6 +817,9 @@ static inline bool rq_mergeable(struct request *rq)
>  	if (req_op(rq) == REQ_OP_WRITE_ZEROES)
>  		return false;
>  
> +	if (req_op(rq) == REQ_OP_VERIFY)
> +		return false;
> +
>  	if (req_op(rq) == REQ_OP_ZONE_APPEND)
>  		return false;
>  
> @@ -1072,6 +1078,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>  	if (unlikely(op == REQ_OP_WRITE_ZEROES))
>  		return q->limits.max_write_zeroes_sectors;
>  
> +	if (unlikely(op == REQ_OP_VERIFY))
> +		return q->limits.max_verify_sectors;
> +
>  	return q->limits.max_sectors;
>  }
>  
> @@ -1154,6 +1163,8 @@ extern void blk_queue_max_discard_sectors(struct request_queue *q,
>  		unsigned int max_discard_sectors);
>  extern void blk_queue_max_write_same_sectors(struct request_queue *q,
>  		unsigned int max_write_same_sectors);
> +extern void blk_queue_max_verify_sectors(struct request_queue *q,
> +		unsigned int max_verify_sectors);
>  extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
>  		unsigned int max_write_same_sectors);
>  extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
> @@ -1348,6 +1359,16 @@ extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  		unsigned flags);
>  extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp_mask, unsigned flags);
> +extern int __blkdev_emulate_verify(struct block_device *bdev, sector_t sector,
> +		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
> +		char *buf);
> +extern int blkdev_emulate_verify(struct block_device *bdev, sector_t sector,
> +		sector_t nr_sects, gfp_t gfp_mask);
> +extern int __blkdev_issue_verify(struct block_device *bdev,
> +		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
> +		struct bio **biop);
> +extern int blkdev_issue_verify(struct block_device *bdev, sector_t sector,
> +		sector_t nr_sects, gfp_t gfp_mask);
>  
>  static inline int sb_issue_discard(struct super_block *sb, sector_t block,
>  		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
> @@ -1553,6 +1574,16 @@ static inline unsigned int bdev_write_same(struct block_device *bdev)
>  	return 0;
>  }
>  
> +static inline unsigned int bdev_verify_sectors(struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)
> +		return q->limits.max_verify_sectors;
> +
> +	return 0;
> +}
> +
>  static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index f44eb0a04afd..5eda16bd2c3d 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -184,6 +184,7 @@ struct fsxattr {
>  #define BLKSECDISCARD _IO(0x12,125)
>  #define BLKROTATIONAL _IO(0x12,126)
>  #define BLKZEROOUT _IO(0x12,127)
> +#define BLKVERIFY _IO(0x12,128)
>  /*
>   * A jump here: 130-131 are reserved for zoned block devices
>   * (see uapi/linux/blkzoned.h)
> -- 
> 2.22.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

