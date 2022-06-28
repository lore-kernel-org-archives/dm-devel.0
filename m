Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B96E2CCA479
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 06:38:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-z96wSw4YOx2HrUhTW3ZSlg-1; Tue, 28 Jun 2022 02:38:08 -0400
X-MC-Unique: z96wSw4YOx2HrUhTW3ZSlg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A87D81029F77;
	Tue, 28 Jun 2022 06:38:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9608A2026D07;
	Tue, 28 Jun 2022 06:38:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4BF60194705F;
	Tue, 28 Jun 2022 06:38:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E06E919466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 04:20:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C954A415F5E; Tue, 28 Jun 2022 04:20:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C557240334D
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 04:20:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD733800971
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 04:20:22 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-xsoBy5BKNaWyB6PvJFAymg-1; Tue, 28 Jun 2022 00:20:18 -0400
X-MC-Unique: xsoBy5BKNaWyB6PvJFAymg-1
Received: by mail-qk1-f175.google.com with SMTP id k20so8864775qkj.1;
 Mon, 27 Jun 2022 21:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AOuetpAXYSYI+dzBjT/ncBTsh7x4YoeNdtNMml9Z8Vg=;
 b=xyuqO90l5GDJxonTwCz7BBL1h79W0RSIwDpm9xdv/WpyWGDr+f4hy3IM00ciN/zg7K
 RHiqNMjF5r1VLUiPvjdOP8AZ7nBjZGLOfFaiSloMLJenr3niX7JmfNYUiV4M9BNGhiVL
 ez9RDM5umNe1B9SfX3QM2tsAb8zqc6x3BaH4Cl/gXoglFjWmocwTM1dQj8zOOXWmtsp3
 rUmycvArt+QKRA4nad8oJ+UrlL5sv8FZc4S0YQjT3aRu3YmTOa5IczQ7AuYjcT6zsMSX
 8l+qo4aN96yYN0yYhkC3vVEZYpYbQ+rCx7tGG5H9YBgKe9mJ9kFptbyaSdKCDf1ajaQd
 9hKw==
X-Gm-Message-State: AJIora+wbO0ZdGfNmNBvhsvQLFj1u/cKjqVl1CCa/wzsCAVX2ObAJ+4Q
 XC+2ctiNGYIJM6DvMf7wT2wyxATtcUC4Mfa/LA==
X-Google-Smtp-Source: AGRyM1seI9Ly0gshnChuPHs+Ql1zrzPSXLVpiTv/8F70O4T0r7+GLobK6iMGePdGlK7xTkzAQvRojQ==
X-Received: by 2002:a05:620a:3183:b0:6af:40c:284d with SMTP id
 bi3-20020a05620a318300b006af040c284dmr10154393qkb.433.1656390017553; 
 Mon, 27 Jun 2022 21:20:17 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 m5-20020ac84445000000b00307beda5c6esm8132383qtn.26.2022.06.27.21.20.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jun 2022 21:20:16 -0700 (PDT)
Date: Tue, 28 Jun 2022 00:20:16 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20220628042016.wd65amvhbjuduqou@moria.home.lan>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
MIME-Version: 1.0
In-Reply-To: <Yrld9rLPY6L3MhlZ@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Tue, 28 Jun 2022 06:38:00 +0000
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> On Sun, Jun 26, 2022 at 04:14:58PM -0400, Kent Overstreet wrote:
> > On Fri, Jun 24, 2022 at 10:12:52PM +0800, Ming Lei wrote:
> > > Commit 7759eb23fd98 ("block: remove bio_rewind_iter()") removes
> > > the similar API because the following reasons:
> > > 
> > >     ```
> > >     It is pointed that bio_rewind_iter() is one very bad API[1]:
> > > 
> > >     1) bio size may not be restored after rewinding
> > > 
> > >     2) it causes some bogus change, such as 5151842b9d8732 (block: reset
> > >     bi_iter.bi_done after splitting bio)
> > > 
> > >     3) rewinding really makes things complicated wrt. bio splitting
> > > 
> > >     4) unnecessary updating of .bi_done in fast path
> > > 
> > >     [1] https://marc.info/?t=153549924200005&r=1&w=2
> > > 
> > >     So this patch takes Kent's suggestion to restore one bio into its original
> > >     state via saving bio iterator(struct bvec_iter) in bio_integrity_prep(),
> > >     given now bio_rewind_iter() is only used by bio integrity code.
> > >     ```
> > > 
> > > However, it isn't easy to restore bio by saving 32 bytes bio->bi_iter, and saving
> > > it only can't restore crypto and integrity info.
> > > 
> > > Add bio_rewind() back for some use cases which may not be same with
> > > previous generic case:
> > > 
> > > 1) most of bio has fixed end sector since bio split is done from front of the bio,
> > > if driver just records how many sectors between current bio's start sector and
> > > the bio's end sector, the original position can be restored
> > > 
> > > 2) if one bio's end sector won't change, usually bio_trim() isn't called, user can
> > > restore original position by storing sectors from current ->bi_iter.bi_sector to
> > > bio's end sector; together by saving bio size, 8 bytes can restore to
> > > original bio.
> > > 
> > > 3) dm's requeue use case: when BLK_STS_DM_REQUEUE happens, dm core needs to
> > > restore to the original bio which represents current dm io to be requeued.
> > > By storing sectors to the bio's end sector and dm io's size,
> > > bio_rewind() can restore such original bio, then dm core code needn't to
> > > allocate one bio beforehand just for handling BLK_STS_DM_REQUEUE which
> > > is actually one unusual event.
> > > 
> > > 4) Not like original rewind API, this one needn't to add .bi_done, and no any
> > > effect on fast path
> > 
> > It seems like perhaps the real issue here is that we need a real bio_iter,
> > separate from bvec_iter, that also encapsulates iterating over integrity &
> > fscrypt. 
> 
> Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> hold in per-io data structure. With this patch, 8bytes is enough
> to rewind one bio if the end sector is fixed.

Hold on though, does that check out? Why is that too big for per IO data
structures?

By definition these structures are only for IOs in flight, and we don't _want_
there to ever be very many of these or we're going to run into latency issues
due to queue depth.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

