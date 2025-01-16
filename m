Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6686323;
	Thu, 16 Jan 2025 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737050093; cv=none; b=JxevYX3zxUPkkT7eKG4jefuyGfMbMR2fgDrwst9AGZTlCVtR/3mFOs6Yyuj7NzTAQZmekqeBK5U/kzMaMjw61HlXV2Gemmi2iGk5VK37hG4nNv4a4xN1nUJduKOSczjL3fSxDRmGCgCyVncaGI41mv1obKuNdqH9C4lhLfSB3gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737050093; c=relaxed/simple;
	bh=iglMswzxq2szY9UE3UHvnDlZ+Jw81DovGKmcVkbyy/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISozedZA1Qq9ERBBhjwiM77MUV51PqeyRez1W6Xa73aCouDzsN4JWqBNP2cTVUDAqAX6DNME1s1WbD6BUiN626yz1nJR6/rahHL5qXTT5IFBc/FBJg0tqkA0Fflm0ywHnaXJhOaah+LVmGYhVL5ZJKhGYfkn5s+CDyHDpFIqIyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EvbPbTli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EvbPbTli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C2C4CED6;
	Thu, 16 Jan 2025 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737050093;
	bh=iglMswzxq2szY9UE3UHvnDlZ+Jw81DovGKmcVkbyy/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EvbPbTliXoSObWP7lyG0AlSWYMjUVi+MBimUd8Qjod53v+ORPhtICpqSA6g0c35cf
	 6XgqFPm6KvP75rDojJykCCG05VPCxxv0gRdcLfDRHwHZmUx+ezZQ6AXFpKK6D+aoyx
	 kSc+b0PlK42SSIpK1XgKBz48Ldj9ikFXl3zuVqq1xgd8mlFqVeqDRRj+nd8GcXffO/
	 iPRbMHnWZTzCXPIrK/F1Wd7nwZ+XLlDb2xRxP8GX3tswrmdXHiH+55QuOichN5qEu0
	 6pqaWLiZc6AhhHueZVxZKFB4kqikyrxFXpfqm3qVahD4fKKLFAzOnjNr1ND2ZODusi
	 ATjY320+iLbYQ==
Date: Thu, 16 Jan 2025 17:54:51 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Harald Freudenberger <freude@linux.ibm.com>, mpatocka@redhat.com,
	agk@redhat.com, snitzer@kernel.org, ifranzki@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Message-ID: <20250116175451.GA3772706@google.com>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <20250115173736.GA3712753@google.com>
 <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>
 <20250116080324.GA3910@sol.localdomain>
 <94e11912f1e1413ac2d13c7e5dc0ed35@linux.ibm.com>
 <Z4jNmdb4Bacom3-j@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4jNmdb4Bacom3-j@gondor.apana.org.au>

On Thu, Jan 16, 2025 at 05:12:57PM +0800, Herbert Xu wrote:
> On Thu, Jan 16, 2025 at 10:00:36AM +0100, Harald Freudenberger wrote:
> >
> > Eric your idea was whirling around in my head for at least 3 month now.
> > It would be great to have a way to offer an shash() implementation which
> > clearly states that it is not for use in atomic context. E.g. like as you
> > wrote with a new flag. I'll work out something in this direction and push
> > it onto the crypto mailing list :-)
> 
> I don't like this flag because we'd have to modify every other
> hash user.

But in practice it's the opposite.  Making it an ahash forces users who would
otherwise just be using shash to use ahash instead.

> For example, this would result in your algorithm
> being unavailable to IPsec despite it being an ahash user (because
> it can't sleep).

No one is asking for it to be available to IPsec.  And this is just a MAC, not a
cipher.  But more generally, sleepable algorithms could still be used via an
adapter using cryptd, or by making IPsec support using a workqueue like all the
storage encryption/integrity systems already do.  In any case this would be a
rare (or nonexistent?) use case and should be treated as such.

> I think the dm-crypt patch should wait until after I have added
> virtual address support to ahash.  Then we could compare it properly
> with shash.

That won't solve all the problems with ahash, for example the per-request
allocation.  We'll still end up with something that is worse for 99% of users,
while also doing a very poor job supporting the 1% (even assuming it's 1% and
not 0% which it very well might be) who actually think they want off-CPU
hardware crypto acceleration.  Not to mention the nonsense like having
"synchronous asynchronous hashes".

I think it's time to admit that the approach you're trying to take with the
crypto API is wrong.  This has been known for years.

The primary API needs to be designed around and optimized for software crypto,
which is what nearly everyone wants.

- Eric
