Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13A315BF;
	Tue, 12 Mar 2024 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710260901; cv=none; b=Yw8V2UFIy0W0+BNmQKy7UlywzEMhMqySJQUj5WbDgZwhX1b9Omc9Xlv7LxjHLA/sBaUenjxHnZV2N0qlreffX8gBUSHd1sSaMplQmvFUV/T7U0mNSPkXdhujp6uZ6DYdf5wVCefmu5Ag3m7kYGb8Pje6o2cV4muyj7+nr2Xe2R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710260901; c=relaxed/simple;
	bh=r/j95J5n7Z6hwkgQ2XI+DUlAXhGMCNF4FSZGRMWw2ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2lGiY4h4t5yBaN2uJrP6awz5rnZBJHaHcx3sxybKRRV0SssiFPZtH1ZinGD4lpYcZN9R3gGlqpDATIh2Zi3o0rnuvxw/0PjOH5WK3XMaXqaEOnBW0MAutFjEI+mTUOLcVv7vAYjrj/OlYpjDEIhVnOai/FXNFaJ1B2E91hK2sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cegzNqwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cegzNqwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AF8C433C7;
	Tue, 12 Mar 2024 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710260901;
	bh=r/j95J5n7Z6hwkgQ2XI+DUlAXhGMCNF4FSZGRMWw2ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cegzNqwcJ0e+dYCJf4WEBbVLWyoHocs5FwQyGISEJ58rxS2kB+z+Vlw+nQcfRj1zG
	 6dZ9RwqaHCWj0/AHGfPwVfxn+NjwXZsGqUs+8SMoz70Etm0oS+cWVAYImerDhl1cqD
	 3oAthPHWubz83dMRLghUUsFGz9dbfNd4pKlgImoPed9tlqq/GvnPV/BKX8yXtKDVge
	 PTyxLtwUi8rE9M3T1Zi4VeeOeMU59VANYXL08hIiJoYluvKWQBvhYH073NDqq2xmmo
	 3ykmVIeLwF7AHnYnN40ipIeMziEbyiMXQc9scbICkcOVROZy1J1pDIPUVTK1k6lINC
	 GXRLdasp+ei/A==
Date: Tue, 12 Mar 2024 10:28:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: [GIT PULL] Block updates for 6.9-rc1
Message-ID: <ZfCCoo2txxg1_XSE@kbusch-mbp.mynextlight.net>
References: <eaeec3b6-75c2-4b65-8c50-2d37450ccdd9@kernel.dk>
 <20240311235023.GA1205@cmpxchg.org>
 <CAHk-=wgOfw8NBQ2Qyh8QUjhp5z4v--PuciLE7drn5LJkTtgPVw@mail.gmail.com>
 <e3fea6c3-7704-46cd-b078-0c6e8d966474@kernel.dk>
 <CAHk-=wgXZ6dE1yHK_jQmnSjbEbndyzZHC5dJNsmQYTD2K-m61w@mail.gmail.com>
 <Ze-hwnd3ocfJc9xU@redhat.com>
 <Ze-rRvKpux44ueao@infradead.org>
 <ZfBzTWM7NBbGymsY@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfBzTWM7NBbGymsY@redhat.com>

On Tue, Mar 12, 2024 at 11:22:53AM -0400, Mike Snitzer wrote:
> 4) blk_validate_limits() will reject the limits that
>    blk_stack_limits() created:
>         /*
>          * Devices that require a virtual boundary do not support scatter/gather
>          * I/O natively, but instead require a descriptor list entry for each
>          * page (which might not be identical to the Linux PAGE_SIZE).  Because
>          * of that they are not limited by our notion of "segment size".
>          */
> 	if (lim->virt_boundary_mask) {
>                 if (WARN_ON_ONCE(lim->max_segment_size &&
>                                  lim->max_segment_size != UINT_MAX))
>                         return -EINVAL;
>                 lim->max_segment_size = UINT_MAX;
> 	} else {
>                 /*
>                  * The maximum segment size has an odd historic 64k default that
>                  * drivers probably should override.  Just like the I/O size we
>                  * require drivers to at least handle a full page per segment.
>                  */
> 		if (!lim->max_segment_size)
>                         lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
>                 if (WARN_ON_ONCE(lim->max_segment_size < PAGE_SIZE))
>                 	return -EINVAL;
>         }
> 
> blk_validate_limits() is currently very pedantic. I discussed with Jens
> briefly and we're thinking it might make sense for blk_validate_limits()
> to be more forgiving by _not_ imposing hard -EINVAL failure.  That in
> the interim, during this transition to more curated and atomic limits, a
> WARN_ON_ONCE() splat should serve as enough notice to developers (be it
> lower level nvme or higher-level virtual devices like DM).
> 
> BUT for this specific max_segment_size case, the constraints of dm-crypt
> are actually more conservative due to crypto requirements. Yet nvme's
> more general "don't care, but will care if non-nvme driver does" for
> this particular max_segment_size limit is being imposed when validating
> the combined limits that dm-crypt will impose at the top-level.
> 
> All said, the above "if (lim->virt_boundary_mask)" check in
> blk_validate_limits() looks bogus for stacked device limits.

Yes, I think you're right. I can't tell why this check makes sense for
any device, not just stacked ones. It could verify lim->max_segment_size
is >= virt_boundary_mask, but to require it be UINT_MAX doesn't look
necessary.
