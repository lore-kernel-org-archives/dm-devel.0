Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE523E229;
	Fri, 26 Sep 2025 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758903430; cv=none; b=kSxFlyMkLQNiosv1uJRsNUnJ2OSIpsJkBoKd/EjNhAUny63boJ/e49y9vTRoW2pDTYOCSKCffPr0L+7vM7VdRag4rKvm8ztpVPIjp96paIRuAnqI+TgLSV4Q5sc7/idG6WCOmMhwH0SK5DPQQF93kuOgcD9AwEOlmSk8v2+ZBRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758903430; c=relaxed/simple;
	bh=xAvuKcyN7VL20OsOj8SivIeSbwW9mQxLg5NRd0fpFk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGv0Vz0Vx8GyVabfKnvATZF1CiOBMZ4e3g1JLkvhNTn7sSmgatObNGS5iT9D7yZkv/NAH/0QvRsUwhDVSKhOTNuoaDCRc7H1RpluEn7YGB6VlFHwmA0v9PvYawOkIbLCRHxNhHmB/7uiZL+ZaxPL0hLEaVAhJFIMyDegIyn7grA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rufHO2J8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rufHO2J8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DD2C4CEF4;
	Fri, 26 Sep 2025 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758903429;
	bh=xAvuKcyN7VL20OsOj8SivIeSbwW9mQxLg5NRd0fpFk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rufHO2J8Kf49HehauJy20J2cU/8t/ZwKm/ZGO5xLG0pY4wEgr8zOB85LuNcAPzsT4
	 XY+IU+onIPmPjU5SXmvbASpS96j5/uM6SsLR1V4srzsTYuoYOP9n2JQMwyBujwQzTg
	 TQ7znSmYdI0Pzq6FJZMQfpnHFrwGxxuIU1mcARCSNEGCwHhq8lWPtbNuZJeOuKkMk1
	 4r//iMHYPNe3her2n1gdv3J/ehu08tbMwi5KUOVFBZ31IHPnkYhnmjIrpRYDDDChyy
	 w+ET3VtFh/he60+tFoFFf8VE1/vLp/Vxux/vgGQf7vWINBdLlRhlETS0j6oiNMFzOy
	 3ekOJreE6B5/Q==
Date: Fri, 26 Sep 2025 10:17:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	snitzer@kernel.org, linux-block@vger.kernel.org,
	ebiggers@google.com
Subject: Re: [RFC PATCH] dm-crypt: allow unaligned bio_vecs for direct io
Message-ID: <aNa8g0IZuQZvA93v@kbusch-mbp>
References: <20250918161642.2867886-1-kbusch@meta.com>
 <aMxnzIavwnJmdAz1@kbusch-mbp>
 <f3d06d99-638d-99a5-03e3-686b544d97ac@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3d06d99-638d-99a5-03e3-686b544d97ac@redhat.com>

On Fri, Sep 26, 2025 at 04:19:58PM +0200, Mikulas Patocka wrote:
> 
> I'd like to ask - how much does it help performance? How many percent 
> faster does your application run?

The best info I have from the storage team I'm working with is this
reduces their application's memory bandwidth utilization by a little
over 10%.

> Another question - what if the user uses preadv or pwritev with direct I/O 
> and uses more than 4 sg lists? Will this be rejected in the upper layers, 
> or will it reach dm-crypt and return -EINVAL? 

I believe it would reach dm-crypt with this patch.

If you tried today, it should get rejected by the upper layers for
unalignement. But there are some changes pending in the 6.18 block tree
that defer the alignment detection to later such that dm-crypt may have
to deal with this and fail the IO (unless something higher splits the
bio to its queue limits first), so sounds like I should sort that out.

Regarding the 4 scatterlist limit, we're using 4k sized logical blocks.
The incoming data typically has an offset crossing a page boundary, so
needs 2 pages for each block. Just 2 scatterlists would do the trick.

If we really want to remove all software constraints here, then we could
increase the pre-allocated scatterlist size, or dynamically allocate an
approrpiate scatter gather table per-io. I guess we'd have to expand the
list somewhere if this needs to work with aead, too.

> Note that returning error 
> from dm-crypt may be quite problematic, because it would kick the leg out 
> of RAID, if there were RAID above dm-crypt. I think that we should return 
> BLK_STS_NOTSUPP, because that would be ignored by RAID.

Thanks, I'll try this out.

> I am considering committing this for the kernel 6.19 (it's too late to add 
> it to the 6.18 merge window).

No problem, I don't want to rush this. Your reply is at least
encouraging enough for me to sort out more than just "plaint64" with
this proposal.
