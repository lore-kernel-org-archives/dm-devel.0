Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AB4C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:35:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8E91064FE3
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E91064FE3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-l9AbUzUsNgOxb1Huftyl-A-1; Wed, 10 Mar 2021 07:35:29 -0500
X-MC-Unique: l9AbUzUsNgOxb1Huftyl-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4366801817;
	Wed, 10 Mar 2021 12:35:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ED4A19727;
	Wed, 10 Mar 2021 12:35:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0E38B4EA69;
	Wed, 10 Mar 2021 12:35:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12ACZGIn024971 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 07:35:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C32AD217B40F; Wed, 10 Mar 2021 12:35:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD808217B40D
	for <dm-devel@redhat.com>; Wed, 10 Mar 2021 12:35:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74D29185A79C
	for <dm-devel@redhat.com>; Wed, 10 Mar 2021 12:35:14 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-429-XOjZRNQvMw65m0nN7AHTFw-1; Wed, 10 Mar 2021 07:35:12 -0500
X-MC-Unique: XOjZRNQvMw65m0nN7AHTFw-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lJy3E-003O6D-2z; Wed, 10 Mar 2021 12:34:59 +0000
Date: Wed, 10 Mar 2021 12:34:56 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <20210310123456.GA758100@infradead.org>
References: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
	<1614774618-22410-5-git-send-email-sergei.shtepa@veeam.com>
	<20210309173555.GC201344@infradead.org>
	<20210310052812.GB26929@veeam.com>
MIME-Version: 1.0
In-Reply-To: <20210310052812.GB26929@veeam.com>
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>, "song@kernel.org" <song@kernel.org>,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 10, 2021 at 08:28:12AM +0300, Sergei Shtepa wrote:
> > So instead of doing this shoudn't the interposer just always submit to the
> > whole device?  But if we keep it, the logic in this funtion should go
> > into a block layer helper, passing a block device instead of the

> 
> device-mapper allows to create devices of any size using only part of
> the underlying device. Therefore, it is not possible to apply the
> interposer to the whole block device.
> Perhaps it makes sense to put the blk_partition_unremap() function in the
> block layer? I'm not sure that's a good thing.

I suspect the answer is to not remap bios that are going to be handled
by the interposer.  In fact much of submit_bio_checks as-is is a bad
idea for interposed devices.  I think what we need to do instead is to
pass an explicit bdev to submit_bio_checks and use that everywhere,
including in the subfunctions.

With that we might also be able to remove the separate interpose hook
and thus struct bdev_interposer entirely as now ->submit_bio of the
interposer could do all the work:

static noinline blk_qc_t submit_bio_interposed(struct bio *bio)
{
	struct block_device *orig_bdev = bio->bi_bdev, *interposer;
	struct bio_list bio_list[2] = { };
	blk_qc_t ret = BLK_QC_T_NONE;

	if (current->bio_list) {
                bio_list_add(&current->bio_list[0], bio);
                return BLK_QC_T_NONE;
        }

	if (unlikely(bio_queue_enter(bio)))
		return BLK_QC_T_NONE;

	interposer = orig_bdev->bd_interposer;
	if (unlikely(!interposer)) {
		/* interposer was removed */
		bio_list_add(&current->bio_list[0], bio);
		goto queue_exit;
	}
	if (!submit_bio_checks(bio, interposer))
		goto queue_exit;

	bio_set_flag(bio, BIO_INTERPOSED);

	current->bio_list = bio_list;
	ret = interposer->bd_disk->fops->submit_bio(bio);
	current->bio_list = NULL;

queue_exit:
	blk_queue_exit(bdev->bd_disk->queue);

	/* Resubmit remaining bios */
	while ((bio = bio_list_pop(&bio_list[0])))
		ret = submit_bio_noacct(bio);
	return ret;
}

blk_qc_t submit_bio_noacct(struct bio *bio)
{
	if (bio->bi_bdev->bd_interposer && !bio_flagged(bio, BIO_INTERPOSED)
		return submit_bio_interposed(bio);
		
	...
}

Note that both with this and your original code the interposer must
never resubmit I/O to itself.  Is that actually the case for DM?  I'm
trying to think of a good debug check for that, but right now I can't
think of something that doesn't cause any overhead for n

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

