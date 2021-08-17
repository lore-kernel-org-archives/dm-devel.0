Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9618FC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 23:50:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 12D3461019
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 23:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 12D3461019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-DIExzJBNOv2fWNwmYUZXKA-1; Tue, 17 Aug 2021 19:50:02 -0400
X-MC-Unique: DIExzJBNOv2fWNwmYUZXKA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11CAB802920;
	Tue, 17 Aug 2021 23:49:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4C7761096;
	Tue, 17 Aug 2021 23:49:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E30C2181A100;
	Tue, 17 Aug 2021 23:49:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HNk3nf006562 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 19:46:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E375310130E6; Tue, 17 Aug 2021 23:46:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEDD41012325
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 23:45:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA53C89C7DC
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 23:45:58 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-336-P7EWGllkNtGZV1e728mYrQ-1;
	Tue, 17 Aug 2021 19:45:56 -0400
X-MC-Unique: P7EWGllkNtGZV1e728mYrQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9036E60E90;
	Tue, 17 Aug 2021 23:36:13 +0000 (UTC)
Date: Tue, 17 Aug 2021 16:36:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: SelvaKumar S <selvakuma.s1@samsung.com>
Message-ID: <20210817233613.GA12597@magnolia>
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101803epcas5p10cda1d52f8a8f1172e34b1f9cf8eef3b@epcas5p1.samsung.com>
	<20210817101423.12367-5-selvakuma.s1@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20210817101423.12367-5-selvakuma.s1@samsung.com>
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
Cc: snitzer@redhat.com, linux-nvme@lists.infradead.org, dm-devel@redhat.com,
	hch@lst.de, agk@redhat.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
	willy@infradead.org, nj.shetty@samsung.com, kch@kernel.org,
	selvajove@gmail.com, linux-block@vger.kernel.org,
	mpatocka@redhat.com, javier.gonz@samsung.com, kbusch@kernel.org,
	axboe@kernel.dk, damien.lemoal@wdc.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-api@vger.kernel.org,
	johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
	joshiiitr@gmail.com, asml.silence@gmail.com
Subject: Re: [dm-devel] [PATCH 4/7] block: Introduce a new ioctl for simple
	copy
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 17, 2021 at 03:44:20PM +0530, SelvaKumar S wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Add new BLKCOPY ioctl that offloads copying of one or more sources ranges
> to a destination in the device. COPY ioctl accepts a 'copy_range'
> structure that contains destination (in sectors), no of sources and
> pointer to the array of source ranges. Each source range is represented by
> 'range_entry' that contains start and length of source ranges (in sectors)
> 
> MAX_COPY_NR_RANGE, limits the number of entries for the IOCTL and
> MAX_COPY_TOTAL_LENGTH limits the total copy length, IOCTL can handle.
> 
> Example code, to issue BLKCOPY:
> /* Sample example to copy three source-ranges [0, 8] [16, 8] [32,8] to
>  * [64,24], on the same device */
> 
> int main(void)
> {
> 	int ret, fd;
> 	struct range_entry source_range[] = {{.src = 0, .len = 8},
> 		{.src = 16, .len = 8}, {.src = 32, .len = 8},};
> 	struct copy_range cr;
> 
> 	cr.dest = 64;
> 	cr.nr_range = 3;
> 	cr.range_list = (__u64)&source_range;
> 
> 	fd = open("/dev/nvme0n1", O_RDWR);
> 	if (fd < 0) return 1;
> 
> 	ret = ioctl(fd, BLKCOPY, &cr);
> 	if (ret < 0) printf("copy failure\n");
> 
> 	close(fd);
> 
> 	return ret;
> }
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/ioctl.c           | 33 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/fs.h |  8 ++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/block/ioctl.c b/block/ioctl.c
> index eb0491e90b9a..2af56d01e9fe 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -143,6 +143,37 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
>  				    GFP_KERNEL, flags);
>  }
>  
> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> +		unsigned long arg)
> +{
> +	struct copy_range crange;
> +	struct range_entry *rlist;
> +	int ret;
> +
> +	if (!(mode & FMODE_WRITE))
> +		return -EBADF;
> +
> +	if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
> +		return -EFAULT;
> +
> +	rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
> +			GFP_KERNEL);
> +	if (!rlist)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(rlist, (void __user *)crange.range_list,
> +				sizeof(*rlist) * crange.nr_range)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = blkdev_issue_copy(bdev, crange.nr_range, rlist, bdev, crange.dest,
> +			GFP_KERNEL, 0);
> +out:
> +	kfree(rlist);
> +	return ret;
> +}
> +
>  static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
>  		unsigned long arg)
>  {
> @@ -468,6 +499,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
>  	case BLKSECDISCARD:
>  		return blk_ioctl_discard(bdev, mode, arg,
>  				BLKDEV_DISCARD_SECURE);
> +	case BLKCOPY:
> +		return blk_ioctl_copy(bdev, mode, arg);
>  	case BLKZEROOUT:
>  		return blk_ioctl_zeroout(bdev, mode, arg);
>  	case BLKGETDISKSEQ:
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 7a97b588d892..4183688ff398 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -76,6 +76,13 @@ struct range_entry {
>  	__u64 len;
>  };
>  
> +struct copy_range {
> +	__u64 dest;
> +	__u64 nr_range;

If the maximum number of elements in the range list is 1<<12, there's no
need for this to be larger than a u16, right?

> +	__u64 range_list;

Pointers embedded in a structure are /not/ a good idea, because this
will create a lot of compatibility headaches for 32-bit binaries running
on 64-bit kernels.  Please just make the size of this header structure
a multiple of 8 bytes and put the range_entry list immediately after it.

struct copy_range {
	__s64 dest_offset;
	__u32 nr_range_entries;
	__u32 flags;
	__u64 reserved[2];
};

struct __user range_entry *re = ((struct range_entry *)(copyhead + 1));

copy_from_user(&urk, re...);

--D

> +	__u64 rsvd;
> +};
> +
>  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
>  #define FILE_DEDUPE_RANGE_SAME		0
>  #define FILE_DEDUPE_RANGE_DIFFERS	1
> @@ -197,6 +204,7 @@ struct fsxattr {
>  #define BLKROTATIONAL _IO(0x12,126)
>  #define BLKZEROOUT _IO(0x12,127)
>  #define BLKGETDISKSEQ _IOR(0x12,128,__u64)
> +#define BLKCOPY _IOWR(0x12, 129, struct copy_range)
>  /*
>   * A jump here: 130-136 are reserved for zoned block devices
>   * (see uapi/linux/blkzoned.h)
> -- 
> 2.25.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

