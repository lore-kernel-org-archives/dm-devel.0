Return-Path: <SRS0=VWZ+=IN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129DAC433E0
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 13:06:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C5F864EB6
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 13:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C5F864EB6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-Q57MjNo1Nb6mI31NOjppSQ-1; Mon, 15 Mar 2021 09:06:34 -0400
X-MC-Unique: Q57MjNo1Nb6mI31NOjppSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B0AC107ACCA;
	Mon, 15 Mar 2021 13:06:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E5C01757E;
	Mon, 15 Mar 2021 13:06:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5EED618155DE;
	Mon, 15 Mar 2021 13:06:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12FD6QDk003239 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Mar 2021 09:06:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C7BBE2166B2F; Mon, 15 Mar 2021 13:06:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C23712166BA2
	for <dm-devel@redhat.com>; Mon, 15 Mar 2021 13:06:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7139485A5B5
	for <dm-devel@redhat.com>; Mon, 15 Mar 2021 13:06:24 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-309-xB8uhqacNDOaj2qc3_vq1w-1;
	Mon, 15 Mar 2021 09:06:21 -0400
X-MC-Unique: xB8uhqacNDOaj2qc3_vq1w-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id D9844418B2;
	Mon, 15 Mar 2021 09:06:17 -0400 (EDT)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Mon, 15 Mar 2021 14:06:15 +0100
Date: Mon, 15 Mar 2021 16:06:13 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20210315130613.GC30489@veeam.com>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
	<1615563895-28565-3-git-send-email-sergei.shtepa@veeam.com>
	<20210314092823.GB3773360@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210314092823.GB3773360@infradead.org>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B58627C62
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v7 2/3] block: add bdev_interposer
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

The 03/14/2021 12:28, Christoph Hellwig wrote:
> On Fri, Mar 12, 2021 at 06:44:54PM +0300, Sergei Shtepa wrote:
> > bdev_interposer allows to redirect bio requests to another devices.
> 
> I think this warrants a somewhat more detailed description.
> 
> The code itself looks pretty good to me now, a bunch of nitpicks and
> a question below:
> 
> > +static noinline blk_qc_t submit_bio_interposed(struct bio *bio)
> > +{
> > +	blk_qc_t ret = BLK_QC_T_NONE;
> > +	struct bio_list bio_list[2] = { };
> > +	struct gendisk *orig_disk;
> > +
> > +	if (current->bio_list) {
> > +		bio_list_add(&current->bio_list[0], bio);
> > +		return BLK_QC_T_NONE;
> > +	}
> 
> I don't think this case can ever happen:
> 
>  - current->bio_list != NULL means a ->submit_bio or blk_mq_submit_bio
>    is active.  But if this device is being interposed this means the
>    interposer recurses into itself, which should never happen.  So
>    I think we'll want a WARN_ON_ONCE here as a debug check instead.

Yes, it is.
Completely remove this check or add "BUG_ON(current->bio_list);" for
an emergency?

> 
> > +
> > +	orig_disk = bio->bi_bdev->bd_disk;
> > +	if (unlikely(bio_queue_enter(bio)))
> > +		return BLK_QC_T_NONE;
> > +
> > +	current->bio_list = bio_list;
> > +
> > +	do {
> > +		struct block_device *interposer = bio->bi_bdev->bd_interposer;
> > +
> > +		if (unlikely(!interposer)) {
> > +			/* interposer was removed */
> > +			bio_list_add(&current->bio_list[0], bio);
> > +			break;
> > +		}
> > +		/* assign bio to interposer device */
> > +		bio_set_dev(bio, interposer);
> > +		bio_set_flag(bio, BIO_INTERPOSED);
> 
> Reassigning the bi_bdev here means the original source is lost by the
> time we reach the interposer.  This initially seemed a little limiting,
> but I guess the interposer driver can just record that information
> locally, so we should be fine.  The big upside of this is that no
> extra argument to submit_bio_checks, which means less changes to the
> normal fast path, so if this works for everyone that is a nice
> improvement over my draft.
> 
> > +
> > +		if (!submit_bio_checks(bio))
> > +			break;
> > +		/*
> > +		 * Because the current->bio_list is initialized,
> > +		 * the submit_bio callback will always return BLK_QC_T_NONE.
> > +		 */
> > +		interposer->bd_disk->fops->submit_bio(bio);
> > +	} while (false);
> 
> I find the do { ... } while (false) idiom here a little strange.  Normal
> kernel style would be a goto done instead of the breaks.
> 

Ok. I'll use the normal kernel style.

> > +int bdev_interposer_attach(struct block_device *original,
> > +			   struct block_device *interposer)
> 
> A kerneldoc comment for bdev_interposer_attach (and
> bdev_interposer_detach) would be nice to explain the API a little more.
> 

Yes, I should add kerneldoc comments.

> > +{
> > +	int ret = 0;
> > +
> > +	if (WARN_ON(((!original) || (!interposer))))
> > +		return -EINVAL;
> 
> No need for the inner two levels of braces.

Ok.

> 
> > +	 * interposer should be simple, no a multi-queue device
> > +	 */
> > +	if (!interposer->bd_disk->fops->submit_bio)
> 
> Please use queue_is_mq() instead.

Ok.

> 
> > +	if (bdev_has_interposer(original))
> > +		ret = -EBUSY;
> > +	else {
> > +		original->bd_interposer = bdgrab(interposer);
> 
> Just thinking out a loud:  what happens if the interposed device
> goes away?  Shouldn't we at very least also make sure this
> gabs another refererence on bdev as well?

If the original device is removed from the system, the interposer device
will be permanently occupied. I need to add an interposer release when
deleting a block device.

> 
> > +struct bdev_interposer;
> 
> Not needed any more.

Yes.

> 
> > +static inline bool bdev_has_interposer(struct block_device *bdev)
> > +{
> > +	return (bdev->bd_interposer != NULL);
> > +};
> 
> No need for the braces.

Ok.

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

