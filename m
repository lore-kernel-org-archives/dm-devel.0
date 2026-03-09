Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CED38BF91
	for <dm-devel@lists.linux.dev>; Mon,  9 Mar 2026 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773064892; cv=none; b=Gvmz13Nprg3jf4WMUwQWajH5L2zUFL+tLJgGOfmUzLvTFXSiRSBWW7qM8FaoIa2GeA6fyfS/tLk+E7zTF38k3C0bmsoT4XOV8EKLfmKYGx2oDKUvJj3xlW5YqyM9VWafIBWvCbMohauJW9u6HDPNJVxFm4Ktu7fKP7Tv6PDtOtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773064892; c=relaxed/simple;
	bh=EEOTlo86A7ZfBDzwp1r8PpCOvEmtkfd/bbw+Elh5c74=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LoFCfrecCCZ3W1h5RwPHYziXOFnBFwzJ4WEOsJ5g6yAJWPZT8fJsFgTSGcXsI0pE2moK0iLiyRA+krVncJHdKFrnTXjw01moQlNqeDwnTtRrPGnBGjcbjeWO+gh+m99xVS/u0V4HCpLhex0AQBnRiyRf48SCvxv/nC+ZzJpCicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BWhIsodJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWhIsodJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773064890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gAFp5NffJ90d8jxyKdfFgqhADKMayxhkc4+zwPm9YPY=;
	b=BWhIsodJ5m0KAnnq9ZXrZbN3GLDaBiXSkAoLKn1z3HXx6pjKXStbUGarXMWu+M7j6ehfTx
	TdaIqJMYURzWR3gY4kDQiCGjJeKEs+HjKHe3R/eKj/f9rYdk1efMHR158YF5b4JOHAO9JB
	vXtcEDbsnriXKK9X08ROy4kdipIJUOM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-xEKTaFEcNoKp-_nIPIXWeQ-1; Mon,
 09 Mar 2026 10:01:26 -0400
X-MC-Unique: xEKTaFEcNoKp-_nIPIXWeQ-1
X-Mimecast-MFC-AGG-ID: xEKTaFEcNoKp-_nIPIXWeQ_1773064884
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5709419560BC;
	Mon,  9 Mar 2026 14:01:24 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6F8B19560A6;
	Mon,  9 Mar 2026 14:01:21 +0000 (UTC)
Date: Mon, 9 Mar 2026 15:01:18 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: linux-block@vger.kernel.org, Linlin Zhang <linlin.zhang@oss.qualcomm.com>, 
    ebiggers@kernel.org, linux-kernel@vger.kernel.org, adrianvovk@gmail.com, 
    dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com, 
    israelr@nvidia.com
Subject: Re: [PATCH v1 1/3] block: export blk-crypto symbols required by
 dm-inlinecrypt
In-Reply-To: <20260304121729.1532469-2-linlin.zhang@oss.qualcomm.com>
Message-ID: <4fe2e556-2190-0cc1-08b3-96046432d48d@redhat.com>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com> <20260304121729.1532469-2-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: TeJwiUSZRFfZTvtDdQS_JS_Yv0C84_49fEQXzUj2NIM_1773064884
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Jens

Would you please ack this block layer patch, so that I can add it to the 
device mapper tree?

Mikulas


On Wed, 4 Mar 2026, Linlin Zhang wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> bio_crypt_set_ctx(), blk_crypto_init_key(), and
> blk_crypto_start_using_key() are needed to use inline encryption; see
> Documentation/block/inline-encryption.rst.  Export them so that
> dm-inlinecrypt can use them.  The only reason these weren't exported
> before was that inline encryption was previously used only by fs/crypto/
> which is built-in code.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/blk-crypto.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index 856d3c5b1fa0..40a99a859748 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -116,6 +116,7 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
>  
>  	bio->bi_crypt_context = bc;
>  }
> +EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
>  
>  void __bio_crypt_free_ctx(struct bio *bio)
>  {
> @@ -349,6 +350,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(blk_crypto_init_key);
>  
>  bool blk_crypto_config_supported_natively(struct block_device *bdev,
>  					  const struct blk_crypto_config *cfg)
> @@ -399,6 +401,7 @@ int blk_crypto_start_using_key(struct block_device *bdev,
>  	}
>  	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
>  }
> +EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
>  
>  /**
>   * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
> -- 
> 2.34.1
> 

