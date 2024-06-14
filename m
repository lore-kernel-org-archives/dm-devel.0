Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CAD149DEE
	for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 07:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718351809; cv=none; b=BypbCZGJ1uZBKbYuZ9Ci81kZziXMLWeJt6I1GoOCDE4j+mJyBFDco5ahJ4tlDW03NABtoqmMPKGPsPcSxzsRG1OQrRYwpDOikoOtTcQ1cyWabp25K4YN1JratP4DkxVpm0WZURhG2buZioBMbPI49joOOAV9vUirdPqS0tf2QeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718351809; c=relaxed/simple;
	bh=cCTHejGQxMi6RzmM8k0/qqpdwyLsfEJT+eXWS8ocifI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qsi4TGdLvlfEnA9FVItZC0MdOiCJFyeRrtVp5WYEJcmseTetT++MTXY8TN87Fu+BTER18P/JECyQw7flhnpo/mfGcjEJ0MG+IyrsWb3lhFQI6zJka4zu5/YP1jBf/u0sTy3V/SRojOOATKpUDYaEOUANEQ/NTEH3WczjXSEQXcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=EL6jFQ9e; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="EL6jFQ9e"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4405cf0cb1eso10021811cf.1
        for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 00:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1718351805; x=1718956605; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BedO1x12znmji4xt7UpC8XDe1FvgdzsEI86mvlWGudA=;
        b=EL6jFQ9ePyB2aZ69eqETBjdawWjSZ+fAVMJnvFTsLTIBe8q32bQ2YsIW20TwD6oeZY
         XLc6DhGsUwN+BgJaWuK1OyJbqHeZZQV2XS8vTDyaNhxsQDgw0DdYf4PekkkLkD1YnzWV
         upl2kX7rM+hjF42/IWf56Tv6tJbObgJ3lE1t4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718351805; x=1718956605;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BedO1x12znmji4xt7UpC8XDe1FvgdzsEI86mvlWGudA=;
        b=nHM40YGBHxWDh/YkMQlu9UuXJ5Q2WkUoazFadZHZhLd8mzObIgDztKgxEzQ4rjs5xi
         uIeREkigsRb8ptyTJ8Qmukzd1mCK+fNzZu1pUBqq7RIvjSfSSdM2ijp6GY/WI8jPvck4
         lvOq7H4M9lRqMdx00elXnO+G7ZoaGPMqhQaVmHP+qiRdrwz4+/k06QZ+11pYx64X9NF6
         VT8obSQ7r7RcSnJD/ycTqGJlymAP9W6sM38s4T07ITYObGQncr77+xf/EIjejxej5jsB
         wUnqyqxS//ZWxjOLp/csk3R+KqqKRBkkUevz8hAGnm4Adt4qMCOOvoHPZf0h23SNY3tk
         TaGw==
X-Forwarded-Encrypted: i=1; AJvYcCW3fgZuUnMMjD2xj7wF2sHsCo9oPeN9jH3OrSuWU8UXXhMS/Le+EPIC9X/N6LteAhIdAo0thQRDN8c1YVkbkCAlDl8pq1790ZI=
X-Gm-Message-State: AOJu0Yw+iCIogQ0NHNJs7FjBrJXLzxupeLEhNUADpY0k6SVKcTwPvGp/
	Q5fL0KKIkiPiTBxsD8O+JP0LopU8C0+dQAanUutPW60Id12oAPpITj7cN/Ce3xE=
X-Google-Smtp-Source: AGHT+IEDi8BhVjLu2vbVbmBxB83hP6gyIibQXt+H84ODwaVrhmTedMPZYFZeMGGsfo/+7hGiDnXdRg==
X-Received: by 2002:a05:622a:1822:b0:43e:2639:a987 with SMTP id d75a77b69052e-44216b3a874mr27744421cf.59.1718351804940;
        Fri, 14 Jun 2024 00:56:44 -0700 (PDT)
Received: from localhost ([213.195.124.163])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-441f2ff9ef8sm13823221cf.89.2024.06.14.00.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 00:56:44 -0700 (PDT)
Date: Fri, 14 Jun 2024 09:56:42 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 10/26] xen-blkfront: don't disable cache flushes when
 they fail
Message-ID: <Zmv3usMvGGK7ZbMT@macbook>
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-11-hch@lst.de>
 <ZmlVziizbaboaBSn@macbook>
 <20240612150030.GA29188@lst.de>
 <ZmnFH17bTV2Ot_iR@macbook>
 <20240613140508.GA16529@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240613140508.GA16529@lst.de>

