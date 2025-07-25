Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5B240604;
	Fri, 25 Jul 2025 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753465095; cv=none; b=tylUfx+8wuVYDXs6XL9b9tUx01EQiswaycVp/+2KSSyXwj1UHXKQxZYItdBi352rOy0mCEdU5mzYNcawjvLes/6kqVrdI0J4V3m/koaZYiK3TFvRpzxzDPYOLIwQcUDsrXieEbpYHG8/5bxugVc+hjn/s5RhV1MJZPySuGRoxvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753465095; c=relaxed/simple;
	bh=k7VMgFkBoM/BIoZOYAxkP2UUTbe2UmzWSNd6g/2p1cU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGOF+dLv0iLnvR/j0SMmiPjT8fihg9r2x2h8zBtquHM/2FqXtldCI0Em+YMLKimuEdeQQUBCCZ3XvDKeDkXQhoj79T8/r6M+Lmxy1599V3TvMMTVXgR/jB3ZGugDckmOyAhTTFVDrwn4VpE2vz6wjZTxisMPAU3utNFjH0aIy9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMqzw/Sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMqzw/Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754CEC4CEE7;
	Fri, 25 Jul 2025 17:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753465093;
	bh=k7VMgFkBoM/BIoZOYAxkP2UUTbe2UmzWSNd6g/2p1cU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tMqzw/SnfuOeH6EIDQDN/Ymg/XGsqIzChGL3+SvpCM+yGcEpF6dT/mJFmt7AlJbX6
	 NGuBS3OYlSKSqCt01fcryyvAV533pkau6lNu4BEA3XC9KYyQPhgTij8bUQbjCH2ubY
	 Imf61xpFcTyJwhG1mkj0P3hkNCyT5indTWtPnWiwcSty+Mb40TxYjuFrboCD9a4aq4
	 pSm42L/1N65TquajKaU/k57ewydVb/gZ+YXr5ckXp/XZDGgG/8SQ86/nCbcSl+IYj+
	 didxlFPFZEZlWIxUvVtMuzoG0+GFQgyKXzJufS+GoKfMZChLwuxwBc9adk/+WzDxmC
	 zQOaWQqRMBKcg==
Date: Fri, 25 Jul 2025 17:38:11 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dengler@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	herbert@gondor.apana.org.au, ifranzki@linux.ibm.com, agk@redhat.com,
	snitzer@kernel.org, gmazyland@gmail.com
Subject: Re: [PATCH v5 0/2] dm-integrity: Implement asynch digest support
Message-ID: <20250725173811.GA3642931@google.com>
References: <20250722133832.319226-1-freude@linux.ibm.com>
 <5fc734af-a2c1-b7bb-85fb-cba6b8722c13@redhat.com>
 <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56aa9892c7825a443f8a6153e17b4c46@linux.ibm.com>

On Fri, Jul 25, 2025 at 10:14:30AM +0200, Harald Freudenberger wrote:
> On 2025-07-24 16:40, Mikulas Patocka wrote:
> > On Tue, 22 Jul 2025, Harald Freudenberger wrote:
> > 
> > > Support for ahashes in dm-integrity.
> > > 
> > > Changelog:
> > > 
> > > v1: First implementation. Tested with crc32, sha256, hmac-sha256 and
> > >     the s390 specific implementations for hmac-sha256 and protected
> > >     key phmac-sha256. Also ran with some instrumented code (in the
> > > digest
> > >     implementation) to verify that in fact now the code runs
> > > asynchronous.
> > > v2: Support shash and ahash. Based on Mikulas' idea about implementing
> > >     ahash support similar to dm-verity this version now adds support
> > >     for ahash but does not replace the shash support. For more details
> > >     see the text of the patch header.
> > > v3: The line to store the digestsize into the new internal variable
> > >     did not make it into the patch set which was sent out. So now
> > >     this important code piece is also there. Also rebuilded, sparse
> > >     checked and tested to make sure the patches are ok.
> > > v4: Thanks to Mikulas a total new implementation of the ahash support
> > >     for the dm-integrity layer :-)
> > > v5: Slight rework around the allocation and comparing of ahash and
> > >     shash algorithm.
> > >     V5 has been tested with the new introduced ahash phmac which is a
> > >     protected key ("hardware key") version of a hmac for s390. As of
> > > now
> > >     phmac is only available in Herbert Xu's cryptodev-2.6 kernel tree
> > >     but will be merged into mainline with the next merge window for
> > >     the 6.17 development kernel.
> > > 
> > > Mikulas Patocka (2):
> > >   dm-integrity: use internal variable for digestsize
> > >   dm-integrity: introduce ahash support for the internal hash
> > > 
> > >  drivers/md/dm-integrity.c | 370
> > > +++++++++++++++++++++++++++-----------
> > >  1 file changed, 265 insertions(+), 105 deletions(-)
> > > 
> > > 
> > > base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> > > --
> > > 2.43.0
> > > 
> > 
> > Hi
> > 
> > Eric Biggers recently removed ahash support from dm-verity - see this
> > commit:
> > https://kernel.googlesource.com/pub/scm/linux/kernel/git/device-mapper/linux-dm/+/f43309c6743257244f11f14d31c297ee6a410ded
> > 
> > Should I revert Eric's patch? - would you need dm-verity with
> > asynchronous
> > hashes on zseries too?
> > 
> > Is this patch series needed for performance (does it perform better than
> > the in-cpu instructions)? Or is it need because of better security (the
> > keys are hidden in the hardware)?
> > 
> > Mikulas
> 
> I've seen this. Well as of now we don't need dm-verity. However, I'll check
> our plans and let you know within the next days.
> 
> Thanks

Isn't your use case the "s390 specific protected key hash phmac"
(https://lore.kernel.org/linux-crypto/20250617134440.48000-1-freude@linux.ibm.com/)?
dm-verity uses an unkeyed hash, so that isn't applicable there.

BTW, did you consider a lib/crypto/ API for phmac?  I suspect it could
be much simpler than the asynchronous hash based version.

- Eric
