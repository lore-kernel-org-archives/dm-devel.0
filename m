Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A6252F76;
	Fri,  4 Oct 2024 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728020652; cv=none; b=KxhGT6Nn4h7kAhFT/Dy7VikgOZb18vubRsk68JtYJ9VdP5FSDVR3HhXxdqjmwvzEy4Vj55Jnma4DHRbvfxfpuTysiDy2MF1lHwRPyM/4f6U2h44Rz1lzFMinwqXOwLsMPCwNe0nsyb/CDPgppzCe/FIBtGhcZ1gW1v3n61M5XXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728020652; c=relaxed/simple;
	bh=oC5K0/ShitYL7GsFKHIJR4DTrOAXzRqRN4nxDpVmbjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScLgFe8F+yuuK+K1dMmSDOBcpf9t8Y1EqFNVp7M2ptzEQgCOsNdSTqSEcPatfc7O0EKmvebDWJ/jrQCdJBVVfC8xsxrByPvZ7zR1bC2eM34eL9IBfL0ff05w+G9m+U2EJDt9TaPZiY0+BjzuYqVgfub7jgTK1iyK7lvefnQwkYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YgnuRnLW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YgnuRnLW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i66gyaXy5MtT8DBNJKCiC/vQxjyIN5X0O8CftA6PRzY=; b=YgnuRnLW8omOzvzmlPNlQw3Pov
	Qw00vim6Gq9m+up48Dtft3BLd33hiKI0EMTLJF9T54pClM3ANxD1sf7Ao/cNJxCNyDUjrlDxC+fM8
	iPfajZJcNrOEFae+kJfkpzNZ1A0kXhHEKpmjV4LEDzyMlcYXabuw3cs2PxSBj1nqc5MID1un9n1LM
	Bed90RaqVQhYRuYp0oRvIbOq/HX222k1LGWrf9JDMgHFzAFRPj0r/m0Zj4AVWpLib/ZCt7q99NIFr
	MTzxSHpQI+zPlwkKweY4j5x5cKhEZyIj9VhtYrRQCHq+rS/ZnD1a3Juj3So8pK5mMPtYfSTsHBm0+
	G5H4MjSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1swb6l-0000000B5OE-2uOp;
	Fri, 04 Oct 2024 05:44:07 +0000
Date: Thu, 3 Oct 2024 22:44:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>
Subject: Re: [RFC PATCH] dm-inlinecrypt: add target for inline block device
 encryption
Message-ID: <Zv-Ap9E2r1bRT2Wm@infradead.org>
References: <20241004004152.8845-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004004152.8845-1-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 03, 2024 at 05:41:52PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a new device-mapper target "dm-inlinecrypt" that is similar to
> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> This allows it to take advantage of inline encryption hardware such as
> that commonly built into UFS host controllers.
> 
> The table syntax matches dm-crypt's, but for now only a stripped-down
> set of parameters is supported.  For example, for now AES-256-XTS is the
> only supported cipher.

Maybe I'm stepping into a mine-field here, but if this simply uses
blk-crypto to accellerate a subset of dm-crypt, why isn't dm-crypt
simply enhanced to use blk-crypto when available?
compatible,

> +EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);

Please split the exports in a separate subsystem into a separate prep
patch, documenting why it makes sense to have these as exported APIs.

