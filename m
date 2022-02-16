Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DE5C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 18:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645036601;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BLlAOog/nfw6H7QvICRx4xixzs+4HhiiWHKWcdHI0QU=;
	b=WRQB7CjAuH+z6nLAb+P8y4h8TVeXguWF8myOw437wnGP4xAgPT4ok4Mqp8qOzsM+09iNyM
	yuMozQjofRNHOIMw5aQqjYWWWhy6aXxOr6CS29N48OlUPjAEDOp0EZjtpXjIfbmj5gqZN1
	COfQaSPB+Vr3c9Fmqm/7ZoP5BIhPQXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-TfiJCZFWPyCeXVnIaTX29A-1; Wed, 16 Feb 2022 13:36:37 -0500
X-MC-Unique: TfiJCZFWPyCeXVnIaTX29A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87DC98144EC;
	Wed, 16 Feb 2022 18:36:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 061A47D526;
	Wed, 16 Feb 2022 18:36:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 189B24BB7C;
	Wed, 16 Feb 2022 18:36:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21GIaUuB013871 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 13:36:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 250E276E9; Wed, 16 Feb 2022 18:36:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20CF476E8
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 18:36:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D64373C01D98
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 18:36:23 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-365-KHFt1MKsNVSuH4c1Fuho6w-1; Wed, 16 Feb 2022 13:36:22 -0500
X-MC-Unique: KHFt1MKsNVSuH4c1Fuho6w-1
Received: by mail-qk1-f197.google.com with SMTP id
	de36-20020a05620a372400b00508b2c3063eso1921081qkb.12
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 10:36:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=aEnh4v2rUd+a1mRZO11npkIbStQoEjtYz9jOrVTs9y0=;
	b=q8bIemuZstHzwCDCXiffedvPNYWg9qWkGB5obBs4UaNr0LVaXRR9Po8FPALTCJm2dv
	itZsBche1fF4o+AqD9cl1PWIBN8aLpEkbYlB3s3nGrAKhfaTI1xZ7Dy+QQjSLssKAQWK
	5EX0VZ0MYEvf5AG42BDINJ6PavjL/E5MlU5mhGmzji55JwPxgybkpnEfqE9Raljsbu64
	+iBc5pjT2Wr59m0HoavIV8h26KngdiM4DM7XHwQ2hN+sZkIB7L3wkl62W1O23Tpzei+Q
	d2hNi1HOqTGPcywLG8E6uqq1Y86w7OEzcHJusDNVOgd3WX2WExYuCGO3T5rsvhRHyAzI
	I6xQ==
X-Gm-Message-State: AOAM5320/OuSsMW7Xjv4up1b+uKyruU4iDmLPERG9DxOm7HV3sBpFuV8
	m4fty1xhsq0E3SxWSyIjFlKB+n98IvNQWUJQ/uS6a90HqESsewTCABYi1INxMVH6tnCPYWB5rty
	AMXorrDoYHS0CtQ==
X-Received: by 2002:a05:620a:1a97:b0:60c:8807:712a with SMTP id
	bl23-20020a05620a1a9700b0060c8807712amr926156qkb.136.1645036581600;
	Wed, 16 Feb 2022 10:36:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhm0NtOyBgT+M+J0kPaNZXBLv99NvrTO8Ft/L0Gx8719csCia04TnDe9rCguvIwbrKCyb58w==
X-Received: by 2002:a05:620a:1a97:b0:60c:8807:712a with SMTP id
	bl23-20020a05620a1a9700b0060c8807712amr926144qkb.136.1645036581408;
	Wed, 16 Feb 2022 10:36:21 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	y9sm13100691qtx.85.2022.02.16.10.36.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Feb 2022 10:36:21 -0800 (PST)
Date: Wed, 16 Feb 2022 13:36:20 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Yg1EJFq2P4e8+6xn@redhat.com>
References: <20220215100540.3892965-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220215100540.3892965-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] make the blk-mq stacking interface optional
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 15 2022 at  5:05P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Hi Jens,
> 
> this series requires an explicit select to use the blk-mq stacking
> interfaces.  This means they don't get build without dm support, and
> thus the buildbot should catch abuses like the one we had in the ufs
> driver more easily.  And while I touched this code I also ended up
> cleaning up various loose ends.

All look good to me, thanks, for series:

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

