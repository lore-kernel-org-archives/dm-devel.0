Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D452C04FF3
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD36A600EF
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD36A600EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-1SAOm1xGPYiufvY5UXY96Q-1; Mon, 24 May 2021 02:47:47 -0400
X-MC-Unique: 1SAOm1xGPYiufvY5UXY96Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD774501E3;
	Mon, 24 May 2021 06:47:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F1F31002EF0;
	Mon, 24 May 2021 06:47:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 75B885534D;
	Mon, 24 May 2021 06:47:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14LHH0bo023117 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 13:17:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 528551692BE; Fri, 21 May 2021 17:17:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AF3B16C2C6
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:16:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B48B182506A
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:16:57 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
	[209.85.214.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-396-avu8VYVRPVCpVo666IPC8w-1; Fri, 21 May 2021 13:16:50 -0400
X-MC-Unique: avu8VYVRPVCpVo666IPC8w-1
Received: by mail-pl1-f181.google.com with SMTP id s4so9769038plg.12;
	Fri, 21 May 2021 10:16:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=/6CTfoP+3YhIDA2Sa2Vg3MwIl/4IQc5OvLMHtpk2uwk=;
	b=fn3UZ0zwz7vXYqVp2ZAJ5GMxpSun6cWAvx1urg7r+77dkihdy4MD8rV2fBwI25y2J8
	iJcpJG2v8zL/h7CU8hTL0pRZSVeehzje87It2GaxAOf6KHHmPgDfBPZJP7rPExt/8oke
	NoK6y/yhRn7rqBL9jYJ8yhZJpnnXi25dlC/AwlgCfqjPFpa+PVYDZ9Yr3Rmz4T+twApW
	tN4B7ut4vO3jkhR013CohlPKSfsCyxBA1reoaCiokUA7o0Z7pEIT9+OgHKXtRbKo7otj
	B2NP5HYFPbMJnjV8hZevT0NyNi1cYnbU35MbW6TygLYTXI3L5akVWku5gT4+kzgawKgY
	xRig==
X-Gm-Message-State: AOAM533bzC9Cb69d93Caj1sIVQFXgW1BFGxUWdjtTf5Dyr9/Btyuc8Cp
	yE/nkYMyNQwVMu/PZ/KjHgo=
X-Google-Smtp-Source: ABdhPJxtynqdEQ1F/D+2PqiHL9NmQC5jqLXgWhG+E7yzr8uLp59ObRLAPQ67LxwzZAhslkMqhOa4cA==
X-Received: by 2002:a17:90a:590d:: with SMTP id
	k13mr12082927pji.68.1621617409049; 
	Fri, 21 May 2021 10:16:49 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
	by smtp.gmail.com with ESMTPSA id
	q24sm4964064pgb.19.2021.05.21.10.16.47
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 21 May 2021 10:16:47 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
	id 6461E423A3; Fri, 21 May 2021 17:16:46 +0000 (UTC)
Date: Fri, 21 May 2021 17:16:46 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210521171646.GA25017@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 24 May 2021 02:47:09 -0400
Cc: nvdimm@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>,
	Mike Snitzer <snitzer@redhat.com>, linux-m68k@vger.kernel.org,
	linux-nvme@lists.infradead.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Joshua Morris <josh.h.morris@us.ibm.com>,
	linux-s390@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Matias Bjorling <mb@lightnvm.io>, Nitin Gupta <ngupta@vflare.org>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-xtensa@linux-xtensa.org,
	Alex Dubov <oakad@yahoo.com>, Heiko Carstens <hca@linux.ibm.com>,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
	drbd-dev@tron.linbit.com, Philip Kelleher <pjk1939@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>, linux-mmc@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 01/26] block: refactor device number setup in
 __device_add_disk
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 21, 2021 at 07:50:51AM +0200, Christoph Hellwig wrote:
> diff --git a/block/genhd.c b/block/genhd.c
> index 39ca97b0edc6..2c00bc3261d9 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -335,52 +335,22 @@ static int blk_mangle_minor(int minor)

<-- snip -->

> -int blk_alloc_devt(struct block_device *bdev, dev_t *devt)
> +int blk_alloc_ext_minor(void)
>  {
> -	struct gendisk *disk = bdev->bd_disk;
>  	int idx;
>  
> -	/* in consecutive minor range? */
> -	if (bdev->bd_partno < disk->minors) {
> -		*devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
> -		return 0;
> -	}
> -

It is not obviously clear to me, why this was part of add_disk()
path, and ...

> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index dc60ecf46fe6..504297bdc8bf 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -379,9 +380,15 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
>  	pdev->type = &part_type;
>  	pdev->parent = ddev;
>  
> -	err = blk_alloc_devt(bdev, &devt);
> -	if (err)
> -		goto out_put;
> +	/* in consecutive minor range? */
> +	if (bdev->bd_partno < disk->minors) {
> +		devt = MKDEV(disk->major, disk->first_minor + bdev->bd_partno);
> +	} else {
> +		err = blk_alloc_ext_minor();
> +		if (err < 0)
> +			goto out_put;
> +		devt = MKDEV(BLOCK_EXT_MAJOR, err);
> +	}
>  	pdev->devt = devt;
>  
>  	/* delay uevent until 'holders' subdir is created */

... and why we only add this here now.

Other than that, this looks like a super nice cleanup!

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

