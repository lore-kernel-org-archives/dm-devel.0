Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D46344DAA;
	Mon, 22 Jun 2026 18:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782152611; cv=none; b=DtiCvfqsRttIzrJC1cM5dXbWdezka8fFGkgIzqZEKN8d+Mscdj37jubfevBS7AaVNJlDAKV3SXEajgBXxpK53KcK7A/UqAKxP2AeyVxdCWxt6J93LK0HOeJGxK/RH/sovTbunmwO3SqsLgU2Q2dBn3yviLqvLoHvbltu/rgdlC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782152611; c=relaxed/simple;
	bh=snCGNA7GPy+fZfLOt/Rz5RAbiBdpMxpSM4rpgtn9XGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFmCIt/xtJm7btqB480jH9iX3DTJkGDqIqLyfAu7CHCC5dqyQLp6eQ/zhqft3KKe1S/8Js7p6fxKB5Jf5kj5uAUtdFEBQfUf3nYUJFK1ASpDDwwlN9RuGMd+x/8H1Zi74aUom3P1r14W2z2jwsEmUgPdRrMtJyJYm4YNf0QVhIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otS4Sns3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otS4Sns3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AB21F000E9;
	Mon, 22 Jun 2026 18:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782152610;
	bh=y1inLTfbxBlQmyy5Blkro32FzKOSobQAi18KXnBA5vQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=otS4Sns3RymUYZmk1d/ZmxH43EtlUaLYbPGz4OJK4UzCvuS8ppAtC1fy0/SaZaxM8
	 hNSkRVepudsrFKZ4tL81dXVXRQ/BdMUe/34jHr5BrsiuKjHb7Aw+u/x/jhKFe6L99O
	 whtFEaiwhnmpQFU+8NxlIttGJ/oEcJ4dg0vlwvWurhlj133ZBZkUytHOoZckhC88fB
	 Z0xHHIEfR52gwOXLw/JYcR2EkvFmk7vWBUy7hKttVQVxV63yFHLBWCBWo49nqUocbX
	 aILStthasEzlnXCXSGklIwmy12xIhTz5NxtsfoHpzVhpEsYHElvy304DFjoQTnXlG8
	 r0OK7/ipurK7w==
Date: Mon, 22 Jun 2026 18:23:28 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Leonid Ravich <lravich@amazon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/3] crypto: skcipher - per-request multi-data-unit
 batching
Message-ID: <20260622182328.GB1250822@google.com>
References: <ajDWww8OgNcXs73c@gondor.apana.org.au>
 <20260622071044.4079-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622071044.4079-1-lravich@amazon.com>

On Mon, Jun 22, 2026 at 07:10:44AM +0000, Leonid Ravich wrote:
> On Mon, Jun 15, 2026 at 03:53:17PM -0700, Eric Biggers wrote:
> > So in other words, this series slows down dm-crypt and crypto_skcipher
> > for everyone to optimize for an out-of-tree driver.  And there's also no
> > benchmark showing that your driver is even worth it over just using the
> > CPU.
> 
> I measured on arm64 (Graviton3, dm-crypt + xts-aes-ce, RAM-backed,
> fixed CPU freq):
> 
>   - 4 KiB random write, 512-byte sectors: v4 as posted regressed ~5%.
>     Root cause (ftrace): a per-bio kmalloc_array() for the scatterlists,
>     where the per-sector path uses dm-crypt's inline sg_in[]/sg_out[].
> 
>   - Reusing the inline arrays when the segment count fits (heap only for
>     larger bios) removes the regression, back to parity. This will be in
>     the dm-crypt patch for v5.
> 
> So the software path is neutral after the fix, not slower. No software throughput win
> either: the auto-splitter still calls alg->encrypt per data unit. The win
> is for a consumer that takes the whole request in one pass, a HW engine,
> or any async offload engine that pays a fixed per-request cost,
> it currently pays once per sector instead of once per bio.
> 
> I'd rather not over-complicate the patches until there's a general
> ack on the direction: per-request data_unit_size + auto-split,
> enabling one-pass consumers, neutral for everyone else. Is that direction
> acceptable? If so I'll respin v5.

I don't think there's a path forward without an in-tree user that's
shown to be worthwhile over just using the acceleration built directly
into the CPU.  As well as confirmation of no regression to existing
users, including in cases where the inline sg list can't be used.

- Eric
