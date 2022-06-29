Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFAD5C43334
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 01:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656464597;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3plxcDOpSLiEYfExM7M5G+Kgfe50N6fZZw5zHQYFlTg=;
	b=NDwZ3QXDkrUs9EC1VTMKna+xmjnfxmhJZcfDrr97RElEtEHR5KuzTCgchhAKUG8iZa0dpv
	CZ2upaAUa+636SSpxwd59MYVHZLmeZlxD8vvK3iasjAF1UJfo1Bvh2HlC3CAhY0vrqDNcr
	5Tvbfw5zrR0vSN7Xoh86yhyOEUwlIVE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-4uF5zilyNk2n_2Gvf9FmCA-1; Tue, 28 Jun 2022 21:03:14 -0400
X-MC-Unique: 4uF5zilyNk2n_2Gvf9FmCA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA2D81C0F684;
	Wed, 29 Jun 2022 01:03:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 697321410F3B;
	Wed, 29 Jun 2022 01:03:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 394651947056;
	Wed, 29 Jun 2022 01:03:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 966BE1947056
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 01:03:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5273C2026D07; Wed, 29 Jun 2022 01:03:10 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CAE852026D64;
 Wed, 29 Jun 2022 01:03:04 +0000 (UTC)
Date: Wed, 29 Jun 2022 09:02:58 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Message-ID: <YrukwsgbFxd69wA1@T590>
References: <20220624141255.2461148-1-ming.lei@redhat.com>
 <20220624141255.2461148-2-ming.lei@redhat.com>
 <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
MIME-Version: 1.0
In-Reply-To: <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

On Tue, Jun 28, 2022 at 12:36:17PM -0400, Kent Overstreet wrote:
> On Tue, Jun 28, 2022 at 03:49:28PM +0800, Ming Lei wrote:
> > On Tue, Jun 28, 2022 at 12:26:10AM -0400, Kent Overstreet wrote:
> > > On Mon, Jun 27, 2022 at 03:36:22PM +0800, Ming Lei wrote:
> > > > Not mention bio_iter, bvec_iter has been 32 bytes, which is too big to
> > > > hold in per-io data structure. With this patch, 8bytes is enough
> > > > to rewind one bio if the end sector is fixed.
> > > 
> > > And with rewind, you're making an assumption about the state the iterator is
> > > going to be in when the IO has completed.
> > > 
> > > What if the iterator was never advanced?
> > 
> > bio_rewind() works as expected if the iterator doesn't advance, since bytes
> > between the recorded position and the end position isn't changed, same
> > with the end position.
> > 
> > > 
> > > So say you check for that by saving some other part of the iterator - but that
> > > may have legitimately changed too, if the bio was redirected (bi_sector changes)
> > > or trimmed (bi_size changes)
> > > 
> > > I still think this is an inherently buggy interface, the way it's being proposed
> > > to be used.
> > 
> > The patch did mention that the interface should be for situation in which end
> > sector of bio won't change.
> 
> But that's an assumption that you simply can't make!

Of course, we can, at least for this DM's use case, the bio is issued
from FS or split from DM, and it won't be issued to underlying queue any
more, and simply owned by DM core code.

> 
> We allow block device drivers to be stacked in _any_ combination. After a bio is
> completed it may have been partially advanced, fully advanced, trimmed, not
> trimmed, anything - and bi_sector and thus also bio_end_sector() may have
> changed, and will have if there's partition tables involved.

How can bio (partial)advance change bio's end sector?

bio end sector can be changed only when bio->bi_iter.bi_size is changed
manually(include bio_trim), or ->bi_bdev is changed. But inside one
driver, if the bio is owned by this driver(such as the driver is the
finally layer request based driver), the assumption often can make.


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

