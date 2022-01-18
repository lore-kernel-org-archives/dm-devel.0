Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDBFC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 07:59:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-Sm_BWuBSMoOeTwKpomKBSw-1; Tue, 18 Jan 2022 02:59:37 -0500
X-MC-Unique: Sm_BWuBSMoOeTwKpomKBSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA39264140;
	Tue, 18 Jan 2022 07:59:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4015416A5A;
	Tue, 18 Jan 2022 07:59:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8EDFC4BB7C;
	Tue, 18 Jan 2022 07:59:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I7xTlX016254 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 02:59:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD1AC401E44; Tue, 18 Jan 2022 07:59:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8F13401E22
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:59:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F921858EED
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:59:29 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-164-TsLbumSxNRuZxq0obiNFHA-1; Tue, 18 Jan 2022 02:59:26 -0500
X-MC-Unique: TsLbumSxNRuZxq0obiNFHA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1n9iTq-000VJK-1i; Tue, 18 Jan 2022 07:00:34 +0000
Date: Mon, 17 Jan 2022 23:00:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YeZlkpvCJ97nIzOS@infradead.org>
References: <1642183128-17875-1-git-send-email-bmarzins@redhat.com>
	<YeUf9dRHky81/bs4@infradead.org> <YeYKGPxVZFM8pneN@T590>
MIME-Version: 1.0
In-Reply-To: <YeYKGPxVZFM8pneN@T590>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm rq: clear cloned bio ->bi_bdev to fix I/O
 accounting
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

On Tue, Jan 18, 2022 at 08:30:16AM +0800, Ming Lei wrote:
> On Sun, Jan 16, 2022 at 11:51:17PM -0800, Christoph Hellwig wrote:
> > So I actually noticed this during code inspection a while ago, but I
> > think we need to use the actual underlying device instead of NULL here
> > to keep our block layer gurantees.  See the patch in my queue below.
> > 
> > ---
> > From 1e330b8e57fc0d6c6fb07c0ec2915dca5d7a585a Mon Sep 17 00:00:00 2001
> > From: Christoph Hellwig <hch@lst.de>
> > Date: Thu, 13 Jan 2022 10:53:59 +0100
> > Subject: block: assign bi_bdev for cloned bios in blk_rq_prep_clone
> > 
> > The cloned bios for the cloned request in blk_rq_prep_clone currently
> > still point to the original bi_bdev.  This is harmless because dm-mpath
> 
> It breaks io accounting, so not harmless, but the code in this patch is
> fine:

That's what I thought at the time.  Based on the patch from
Benjamin that is obviously not true, so I'll reword the commit message
and add a Fixes tag.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

