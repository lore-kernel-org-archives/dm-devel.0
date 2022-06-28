Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1CF5C43334
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 07:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656402191;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=njcikWwaC/6nvnN7sxANbuZrHOwR/7+Sgy+tCHA9Hpc=;
	b=auWAUfYMuSK/AWlQey06tFJKlSRSb28sv+j3wG+5wRTQOAjKdgeqsK9tcP+J8ifKv6qByi
	eixifwiSx4jBa5sTOjW/qJTeqkM+wY09xlaBIBvgEUbmjUaUIDle2dhCW7kr1cODFnBYdn
	Zw+8cKpfqW5yG9y4z3Z3Tnm311wBzn8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-1EAxDEwkPyaKkxu_Qp0ZYA-1; Tue, 28 Jun 2022 03:43:08 -0400
X-MC-Unique: 1EAxDEwkPyaKkxu_Qp0ZYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D8F01C068CE;
	Tue, 28 Jun 2022 07:43:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD15C1415108;
	Tue, 28 Jun 2022 07:43:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B81E4194704D;
	Tue, 28 Jun 2022 07:43:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B2FF51947052
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 07:43:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BFEF1121319; Tue, 28 Jun 2022 07:43:03 +0000 (UTC)
Received: from T590 (ovpn-8-29.pek2.redhat.com [10.72.8.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A4891121314;
 Tue, 28 Jun 2022 07:42:57 +0000 (UTC)
Date: Tue, 28 Jun 2022 15:42:52 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Message-ID: <Yrqw/KY94DDtFVfl@T590>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
MIME-Version: 1.0
In-Reply-To: <20220628042016.wd65amvhbjuduqou@moria.home.lan>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28, 2022 at 12:20:16AM -0400, Kent Overstreet wrote:
> On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> > On Sun, Jun 26, 2022 at 04:14:58PM -0400, Kent Overstreet wrote:
> > > On Fri, Jun 24, 2022 at 10:12:52PM +0800, Ming Lei wrote:
> > > > Commit 7759eb23fd98 ("block: remove bio_rewind_iter()") removes
> > > > the similar API because the following reasons:
> > > > 
> > > >     ```
> > > >     It is pointed that bio_rewind_iter() is one very bad API[1]:
> > > > 
> > > >     1) bio size may not be restored after rewinding
> > > > 
> > > >     2) it causes some bogus change, such as 5151842b9d8732 (block: reset
> > > >     bi_iter.bi_done after splitting bio)
> > > > 
> > > >     3) rewinding really makes things complicated wrt. bio splitting
> > > > 
> > > >     4) unnecessary updating of .bi_done in fast path
> > > > 
> > > >     [1] https://marc.info/?t=153549924200005&r=1&w=2
> > > > 
> > > >     So this patch takes Kent's suggestion to restore one bio into its original
> > > >     state via saving bio iterator(struct bvec_iter) in bio_integrity_prep(),
> > > >     given now bio_rewind_iter() is only used by bio integrity code.
> > > >     ```
> > > > 
> > > > However, it isn't easy to restore bio by saving 32 bytes bio->bi_iter, and saving
> > > > it only can't restore crypto and integrity info.
> > > > 
> > > > Add bio_rewind() back for some use cases which may not be same with
> > > > previous generic case:
> > > > 
> > > > 1) most of bio has fixed end sector since bio split is done from front of the bio,
> > > > if driver just records how many sectors between current bio's start sector and
> > > > the bio's end sector, the original position can be restored
> > > > 
> > > > 2) if one bio's end sector won't change, usually bio_trim() isn't called, user can
> > > > restore original position by storing sectors from current ->bi_iter.bi_sector to
> > > > bio's end sector; together by saving bio size, 8 bytes can restore to
> > > > original bio.
> > > > 
> > > > 3) dm's requeue use case: when BLK_STS_DM_REQUEUE happens, dm core needs to
> > > > restore to the original bio which represents current dm io to be requeued.
> > > > By storing sectors to the bio's end sector and dm io's size,
> > > > bio_rewind() can restore such original bio, then dm core code needn't to
> > > > allocate one bio beforehand just for handling BLK_STS_DM_REQUEUE which
> > > > is actually one unusual event.
> > > > 
> > > > 4) Not like original rewind API, this one needn't to add .bi_done, and no any
> > > > effect on fast path
> > > 
> > > It seems like perhaps the real issue here is that we need a real bio_iter,
> > > separate from bvec_iter, that also encapsulates iterating over integrity &
> > > fscrypt. 
> > 
> > Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> > hold in per-io data structure. With this patch, 8bytes is enough
> > to rewind one bio if the end sector is fixed.
> 
> Hold on though, does that check out? Why is that too big for per IO data
> structures?
> 
> By definition these structures are only for IOs in flight, and we don't _want_
> there to ever be very many of these or we're going to run into latency issues
> due to queue depth.

I don't see there is 'queue depth' for bio or bio driver.

32 bytes have been big, and memory footprint is increased too since the data has been
prepared for the future possible rewind. If crypt or integrity is considered, it
can be bigger.



Thanks, 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