On Thu, Jun 13, 2024 at 04:05:08PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 12, 2024 at 05:56:15PM +0200, Roger Pau Monné wrote:
> > Right.  AFAICT advertising "feature-barrier" and/or
> > "feature-flush-cache" could be done based on whether blkback
> > understand those commands, not on whether the underlying storage
> > supports the equivalent of them.
> > 
> > Worst case we can print a warning message once about the underlying
> > storage failing to complete flush/barrier requests, and that data
> > integrity might not be guaranteed going forward, and not propagate the
> > error to the upper layer?
> > 
> > What would be the consequence of propagating a flush error to the
> > upper layers?
> 
> If you propage the error to the upper layer you will generate an
> I/O error there, which usually leads to a file system shutdown.
> 
> > Given the description of the feature in the blkif header, I'm afraid
> > we cannot guarantee that seeing the feature exposed implies barrier or
> > flush support, since the request could fail at any time (or even from
> > the start of the disk attachment) and it would still sadly be a correct
> > implementation given the description of the options.
> 
> Well, then we could do something like the patch below, which keeps
> the existing behavior, but insolates the block layer from it and
> removes the only user of blk_queue_write_cache from interrupt
> context:

LGTM, I'm not sure there's much else we can do.

> ---
> From e6e82c769ab209a77302994c3829cf6ff7a595b8 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 30 May 2024 08:58:52 +0200
> Subject: xen-blkfront: don't disable cache flushes when they fail
> 
> blkfront always had a robust negotiation protocol for detecting a write
> cache.  Stop simply disabling cache flushes in the block layer as the
> flags handling is moving to the atomic queue limits API that needs
> user context to freeze the queue for that.  Instead handle the case
> of the feature flags cleared inside of blkfront.  This removes old
> debug code to check for such a mismatch which was previously impossible
> to hit, including the check for passthrough requests that blkfront
> never used to start with.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/xen-blkfront.c | 44 +++++++++++++++++++-----------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9b4ec3e4908cce..e2c92d5095ff17 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -788,6 +788,14 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
>  			 * A barrier request a superset of FUA, so we can
>  			 * implement it the same way.  (It's also a FLUSH+FUA,
>  			 * since it is guaranteed ordered WRT previous writes.)
> +			 *
> +			 * Note that can end up here with a FUA write and the
> +			 * flags cleared.  This happens when the flag was
> +			 * run-time disabled and raced with I/O submission in
> +			 * the block layer.  We submit it as a normal write

Since blkfront no longer signals that FUA is no longer available for the
device, getting a request with FUA is not actually a race I think?

> +			 * here.  A pure flush should never end up here with
> +			 * the flags cleared as they are completed earlier for
> +			 * the !feature_flush case.
>  			 */
>  			if (info->feature_flush && info->feature_fua)
>  				ring_req->operation =
> @@ -795,8 +803,6 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
>  			else if (info->feature_flush)
>  				ring_req->operation =
>  					BLKIF_OP_FLUSH_DISKCACHE;
> -			else
> -				ring_req->operation = 0;
>  		}
>  		ring_req->u.rw.nr_segments = num_grant;
>  		if (unlikely(require_extra_req)) {
> @@ -887,16 +893,6 @@ static inline void flush_requests(struct blkfront_ring_info *rinfo)
>  		notify_remote_via_irq(rinfo->irq);
>  }
>  
> -static inline bool blkif_request_flush_invalid(struct request *req,
> -					       struct blkfront_info *info)
> -{
> -	return (blk_rq_is_passthrough(req) ||
> -		((req_op(req) == REQ_OP_FLUSH) &&
> -		 !info->feature_flush) ||
> -		((req->cmd_flags & REQ_FUA) &&
> -		 !info->feature_fua));
> -}
> -
>  static blk_status_t blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
>  			  const struct blk_mq_queue_data *qd)
>  {
> @@ -908,23 +904,30 @@ static blk_status_t blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	rinfo = get_rinfo(info, qid);
>  	blk_mq_start_request(qd->rq);
>  	spin_lock_irqsave(&rinfo->ring_lock, flags);
> -	if (RING_FULL(&rinfo->ring))
> -		goto out_busy;
>  
> -	if (blkif_request_flush_invalid(qd->rq, rinfo->dev_info))
> -		goto out_err;
> +	/*
> +	 * Check if the backend actually supports flushes.
> +	 *
> +	 * While the block layer won't send us flushes if we don't claim to
> +	 * support them, the Xen protocol allows the backend to revoke support
> +	 * at any time.  That is of course a really bad idea and dangerous, but
> +	 * has been allowed for 10+ years.  In that case we simply clear the
> +	 * flags, and directly return here for an empty flush and ignore the
> +	 * FUA flag later on.
> +	 */
> +	if (unlikely(req_op(qd->rq) == REQ_OP_FLUSH && !info->feature_flush))
> +		goto out;

Don't you need to complete the request here?

Thanks, Roger.
