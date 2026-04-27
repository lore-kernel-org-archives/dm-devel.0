Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE4B362154
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 05:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777267423; cv=none; b=ntkBWtXCzeIuTgAaVLSwu6VxGBOp0c9sx5kQljDdbOBhb1ByPc6JhAns367xm7YfowJSGvOjVtuoDXyeowryYUroj8ngIvqQjW3pLvnqSLUETxTwox0Qe2K81F6nfRT7vIEqSQQBD+uBEJ92BnPPIo1aeC5c5X3aJkLiBFhTdHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777267423; c=relaxed/simple;
	bh=TaDJDtde7lmdovAVn4/cN24TnFXlh156C1G+16pV8a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=GrXhuDOUTOJyWa9cJlh43jmqDCqBp0tSqCS/m1FUVojuyl+x0oyFpdv0zwx6lRGFM+/V+GSZCbzpolDiTGVDbRN+IwR2HdIgg8GzkvsADdotfNdM285cOyRJYXghYB1TFB9SS1nwwgjGabrgIFNkFdBya8vaemN/D3ZrQhwT5Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WY5dsgER; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WY5dsgER"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777267421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RFj+kFX2/CO3wrhbNQi5YAiqCNR9Dlvsv2leYhL2jPo=;
	b=WY5dsgERmkSM9vFvaZY/vLlkVHAFRCWW1AvGCDFcFalhT9CwYqTjexVFRh3BmgGY38VdgJ
	ZVqAeD/P5550e0qJ35dpuFOYHWaGgsNFtVU13XeUYe1ZpF/dMW/KwO5fbLk+u97YnVGpCN
	p9djMmLxlorF80eJ12E1ddDCQw0KdfE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-sPR_0_h4MGO6rGfMvxZ0Yw-1; Mon,
 27 Apr 2026 01:23:36 -0400
X-MC-Unique: sPR_0_h4MGO6rGfMvxZ0Yw-1
X-Mimecast-MFC-AGG-ID: sPR_0_h4MGO6rGfMvxZ0Yw_1777267414
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 834D21956089;
	Mon, 27 Apr 2026 05:23:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56D41180047F;
	Mon, 27 Apr 2026 05:23:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63R5NVg32710994
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 01:23:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63R5NRQ92710993;
	Mon, 27 Apr 2026 01:23:27 -0400
Date: Mon, 27 Apr 2026 01:23:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <ae7yzw-5wz9cqZt8@redhat.com>
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 2jX33pImzgvkrxvmkyWlCDKYYx8mN0_gtdUjCMHbS6g_1777267414
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a new device-mapper target "dm-inlinecrypt" that is similar to
> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> This allows it to take advantage of inline encryption hardware such as
> that commonly built into UFS host controllers.
> 
> The table syntax matches dm-crypt's, but for now only a stripped-down
> set of parameters is supported.  For example, for now AES-256-XTS is the
> only supported cipher.
> 
> dm-inlinecrypt is based on Android's dm-default-key with the
> controversial passthrough support removed.  Note that due to the removal
> of passthrough support, use of dm-inlinecrypt in combination with
> fscrypt causes double encryption of file contents (similar to dm-crypt +
> fscrypt), with the fscrypt layer not being able to use the inline
> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
> as Android that use fscrypt and where a more optimized approach is
> needed.  It is however suitable as a replacement for dm-crypt.
> 
> dm-inlinecrypt supports both keyring key and hex key, the former avoids
> the key to be exposed in dm-table message. Similar to dm-default-key in
> Android, it will fallabck to the software block crypto once the inline
> crypto hardware cannot support the expected cipher.
> 
> Test:
> dmsetup create inlinecrypt_logon --table "0 `blockdev --getsz $1` \
> inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0"
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/md/Kconfig          |  10 +
>  drivers/md/Makefile         |   1 +
>  drivers/md/dm-inlinecrypt.c | 559 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 570 insertions(+)
>  create mode 100644 drivers/md/dm-inlinecrypt.c
<snip> 
> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> new file mode 100644
> index 000000000000..b6e98fdf8af1
> --- /dev/null
> +++ b/drivers/md/dm-inlinecrypt.c
<snip>
> +static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
> +{
> +	const struct inlinecrypt_ctx *ctx = ti->private;
> +	sector_t sector_in_target;
> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
> +
> +	bio_set_dev(bio, ctx->dev->bdev);
> +
> +	/*
> +	 * If the bio is a device-level request which doesn't target a specific
> +	 * sector, there's nothing more to do.
> +	 */
> +	if (bio_sectors(bio) == 0)
> +		return DM_MAPIO_REMAPPED;
> +
> +	/*
> +	 * The bio should never have an encryption context already, since
> +	 * dm-inlinecrypt doesn't pass through any inline encryption
> +	 * capabilities to the layer above it.
> +	 */
> +	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
> +		return DM_MAPIO_KILL;
> +
> +	/* Map the bio's sector to the underlying device. (512-byte sectors) */
> +	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
> +	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
> +	/*
> +	 * If the bio doesn't have any data (e.g. if it's a DISCARD request),
> +	 * there's nothing more to do.
> +	 */
> +	if (!bio_has_data(bio))
> +		return DM_MAPIO_REMAPPED;
> +
> +	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
> +	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
> +	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
> +		return DM_MAPIO_KILL;
> +	dun[0] >>= ctx->sector_bits - SECTOR_SHIFT; /* crypto sectors */
> +
> +	/*
> +	 * This check isn't necessary as we should have calculated max_dun
> +	 * correctly, but be safe.
> +	 */
> +	if (WARN_ON_ONCE(dun[0] > ctx->max_dun))
> +		return DM_MAPIO_KILL;
> +
> +	bio_crypt_set_ctx(bio, &ctx->key, dun, GFP_NOIO);
> +
> +	/*
> +	 * Since we've added an encryption context to the bio and
> +	 * blk-crypto-fallback may be needed to process it, it's necessary to
> +	 * use the fallback-aware bio submission code rather than
> +	 * unconditionally returning DM_MAPIO_REMAPPED.
> +	 *
> +	 * To get the correct accounting for a dm target in the case where
> +	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
> +	 * true), call __blk_crypto_submit_bio() directly and return
> +	 * DM_MAPIO_REMAPPED in that case, rather than relying on
> +	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
> +	 */
> +	if (__blk_crypto_submit_bio(bio))

This will still double account for fallback writes (which call
submit_bio() on the encrypted bios, and return DM_MAPIO_SUBMITTED here). 

-Ben

> +		return DM_MAPIO_REMAPPED;
> +	return DM_MAPIO_SUBMITTED;
> +}

