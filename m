Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E79136358
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 00:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783731284; cv=none; b=BX1jMN8CrCJcPwK6Ry/VP/VrV9WX0+kW5dwT9WKHR2ok+uhqZrS7p2sWDytEPzNqXklIJe4uk17JzBytNZ00Iai1UtsNRd1na+tApliNX9UyDgoRLCNHioA86KIP04m/OKrFWXV6xf/RjZz6ciSvaBedyCPmE/wfHENyqkM0/hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783731284; c=relaxed/simple;
	bh=QGtm/3ID5P4nBS65RlqhIwz9eK+RbrymoUkaquxpplE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9sbQbKLE3UqgrCS6mmM6sAUpM7Vi16NrhMIekH4e09KNiSvr0wQApWKEE1ooulhojFze5mka5x0uVXzqsX6a/LtS8gJDDc/VmGDzWJMssUkJMi7n1Ymhi1DpvB1Mt7Xpbjgp0FzhupO7qeCsW+h4ccJ6d/mX11jCCEjt4WNwdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpvxLuDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpvxLuDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEDE1F000E9;
	Sat, 11 Jul 2026 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783731282;
	bh=2rzCkw2b72Fp++XsziXQfIfZQh6P+JdnCOgO32TXev4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KpvxLuDdIa+Y5caK+aUy5/18LqNAf9tTUTxzbSP5eck/TBBRikXmjDw1gEZIIpTRJ
	 AZFGTuD4kzNSMLVzKBbHX2/l5f1+bidlDxoi2J62RBPLEoPXtjr+cOa1dSiURt0no7
	 mwQBwNnZh1QUzyPQvytu90jt+541xt5ep1gxtqkmNBOA0zfYeRM4/5mLVCrsp0+0Ex
	 8UOO909QDH2hXMx4o4Lrlg5QCsVlB7iMASOf6HBI0y3wlgqj4WeF6Khoy5rBrzW9rF
	 kXjE7jp5fCJIijaC4xlyrg0ePCqbsH+FDrmESv2Jy6g8BFNf7RJjv6WOtb+YXwIqlV
	 OZbIXrxHHbTZA==
Date: Fri, 10 Jul 2026 20:54:40 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, snitzer@kernel.org,
	bmarzins@redhat.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 3/3] dm-crypt: allow unaligned bio_vecs for direct io
Message-ID: <20260711005440.GA7610@quark>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709161519.1559723-4-kbusch@meta.com>

On Thu, Jul 09, 2026 at 09:15:19AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Many storage devices can handle DMA for data that is not aligned to the
> logical block size. The block and filesystem layers have introduced
> updates to allow that kind of memory alignment flexibility when
> possible.
> 
> dm-crypt, however, currently constrains itself to aligned memory because
> it sends a single scatterlist element for the in/out list to the encrypt
> and decrypt algorithms. This forces applications that have unaligned
> data to copy through a bounce buffer, increasing CPU and memory
> utilization.
> 
> Use multiple scatterlist elements as needed to relax the memory
> alignment requirement. To keep this simple, this more flexible
> constraint is enabled only for certain encryption and initialization
> vector types, specifically the ones that don't have additional use for
> the request scatterlist elements beyond pointing to user data.
> 
> In the unlikely case where the incoming bio uses a highly fragmented
> vector, the four inline scatterlist elements may not be enough, so
> allocate a temporary scatterlist when needed, falling back to a mempool
> for the in and out buffers to guarantee forward progress if the initial
> allocation fails.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

So what is the minimum SG entry length alignment this can result in?
Once that get misaligned enough, crypto_skcipher_encrypt() and
crypto_skcipher_decrypt() start allocating bounce buffers internally.
That code has no mempool fallback and can fail with ENOMEM.

I think you'll need to take the limitations of crypto_skcipher into
account.  See the comment above CRYPTO_ALG_ALLOCATES_MEMORY.

Note: I'm working on fixing at least AES-XTS to not allocate memory
(https://lore.kernel.org/linux-crypto/20260707053503.209874-12-ebiggers@kernel.org/).
But segment lengths not a multiple of 16 bytes will always be
inefficient to process and really should be avoided.

- Eric
