Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9399FC4332F
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 20:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667852648;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cproI/A2yaVf8iS7Zt5/HOwYXxVj1Pryuv2YsTIlN8s=;
	b=SRO3+9264BBWwUqoZeKKhwXLV3eJ0R77n3UqjYXZS3xHed4T7APKcoq0omusAxwd+ly8vY
	cygRSI8wYVO876F3BDzzIZ+dpjfG6V4ij3LAFiT0HGBbnCLNFa7aG8OCha8tbWjW254BN+
	HkqkT9rxQYpoVl+L0HmHaO9+8VKR250=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-AkNU7GAAP_KNYsCSa7qOjg-1; Mon, 07 Nov 2022 15:24:06 -0500
X-MC-Unique: AkNU7GAAP_KNYsCSa7qOjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E28F3185A7A3;
	Mon,  7 Nov 2022 20:24:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90D05140EBF5;
	Mon,  7 Nov 2022 20:24:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 563971946588;
	Mon,  7 Nov 2022 20:24:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1517A1946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 20:24:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2A2F477F5F; Mon,  7 Nov 2022 20:24:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB5BC477F5E
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 20:24:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90D05811E67
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 20:24:01 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-c8yv4uMfMnSbfCGuWVq6Sw-1; Mon, 07 Nov 2022 15:23:59 -0500
X-MC-Unique: c8yv4uMfMnSbfCGuWVq6Sw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 808BE61182;
 Mon,  7 Nov 2022 20:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FEEC433C1;
 Mon,  7 Nov 2022 20:23:57 +0000 (UTC)
Date: Mon, 7 Nov 2022 12:23:56 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y2lpXPD2jlumpNfr@sol.localdomain>
References: <20221107144229.1547370-1-hch@lst.de>
 <20221107144229.1547370-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221107144229.1547370-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 3/3] blk-crypto: move
 __blk_crypto_cfg_supported to blk-crypto-internal.h
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

On Mon, Nov 07, 2022 at 03:42:29PM +0100, Christoph Hellwig wrote:
> __blk_crypto_cfg_supported is only used internally by the blk-crypto
> code now, so move it out of the public header.

"public header" is ambiguous here.  blk-crypto.h is the "public header" for
upper layers, but blk-crypto-profile.h is the "public header" for drivers.
Maybe write "blk-crypto-profile.h, which is included by drivers".

> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index e6818ffaddbf8..c587b3e1886c9 100644
> --- a/block/blk-crypto-internal.h
> +++ b/block/blk-crypto-internal.h
> @@ -19,6 +19,9 @@ struct blk_crypto_mode {
>  
>  extern const struct blk_crypto_mode blk_crypto_modes[];
>  
> +bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
> +				const struct blk_crypto_config *cfg);
> +
>  #ifdef CONFIG_BLK_INLINE_ENCRYPTION

It should go in the '#ifdef CONFIG_BLK_INLINE_ENCRYPTION' section.

> diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
> index bbab65bd54288..e990ec9b32aa4 100644
> --- a/include/linux/blk-crypto-profile.h
> +++ b/include/linux/blk-crypto-profile.h
> @@ -144,9 +144,6 @@ blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
>  
>  void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
>  
> -bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
> -				const struct blk_crypto_config *cfg);
> -
>  int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
>  			   const struct blk_crypto_key *key);

Otherwise I guess this patch is fine.  The exact same argument would also apply
to blk_crypto_get_keyslot(), blk_crypto_put_keyslot(), and
__blk_crypto_evict_key(), though.  It might be worth handling them all in one
patch.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

