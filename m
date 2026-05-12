Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB734F48A;
	Tue, 12 May 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778612017; cv=none; b=CLWRdN/qj70GQB6gOjaSk8jztPRydu+yKySsfIsIP2gDry9ThQYRw9+m05IjxWPwBE2F3m+stHAobuxoD2yyi4HN8gzX3Ntz2sq0TkRF1QLWUbOL5i3eaIAyEjbOyconqT/bCcpGaKIkUiLAlUIXp7aKivCP6v/m4cOoC7guu6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778612017; c=relaxed/simple;
	bh=uMz7MW+SWq5AWMBcgDdU0w3RFBHT9PqHFn8eO9emi3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwUCaY8M/I0gtIb+xvlEhOddPMfOjrvLzgtKahZV6xs+ufhlT2QfUdF9Eol24ZUBLXTlMjR8Yp2Qm74s9PgnEtoqh/Kbu0XZn8KtZMfrSyuogpOM9ZvJWVzJoP5tz7upWbNYi05fvFnI5J5ZMntQE5L3lTx036v6Yi+X5g0uvmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCVtyK6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCVtyK6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5147C2BCB0;
	Tue, 12 May 2026 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778612017;
	bh=uMz7MW+SWq5AWMBcgDdU0w3RFBHT9PqHFn8eO9emi3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TCVtyK6exqsVcsftpztAwRt7AAsl7Ga1b75aTH9GGmwWawAZQ8mHa/z9zOsYowlTZ
	 uOTXBzIWyBnfhIx+CuHylpFbhHSuA4iHNz6QIlcwZyjZnsPjqTubNc6Pm/PbaYL458
	 oNfXSARJRoP2XTaSur/5T2J6ho94LF+sbM3Hxh5tuMyqEy3z+TCScgz136l7sN3iy4
	 YEd/dw0OSNd7xGksLJo0CGExhyQTeWznu/rkt5hBNVKZjYWczYAxBz8qbNXLhvob2H
	 kyuDmXo4RjPXlxPaIHVk+FxQk1ou2jGAYT84vpSErJlvctRB3B7jSOzSoUSR1u03T3
	 vDfzROs4MieYA==
Date: Tue, 12 May 2026 18:53:35 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] dm-inlinecrypt: initialize blk-crypto key as
 HW-wrapped key
Message-ID: <20260512185335.GA3085076@google.com>
References: <20260512095203.3688708-1-linlin.zhang@oss.qualcomm.com>
 <20260512095203.3688708-2-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512095203.3688708-2-linlin.zhang@oss.qualcomm.com>

On Tue, May 12, 2026 at 02:52:03AM -0700, Linlin Zhang wrote:
> dm-inlinecrypt currently initializes the blk-crypto key using
> BLK_CRYPTO_KEY_TYPE_RAW, which implies that the provided key material
> is a plaintext software key owned by the block layer.
> 
> However, on platforms where dm-inlinecrypt is used together with a
> hardware-backed key source (e.g. TrustZone/TEE or other secure key
> wrapping mechanisms), the key material passed down is already wrapped
> and must be treated as opaque by the block layer.
> 
> Initialize the blk-crypto key using BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> instead, so that dm-inlinecrypt correctly models hardware-wrapped keys
> and avoids incorrect assumptions about key ownership and visibility.
> 
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/md/dm-inlinecrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> index bd8e58a028c5..bcbf363c533a 100644
> --- a/drivers/md/dm-inlinecrypt.c
> +++ b/drivers/md/dm-inlinecrypt.c
> @@ -386,7 +386,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
>  
>  	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
> -				  BLK_CRYPTO_KEY_TYPE_RAW,
> +				  BLK_CRYPTO_KEY_TYPE_HW_WRAPPED,
>  				  cipher->mode_num, dun_bytes,
>  				  ctx->sector_size);

The raw key support is useful too, and it should be the default.
I recommend adding a "wrappedkey" optional argument that enables
BLK_CRYPTO_KEY_TYPE_HW_WRAPPED.

- Eric
