Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD11C47080
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1B23E6109E
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B23E6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-bXJ9H0VtMbOc13bly21Z6w-1; Mon, 24 May 2021 02:47:42 -0400
X-MC-Unique: bXJ9H0VtMbOc13bly21Z6w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 204D2180FD69;
	Mon, 24 May 2021 06:47:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0295B5D9F2;
	Mon, 24 May 2021 06:47:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C833D55356;
	Mon, 24 May 2021 06:47:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14LHiILj025800 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 13:44:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 02B581692BA; Fri, 21 May 2021 17:44:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F150B1692C7
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:44:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBA10101D232
	for <dm-devel@redhat.com>; Fri, 21 May 2021 17:44:14 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
	[209.85.215.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-148-Q_XhjA9YMse5aa8eelpcyw-1; Fri, 21 May 2021 13:44:10 -0400
X-MC-Unique: Q_XhjA9YMse5aa8eelpcyw-1
Received: by mail-pg1-f173.google.com with SMTP id l70so14812993pga.1;
	Fri, 21 May 2021 10:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=lcP+zO2F1IGQjzr8jBvO9rG6CcCMMr/Whp/T20TGCRM=;
	b=bkUZx2KTcJ4wqOf0AYFSLpW7UKPjgViT6yqZ1tkIDV9jcSVseve3AkFV2aMpkhVhPQ
	/d1/0gvftUGXdFyEgnaUCthRKqvWfEky9pezZEufx7GpRKvy+SYPmM95jAf5/VDBphlx
	8UJdOY5M6Gwh+NRYWSGWITnxn2g2m0JBMsPPBVW9XLbDTJdSggGmSAhNPAGScWaj58hE
	HU3pzzpnQ3cmCAZaiZu7U6lLYtM3rdGSEblNW7putGGmb6gblkpsne24KLEpaZwVR+Aw
	ahqra8mpEIFVJTQCJLdWuz/h1+hu3OZpC635humenGtDrL88vzc0bMdIAFhFc2J7X0RR
	h5jw==
X-Gm-Message-State: AOAM532uVfbkKq5wFfgn+dA/XF19hUcnrwuwHCrXA3lQ0rRAsyRMpwyU
	eF9B3kiyeE3BgvP5pFw1Qjg=
X-Google-Smtp-Source: ABdhPJx2cr14kVfs56RCS6Lg1N9a0F2CxWXa6sTYNwZ2wWHW3RuCIJw00Zxq6x/ufjwVbJsYm0Ya2A==
X-Received: by 2002:a05:6a00:15d4:b029:2de:a538:c857 with SMTP id
	o20-20020a056a0015d4b02902dea538c857mr11480779pfu.51.1621619049288;
	Fri, 21 May 2021 10:44:09 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
	by smtp.gmail.com with ESMTPSA id o3sm4974976pgh.22.2021.05.21.10.44.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 21 May 2021 10:44:08 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
	id 766BF423A3; Fri, 21 May 2021 17:44:07 +0000 (UTC)
Date: Fri, 21 May 2021 17:44:07 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210521174407.GA25291@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-6-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 05/26] block: add blk_alloc_disk and
 blk_cleanup_disk APIs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 21, 2021 at 07:50:55AM +0200, Christoph Hellwig wrote:
> Add two new APIs to allocate and free a gendisk including the
> request_queue for use with BIO based drivers.  This is to avoid
> boilerplate code in drivers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/genhd.c         | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/genhd.h | 22 ++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index e4974af3d729..6d4ce962866d 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1302,6 +1302,25 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
>  }
>  EXPORT_SYMBOL(__alloc_disk_node);
>  
> +struct gendisk *__blk_alloc_disk(int node)
> +{
> +	struct request_queue *q;
> +	struct gendisk *disk;
> +
> +	q = blk_alloc_queue(node);
> +	if (!q)
> +		return NULL;
> +
> +	disk = __alloc_disk_node(0, node);
> +	if (!disk) {
> +		blk_cleanup_queue(q);
> +		return NULL;
> +	}
> +	disk->queue = q;
> +	return disk;
> +}
> +EXPORT_SYMBOL(__blk_alloc_disk);

Its not obvious to me why using this new API requires you then to
set minors explicitly to 1, and yet here underneath we see the minors
argument passed is 0.

Nor is it clear from the documentation.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

