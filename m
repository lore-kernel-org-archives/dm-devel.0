Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72DBC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 13:21:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6922260F35
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 13:21:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6922260F35
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kroah.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-1LioQvBWMFiSblPrWcbMLw-1; Tue, 17 Aug 2021 09:21:10 -0400
X-MC-Unique: 1LioQvBWMFiSblPrWcbMLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72673871807;
	Tue, 17 Aug 2021 13:21:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CB136091B;
	Tue, 17 Aug 2021 13:21:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A6D4A181A2A7;
	Tue, 17 Aug 2021 13:21:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HDL2j9026706 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 09:21:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B9063100CBC9; Tue, 17 Aug 2021 13:21:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B474F1009B9A
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 13:20:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99942185A794
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 13:20:59 +0000 (UTC)
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com
	[66.111.4.224]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-383-VAKma_bHMzGPrpOQY6B_QA-1; Tue, 17 Aug 2021 09:20:58 -0400
X-MC-Unique: VAKma_bHMzGPrpOQY6B_QA-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailnew.nyi.internal (Postfix) with ESMTP id 444E1580B2A;
	Tue, 17 Aug 2021 09:10:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
	by compute2.internal (MEProxy); Tue, 17 Aug 2021 09:10:54 -0400
X-ME-Sender: <xms:W7UbYXkXz1mNG4J3L4VevBCW7wBAC2mDvKSHjuLsVcKOeiHHAsPgXw>
	<xme:W7UbYa3QxSV-P89lhoDi9siFRC30TI09CkEYvQPeHPIjNcDAtutDygDVQbKGjEh6J
	3tp13HYufkIWQ>
X-ME-Received: <xmr:W7UbYdqfkSuiS6CCeDvxOgEk9CHGuH81JpR_YuLNR96d90Yifphuqc7F7v71elMWvChmgrX90BeFSfuMVWfHSubuA1MG8807>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleefgdeivdcutefuodetggdotefrodftvf
	curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
	uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
	fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
	jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
	ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
	rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
	gtohhm
X-ME-Proxy: <xmx:W7UbYflXehCXBOklU-0G37vBlXBPdTZuSDHH_nrKNU6iC_GBDCNPcQ>
	<xmx:W7UbYV3v8DIwmaiwnox9y_cHAlXfKggU_odGNHlQ8yM5rD1fUnzFqA>
	<xmx:W7UbYesURvgWKauLhOo5gPvWnVQmJI2vs64LFeQTh4B5i0vmBaJOPA>
	<xmx:XrUbYQ0juNV9Td0BZ3gsdfZytA5Vfox6EvMokvxxPhkCTRtE1TeNhw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
	17 Aug 2021 09:10:50 -0400 (EDT)
Date: Tue, 17 Aug 2021 15:10:48 +0200
From: Greg KH <greg@kroah.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>
Message-ID: <YRu1WFImFulfpk7s@kroah.com>
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
Cc: snitzer@redhat.com, djwong@kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@redhat.com, hch@lst.de, agk@redhat.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, willy@infradead.org,
	nj.shetty@samsung.com, kch@kernel.org, selvajove@gmail.com,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	javier.gonz@samsung.com, kbusch@kernel.org, axboe@kernel.dk,
	damien.lemoal@wdc.com, joshi.k@samsung.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

No error checking for huge values of nr_range?  Is that wise?  You
really want userspace to be able to allocate "all" of the kernel memory
in the system?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

