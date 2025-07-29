Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553821DE4CA;
	Tue, 29 Jul 2025 01:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753753254; cv=none; b=Anm+W0+F3OS3IWLtT8QCL+/lFjBTegntPmLA2nq9bAqxF+rLEKmxO1BA4KiUOnsKCaStVKzez5HGWfFytnoO5wIT0ZeN9J6GlZAPgemo7Lim3s5n3DBamzXow0bdYu1pMNGFryIq8RBau9ldPNkgAha7LzQ1Hl4spWO4IVQkrYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753753254; c=relaxed/simple;
	bh=NFfZfS6SZss3OmqP+XzfF5OHf8CGFTiZe0bfLFBsYLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2z2HqV2FMe4Ig3NLXjFeqElG8k5MgBG/ke8Zl6DfVULYZeMeHhqFwbrfZTS7ZroVrO1SWwHTe3YQG3U2i/wxW4njHCvBXHF6LJCb03aCw0Ay7hzkUXayQoFDQjx/YgDmlMX25RzHtSkZEgmSubDeV8Zs+wg/aAc68ICzo1rphc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aVYrFzom; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aVYrFzom"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TbK1Lxvn1+k9G8UrrepIdAmU03gfYhnB58b7iSj/tvc=; b=aVYrFzomGQLUbgUiA0apliCIC+
	7kxqwUp9NC684rODuHIW7MonONF2kmJoL7ZhiM9hE+vHokPgEEkl5NL1bOC7n9RK/ZrztAcBEBGK7
	LN1ADlVp0hXxjt2oyZ5ZVBTMG00NCgT5bgoKo2R94PE6qmTibZWHxus+yQLfCDIxokeRob41w6YWk
	fZmWpd65d3ETF6howBszoSc6nqH1EfKEJLUkLJS5ZQt1MIW+2icx5uo30/rs8u+GalUiqiq/4H6Yi
	QOfsUOrmOGVM76CXWqj79cWiqsDYFpHWT/h5SA73PS/XbBXtV4ftggj7FzO5nEOSQ6+xX0knQUpTO
	HC+rou/A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ugZ58-00APbp-2h;
	Tue, 29 Jul 2025 09:40:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Jul 2025 09:40:39 +0800
Date: Tue, 29 Jul 2025 09:40:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	ifranzki@linux.ibm.com, agk@redhat.com, snitzer@kernel.org,
	gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
Message-ID: <aIgml2oqM9FyIyys@gondor.apana.org.au>
References: <20250722133832.319226-1-freude@linux.ibm.com>
 <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com>
 <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com>
 <20250725173811.GA3642931@google.com>
 <dbe165f661d11a4bed8d7c806a9eeb5e@linux.ibm.com>
 <51dc2ccd-c06d-e719-9568-35a8d3a1010f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51dc2ccd-c06d-e719-9568-35a8d3a1010f@redhat.com>

On Mon, Jul 28, 2025 at 11:24:25PM +0200, Mikulas Patocka wrote:
>
> I'd like to ask the maintainers of crypto-api - Herbert or David - what if 
> I pass vmalloc-allocated memory (or possibly stack memory) as "result" to 
> ahash_request_set_crypt(req, sg, result, nbytes);? Is it legal or not?

It's perfectly legal to pass a stack-allocated or vmallc pointer
for the result field in ahash.

Only SG lists require DMA memory.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
