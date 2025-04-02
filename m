Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6AA1E7C27
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743615796; cv=none; b=Pbhxu+7hPEvnZseyvJNktOLHhbDRtmrg5XC6H/Ik6DRiCcXfGGtVG4lJJPJLCIRBR5UdxojHKO2d/9J+46/MxUgmhq4M9uKXknrBmyD1p3GGHqrRiuQs+4KmJwYAAzjOW5QXHkSqibGOIabDnA95hagIg4OfP5G6wFTYjQ5Acbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743615796; c=relaxed/simple;
	bh=aPnXSqN362836qS7NwPuyeHu4+HmFWetHlgOkvt+hL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYUbpsO8iEZ6DquXNodbjITFqnkMqIYrUaHwpeHrU1pFjNBA4Be5voaEZ2OauNRNX9wLr1r9v3w3lCVNuaUCmseD2MoCHobyC7Fz6mZ0lhH+DWE0CgwWrnLBpzeHLFnLg8ndSfeh8POpurzA/49Etnce1WWSi3xLc+0bIphgOAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWXGZSgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWXGZSgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2054CC4CEE5;
	Wed,  2 Apr 2025 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743615795;
	bh=aPnXSqN362836qS7NwPuyeHu4+HmFWetHlgOkvt+hL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWXGZSgycSiyGu0GVTgNsOyyt3iwWFpw0wDBZopw34cMfWqhMpRtGI6EmaPeMV6GR
	 D2FXUl8xBFPYSkG/rZhkgW1dzTXWKfnAGtCdL/pnrHnY6TRjUmiohNI61phcuYN4S+
	 aYLRfOcNRCasw5GwjoQQevVMob+du+rkNONfQDUiUTqEPDpfzK0lQ8U6+5rdCVNln/
	 mOJrfelbLkRaFo7n0jJKbG4HcUoJkCF8QE/yjaXa98/d7ilkdWm5Waz+9xE8d6RsXC
	 1ZaVH8wQbhtj2xLzzYRoKE+MAriEP0gzsVdyx2WxVCNqkh+G7CKmEGBWPQOrrdTseI
	 eQpGRuQq32Gpw==
Date: Wed, 2 Apr 2025 10:43:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	guoweichao@oppo.com, bvanassche@acm.org
Subject: Re: [PATCH 1/2] dm-bufio: improve the performance of
 __dm_bufio_prefetch
Message-ID: <20250402174313.GG1235@sol.localdomain>
References: <20250402070934.2387587-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402070934.2387587-1-weilongping@oppo.com>

On Wed, Apr 02, 2025 at 03:09:34PM +0800, LongPing Wei wrote:
> 1. call blk_flush_plug when cache hit as the address of the subsequent
>  bio is no longer contiguous with the previous bio;
> 2. skip cond_resched when ioprio class is rt;
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  drivers/md/dm-bufio.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Looks fine:

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

But I do think the prefetching should be reworked to be along the lines of what
I suggested here:
https://lore.kernel.org/dm-devel/20250327170524.GF1425@sol.localdomain/
Any chance you're interested in helping with that?

It also *might* be the case that the prefetching is no longer helpful and should
just be removed.  Especially if dm-verity will start prefetching the whole hash
tree anyway, as your other patch does.

- Eric
