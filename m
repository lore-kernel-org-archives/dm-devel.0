Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172A8C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:31:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8CCD760E9C
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8CCD760E9C
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633527115;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=14dJOJZpsHObo46bASw27+ia6ZPUu6SN8euB2xE89kM=;
	b=SgH0cP7Gf+Lk1fq/tN2HZs6p0+/2nWH77avv+gps2ZOughfbaEJLpWxsBgMNWeL/2pp5A6
	O9+flcaSyvNhV1Mx4XexGmcnvooR4a/e1R15Fapv4AwMvb6/W1xNJxLPJxm1COwqTRqRVb
	cLIPFGJIuKBIu9wB/d8BWTHSgdpq2oQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-DnOpu5fXMWeysWovJSKs-g-1; Wed, 06 Oct 2021 09:31:49 -0400
X-MC-Unique: DnOpu5fXMWeysWovJSKs-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94D351006AA5;
	Wed,  6 Oct 2021 13:31:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 186BF17C58;
	Wed,  6 Oct 2021 13:31:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 539DC4E58F;
	Wed,  6 Oct 2021 13:31:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196DOdKm014631 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 09:24:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 316792180130; Wed,  6 Oct 2021 13:24:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 251522180120
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:24:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02DDF18A658F
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:24:39 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
	[209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-263-IX8FN15lP7Gu3FLHME2fQw-1; Wed, 06 Oct 2021 09:24:37 -0400
X-MC-Unique: IX8FN15lP7Gu3FLHME2fQw-1
Received: by mail-qt1-f198.google.com with SMTP id
	o6-20020a05622a008600b002a6c2fbc853so2228111qtw.16
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 06:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=PhQKrj6CTy/IMZheSbTjJtRay2DZf3eElNhZxG86YDA=;
	b=s3oTs41mALT23lUV5ycnC0UpiR0hXNevpVNkPBw7JWVpUtiOhLQ2zgtK23Z5GwuiDT
	2dZ0KuqaafmSxGGBJ7ciQGXmMO/HeyVJgwfEj4i5Id8eTEc7hxTwq2isu1VXBR1l+ceW
	ABvdJqSBQUJbOI7jM/gDLa9m3R3BAhsTYJkQGEQHRkCZLnjn2pvB5w6Q6czFkRBjOc1L
	+ffSdtL/tbxWoxKHIPT0GZWCXjzr7kLE4Nl6LoMOc/faaLgX4bGDevBQkGAUQwvQeJQO
	tazUNznf5k+70AO1P227eQD9hPmnQIX1am80Y8u1m0PICoazuyR9Dc+F1gnNbQNQok4c
	6mqQ==
X-Gm-Message-State: AOAM530q1LVEkG4bLwXPoNTcdL8FMM+GMdt8LZkNzXuRt/D1oLHYTsgB
	TY6rYwXSzjbVKjAYzsiwAzGGYskZZ/BgjgTMGbg+MXdkP8vO0krUrYzD2gN02vPIXifTwVd+AEc
	uRBDUTB2Lhwb47g==
X-Received: by 2002:a37:9d16:: with SMTP id g22mr19915882qke.158.1633526676977;
	Wed, 06 Oct 2021 06:24:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwU5K9sLtf2F8/ZVmQbICWiONRseEkHUAhaNdvw8PixzCkidZf3Sgubc2NbR+xRlb/+oJjIrw==
X-Received: by 2002:a37:9d16:: with SMTP id g22mr19915860qke.158.1633526676823;
	Wed, 06 Oct 2021 06:24:36 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id s14sm5011152qtc.9.2021.10.06.06.24.36
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 06:24:36 -0700 (PDT)
Date: Wed, 6 Oct 2021 09:24:35 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-ID: <YV2jk1su5caAZmVP@redhat.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
	<20210929163600.52141-2-ebiggers@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210929163600.52141-2-ebiggers@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v4 1/4] blk-crypto-fallback: properly prefix
 function and struct names
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 29 2021 at 12:35P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> For clarity, avoid using just the "blk_crypto_" prefix for functions and
> structs that are specific to blk-crypto-fallback.  Instead, use
> "blk_crypto_fallback_".  Some places already did this, but others
> didn't.
> 
> This is also a prerequisite for using "struct blk_crypto_keyslot" to
> mean a generic blk-crypto keyslot (which is what it sounds like).
> Rename the fallback one to "struct blk_crypto_fallback_keyslot".
> 
> No change in behavior.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

