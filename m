Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7232036F0;
	Fri, 18 Oct 2024 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729272806; cv=none; b=BsBupir9Qq5KxkRE/tK/MhLR+i7pMMzCTzH1zvpftLVSgmtJ4rSxGg+Ns8vdUOeKcvw0GZFdxqRd6a280pI4jc/UZIHX7WYgxtQj999SumA3JonLi7nHWfLWL8EiR2anDclMnSNlswbDqXSe4ankPUOWIEqzd+Ncu2OR5eIOvSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729272806; c=relaxed/simple;
	bh=5TQXWa/QPquJfO4y4bgGgLNqEKC99NnpoIpYhQzW82Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdi+1G0XbiG11cNH6pSQ+Fs83y5eFoPtvF/1H1QoWxz1r4kAonY1VJ5cjbcoTnueRldUScWUiSFZqm0mX6csZcaX3bt7xMTUrimSZEYJwTWKZjykCVGxWxiuJhb0ojVEH7I/+Qe0z8HEIkCWIhnGitmdKdxszsRyUgOSQ3sU5y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrqB8NRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrqB8NRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16033C4CEC3;
	Fri, 18 Oct 2024 17:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729272805;
	bh=5TQXWa/QPquJfO4y4bgGgLNqEKC99NnpoIpYhQzW82Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hrqB8NRmHmZU+X3tECkCHthZ5vXEEG35Lj54BBygbuqtD98xb6NHW6gDtJjic9QEC
	 9ARbmC1+Kd9eCr4sYrCmIrIcWznMHfhOsHhm9jzv/FXpNIEjP32vkLc+Z5fbM/GDQm
	 ruVIfzODjx7Nhgh3s6MU2h1ulkfjGOdEsVqKv3KLk1asKDiDcsGB465kseh27LaKRx
	 tXECdLCCInrI/vV64opY8/79sJNfDfluDXLDAD/19I0JA2iWM68pKNBQEryUkk5wfK
	 QUTG8WkPlZx2MGpbcvnsIw0gImrB9lLp/wBtmYDAHMUyPfmwt8FxVQ9ob3ZBcQ40ID
	 z1Ua73VNzzHyA==
Date: Fri, 18 Oct 2024 10:33:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Adrian Vovk <adrianvovk@gmail.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH v2 2/2] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <20241018173323.GA1127@sol.localdomain>
References: <20241016232748.134211-1-ebiggers@kernel.org>
 <20241016232748.134211-3-ebiggers@kernel.org>
 <681a6d2e-a80a-4e81-a049-841d7e8582ba@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681a6d2e-a80a-4e81-a049-841d7e8582ba@gmail.com>

On Thu, Oct 17, 2024 at 10:52:42PM -0400, Adrian Vovk wrote:
> Hello,
> 
> On 10/16/24 19:27, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a new device-mapper target "dm-inlinecrypt" that is similar to
> > dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> > This allows it to take advantage of inline encryption hardware such as
> > that commonly built into UFS host controllers.
> 
> Wow! Thank you for this patch! This is something we really want in systemd
> and in GNOME, and I came across this patchset on accident while trying to
> find a way to get someone to work on it for us.
> 
> > The table syntax matches dm-crypt's, but for now only a stripped-down
> > set of parameters is supported.  For example, for now AES-256-XTS is the
> > only supported cipher.
> > 
> > dm-inlinecrypt is based on Android's dm-default-key with the
> > controversial passthrough support removed.
> 
> That's quite unfortunate. I'd say this passthrough support is probably the
> most powerful thing about dm-default-key.
> 
> Could you elaborate on why you removed it?

Well, see the conversation you've been having with Christoph.  It seems the
passthrough / "metadata encryption" support will need to be reworked into a
filesystem native feature in order to have a chance at upstream.

Meanwhile there are people who have been waiting for basically "dm-crypt with
blk-crypto", without the passthrough support.  I hoped that I could help with
that in the meantime -- hence this patchset.

I'll go ahead and send out the full dm-default-key patches too as an RFC just so
that people can see what it involves exactly.  But be warned -- it is a bit ugly
with changes in multiple layers (not just the dm target itself).

- Eric
