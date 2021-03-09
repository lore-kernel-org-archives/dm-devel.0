Return-Path: <SRS0=+b8E=IH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8742C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 17:28:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E2826524C
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 17:28:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E2826524C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-0sutki8ZNjuML6F9R38KJA-1; Tue, 09 Mar 2021 12:28:10 -0500
X-MC-Unique: 0sutki8ZNjuML6F9R38KJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11F648018AF;
	Tue,  9 Mar 2021 17:28:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C34035F724;
	Tue,  9 Mar 2021 17:28:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6739657DC2;
	Tue,  9 Mar 2021 17:28:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 129HS2vB008110 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Mar 2021 12:28:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 506582156A21; Tue,  9 Mar 2021 17:28:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA75E2156A3B
	for <dm-devel@redhat.com>; Tue,  9 Mar 2021 17:27:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53CB08032E6
	for <dm-devel@redhat.com>; Tue,  9 Mar 2021 17:27:56 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-344-vxy3ACZPMcKwfhX_OiW65w-1; Tue, 09 Mar 2021 12:27:54 -0500
X-MC-Unique: vxy3ACZPMcKwfhX_OiW65w-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lJg8b-000r8r-Jh; Tue, 09 Mar 2021 17:27:23 +0000
Date: Tue, 9 Mar 2021 17:27:17 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <20210309172717.GB201344@infradead.org>
References: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
	<1614774618-22410-3-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
In-Reply-To: <1614774618-22410-3-git-send-email-sergei.shtepa@veeam.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, snitzer@redhat.com,
	linux-api@vger.kernel.org, pavel.tide@veeam.com,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 2/4] block: add blk_interposer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +static blk_qc_t __submit_bio_interposed(struct bio *bio)
> +{
> +	struct bio_list bio_list[2] = { };
> +	blk_qc_t ret = BLK_QC_T_NONE;
> +
> +	current->bio_list = bio_list;
> +	if (likely(bio_queue_enter(bio) == 0)) {
> +		struct block_device *bdev = bio->bi_bdev;
> +
> +		if (likely(bdev_has_interposer(bdev))) {
> +			bio_set_flag(bio, BIO_INTERPOSED);
> +			bdev->bd_interposer->ip_submit_bio(bio);
> +		} else {
> +			/* interposer was removed */
> +			bio_list_add(&current->bio_list[0], bio);
> +		}
> +
> +		blk_queue_exit(bdev->bd_disk->queue);
> +	}
> +	current->bio_list = NULL;
> +
> +	/* Resubmit remaining bios */
> +	while ((bio = bio_list_pop(&bio_list[0])))
> +		ret = submit_bio_noacct(bio);
> +
> +	return ret;
> +}
> +
>  /**
>   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
>   * @bio:  The bio describing the location in memory and on the device.
> @@ -1043,6 +1071,14 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
>  		return BLK_QC_T_NONE;
>  	}
>  
> +	/*
> +	 * Checking the BIO_INTERPOSED flag is necessary so that the bio
> +	 * created by the bdev_interposer do not get to it for processing.
> +	 */
> +	if (bdev_has_interposer(bio->bi_bdev) &&
> +	    !bio_flagged(bio, BIO_INTERPOSED))
> +		return __submit_bio_interposed(bio);
> +
>  	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
>  		return __submit_bio_noacct_mq(bio);
>  	return __submit_bio_noacct(bio);
> diff --git a/block/genhd.c b/block/genhd.c
> index fcc530164b5a..1ae8516643c8 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -30,6 +30,11 @@
>  static struct kobject *block_depr;
>  
>  DECLARE_RWSEM(bdev_lookup_sem);
> +/*
> + * Prevents different block-layer interposers from attaching or detaching
> + * to the block device at the same time.
> + */
> +DEFINE_MUTEX(bdev_interposer_attach_lock);

This one can and should be marked static.

> +int bdev_interposer_attach(struct block_device *bdev, struct bdev_interposer *interposer,

Please avoid the overly long line.

> +	int ret = 0;
> +
> +	if (WARN_ON(!interposer))

WARN_ON_ONCE?

> +		return -EINVAL;
> +
> +	if (!blk_mq_is_queue_frozen(bdev->bd_disk->queue))
> +		return -EPERM;

This probly should be a WARN_ON_ONCE() as well.

> +
> +	mutex_lock(&bdev_interposer_attach_lock);
> +	if (bdev_has_interposer(bdev)) {
> +		if (bdev->bd_interposer->ip_submit_bio == ip_submit_bio)
> +			ret = -EALREADY;
> +		else
> +			ret = -EBUSY;
> +		goto out;
> +	}

Do we really need the two different error codes here?

> +
> +	interposer->ip_submit_bio = ip_submit_bio;

I'd rather let the caller initialize the field instead of passing the
submit function separately.

> +void bdev_interposer_detach(struct bdev_interposer *interposer,
> +			  const ip_submit_bio_t ip_submit_bio)
> +{

> +	/* Check if it is really our interposer. */
> +	if (WARN_ON(bdev->bd_interposer->ip_submit_bio != ip_submit_bio))
> +		goto out;

I don't really see any need to pass ip_submit_bio just for this check.

> +	struct bdev_interposer * bd_interposer;

The * goes just before the member name.

> +/*
> + * block layer interposers structure and functions
> + */
> +typedef void (*ip_submit_bio_t) (struct bio *bio);
> +
> +struct bdev_interposer {
> +	ip_submit_bio_t ip_submit_bio;
> +	struct block_device *bdev;

Do we need the ip_ prefix here?  Also we probably don't really the
the typedef for the function pointer.

> +#define bdev_has_interposer(bd) ((bd)->bd_interposer != NULL)

And inline function would be nice here.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

