Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58A5C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 07:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667546599;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AmXv5Ge6NRYXGUpjy8O0TzLGK1ypB0S8wAa8zPpJIEo=;
	b=XMBjbT97tDxOA9rev+I9UteDegkgaHeuhXYYqiWcA/VA6xSxOweyr0CdfB7gzPQLnOmeAJ
	Vuvn4plpQLIZKu+3+a4fio4NjA27SPU7AKSm2WNSGvncIYaD6oD77wpjF3oOM6M9qpLf27
	pWO0kgaRjh1ZI7jwCHJ7IwHRX3hxc4w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-DhzQpHIVOd6yF-mQ2mdW3g-1; Fri, 04 Nov 2022 03:23:18 -0400
X-MC-Unique: DhzQpHIVOd6yF-mQ2mdW3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FD13811E67;
	Fri,  4 Nov 2022 07:23:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C051640C6EE9;
	Fri,  4 Nov 2022 07:23:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B11851946597;
	Fri,  4 Nov 2022 07:23:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 442681946594
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 07:23:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35525C2C8DD; Fri,  4 Nov 2022 07:23:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DCACC2C8D9
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 07:23:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2505299E766
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 07:23:11 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-8Q4m53DZNuSmM-Pf5WeLhQ-1; Fri, 04 Nov 2022 03:23:10 -0400
X-MC-Unique: 8Q4m53DZNuSmM-Pf5WeLhQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B0F39620D7;
 Fri,  4 Nov 2022 07:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D54C433D6;
 Fri,  4 Nov 2022 07:23:08 +0000 (UTC)
Date: Fri, 4 Nov 2022 00:23:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y2S927PXuEYM7xwJ@sol.localdomain>
References: <20221104054621.628369-1-hch@lst.de>
 <20221104054621.628369-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221104054621.628369-3-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 2/2] blk-crypto: add a
 blk_crypto_cfg_supported helper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 04, 2022 at 06:46:21AM +0100, Christoph Hellwig wrote:
> Add a blk_crypto_cfg_supported helper that wraps
> __blk_crypto_cfg_supported to retreive the crypto_profile from the
> request queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-crypto-profile.c         |  7 +++++++
>  block/blk-crypto.c                 | 13 ++++---------
>  fs/crypto/inline_crypt.c           |  4 +---
>  include/linux/blk-crypto-profile.h |  2 ++
>  4 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
> index 96c511967386d..e8a0a3457fa29 100644
> --- a/block/blk-crypto-profile.c
> +++ b/block/blk-crypto-profile.c
> @@ -353,6 +353,13 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
>  	return true;
>  }
>  
> +bool blk_crypto_cfg_supported(struct block_device *bdev,
> +			      const struct blk_crypto_config *cfg)
> +{
> +	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
> +					  cfg);
> +}

I think this part is too confusing, because there's already a function
blk_crypto_config_supported() which does something slightly different.

How about calling this blk_crypto_config_supported_natively() instead?  It's
kind of long, but it's much clearer.

Also, it should be defined in blk-crypto.c, next to
blk_crypto_config_supported(), and not in blk-crypto-profile.c.
(And declared in blk-crypto.h, not blk-crypto-profile.h.)

This would also make it so that fs/crypto/inline_crypt.c could go back to
including blk-crypto.h instead of blk-crypto-profile.h.  blk-crypto.h is
supposed to be the interface to upper layers, not blk-crypto-profile.h.

So, something like this:

	bool blk_crypto_config_supported(struct block_device *bdev,
					 const struct blk_crypto_config *cfg)
	{
		return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
		       blk_crypto_config_supported_natively(bdev, cfg);
	}

	bool blk_crypto_config_supported_natively(struct block_device *bdev,
						  const struct blk_crypto_config *cfg)
	{
		return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
						  cfg);
	}

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

