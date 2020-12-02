Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615DBC64E7B
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:55:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 99E4F221FD
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99E4F221FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-Y6ghoQZjNJSE-9ohluzNUw-1; Wed, 02 Dec 2020 17:55:29 -0500
X-MC-Unique: Y6ghoQZjNJSE-9ohluzNUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2C741075645;
	Wed,  2 Dec 2020 22:55:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C87013470;
	Wed,  2 Dec 2020 22:55:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 231A3180954D;
	Wed,  2 Dec 2020 22:55:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2MtKVl017021 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 17:55:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CAEB72166B27; Wed,  2 Dec 2020 22:55:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF6902166B2B
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:55:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 395F8101A53F
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:55:17 +0000 (UTC)
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com
	[209.85.222.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-138-6reZy-VgPyeYukxF1Eix5w-1; Wed, 02 Dec 2020 17:55:15 -0500
X-MC-Unique: 6reZy-VgPyeYukxF1Eix5w-1
Received: by mail-qk1-f194.google.com with SMTP id b144so366373qkc.13
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 14:55:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=VtlFvmaklvcZDGrLlSAgQhu+0H7bK0zCUEpwXYO6ZPg=;
	b=Bco5AMBQYvVrsIxBSwhKrWlPwkkLaR7IZB4SWBJ3zykIDxgMbfudNbEDn3uMsQpgGf
	uVf09iIMW6ZEAN733ON6ALSTTXOWDmvvtYEo3tLppYiT+5hlZWEJYOCQk53LEnPATCbd
	LZX+ryp7PNFvbd0Aq2fKkLTw9HM8GKKRdu2VAY1wunjBtQm8WYbHyoxeodoav+rOn35I
	ruL+2HicCzQhT5Cp3yp6ey79hUBBMWlqx+JSWXiy/gvGr8xwAHEK0Y5LNjN1qw82Plc1
	yfeQS3dza2su4ArRXdk3WQPIqvAz1yOoJ3F+/nk9ZYXD85/suxXVg+MaXkxvLhyUQTj3
	gRlw==
X-Gm-Message-State: AOAM532WB/QZEMwrzQwazTFjP8YJtduY8FXnQk9oxI5Q8H4DXOuzBM+y
	aLaiQIvgHFju8Pdq9cQTMLh85Wi7Tq9iOQ==
X-Google-Smtp-Source: ABdhPJzxbVxALs+v4IXK2QlV8LBTGqeZrxGS7JYABGudWsaxBMX2uEOJyie3dRa7pXdUAfhwcyfqDw==
X-Received: by 2002:a37:8c06:: with SMTP id o6mr63663qkd.382.1606949714715;
	Wed, 02 Dec 2020 14:55:14 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id r14sm452404qte.27.2020.12.02.14.55.13
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 14:55:13 -0800 (PST)
Date: Wed, 2 Dec 2020 17:54:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gbNeczmbhF8ZEW@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-4-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 3/9] block: store a block_device pointer in
	struct bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> Replace the gendisk pointer in struct bio with a pointer to the newly
> improved struct block device.  From that the gendisk can be trivially
> accessed with an extra indirection, but it also allows to directly
> look up all information related to partition remapping.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

