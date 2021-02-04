Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B416AC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:06:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21D7564F58
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21D7564F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-HplhmP61NhaD1q6oiFsJsA-1; Thu, 04 Feb 2021 05:06:50 -0500
X-MC-Unique: HplhmP61NhaD1q6oiFsJsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C15B5804038;
	Thu,  4 Feb 2021 10:06:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6339F722EB;
	Thu,  4 Feb 2021 10:06:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 030A618095CB;
	Thu,  4 Feb 2021 10:06:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114A6gCi028109 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 05:06:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DF66210F1CBA; Thu,  4 Feb 2021 10:06:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBC1B10F1CB2
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 10:06:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D6F2801182
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 10:06:39 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-509-_cyxwVW1PgKsnt5Ui78tZQ-1;
	Thu, 04 Feb 2021 05:06:37 -0500
X-MC-Unique: _cyxwVW1PgKsnt5Ui78tZQ-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id EDA60874F7;
	Thu,  4 Feb 2021 13:06:34 +0300 (MSK)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Thu, 4 Feb 2021 11:06:33 +0100
Date: Thu, 4 Feb 2021 13:06:31 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20210204100631.GB4325@veeam.com>
References: <1612367638-3794-1-git-send-email-sergei.shtepa@veeam.com>
	<1612367638-3794-3-git-send-email-sergei.shtepa@veeam.com>
	<20210203161836.GB21359@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210203161836.GB21359@redhat.com>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265667362
X-Veeam-MMEX: True
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
Cc: axboe@kernel.dk, Damien.LeMoal@wdc.com, jack@suse.cz, corbet@lwn.net,
	johannes.thumshirn@wdc.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, ming.lei@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	gregkh@linuxfoundation.org, steve@sk2.org, koct9i@gmail.com,
	agk@redhat.com, pavgel.tide@veeam.com
Subject: Re: [dm-devel] [PATCH v4 2/6] block: add blk_interposer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 02/03/2021 11:18, Mike Snitzer wrote:
> On Wed, Feb 03 2021 at 10:53am -0500,
> Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> 
> > blk_interposer allows to intercept bio requests, remap bio to another devices or add new bios.
> > 
> > Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> > ---
> >  block/bio.c               |  2 +
> >  block/blk-core.c          | 33 ++++++++++++++++
> >  block/genhd.c             | 82 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/blk_types.h |  6 ++-
> >  include/linux/genhd.h     | 18 +++++++++
> >  5 files changed, 139 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/bio.c b/block/bio.c
> > index 1f2cc1fbe283..f6f135eb84b5 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -684,6 +684,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
> >  	bio_set_flag(bio, BIO_CLONED);
> >  	if (bio_flagged(bio_src, BIO_THROTTLED))
> >  		bio_set_flag(bio, BIO_THROTTLED);
> > +	if (bio_flagged(bio_src, BIO_INTERPOSED))
> > +		bio_set_flag(bio, BIO_INTERPOSED);
> >  	bio->bi_opf = bio_src->bi_opf;
> >  	bio->bi_ioprio = bio_src->bi_ioprio;
> >  	bio->bi_write_hint = bio_src->bi_write_hint;
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 7663a9b94b80..c84bc42ba88b 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1032,6 +1032,32 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
> >  	return ret;
> >  }
> >  
> > +static blk_qc_t __submit_bio_interposed(struct bio *bio)
> > +{
> > +	struct bio_list bio_list[2] = { };
> > +	blk_qc_t ret = BLK_QC_T_NONE;
> > +
> > +	current->bio_list = bio_list;
> > +	if (likely(bio_queue_enter(bio) == 0)) {
> > +		struct gendisk *disk = bio->bi_disk;
> > +
> > +		if (likely(blk_has_interposer(disk))) {
> > +			bio_set_flag(bio, BIO_INTERPOSED);
> > +			disk->interposer->ip_submit_bio(bio);
> > +		} else /* interposer was removed */
> > +			bio_list_add(&current->bio_list[0], bio);
> 
> style nit:
> 
> } else {
> 	/* interposer was removed */
> 	bio_list_add(&current->bio_list[0], bio);
> }
> 
> > +
> > +		blk_queue_exit(disk->queue);
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
> > @@ -1057,6 +1083,13 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
> >  		return BLK_QC_T_NONE;
> >  	}
> >  
> > +	/*
> > +	 * Checking the BIO_INTERPOSED flag is necessary so that the bio
> > +	 * created by the blk_interposer do not get to it for processing.
> > +	 */
> > +	if (blk_has_interposer(bio->bi_disk) &&
> > +	    !bio_flagged(bio, BIO_INTERPOSED))
> > +		return __submit_bio_interposed(bio);
> >  	if (!bio->bi_disk->fops->submit_bio)
> >  		return __submit_bio_noacct_mq(bio);
> >  	return __submit_bio_noacct(bio);
> > diff --git a/block/genhd.c b/block/genhd.c
> > index 419548e92d82..39785a3ef703 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -30,6 +30,7 @@
> >  static struct kobject *block_depr;
> >  
> >  DECLARE_RWSEM(bdev_lookup_sem);
> > +DEFINE_MUTEX(bdev_interposer_mutex);
> 
> Seems you're using this mutex to protect access to disk->interposer in
> attach/detach.  This is to prevent attach/detach races to same device?

Yes. There is a probability of 0.00...01% that two different modules will
try to attach/detach to the same disk at the same time.
Since the attach/detach operation is infrequent, using mutex is quite appropriate.
> 
> Thankfully attach/detach isn't in the bio submission fast path but it'd
> be helpful to document what this mutex is protecting).

I'll think about the name of this mutex and add a comment.

> 
> A storm of attach or detach will all hit this global mutex though...
> 
> Mike
> 

Thank you for the review.
I am very interested in your opinion about [PATCH v4 4/6] and [PATCH v4 5/6].
However, the kernel test robot has already found something there on sparc.

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

