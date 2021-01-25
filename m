Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF856C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:24:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1125922EBF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:24:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1125922EBF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-R03et7-BNpaeA2JAgAWIfg-1; Mon, 25 Jan 2021 13:24:50 -0500
X-MC-Unique: R03et7-BNpaeA2JAgAWIfg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC8D801B18;
	Mon, 25 Jan 2021 18:24:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF8D31A3D8;
	Mon, 25 Jan 2021 18:24:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 245691809CA0;
	Mon, 25 Jan 2021 18:24:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PILvKm005142 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 13:21:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C67DF2026D37; Mon, 25 Jan 2021 18:21:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0C502026D38
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:21:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59A6C811E76
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:21:55 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-302-54X89W96PC2_QwKuCOUhPA-1;
	Mon, 25 Jan 2021 13:21:53 -0500
X-MC-Unique: 54X89W96PC2_QwKuCOUhPA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id A43DB68B02; Mon, 25 Jan 2021 19:21:50 +0100 (CET)
Date: Mon, 25 Jan 2021 19:21:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20210125182150.GA15367@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-6-hch@lst.de>
	<dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
	<20210125175528.GA13451@lst.de>
	<2b600368-96fa-7caf-f05b-321de616f7c9@kernel.dk>
	<13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk>
	<20210125181349.GA14432@lst.de>
	<1c0fabdc-9b73-dfd7-f49d-c211d58cbf12@kernel.dk>
	<20210125181826.GA14957@lst.de>
	<22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-s390 <linux-s390@vger.kernel.org>,
	linux-bcache <linux-bcache@vger.kernel.org>, Coly Li <colyli@suse.de>,
	"open list:SOFTWARE RAID \(Multiple Disks\) SUPPORT"
	<linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-block <linux-block@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 05/10] block: do not reassig ->bi_bdev when
 partition remapping
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 25, 2021 at 11:19:23AM -0700, Jens Axboe wrote:
> On 1/25/21 11:18 AM, Christoph Hellwig wrote:
> > On Mon, Jan 25, 2021 at 11:15:04AM -0700, Jens Axboe wrote:
> >> On 1/25/21 11:13 AM, Christoph Hellwig wrote:
> >>> On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
> >>>> Partition table entries are not in disk order.
> >>>
> >>> And the issue shows up with the series just up to the this patch,
> >>> without any later patches?
> >>
> >> At that patch specifically. I bisected it, and then I double checked
> >> by running the previous commit (boots fine), then apply this one, and
> >> then I run into that error. So it should be 100% reliable.
> > 
> > Ok, I have an idea.  With EOD message you mean this printk, right:
> > 
> > 	pr_info_ratelimited("attempt to access beyond end of device\n"
> >                             "%s: rw=%d, want=%llu, limit=%llu\n",
> > 			    ...
> > 
> > right?
> 
> Yep

Can you give this untested patch a spin?  This should fix the
case where we check the eod for the original partition with the
remapped bi_sectors.  Looking into a local reproducer now.

diff --git a/block/blk-core.c b/block/blk-core.c
index 88f60890443264..6253a2f9a1c08f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -813,13 +813,16 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 
 	if (should_fail_bio(bio))
 		goto end_io;
+
 	if (unlikely(bio_check_ro(bio)))
 		goto end_io;
-	if (unlikely(bio_check_eod(bio)))
-		goto end_io;
-	if (bio->bi_bdev->bd_partno && !bio_flagged(bio, BIO_REMAPPED) &&
-	    unlikely(blk_partition_remap(bio)))
-		goto end_io;
+	if (!bio_flagged(bio, BIO_REMAPPED)) {
+		if (unlikely(bio_check_eod(bio)))
+			goto end_io;
+		if (bio->bi_bdev->bd_partno &&
+		    unlikely(blk_partition_remap(bio)))
+			goto end_io;
+	}
 
 	/*
 	 * Filter flush bio's early so that bio based drivers without flush

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

