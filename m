Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4327E178371
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 19:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716925323; cv=none; b=KJ32tsjtmjzcx+XkA0ernVgWCMfbP7vw5nFQAn8LYUiiapcFJ2ZHIYFpjiRxWrLjyQ7TZvf1luMci3LJ++PZjf5GBzbHDO2AAVY3Y+3b2tvG+HXh5A1Wht3FkjIxydOtZDbqn43B0QqDEhCG0Xw2q4EgAU5jZs+MZfPgjQooEW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716925323; c=relaxed/simple;
	bh=5yn8/OS7YqLDgvUMwCfk9SzzaGD35aBaSwRIkIBGk/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4A4Gqe79LbC5UW4x9GGM+WkZqTcC3Cfd/O9SLfYogExhQ05F2kw5vQAGNS/C/Xp+Jb7hmcBVN+sTcM3I+0RJtuHRvDsWs4NoCb7fHEtfsVQWLxdi1ySJjuzB5beZ88ATYKbAj4KYHr149DycflprJaDylzayTbCsZTi+ETuR0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftFV9gH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftFV9gH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA52C3277B;
	Tue, 28 May 2024 19:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716925322;
	bh=5yn8/OS7YqLDgvUMwCfk9SzzaGD35aBaSwRIkIBGk/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ftFV9gH1PiRu4eKA8dJrPyOjzvMMhLig0FUaznOlasZQ9nIEskXQdh2Kg45pTa7k1
	 iy/nJWMAj29zUeiseJnAuNDyz9phgpSIE74GOd/fvEa8mVaSPjxcwqrWWWOe6fUKfn
	 p73nWVOK4VmvouW30X1DsRMCd6/PQXn/agv30gNnYfW+u1QpnFr+7Zjdof2NW65N7I
	 Xjb6PwhkJh8WuwbJsYbKYo0P4MNlKsN9DfXEhlw1RCCWUvNEB1RVBQR6U1Ki8n8FHx
	 KZWbFnRBktFleFNmBHXzJUFpTUW8k7NZR9qwFIsQCVpUbXjVpoxsl+Rz2csXCqUFHd
	 RJo6DYLHlpmHw==
Date: Tue, 28 May 2024 12:42:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sven <dm-devel@schwermer.no>
Cc: dm-devel@lists.linux.dev, marex@denx.de, nhuck@google.com
Subject: Re: dm-verity requires WQ_UNBOUND with mxs-dcp
Message-ID: <20240528194201.GA1201@sol.localdomain>
References: <296810f8-367c-4a33-b315-3074690d4c36@schwermer.no>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <296810f8-367c-4a33-b315-3074690d4c36@schwermer.no>

On Tue, May 28, 2024 at 10:58:33AM +0200, Sven wrote:
> Hi,
> 
> I'm seeing a problem using dm-verity with the sha256-dcp driver (mxs-dcp).
> Specifically, I'm seeing corruption errors a la
> 
> device-mapper: verity: 179:2: metadata block 76823 is corrupted
> 
> This is a regression that has started to appear with commit
> 
> c25da5b7baf1d dm verity: stop using WQ_UNBOUND for verify_wq
> 
> Reverting that commit while keeping an identical rootfs fixes my issue and I
> don't get any warnings anymore. I'm using an i.MX6ULL SoC which only has one
> CPU core so I don't really understand how WQ_UNBOUND can have an affect
> here. However, there might be side effects that I'm not aware of.
> 
> It might be worth noting that I'm using the dm-verity device as my root
> device without initramfs. I'm seeing this on both v6.6.23 and today's master
> (v6.10-rc1-13-g2bfcfd584ff5c).
> 
> Does anyone have ideas, how WQ_UNBOUND could be required here?
> 

Does this happen with software SHA-256, or is it specific to the sha256-dcp
driver?  Does this driver pass all the crypto self-tests?

- Eric
