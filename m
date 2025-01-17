Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39B91F7586;
	Fri, 17 Jan 2025 06:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737094892; cv=none; b=ciBheQNbGqdIKA5GU14tJ8WZ7gERHn2P3nTZVcOVysU7zSpxZf35bcczZtSVhOAUwCh6jHnpdIQ9zzreNHqwubFk7dqtWSzB3ke7Qmc6riq4PBwyM0PfELRT5t7kR/gkHHta2AIfvHjBdyaGF2QNfxV4j5g03ms8IPvs0q6qvys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737094892; c=relaxed/simple;
	bh=2OhMBDtEbXwTAHkNsEe6HamiyrxZuT3/v53V5ZG8wcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sr+QGd523cL+Ea0Nir8kzSXzUw7QWo4oaplxCn7i0LoW1mwNXGH05BxzA4sZWMxzZSmzUBAjxGcTRyu+bB2hSWfeel8qXyeCdMEDMmDWH5oop96P5yzKN/Z5RJYEbi84DrF06gcdyR0Y4AvteQv8aWfAx8pDbLXh+zzefCTHx1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WJMf0cJT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WJMf0cJT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r7RI9c0BSk3l3t8JX4/mNeWOAa5x0JyXCYROE80NAvc=; b=WJMf0cJTy4A+vmd+ziwjC3L4Uw
	k6uRHGtuEi+vLo5lzIR0YEH7fxIJ36GYTZx40p1sDHNioHGokk7xN00P9WJpoJXMUyPRRQkFcZT2A
	+6Zxa/Fk7afBQIf144U4A69ch2nRucMol7dyHJOX9cZG6tI3vffFD7wboSzFn91kMdd4DOHw6kMNm
	YpNqbIPqvZ8bYkOZyDy/gtxFbZgoqpWXXHAJokH/P3ppjuz6ofGIo7lKBEfhr92tLvCs6hRTsGKJh
	noHQVadYqpD9V/7hidg/RKRUH631eDPhOw85GWmNUOqgyE4KulYQGivJZdCzxaNgaaA5vKTXjneKe
	QzAQI/Xg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tYfWQ-00A33I-2S;
	Fri, 17 Jan 2025 14:21:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jan 2025 14:21:19 +0800
Date: Fri, 17 Jan 2025 14:21:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, mpatocka@redhat.com,
	agk@redhat.com, snitzer@kernel.org, ifranzki@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Message-ID: <Z4n238ML4fdFsFAw@gondor.apana.org.au>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <20250115173736.GA3712753@google.com>
 <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>
 <20250116080324.GA3910@sol.localdomain>
 <94e11912f1e1413ac2d13c7e5dc0ed35@linux.ibm.com>
 <Z4jNmdb4Bacom3-j@gondor.apana.org.au>
 <20250116175451.GA3772706@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116175451.GA3772706@google.com>

On Thu, Jan 16, 2025 at 05:54:51PM +0000, Eric Biggers wrote:
>
> But in practice it's the opposite.  Making it an ahash forces users who would
> otherwise just be using shash to use ahash instead.

I think that's a good thing.  shash was a mistake and I intend to
get rid of it.  But we should not do the ahash conversion right now.
Let me finish adding virtual address support first and then we could
reassess whether this makes sense or not.

> No one is asking for it to be available to IPsec.  And this is just a MAC, not a
> cipher.  But more generally, sleepable algorithms could still be used via an
> adapter using cryptd, or by making IPsec support using a workqueue like all the
> storage encryption/integrity systems already do.  In any case this would be a
> rare (or nonexistent?) use case and should be treated as such.

If it was possible to shoehorn phmac/paes into a synchronous
algorithm I'd love to do it.  But the fact is that this requires
asynchronous communication in the *unlikely* case which means
that the best way to model is with an optional async interface.

	if (unlikely(crypto_ahash_op(...) == -EINPROGRESS))
		do async
	else
		op completed synchronously

> That won't solve all the problems with ahash, for example the per-request
> allocation.  We'll still end up with something that is worse for 99% of users,
> while also doing a very poor job supporting the 1% (even assuming it's 1% and
> not 0% which it very well might be) who actually think they want off-CPU
> hardware crypto acceleration.  Not to mention the nonsense like having
> "synchronous asynchronous hashes".

I disagree.  I want the users to start feeding ahash with more
than one unit of input.  So rather than splitting up a folio
into page-size or sector-size units, you feed the whole thing
to ahash and the data should be split up automatically and hashed
in parallel.

> I think it's time to admit that the approach you're trying to take with the
> crypto API is wrong.  This has been known for years.

The only thing I agree with you here is that an SG list-based input
format is inappropriate.  And that is why I'm adding virtual address
support to ahash (and later to skcipher).

> The primary API needs to be designed around and optimized for software crypto,
> which is what nearly everyone wants.

I agree with that completely.  However, what triggered this thread
is in fact something that is not purely software crypto because it
involves system-wide communication which could take seconds to
complete.  The original patch tried to shoehorn this into a
synchronous implementation that would just fail randomly after
waiting.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
