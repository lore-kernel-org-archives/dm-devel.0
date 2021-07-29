Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F13C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:33:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 97FD960EFD
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 97FD960EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627576380;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5oZOgm8o/8UoqLf0neEKv40jnKdTV99dQTHkeXZa2Wc=;
	b=dZ4BjdldnVREkBkvfjMDUmv6OnSbjd8ttqgvo7D5znHfGlyqqvqT+Z5+h20R0599+FQ7/X
	KQG3g5ldZKh9A6gWefZuo+2DoceMsifstGeI8DBhkzsOwLacHLCqrV1Sgd76WqaO3Q7Ngo
	7ecsX53QvjTPV+4vSHOzMdjtxTDkvf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-XzruAECmMlO2oqPjJ_35vQ-1; Thu, 29 Jul 2021 12:32:53 -0400
X-MC-Unique: XzruAECmMlO2oqPjJ_35vQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92C3D190B2A1;
	Thu, 29 Jul 2021 16:32:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B9C760877;
	Thu, 29 Jul 2021 16:32:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EF34C180B7A2;
	Thu, 29 Jul 2021 16:32:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TGWknI012335 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 12:32:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 85E3020B6632; Thu, 29 Jul 2021 16:32:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FD1C20B662D
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:32:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16E25101A52C
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:32:43 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
	[209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-47-sesFETDNMYahB7iUQdqCRQ-1; Thu, 29 Jul 2021 12:32:41 -0400
X-MC-Unique: sesFETDNMYahB7iUQdqCRQ-1
Received: by mail-qv1-f71.google.com with SMTP id
	s12-20020ad4446c0000b029033a9344451cso70536qvt.21
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 09:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=fbFw+xoO3h0Tqx3b8uM1PS4AxjRaaO0844YZWUhMwME=;
	b=ozCpg20MDxtNkLoWoCMxSpHcbrMInlWDOKt93Vs9Xg1DN8mx/m9BVwuPYj7DGyOrr1
	8JsRC2WV6a5g6wJOt5uQwMQ25wasVTlh7jlo1I4cy0tFYu2ZfsLkYWYpFf15CfGiezdF
	EUdp/aWYIa4xx4dXjPEqREw3sN+b5uBcj2BXZs21XdHD9WwlGRbllxYqHXkNxRqrRAzf
	Un0Stphrtel/skvodEg1skLo7fGVsi7NrAol4iAn5RkZ7cYiCVx8nQfZyQik6KvXqGrP
	L/egPnWSK8kHLjk3FsfslR3ZaK+3jXaOKKIVWhsLwzsJsN8UVW3OQyuXUTZy9CGY9hAI
	C4Lg==
X-Gm-Message-State: AOAM532awO0/efBy7VO8yP6IodBOY0CsH984NFd+37PV8beXpbzJ08//
	fSRon2YXn/Nzny6aToj0MoPPTSKTk4LinCtycBMJYW5N7J/UehUHutMg4l+t5gkNi2184c5+osE
	iOsvsIt7hSUzICA==
X-Received: by 2002:a05:620a:1904:: with SMTP id
	bj4mr3026821qkb.283.1627576361063; 
	Thu, 29 Jul 2021 09:32:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtKAaVnJ7lXcNK6jx8oCRrhMgmbkvpt9K4BZHi/iPnG6xgooGOCOFzt8GqmKtFEET05sGagw==
X-Received: by 2002:a05:620a:1904:: with SMTP id
	bj4mr3026807qkb.283.1627576360908; 
	Thu, 29 Jul 2021 09:32:40 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	18sm2070772qkv.118.2021.07.29.09.32.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Jul 2021 09:32:40 -0700 (PDT)
Date: Thu, 29 Jul 2021 12:32:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQLYJ3C5LVI3Lu1r@redhat.com>
References: <20210725055458.29008-1-hch@lst.de>
	<20210725055458.29008-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210725055458.29008-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
	registration
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

On Sun, Jul 25 2021 at  1:54P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> device mapper needs to register holders before it is ready to do I/O.
> Currently it does so by registering the disk early, which has all kinds
> of bad side effects.  Support registering holders on an initialized but
> not registered disk instead by delaying the sysfs registration until the
> disk is registered.

Maybe expand "bad side effects" in header to include what you detailed here?:
https://listman.redhat.com/archives/dm-devel/2021-July/msg00130.html

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

