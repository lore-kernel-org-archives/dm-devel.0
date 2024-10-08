Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A80157E9F;
	Tue,  8 Oct 2024 09:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728379210; cv=none; b=kTM9FQwk4Eku0idm2C2ELeMv06UmusFFDOuUQITIrhQyDU3zYph6JwRajNj87s1iV589K7qGwD+zWtSrEdhIvaZFW8XOMoZY6yN0TtMZSqg95pNGaw5PzYW1cE6M9HTMd0EEvyrCko09fr6DMNs3gmeXj6zzTOuuCg+EhjhQS98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728379210; c=relaxed/simple;
	bh=irKY5q86L7tikefLZfIE/69XftXAQof8SOZ1KjMdoMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiM+SQAMV1ecjb0rt5pGDA+gScluh8h5PXV7IY8JjbjnjzgD4oUJHm/i2ha6G2k50iD2kThvT3v4217aNhBsprjJsSKINg7/0WXgi+wXM6x2m3JxhDEsxnrkkJb4UTUx5qe/pQ3kXLvO7d6whsv2R/ewwOwbZKVu00+YOD7zniM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q9kuxqrF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q9kuxqrF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u8c9792gStLKdJ+OYC69jlkxI5aQboG1khHK0oQvnyY=; b=q9kuxqrFiesz+M+jGk9SMhfKs2
	vX7oH73dqDJAQsA9n4Q1tjrY88dvOelWi/e+69Tji6XVGSZoXXzpPHagGIy1DcChriYbSyMYCiP8F
	CK2jsgeTRXFI9oLZkluYX7Rg8/tileunqxhVZzVk2pn3aoqBOlKmGnLEla1CsozHZLRkvgy8bfhDn
	ExD2LisCQNtFMCutGJpQ9MeVfei4AZ2kRUSYTJlQAJGNELlhwNy+MGuK1vuf7XB9wT98vEdCUjGkn
	5EWpj4LpYO5LqB9LkbvbHRzEKdMb2lRJsQzmkv0iIIZYVA4aHj4225/nZHiFkOmqjCBUX0vtRZUG9
	U9pA8k6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sy6O0-00000005GtI-0PoP;
	Tue, 08 Oct 2024 09:20:08 +0000
Date: Tue, 8 Oct 2024 02:20:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>
Subject: Re: [RFC PATCH] dm-inlinecrypt: add target for inline block device
 encryption
Message-ID: <ZwT5SOkYRbOkeRRe@infradead.org>
References: <20241004004152.8845-1-ebiggers@kernel.org>
 <Zv-Ap9E2r1bRT2Wm@infradead.org>
 <20241004184819.GA86456@google.com>
 <f335366a-3752-4272-8592-fe1ed9f43aee@gmail.com>
 <ZwN1hDK34h0du5qp@infradead.org>
 <89fe49aa-4c7c-42ef-a59c-c962f4403145@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89fe49aa-4c7c-42ef-a59c-c962f4403145@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 07, 2024 at 10:25:56AM +0200, Milan Broz wrote:
> I am talking from the security point of view. Now, dm-crypt does not trust
> storage devices. Storage devices will never see plaintext (or key).
> With inline crypto, it needs to see both.

With inline crypto as implemented right now the actual storage device
does not see the plaintext and key, only the storage controller that
is part of the SOC that Linux runs on.

> My goal is to mitigate these risks completely with dm-crypt, while clearly
> saying dm-inlinecrypt will have a different threat model.
> 
> (Yes, if inline crypto is used through crypto API, we have the same problem,
> but you can mitigate it by turning off specific crypto modules.)

That same could be done by requiring an explicit opt-in for using inline
crypto.  But yes, at that point just using a different target should
not be a major inconvenience.

> I see several self-encryption hardware where it was so broken that vendors
> basically say, "use sw crypto" but this will not stop users from using it
> in a broken state.

Well, with the crazy mess that the TCG storage specs are the quality of
implementation of key management or even crypto algorithms that is
everything but unexpected.  One important feature of inline crypto
engines is that they can't just do key management or pick their
algorithms and you can always validate the ciphertext vs that done by
software, something that can't work with the broken Opal-like full disk
encryption model.

Anyway, not wanting to second guess you here, just throwing in my 2
cents.
