Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5CBC4332F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 07:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667547398;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=clOELg+z2kJ/ahEl73XZDanjZmVLXQ2FLRIr1K7vN7U=;
	b=LRju7PK3w57U6QPP31nNLFxeHiI26ApL1A48CCLMsc32eAPbEo6KHP1LC6FT6N+R+K5Cn+
	i7CZsngGvooYeUBFMqwys1jrB3FCnYp5QCQIj8Eo5ZdL8bq4FD0LuqRmsPWtPfGfDZHxvc
	ewuNkhv6aREXWy+ZzZGTJ4AlrRXrRio=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-aLsA1QeyOuyZVeOmelF9yg-1; Fri, 04 Nov 2022 03:36:37 -0400
X-MC-Unique: aLsA1QeyOuyZVeOmelF9yg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BB47101A56D;
	Fri,  4 Nov 2022 07:36:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E82D218EB4;
	Fri,  4 Nov 2022 07:36:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB0681946597;
	Fri,  4 Nov 2022 07:36:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7F011946594
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 07:36:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A6AD14EA5C; Fri,  4 Nov 2022 07:36:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F52F18EB4
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 07:36:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FC08185A794
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 07:36:33 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-nKqYzz2VME2Z4Q2Fq5cZ-g-1; Fri, 04 Nov 2022 03:36:31 -0400
X-MC-Unique: nKqYzz2VME2Z4Q2Fq5cZ-g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 73AF5B82C18;
 Fri,  4 Nov 2022 07:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14D1C433D6;
 Fri,  4 Nov 2022 07:28:14 +0000 (UTC)
Date: Fri, 4 Nov 2022 00:28:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y2S/DfZTr90t6QXv@sol.localdomain>
References: <20221104054621.628369-1-hch@lst.de>
 <20221104054621.628369-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221104054621.628369-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 1/2] blk-crypto: don't use struct
 request_queue for public interfaces
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
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Mike Snitzer <snitzer@kernel.org>, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Jaegeuk Kim <jaegeuk@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 04, 2022 at 06:46:20AM +0100, Christoph Hellwig wrote:
>  Each device driver that
>  wants to support inline encryption will construct a blk_crypto_profile, then
> -associate it with the disk's request_queue.
> +associate it with the block device.
>  
[...]
> -Once the driver registers a blk_crypto_profile with a request_queue, I/O
> +Once the driver registers a blk_crypto_profile with a block_device, I/O
>  requests the driver receives via that queue may have an encryption context.
[...]
> -Request queue based layered devices like dm-rq that wish to support inline
> -encryption need to create their own blk_crypto_profile for their request_queue,
> +Request based layered devices like dm-rq that wish to support inline
> +encryption need to create their own blk_crypto_profile for their block_device,
>  and expose whatever functionality they choose. When a layered device wants to
[...]

Shouldn't the three places above still say request_queue, not block_device?
They're talking about the driver.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

