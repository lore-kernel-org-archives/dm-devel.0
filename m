Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83D2C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 04:54:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 444AE64F82
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 04:54:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 444AE64F82
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-i-7sSS2DNvGVGLgMHqZU1g-1; Tue, 09 Mar 2021 23:53:59 -0500
X-MC-Unique: i-7sSS2DNvGVGLgMHqZU1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4C05184214B;
	Wed, 10 Mar 2021 04:53:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C6FB5C233;
	Wed, 10 Mar 2021 04:53:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 05B371809C86;
	Wed, 10 Mar 2021 04:53:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12A4rW0f007948 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Mar 2021 23:53:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 55F012156A2E; Wed, 10 Mar 2021 04:53:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 510762156A21
	for <dm-devel@redhat.com>; Wed, 10 Mar 2021 04:53:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53DC2185A7BC
	for <dm-devel@redhat.com>; Wed, 10 Mar 2021 04:53:29 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-593-LmxFWqD7ObqYhq8XMS5-vg-1;
	Tue, 09 Mar 2021 23:53:25 -0500
X-MC-Unique: LmxFWqD7ObqYhq8XMS5-vg-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 258C58A78F;
	Wed, 10 Mar 2021 07:53:23 +0300 (MSK)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Wed, 10 Mar 2021 05:53:20 +0100
Date: Wed, 10 Mar 2021 07:53:13 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20210310045313.GA26929@veeam.com>
References: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
	<1614774618-22410-3-git-send-email-sergei.shtepa@veeam.com>
	<20210309172717.GB201344@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210309172717.GB201344@infradead.org>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B58627664
X-Veeam-MMEX: True
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>
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

Thank you, Christoph, for the review.
I will correct all except two points.

The 03/09/2021 20:27, Christoph Hellwig wrote:
> > +static blk_qc_t __submit_bio_interposed(struct bio *bio)
> > +{
> > +	struct bio_list bio_list[2] = { };
> > +	blk_qc_t ret = BLK_QC_T_NONE;
> > +
> > +	current->bio_list = bio_list;
> > +	if (likely(bio_queue_enter(bio) == 0)) {
> > +		struct block_device *bdev = bio->bi_bdev;
> > +
> > +		if (likely(bdev_has_interposer(bdev))) {
> > +			bio_set_flag(bio, BIO_INTERPOSED);
> > +			bdev->bd_interposer->ip_submit_bio(bio);
> > +		} else {
> > +			/* interposer was removed */
> > +			bio_list_add(&current->bio_list[0], bio);
> > +		}
> > +
> > +		blk_queue_exit(bdev->bd_disk->queue);
> > +	}
> > +	current->bio_list = NULL;
> > +
> > +	/* Resubmit remaining bios */
> > +	while ((bio = bio_list_pop(&bio_list[0])))
> > +		ret = submit_bio_noacct(bio);
> > +
> > +	return ret;
> > +}
> > +
> >  /**
> >   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
> >   * @bio:  The bio describing the location in memory and on the device.
> > @@ -1043,6 +1071,14 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
> >  		return BLK_QC_T_NONE;
> >  	}
> >  
> > +	/*
> > +	 * Checking the BIO_INTERPOSED flag is necessary so that the bio
> > +	 * created by the bdev_interposer do not get to it for processing.
> > +	 */
> > +	if (bdev_has_interposer(bio->bi_bdev) &&
> > +	    !bio_flagged(bio, BIO_INTERPOSED))
> > +		return __submit_bio_interposed(bio);
> > +
> >  	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
> >  		return __submit_bio_noacct_mq(bio);
> >  	return __submit_bio_noacct(bio);
> > diff --git a/block/genhd.c b/block/genhd.c
> > index fcc530164b5a..1ae8516643c8 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -30,6 +30,11 @@
> >  static struct kobject *block_depr;
> >  
> >  DECLARE_RWSEM(bdev_lookup_sem);
> > +/*
> > + * Prevents different block-layer interposers from attaching or detaching
> > + * to the block device at the same time.
> > + */
> > +DEFINE_MUTEX(bdev_interposer_attach_lock);
> 
> This one can and should be marked static.
> 
> > +int bdev_interposer_attach(struct block_device *bdev, struct bdev_interposer *interposer,
> 
> Please avoid the overly long line.
> 
> > +	int ret = 0;
> > +
> > +	if (WARN_ON(!interposer))
> 
> WARN_ON_ONCE?

This function should be called quite rarely, and the absence of the interposer
parameter indicates that the function is being used incorrectly.
I would like to see this warning every time.

> 
> > +		return -EINVAL;
> > +
> > +	if (!blk_mq_is_queue_frozen(bdev->bd_disk->queue))
> > +		return -EPERM;
> 
> This probly should be a WARN_ON_ONCE() as well.

I think it's better to apply WARN_ON here.

> 
> > +
> > +	mutex_lock(&bdev_interposer_attach_lock);
> > +	if (bdev_has_interposer(bdev)) {
> > +		if (bdev->bd_interposer->ip_submit_bio == ip_submit_bio)
> > +			ret = -EALREADY;
> > +		else
> > +			ret = -EBUSY;
> > +		goto out;
> > +	}
> 
> Do we really need the two different error codes here?

I think I need it. If we try to initialize the interposer again, the reason
for this error is most likely in the logic of the module itself.
If the interposer is occupied by someone else, then we need to let know
about it.

> 
> > +
> > +	interposer->ip_submit_bio = ip_submit_bio;
> 
> I'd rather let the caller initialize the field instead of passing the
> submit function separately.

Yes, I think so. This will allow to keep only one parameter of the function.

> 
> > +void bdev_interposer_detach(struct bdev_interposer *interposer,
> > +			  const ip_submit_bio_t ip_submit_bio)
> > +{
> 
> > +	/* Check if it is really our interposer. */
> > +	if (WARN_ON(bdev->bd_interposer->ip_submit_bio != ip_submit_bio))
> > +		goto out;
> 
> I don't really see any need to pass ip_submit_bio just for this check.
> 
> > +	struct bdev_interposer * bd_interposer;
> 
> The * goes just before the member name.
> 
> > +/*
> > + * block layer interposers structure and functions
> > + */
> > +typedef void (*ip_submit_bio_t) (struct bio *bio);
> > +
> > +struct bdev_interposer {
> > +	ip_submit_bio_t ip_submit_bio;
> > +	struct block_device *bdev;
> 
> Do we need the ip_ prefix here?  Also we probably don't really the
> the typedef for the function pointer.

Ok. Maybe submit_bio_hook would be better? or submit_bio_interposer.

> 
> > +#define bdev_has_interposer(bd) ((bd)->bd_interposer != NULL)
> 
> And inline function would be nice here.

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

