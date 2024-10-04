Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9771EF09D;
	Fri,  4 Oct 2024 18:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728067701; cv=none; b=gv+cnvkdZQv9jCmQOBaJpGOJ90GofELB9wA4IdKMCSGuJm4+DkrvP9amE7HJ01mHRf+9AiHXd/CQ0dY2ORkmMih/X3hv4Y+jBIvbJWNkL1gIGC2Q/o2hGws48SqY/RZjyf4tHzPW5lY/NTU12ymkcrH+JROrgCvPOtZHtDfUMhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728067701; c=relaxed/simple;
	bh=1HqgdvKOc/m4/qLy85gUA+bM5IvgY3Z2AWC8955moa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaFdPYJDB7nA8OIA7YwdSMQ1msSCj59eUiol4NpcdorhInZ3ZLZ6+YhpDTFx/kfYlSujQt4wioiAR6iGXuqQZbjc1DT/slKOHAtyRtdDMPUThZ1pU+p4I5RDIhhwdFZZdLfu8HSkGuJnrvHG1CWhVpKrEz38eXTeauiJ3F5NaqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDfuHnFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDfuHnFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5258EC4CEC6;
	Fri,  4 Oct 2024 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728067701;
	bh=1HqgdvKOc/m4/qLy85gUA+bM5IvgY3Z2AWC8955moa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDfuHnFpMa2Kke9DJFgMsuFPRzKuZeZGJu9ZOakdPAneuj3mEz17czBe1gn2bDqsQ
	 dThauq2ASkkZ+8UlNcBQXm0n1wiBhN1LySl7trtOX2jNNWLhP1TiJFUBj/Bx4bqF8O
	 WYU9jqOh33DSRChvrclLBXiXD3ERk7TwYBMFCvxwHFlGZhSYaxeZtxjuXMGOZnufLA
	 BynRKILRbJW7AEwcF8MxkyDcGiPnsqjGJhPM7GT/InUycDZ4flRg0podnKhi1toROU
	 xmGMUOKggYwvD+6qq3mgBGszKj+CAu5aaCHYxG8bLK1u882PnP+N81sJI2vE4/Vvsx
	 RVf2Er26ZaMvw==
Date: Fri, 4 Oct 2024 18:48:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH] dm-inlinecrypt: add target for inline block device
 encryption
Message-ID: <20241004184819.GA86456@google.com>
References: <20241004004152.8845-1-ebiggers@kernel.org>
 <Zv-Ap9E2r1bRT2Wm@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv-Ap9E2r1bRT2Wm@infradead.org>

On Thu, Oct 03, 2024 at 10:44:07PM -0700, Christoph Hellwig wrote:
> On Thu, Oct 03, 2024 at 05:41:52PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a new device-mapper target "dm-inlinecrypt" that is similar to
> > dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> > This allows it to take advantage of inline encryption hardware such as
> > that commonly built into UFS host controllers.
> > 
> > The table syntax matches dm-crypt's, but for now only a stripped-down
> > set of parameters is supported.  For example, for now AES-256-XTS is the
> > only supported cipher.
> 
> Maybe I'm stepping into a mine-field here, but if this simply uses
> blk-crypto to accellerate a subset of dm-crypt, why isn't dm-crypt
> simply enhanced to use blk-crypto when available?
> compatible,
> 

Milan Broz (cryptsetup maintainer) has said that he prefers a separate dm
target.  See
https://lore.kernel.org/dm-devel/9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com/

That was a couple years ago though, and this discussion seems to have gone
around in a circle.  Maybe things have changed.

A dm-crypt extension sounds fine to me too, though keep in mind there will
eventually be inline crypto exclusive features such as hardware-wrapped keys.

- Eric
