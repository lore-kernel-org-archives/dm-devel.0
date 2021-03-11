Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9516EC433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 10:55:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA19B64FC3
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 10:55:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA19B64FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-SGJnV-nWMbSXPdJXQb13KQ-1; Thu, 11 Mar 2021 05:55:11 -0500
X-MC-Unique: SGJnV-nWMbSXPdJXQb13KQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10179100D675;
	Thu, 11 Mar 2021 10:55:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 060606A046;
	Thu, 11 Mar 2021 10:55:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 00E7757DC3;
	Thu, 11 Mar 2021 10:55:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BAt0in020457 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 05:55:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC8032166B44; Thu, 11 Mar 2021 10:54:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7AD02166BA3
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 10:54:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6691810BD1
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 10:54:57 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-172-g5TLrtABOPGani_8ucK04A-1;
	Thu, 11 Mar 2021 05:54:53 -0500
X-MC-Unique: g5TLrtABOPGani_8ucK04A-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id B2743114A68;
	Thu, 11 Mar 2021 13:54:51 +0300 (MSK)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Thu, 11 Mar 2021 11:54:50 +0100
Date: Thu, 11 Mar 2021 13:54:42 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, <snitzer@redhat.com>
Message-ID: <20210311105442.GA27754@veeam.com>
References: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
	<1614774618-22410-5-git-send-email-sergei.shtepa@veeam.com>
	<20210309173555.GC201344@infradead.org>
	<20210310052812.GB26929@veeam.com>
	<20210310123456.GA758100@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210310123456.GA758100@infradead.org>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B58627062
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
Subject: Re: [dm-devel] [PATCH v6 4/4] dm: add DM_INTERPOSED_FLAG
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

The 03/10/2021 15:34, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 08:28:12AM +0300, Sergei Shtepa wrote:
> > > So instead of doing this shoudn't the interposer just always submit to the
> > > whole device?  But if we keep it, the logic in this funtion should go
> > > into a block layer helper, passing a block device instead of the
> 
> > 
> > device-mapper allows to create devices of any size using only part of
> > the underlying device. Therefore, it is not possible to apply the
> > interposer to the whole block device.
> > Perhaps it makes sense to put the blk_partition_unremap() function in the
> > block layer? I'm not sure that's a good thing.
> 
> I suspect the answer is to not remap bios that are going to be handled
> by the interposer.  In fact much of submit_bio_checks as-is is a bad
> idea for interposed devices.  I think what we need to do instead is to
> pass an explicit bdev to submit_bio_checks and use that everywhere,
> including in the subfunctions.
> 
> With that we might also be able to remove the separate interpose hook
> and thus struct bdev_interposer entirely as now ->submit_bio of the
> interposer could do all the work:
> 
> static noinline blk_qc_t submit_bio_interposed(struct bio *bio)
> {
> 	struct block_device *orig_bdev = bio->bi_bdev, *interposer;
> 	struct bio_list bio_list[2] = { };
> 	blk_qc_t ret = BLK_QC_T_NONE;
> 
> 	if (current->bio_list) {
>                 bio_list_add(&current->bio_list[0], bio);
>                 return BLK_QC_T_NONE;
>         }
> 
> 	if (unlikely(bio_queue_enter(bio)))
> 		return BLK_QC_T_NONE;
> 
> 	interposer = orig_bdev->bd_interposer;
> 	if (unlikely(!interposer)) {
> 		/* interposer was removed */
> 		bio_list_add(&current->bio_list[0], bio);
> 		goto queue_exit;
> 	}
> 	if (!submit_bio_checks(bio, interposer))
> 		goto queue_exit;
> 
> 	bio_set_flag(bio, BIO_INTERPOSED);
> 
> 	current->bio_list = bio_list;
> 	ret = interposer->bd_disk->fops->submit_bio(bio);
> 	current->bio_list = NULL;
> 
> queue_exit:
> 	blk_queue_exit(bdev->bd_disk->queue);
> 
> 	/* Resubmit remaining bios */
> 	while ((bio = bio_list_pop(&bio_list[0])))
> 		ret = submit_bio_noacct(bio);
> 	return ret;
> }
> 
> blk_qc_t submit_bio_noacct(struct bio *bio)
> {
> 	if (bio->bi_bdev->bd_interposer && !bio_flagged(bio, BIO_INTERPOSED)
> 		return submit_bio_interposed(bio);
> 		
> 	...
> }

Your point of view is very interesting. I like.
I will try to implement it and check how it works.

So far, I see the problem in that the interposer device has to intercept
all bio requests from the original device. It will not be possible to
implement an interception of some part. Device mapper can create its own
target for a part of the block device.

But maybe it's a good thing. First, there is little real benefit from
being able to intercept bio requests from a part of the block device.
In real use, this may not be necessary. Secondly, it will get rid of the
problem when part of the bio needs to be intercepted, and part does not.

I'd like to know Mike's opinion on this issue.

> 
> Note that both with this and your original code the interposer must
> never resubmit I/O to itself.  Is that actually the case for DM?  I'm
> trying to think of a good debug check for that, but right now I can't
> think of something that doesn't cause any overhead for n

I believe that the BIO_INTERPOSED flag is quite good at solving this
problem. When cloning a bio, the flag is passed, which means that bio
cannot be called twice.


Thank you again.
Because of you, I will have to rewrite some code again ;)
But it's all for the best.
-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

