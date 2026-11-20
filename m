Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208304;
	b=D6NDalR/epqkF55E3k91b7cbHBZ9Mrk+v2vJDfi6EO6r3/Z4DJEGMqOASBsKrBiDBOfY
	 94tL9/RTKsMAz2yYGt+/6JR7brVKEPUYnx/dFBtbbaTs2Oap9e61VYqlkFf1a0RN9nHmh
	 w4VgvCzNiT6xYbwyGVDhCfRRbYC4R76xSoe8cDXop52oNHs9s+wXldFITjrbrPiR75OdU
	 0MLk2dtWqLv8PriH2S0dALd7YZBogqQ+Pae9qkYywekqbDZFe70NviIkcmlo7WCb3ocAe
	 2uMUhLfpK4eJMrJIqKLUjkfHxm2N/zwUprJjwaLZejBvhrQAFyhalQL4jOoG+iFqiFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208304;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AB51lBLhMDoTfUd45tPOHSpsAw7sjsiX6axY2N+ILsQ=;
	b=AmHxpKxwLOBTZWKjM3P5SxKkRX0+rUl67zgK77aNIoz28OogO9q/agkDsPmEwpGxljdH
	 doL9zVUPs2jq+lL1iRxlDq4JAVfVkliYMg+RK5+Q/BoQ/15JVRT8svL6z6owrNTtdUZTB
	 hceYUATwBZM6x8M6BTw44hOUvbzTFOMz/tIm3+zT7nJdCXVbbBF8VymfMGfa9fd1LOkGr
	 iydOztkc5+fOW9QVVG9EG8BTuALlrY4IULA2NKVaCv/2haucMkf2BOv/Yt95k0/6ZBLAw
	 clAvx5XQEwma8OFn4ZzE0CG8nhoDsz17BNGoAqQg+WZkXlqOhOnEBiDBssvnsTDF2sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aQzIhey4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177D3606A69C;
	Fri, 20 Nov 2026 20:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aQzIhey4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB4A1F000D2;
	Fri, 20 Nov 2026 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208303;
	bh=AB51lBLhMDoTfUd45tPOHSpsAw7sjsiX6axY2N+ILsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aQzIhey4dgED9DabrvhzvK06B9EnK0nbLSY2jQCvfJxPd0L5ROHkDM3KZ0E095ILv
	 z4tUvE/PadBduFrDsSEE0gUZNn+gvR9n4TLJFa2jcmb1E96hH4THvlLfjANMCL0qMr
	 TgdGH/xvVSkn5MM/uJpJ2154FxIr60nRlBz9W8/8eep3vt96deMPYgHihdhjb16+yw
	 TJeB496hcbQ7CUU7qDREiF3+QilyJJkhIppuRNlY4r1gvHX5H7zzR45IrCn0+xl/XI
	 nD3T5722mz9vpuMQhXNPyA/HUT3t2KhQ84i0417+ceIlQCT9Ppa2AjfaZmpCUFBpjn
	 QPgxt5bByxtkA==
Date: Fri, 20 Nov 2026 20:58:21 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Anvik Loitongbam <permissiontogallop@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-inlinecrypt: emit key type as an optional table
 argument
Message-ID: <20261120205821.GA3048696@google.com>
References: <20261120163601.114199-1-permissiontogallop@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120163601.114199-1-permissiontogallop@gmail.com>

On Fri, Nov 20, 2026 at 10:06:01PM +0530, Anvik Loitongbam wrote:
> inlinecrypt_status() emits ctx->key_type as a positional argument between
> the key and iv_offset:
> 
>   <cipher> <key> <key_type> <iv_offset> <dev_path> <start>
> 
> but inlinecrypt_ctr() parses the base table as:
> 
>   <cipher> <key> <iv_offset> <dev_path> <start>
> 
> and keytype, is an optional feature argument parsed by
> inlinecrypt_ctr_optional(). Resulting in STATUSTYPE_TABLE output for every
> dm-inlinecrypt device to be not reloadable, the constructor reads key_type as
> iv_offset and shifts the remaining fields.
> 
> Keep the base table in constructor order and emit a non-default key type
> as keytype:hw-wrapped in the optional feature list. Raw keys remain the
> default and are not emitted, preserving the existing table text for
> raw-key devices.
> 
> The two dmsetup examples in the documentation acquired
> the same extra positional key-type field, so removed it there as well.
> 
> Fixes: f9f57971da38 ("dm-inlinecrypt: add support for hardware-wrapped keys")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anvik Loitongbam <permissiontogallop@gmail.com>

The original Sashiko review of this commit mentioned this bug already
(https://sashiko.dev/#/patchset/20260525121348.1321282-2-linlin.zhang%40oss.qualcomm.com).
Might be worth adding a Reported-by if you found it from there.

> +		if (ctx->key_type != BLK_CRYPTO_KEY_TYPE_RAW)
> +			num_feature_args++;
>  		if (ctx->sector_size != SECTOR_SIZE)
>  			num_feature_args += 2;
>  		if (num_feature_args != 0) {
>  			DMEMIT(" %d", num_feature_args);
> +			if (ctx->key_type != BLK_CRYPTO_KEY_TYPE_RAW)
> +				DMEMIT(" keytype:%s",
> +				       ctx->key_type == BLK_CRYPTO_KEY_TYPE_HW_WRAPPED ?
> +				       "hw-wrapped" : "raw");

The "raw" fallback case doesn't make much sense, because it was just
checked above that it is *not* raw.  So if it is ever reached due to a
new enum value it will be wrong anyway.  Maybe just leave that out and
simply do DMEMIT(" keytype:hw-wrapped").

Otherwise this fix looks good, thanks.

- Eric
