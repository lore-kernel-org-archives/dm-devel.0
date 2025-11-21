Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57AD27FD5B
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 01:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763690367; cv=none; b=hYmI0Tp1qh9VpwSWWldmoL63CHZELZ4nnxGsesMTLHHATEXZfeLoUj4eqijQ+R1qk9C8bNQ14A7gfaQpvwBKunH+sze51EH3aG5Ett3dxmnRROBZN/7UWxX6GB/2GGexoBisR0//2X9dQFXOBT0gZDkwxcbSNqL03bmeTNE4Oxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763690367; c=relaxed/simple;
	bh=bwxhglN0Jt/5i8Eo2MtPbZ7vXeH2j4Up0LHkzWcw3ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiOycuVc9GIjXbCdi4LZsUEVGbky1speBXf23T6ATgN3dI99VncHaiLT2VRt75Nf9flT0x19ypDfl7/IiroZX1VPEjcQTnoBcXZk4SLzI7H95LdJ3bFoT+O7ogdwc6ybKkV0c8d1CJiXzbbq/bL8WG22NK0LpB/NTLvfnHAjwSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyN/cNuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyN/cNuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07CCC4CEF1;
	Fri, 21 Nov 2025 01:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763690367;
	bh=bwxhglN0Jt/5i8Eo2MtPbZ7vXeH2j4Up0LHkzWcw3ak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SyN/cNuSNAZDk/GZEJwAPtXk/SUPeh+/yrXMJMza/BlzaCKz8pew1Y9gVp9ctgy2M
	 kZNMnCF7DvIhpFXEg5ijPEnIHexee4YMrWY7E/A7icSkooUI0lExo1p1fMHzgtju1t
	 DEeHXHhINxJ7h5tqL8wLW/yN8yNZujUeUoX+MzpyQ3xIbKA3CRPkggsKzOFl179Arr
	 httNX+44SZsWpI2q7deZSoFI6BK8NVKHeXB2lUC30LY5iZvAuRcgjYsmclVI1n5eM5
	 LGezNXZcn/IZuYZZxR1GhuznexW/BdlUBC8R7MPucyyWaw65N4aUk0q4Yp5AkhoUWB
	 z+pQl1TS0FJaw==
Date: Fri, 21 Nov 2025 01:59:25 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev, Guangwu Zhang <guazhang@redhat.com>,
	Ondrej Kozina <okozina@redhat.com>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH] dm-verity: disable recursive forward error correction
Message-ID: <20251121015925.GC3078357@google.com>
References: <75ef45cb-4c00-4b27-87cd-3c2914f5dbcc@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75ef45cb-4c00-4b27-87cd-3c2914f5dbcc@redhat.com>

On Fri, Nov 14, 2025 at 04:54:01PM +0100, Mikulas Patocka wrote:
> Hi
> 
> What do you think about this patch?
> 
> There are two problems with the recursive correction:
> 
> 1. It may cause denial-of-service. In fec_read_bufs, there is a loop that 
> has 253 iterations. For each iteration, we may call verity_hash_for_block 
> recursively. There is a limit of 4 nested recursions - that means that 
> there may be at most 253^4 (4 billion) iterations. Red Hat QE team 
> actually created an image that that pushes dm-verity to this limit - and 
> this image just makes the udev-worker process get stuck in the 'D' state.
> 
> 2. It probably doesn't work. In fec_read_bufs we store data into the 
> variable "fio->bufs", but fio bufs is shared between recursive 
> invocations, if "verity_hash_for_block" invoked correction recursively, it 
> would overwrite partially filled fio->bufs.
> 
> So, I'm suggesting to remove recursive correction at all. This patch
> passed the cryptsetup testsuite. Does it pass your tests too?
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Guangwu Zhang <guazhang@redhat.com>
> 
> ---
>  drivers/md/dm-verity-fec.c    |    4 +---
>  drivers/md/dm-verity-fec.h    |    3 ---
>  drivers/md/dm-verity-target.c |    2 +-
>  3 files changed, 2 insertions(+), 7 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
