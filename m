Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1E64D98F7;
	Wed, 13 May 2026 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778692928; cv=none; b=X/VI9j4Z6to1obTcT3XjLlsss4CB+JPC9o3oiqAG1ipyv/D3W1BfcsDvdAarnLEzNcJ5ncWEPnyFiNkaMiGuQUbiMsb/aDC8t9rzvAM5nzUaTEIAgpvuKzdTptgKbFSEU5cucCpYvA89y0DqVYvv3tB2vsWEtt+0dG8OkoLIXHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778692928; c=relaxed/simple;
	bh=vJ5xRH+cfus+4ND3HiapUfnbllhhWZdJfo+TFI9R3Qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6xXmxX5LVKec3c6FPFwyIvOYDR3NoRsRzYlhqG4zVCjU46s84X/eERJKGEoftAPFQ1xdvW63TO67tSKGBj0yeI43lIyxcdjDtd9a03gma6I5rpovDcvZkTqePcBvCM/SlutsIvAh2zj2QSj1vYM5exHPfQNMunVFKJdfjPFuWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlKdcoph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlKdcoph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D8AC19425;
	Wed, 13 May 2026 17:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778692926;
	bh=vJ5xRH+cfus+4ND3HiapUfnbllhhWZdJfo+TFI9R3Qg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nlKdcophWXbbbfre9Hc7OUGejjPvchse7E+Hu8AIy5u90Wcyr+Y5+piPGhhVNYqHp
	 TyJd7lNQh700vdNT2ozY5SwWVGY5k/84+Lbz8HeS/ztHIF2ByXcZaYexXzzvMMtMhk
	 NOzw5gupKS+FrF1KJsHQRmstiFOT5DMWOrPp9G+s8uqdf78tfw1MQpOJqb1DJUh1Hz
	 WKlfPGhaBPGn9HrkZ/396Qk9isaunGKVxsp9Ndn4zbFxCiOtbVjK98qWAJr+kSeOg+
	 czR0i81I0/CXsV5Dw8sdyr5udmAhXn0Czq0bkA9oa86i78iKwz4GFF1MWWioUPDHJM
	 EIUtmGiXE55uQ==
Date: Wed, 13 May 2026 10:22:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] dm-inlinecrypt: initialize blk-crypto key as
 HW-wrapped key
Message-ID: <20260513172204.GB2128@quark>
References: <20260512095203.3688708-1-linlin.zhang@oss.qualcomm.com>
 <20260512095203.3688708-2-linlin.zhang@oss.qualcomm.com>
 <20260512185335.GA3085076@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512185335.GA3085076@google.com>

On Tue, May 12, 2026 at 06:53:35PM +0000, Eric Biggers wrote:
> On Tue, May 12, 2026 at 02:52:03AM -0700, Linlin Zhang wrote:
> > dm-inlinecrypt currently initializes the blk-crypto key using
> > BLK_CRYPTO_KEY_TYPE_RAW, which implies that the provided key material
> > is a plaintext software key owned by the block layer.
> > 
> > However, on platforms where dm-inlinecrypt is used together with a
> > hardware-backed key source (e.g. TrustZone/TEE or other secure key
> > wrapping mechanisms), the key material passed down is already wrapped
> > and must be treated as opaque by the block layer.
> > 
> > Initialize the blk-crypto key using BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> > instead, so that dm-inlinecrypt correctly models hardware-wrapped keys
> > and avoids incorrect assumptions about key ownership and visibility.
> > 
> > Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> > ---
> >  drivers/md/dm-inlinecrypt.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> > index bd8e58a028c5..bcbf363c533a 100644
> > --- a/drivers/md/dm-inlinecrypt.c
> > +++ b/drivers/md/dm-inlinecrypt.c
> > @@ -386,7 +386,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >  	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
> >  
> >  	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
> > -				  BLK_CRYPTO_KEY_TYPE_RAW,
> > +				  BLK_CRYPTO_KEY_TYPE_HW_WRAPPED,
> >  				  cipher->mode_num, dun_bytes,
> >  				  ctx->sector_size);
> 
> The raw key support is useful too, and it should be the default.
> I recommend adding a "wrappedkey" optional argument that enables
> BLK_CRYPTO_KEY_TYPE_HW_WRAPPED.

This patch also makes the variable called "raw_key" contain a key that
isn't a raw key, which is confusing.  "key_bytes" would make more sense
for a byte array that can contain either type of key.  See e.g.
blk_crypto_init_key() which uses that naming convention.

- Eric
