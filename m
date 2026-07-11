Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2C51D54FA
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 04:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783744222; cv=none; b=ZZ+0pW17eiP0jobSdTHq3dTxCHVTCOAR0sxuhzpBUKmrDUo/9sxSkoiDMy8D3zYNXm8HrHH3ZdUreEukTIoqM6NlCzSbS6LWFDtky8qxpu84I0CLvq5u3v7h7ag89OoUJr3TOXURgmNqg+Epk6E1J845+nt7cN8F32ydFBH5wp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783744222; c=relaxed/simple;
	bh=thFlBRAAO/4l9doZBdt4IIFMNpk8A1af+CGufQ3YInc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxYSt2dbGUO782SZsQK4HZY+Coyus47mdPkPdLVaA7GOIugd5XIEW2agUuX4pOymCDU03hjSjIf4ebpVWzqlM0po+KseCOgSTmLKk0FLwl2keEycMZ5uo5YZVs85UM9fBNX7KmjQjljNcNkWo4zcE3yNiihlEmW/Fw2x5Uwxk6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6MwNerI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6MwNerI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9F51F000E9;
	Sat, 11 Jul 2026 04:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783744221;
	bh=jEgcAxCuBFn23pLTCc9aTnMLfFOg3diSDqvT/BgZBoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d6MwNerIe9hG9VXw0fFYjoO0HMYmnEM67vDWqXqRsmLinD/QUSR1iayoy12n3fO0q
	 GvghpnnkHEu/0sRIomVXdtJ0/aF3j3FWiGuxHNggTI0um55b4C7C6icr2UgLJqJKoQ
	 0IAGlxtVd5bRPEOHDyjMRa+hTnJYXtShUcAdDszss7c2hVuSv4DZhkZU06LOyH8nGA
	 vqAUObx313SSlrWFsMRGMudmPfa1t/4esGN5uMvjAPdMfKCcNQ++MCzNXhB5tyAvvX
	 UzrMofuGJnc28F//b4lQAkGxZEhYpCmO2V55+sBcu32ja3xK20X2VIDsST5RY7KB7Q
	 2hNXnGCOlPQXg==
Date: Sat, 11 Jul 2026 00:30:18 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	mpatocka@redhat.com, snitzer@kernel.org, bmarzins@redhat.com
Subject: Re: [PATCHv5 3/3] dm-crypt: allow unaligned bio_vecs for direct io
Message-ID: <20260711043018.GA20714@quark>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-4-kbusch@meta.com>
 <20260711005440.GA7610@quark>
 <alHDG19tfq8lMSQz@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alHDG19tfq8lMSQz@kbusch-mbp>

On Fri, Jul 10, 2026 at 10:14:19PM -0600, Keith Busch wrote:
> On Fri, Jul 10, 2026 at 08:54:40PM -0400, Eric Biggers wrote:
> > 
> > So what is the minimum SG entry length alignment this can result in?
> > Once that get misaligned enough, crypto_skcipher_encrypt() and
> > crypto_skcipher_decrypt() start allocating bounce buffers internally.
> > That code has no mempool fallback and can fail with ENOMEM.
> 
> I'm not the one introducing ENOMEM consideration here.

You are.  This patch starts allowing misaligned segments, which trigger
the use of bounce buffers in the crypto code as I explained.  Currently,
dm-crypt relies on its alignment requirement to avoid those cases.

> Indeed, patch 2 in this series addresses this very thing ahead of what
> I'm asking for.

I don't think patch 2 is sufficient, as BLK_STS_RESOURCE is often not
going to get handled correctly.

> > I think you'll need to take the limitations of crypto_skcipher into
> > account.  See the comment above CRYPTO_ALG_ALLOCATES_MEMORY.
> 
> The block layer's queue limits is the single source of truth for what
> the backing device at any layer can accept. If you've some constraints
> that are not appropriately described there, then let's fix that.

I agree that dm-crypt's queue limits should accurately describe its
constraints.  This patch makes it no longer do so.

- Eric
