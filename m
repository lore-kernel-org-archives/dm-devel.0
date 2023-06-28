Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DC6EB64D9
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971638;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XPnCHsALtLdMWdzhdQAT2N+1DmtLif5a3monIkwfGmY=;
	b=TWdJGc6mLFE0EYNT5WprgnJD8Oc3WRQ93c7jyENiFhEXp4gRwTHY+GJKoBAnhGOowSlhxC
	ST3Kml54fT8jDU0frwd9sU231JTEeaQ3pemTytH2WGRczdi058SdMMVvapRvVgS39dozNI
	5Xg5L0EOPLWK1LTZLZVJP3zOgg+tQMg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-BGKFw0z6O1KW_lUuAMjDLQ-1; Mon, 10 Jul 2023 02:47:15 -0400
X-MC-Unique: BGKFw0z6O1KW_lUuAMjDLQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 891E53815F19;
	Mon, 10 Jul 2023 06:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77C4C40C2072;
	Mon, 10 Jul 2023 06:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03E5D19451D5;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C23A1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Jun 2023 06:51:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6BCF9111F3B6; Wed, 28 Jun 2023 06:51:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 645D2111F3B0
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 06:51:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B07D3C01D9A
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 06:51:17 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-WlHgca6pNkSco4__N715zg-1; Wed, 28 Jun 2023 02:51:14 -0400
X-MC-Unique: WlHgca6pNkSco4__N715zg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9052C61315;
 Wed, 28 Jun 2023 06:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0FDC433C8;
 Wed, 28 Jun 2023 06:51:10 +0000 (UTC)
Message-ID: <365d5129-b65e-919a-3ceb-cc2ccf6b7a5a@kernel.org>
Date: Wed, 28 Jun 2023 15:51:09 +0900
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
 <CGME20230627184029epcas5p49a29676fa6dff5f24ddfa5c64e525a51@epcas5p4.samsung.com>
 <20230627183629.26571-5-nj.shetty@samsung.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230627183629.26571-5-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH v13 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device
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
> For direct block device opened with O_DIRECT, use copy_file_range to
> issue device copy offload, and fallback to generic_copy_file_range incase
> device copy offload capability is absent.

...if the device does not support copy offload or the device files are not open
with O_DIRECT.

No ?

> Modify checks to allow bdevs to use copy_file_range.
> 
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>  block/blk-lib.c        | 26 ++++++++++++++++++++++++++
>  block/fops.c           | 20 ++++++++++++++++++++
>  fs/read_write.c        |  7 +++++--
>  include/linux/blkdev.h |  4 ++++
>  4 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 09e0d5d51d03..7d8e09a99254 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -473,6 +473,32 @@ ssize_t blkdev_copy_offload(
>  }
>  EXPORT_SYMBOL_GPL(blkdev_copy_offload);
>  
> +/* Copy source offset from source block device to destination block
> + * device. Returns the length of bytes copied.
> + */

Multi-line comment style: start with a "/*" line please.

> +ssize_t blkdev_copy_offload_failfast(

What is the "failfast" in the name for ?

> +		struct block_device *bdev_in, loff_t pos_in,
> +		struct block_device *bdev_out, loff_t pos_out,
> +		size_t len, gfp_t gfp_mask)
> +{
> +	struct request_queue *in_q = bdev_get_queue(bdev_in);
> +	struct request_queue *out_q = bdev_get_queue(bdev_out);
> +	ssize_t ret = 0;

You do not need this initialization.

> +
> +	if (blkdev_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len))
> +		return 0;
> +
> +	if (blk_queue_copy(in_q) && blk_queue_copy(out_q)) {

Given that I think we do not allow copies between different devices, in_q and
out_q should always be the same, no ?

> +		ret = __blkdev_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
> +				len, NULL, NULL, gfp_mask);

Same here. Why pass 2 bdevs if we only allow copies within the same device ?

> +		if (ret < 0)
> +			return 0;
> +	}
> +
> +	return ret;

return 0;

> +}
> +EXPORT_SYMBOL_GPL(blkdev_copy_offload_failfast);
> +
>  static int __blkdev_issue_write_zeroes(struct block_device *bdev,
>  		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
>  		struct bio **biop, unsigned flags)
> diff --git a/block/fops.c b/block/fops.c
> index a286bf3325c5..a1576304f269 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -621,6 +621,25 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	return ret;
>  }
>  
> +static ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				size_t len, unsigned int flags)
> +{
> +	struct block_device *in_bdev = I_BDEV(bdev_file_inode(file_in));
> +	struct block_device *out_bdev = I_BDEV(bdev_file_inode(file_out));
> +	ssize_t comp_len = 0;
> +
> +	if ((file_in->f_iocb_flags & IOCB_DIRECT) &&
> +		(file_out->f_iocb_flags & IOCB_DIRECT))
> +		comp_len = blkdev_copy_offload_failfast(in_bdev, pos_in,
> +				out_bdev, pos_out, len, GFP_KERNEL);
> +	if (comp_len != len)
> +		comp_len = generic_copy_file_range(file_in, pos_in + comp_len,
> +			file_out, pos_out + comp_len, len - comp_len, flags);
> +
> +	return comp_len;
> +}
> +
>  #define	BLKDEV_FALLOC_FL_SUPPORTED					\
>  		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
>  		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
> @@ -714,6 +733,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_read	= filemap_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
> +	.copy_file_range = blkdev_copy_file_range,
>  };
>  
>  static __init int blkdev_init(void)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index b07de77ef126..d27148a2543f 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1447,7 +1447,8 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
>  		return -EOVERFLOW;
>  
>  	/* Shorten the copy to EOF */
> -	size_in = i_size_read(inode_in);
> +	size_in = i_size_read(file_in->f_mapping->host);
> +
>  	if (pos_in >= size_in)
>  		count = 0;
>  	else
> @@ -1708,7 +1709,9 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
>  	/* Don't copy dirs, pipes, sockets... */
>  	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
>  		return -EISDIR;
> -	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> +
> +	if ((!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode)) &&
> +		(!S_ISBLK(inode_in->i_mode) || !S_ISBLK(inode_out->i_mode)))
>  		return -EINVAL;
>  
>  	if (!(file_in->f_mode & FMODE_READ) ||
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c176bf6173c5..850168cad080 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1047,6 +1047,10 @@ ssize_t blkdev_copy_offload(
>  		struct block_device *bdev_in, loff_t pos_in,
>  		struct block_device *bdev_out, loff_t pos_out,
>  		size_t len, cio_iodone_t end_io, void *private, gfp_t gfp_mask);
> +ssize_t blkdev_copy_offload_failfast(
> +		struct block_device *bdev_in, loff_t pos_in,
> +		struct block_device *bdev_out, loff_t pos_out,
> +		size_t len, gfp_t gfp_mask);
>  struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
>  		gfp_t gfp_mask);
>  void bio_map_kern_endio(struct bio *bio);

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

