Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C4BC4332F
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 20:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667852773;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yBGXobG3zjPHJ6T+9b7UswCaG/+Rl+WHeOSjN/Ydgx0=;
	b=Buhxfr3KhRSZQ6vXKHmSxQV7jOYSNCLmBdIX9/iMXa/QHQEc1gn59GnmCf+acvBTHH8+3x
	bJnNp0+VNv06jHhISNEw/fmkhfuQevE2FExsjss4tzoyXlHxO/l6POTFSdpvolrdKxvDHj
	+G4tPTj1gjKX/j9xh0EAn8MC0IlE+wQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-4Nto0pYuM1aNftgjxIMk6g-1; Mon, 07 Nov 2022 15:26:09 -0500
X-MC-Unique: 4Nto0pYuM1aNftgjxIMk6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 432053C0E462;
	Mon,  7 Nov 2022 20:26:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 310E7140EBF5;
	Mon,  7 Nov 2022 20:26:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 12DE61946588;
	Mon,  7 Nov 2022 20:26:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B64E31946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 20:26:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 780382166B31; Mon,  7 Nov 2022 20:26:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 707032166B29
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 20:26:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C59085A59D
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 20:26:06 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-rgYj-h0FM6mQyf1iOlbIJg-1; Mon, 07 Nov 2022 15:26:04 -0500
X-MC-Unique: rgYj-h0FM6mQyf1iOlbIJg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 05B40CE178C;
 Mon,  7 Nov 2022 20:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37EBC433C1;
 Mon,  7 Nov 2022 20:16:23 +0000 (UTC)
Date: Mon, 7 Nov 2022 12:16:22 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y2lnloNN5wovDBMF@sol.localdomain>
References: <20221107144229.1547370-1-hch@lst.de>
 <20221107144229.1547370-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221107144229.1547370-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 1/3] blk-crypto: don't use struct
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 07, 2022 at 03:42:27PM +0100, Christoph Hellwig wrote:
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index a496aaef85ba4..0e0c2fc56c428 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -357,17 +357,18 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
>   * request queue it's submitted to supports inline crypto, or the
>   * blk-crypto-fallback is enabled and supports the cfg).
>   */

Replace "request queue" with block_device in the above comment?

> -bool blk_crypto_config_supported(struct request_queue *q,
> +bool blk_crypto_config_supported(struct block_device *bdev,
>  				 const struct blk_crypto_config *cfg)
>  {
>  	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
> -	       __blk_crypto_cfg_supported(q->crypto_profile, cfg);
> +	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
> +	       				  cfg);
>  }

There's a whitespace error here:

$ checkpatch 0001-blk-crypto-don-t-use-struct-request_queue-for-public.patch
ERROR: code indent should use tabs where possible
#87: FILE: block/blk-crypto.c:365:
+^I       ^I^I^I^I  cfg);$

WARNING: please, no space before tabs
#87: FILE: block/blk-crypto.c:365:
+^I       ^I^I^I^I  cfg);$

> -int blk_crypto_evict_key(struct request_queue *q,
> +int blk_crypto_evict_key(struct block_device *bdev,
>                          const struct blk_crypto_key *key)
>  {
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
>	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
>		return __blk_crypto_evict_key(q->crypto_profile, key);
>
>	/*
>        * If the request_queue didn't support the key, then blk-crypto-fallback
>        * may have been used, so try to evict the key from blk-crypto-fallback.
>        */
>	return blk_crypto_fallback_evict_key(key);

Likewise, s/request_queue/block_device/ in the above comment.

> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
> index 69b24fe92cbf1..b314e2febcaf5 100644
> --- a/include/linux/blk-crypto.h
> +++ b/include/linux/blk-crypto.h
[...]
>
> struct request;
> struct request_queue;

These forward declarations are no longer needed and can be removed.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

