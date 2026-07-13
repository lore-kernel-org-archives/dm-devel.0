Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60A9322B8C
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 18:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783968899; cv=none; b=LtjoVRK2SkwtXFXDe6Fii1b/dRx5EJ35rBeHvYdM3N3kdKKEGiv0FQdLQuy+BeSQzMfcngJZx1rH7yyNItOYdoe/mZ2tEn+DRp8MOuLGQ6wLu1RdjK0aJyS2cfn3lZYMOKkA0F8ikkZIRd21rIk3H5C0QzEK9NqdTPO3ulFATnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783968899; c=relaxed/simple;
	bh=oiHYVs7OmZE7YvRszxUXtwAvlFpPJ6842qLs/WgvLxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6i4Rcmde17Z77xzJGzv4ASlEECuNPNZdDz7tmxgFnS/4X8YK5XF31P6VLR13Rh/1m3lv/rh7oQ6RFTCMR5CznWMRtMKw4AP93LNKaPRX8ERDoEgMvMMzLDR80ciVdCEOD07VIntZ4uE8ogLP8jpGSh3AvxwTnpTPbCzoaNwE48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dUh0zols; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUh0zols"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A1F1F000E9;
	Mon, 13 Jul 2026 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783968898;
	bh=2JWvvFcSZtlBR9z5iF5b8QAZGCnpHddmBpFZDexnx5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dUh0zolsf5Gn7oS2wyC0wNc+ogs0y4MxRvBEVliqkPpO19rZESV2WYEZsjVGLv/n+
	 9e5YRKri0fvonRuinsTeuJ/vePj0IvE6jF6qTWupvMMuFjlGG6xBfPqzZPzzO5aoWl
	 qDzhrRFDrY4tRJDWH1wMynBrZPrW+HLvez192SdJNCzSmmsOPwkDe3N2DCw3b9RDPm
	 673FcrhZCQKUuS8DvoiGh1zySLiJDz/rIJoYRbswgKYrVbJgqk0HZmtz+69A2YM73+
	 p7tkr0bvgxZLPLgaHv23tM6MVah1R5zs0O9vbH+LToAG+YbtxTGKpNVwSid73cKd7K
	 3IiMBy46wxLhw==
Date: Mon, 13 Jul 2026 12:54:56 -0600
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	mpatocka@redhat.com, snitzer@kernel.org, bmarzins@redhat.com
Subject: Re: [PATCHv5 3/3] dm-crypt: allow unaligned bio_vecs for direct io
Message-ID: <alU0gPWGDnBkRzFQ@kbusch-mbp>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-4-kbusch@meta.com>
 <20260711005440.GA7610@quark>
 <alHDG19tfq8lMSQz@kbusch-mbp>
 <20260711043018.GA20714@quark>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711043018.GA20714@quark>

On Sat, Jul 11, 2026 at 12:30:18AM -0400, Eric Biggers wrote:
> On Fri, Jul 10, 2026 at 10:14:19PM -0600, Keith Busch wrote:
> 
> I don't think patch 2 is sufficient, as BLK_STS_RESOURCE is often not
> going to get handled correctly.

In practice, I could only get the memory allocation failure to happen in
interrupt context due to the GFP_ATOMIC use, and that appears to be
handled correctly. If I synthesize memory failure in the process
context, then that is getting sent back to the application, so I assume
that's what you mean about BLK_STS_RESOURCE not always handled
correctly. I'll get that fixed up.
 
> > > I think you'll need to take the limitations of crypto_skcipher into
> > > account.  See the comment above CRYPTO_ALG_ALLOCATES_MEMORY.
> > 
> > The block layer's queue limits is the single source of truth for what
> > the backing device at any layer can accept. If you've some constraints
> > that are not appropriately described there, then let's fix that.
> 
> I agree that dm-crypt's queue limits should accurately describe its
> constraints.  This patch makes it no longer do so.

Which one(s)?
