Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDF2C4167D
	for <dm-devel@archiver.kernel.org>; Fri, 11 Nov 2022 07:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668152369;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U6YnL8nhAbNpbcZ44GpVeuSAMeUQKTUdjyg/zoEGgng=;
	b=Vv/adZdA0U6IH4JLr947XlefezShpU3qb/TXGtejUUCFW6ZxyEHBNo6CKC3ESPhlgRWdvR
	F3eWTnTWx5ydZsBdoM7MpzRs12NUewrZrDwAYKTvUzsrne+T8WrbgbM+gOaZvjDWiCegxz
	+OCa0by0s/uOZmavBjUknjF6Zd0aMyk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-odUVYg6ROUiK6PcctW_uzA-1; Fri, 11 Nov 2022 02:39:26 -0500
X-MC-Unique: odUVYg6ROUiK6PcctW_uzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 230AC101AA6A;
	Fri, 11 Nov 2022 07:39:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1287F2023A1D;
	Fri, 11 Nov 2022 07:39:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7EBF51946A4C;
	Fri, 11 Nov 2022 07:39:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B0751946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Nov 2022 18:45:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 608591415122; Thu, 10 Nov 2022 18:45:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59B73141511F
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:45:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CAD03C0218D
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:45:30 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-fHgvhU-OMMmVvlvafk3mRQ-1; Thu, 10 Nov 2022 13:45:26 -0500
X-MC-Unique: fHgvhU-OMMmVvlvafk3mRQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9086461D70;
 Thu, 10 Nov 2022 18:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5647BC433D6;
 Thu, 10 Nov 2022 18:45:24 +0000 (UTC)
Date: Thu, 10 Nov 2022 11:45:21 -0700
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <Y21GwRUeJVwN17rR@kbusch-mbp.dhcp.thefacebook.com>
References: <20221103152559.1909328-1-kbusch@meta.com>
 <Y21BwxCkeaONcYK5@gmail.com>
MIME-Version: 1.0
In-Reply-To: <Y21BwxCkeaONcYK5@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Fri, 11 Nov 2022 07:39:20 +0000
Subject: Re: [dm-devel] [PATCH 0/3] fix direct io errors on dm-crypt
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
Cc: axboe@kernel.dk, Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, mpatocka@redhat.com, stefanha@redhat.com, me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 10, 2022 at 06:24:03PM +0000, Eric Biggers wrote:
> On Thu, Nov 03, 2022 at 08:25:56AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The 6.0 kernel made some changes to the direct io interface to allow
> > offsets in user addresses. This based on the hardware's capabilities
> > reported in the request_queue's dma_alignment attribute.
> > 
> > dm-crypt requires direct io be aligned to the block size. Since it was
> > only ever using the default 511 dma mask, this requirement may fail if
> > formatted to something larger, like 4k, which will result in unexpected
> > behavior with direct-io.
> > 
> > There are two parts to fixing this:
> > 
> >   First, the attribute needs to be moved to the queue_limit so that it
> >   can properly stack with device mappers.
> > 
> >   Second, dm-crypt provides its minimum required limit to match the
> >   logical block size.
> > 
> > Keith Busch (3):
> >   block: make dma_alignment a stacking queue_limit
> >   dm-crypt: provide dma_alignment limit in io_hints
> >   block: make blk_set_default_limits() private
> 
> Hi Keith, can you send out an updated version of this patch series that
> addresses the feedback?
> 
> I'd really like for this bug to be fixed before 6.1 is released, so that there
> isn't a known bug in STATX_DIOALIGN already upon release.

Sorry for the delay, v2 sent.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

