Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47342227BA9;
	Thu, 17 Oct 2024 20:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729196934; cv=none; b=vF2UDQ1zYTv11rPRm9iKLu29HdBgoC+rzRhrb10hXEd+J5wxa5xm0TLU2cBOikE+N2zSstCskeEwfGKbyTlqXKmfIERNQwTPHq9ynmU3RIJTkLnu03nZInzcVj+cSNSoXsA9G2IyqCbpns3MzSJSeKNVaUORURJYwVuKkk0W+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729196934; c=relaxed/simple;
	bh=mHJdPYRlRIBOUm7RwbdVae1/VjEYV2F5pEsRwLleacY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7IeYFWYJ5e6wbEGaypEK0gY2jUWk9X410Djn1pQSsanP9/Hq+X634P3ZHZBHAfzOiz9KSGFzjGn3ehBeHXHx5iR51flpOb0xyv1a5QgUnQFteCFe5jm1B+AwINYv61AhG8vlaVI2kzU1pklh/RoZGZt1H+cBS/IDH4iWE/idUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZME4Xqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZME4Xqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86235C4CEC3;
	Thu, 17 Oct 2024 20:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729196933;
	bh=mHJdPYRlRIBOUm7RwbdVae1/VjEYV2F5pEsRwLleacY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fZME4Xqpen8So84dZF1cWsZTHPv58ZNzBZr4+7Xk6TuMPS9MWM0+qmmv8eGNQAROK
	 q3o+42XsmfPctcf7d4DqyW0B2Xg6HY0p0FDiqmds/VYCYLVyIp78GGbKZEINMjsXCf
	 gj6Z55jpjGAFwZcHCXpJvy4nx7ngzWz9bYXZvcK8XPgd5RWAl4EzVz3Qwmwz2VGtTo
	 4ymnMLQvNrSVlKRbye/56CMPJUo+2lg/TKsPeGqpQkm0hN7/ojlOM7vBBmhNlHoaWv
	 aQlnxWFcZ7Z+p2ILyBd4vboAeROBXae+DdOLDch7okU70ObNeg5jevkcSM/alXfLWi
	 ohsQagH4iudzw==
Date: Thu, 17 Oct 2024 13:28:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH v2 2/2] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <20241017202852.GB11717@sol.localdomain>
References: <20241016232748.134211-1-ebiggers@kernel.org>
 <20241016232748.134211-3-ebiggers@kernel.org>
 <20241017194415.GA11717@sol.localdomain>
 <b8670e11-61d4-4831-8a21-2dda3c5db131@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8670e11-61d4-4831-8a21-2dda3c5db131@gmail.com>

On Thu, Oct 17, 2024 at 10:17:04PM +0200, Milan Broz wrote:
> On 10/17/24 9:44 PM, Eric Biggers wrote:
> > On Wed, Oct 16, 2024 at 04:27:48PM -0700, Eric Biggers wrote:
> > > Add a new device-mapper target "dm-inlinecrypt" that is similar to
> > > dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> > > This allows it to take advantage of inline encryption hardware such as
> > > that commonly built into UFS host controllers.
> > 
> > A slight difference in behavior vs. dm-crypt that I just became aware of:
> > dm-crypt allows XTS keys whose first half equals the second half, i.e.
> > cipher key == tweak key.  dm-inlinecrypt typically will not allow this.  Inline
> > encryption hardware typically rejects such keys, and blk-crypto-fallback rejects
> > them too because it uses CRYPTO_TFM_REQ_FORBID_WEAK_KEYS.
> > 
> > IMO, rejecting these weak keys is desirable, and the fact that dm-inlinecrypt
> > fixes this issue with dm-crypt will just need to be documented.
> 
> Hm, I thought this is already rejected in crypto API (at least in FIPS mode)...
> 
> It should be rejected exactly as you described even for dm-crypt,
> just the check should be (IMO) part of crypto API (set keys), not dm-crypt itself.
> 
> And here I think we should not be backward "compatible" as it is security issue,
> both XTS keys just must not be the same.
> 

In "FIPS mode" such keys are always rejected, but otherwise it is opt-in via the
flag CRYPTO_TFM_REQ_FORBID_WEAK_KEYS.  dm-crypt doesn't use that flag.

We could certainly try to fix that in dm-crypt, though I expect that some
dm-crypt users have started relying on such keys.  It is a common misconception
that XTS is secure when the two halves of the key are the same.

- Eric
