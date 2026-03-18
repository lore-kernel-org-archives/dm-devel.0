Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8110A3DFC85;
	Wed, 18 Mar 2026 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773858776; cv=none; b=EKf/UTpAK4QkV/wHlkMp31BOxFsTz/nHcxTB8a0CpwzLLlCxwVJ+ZgH9VHkz/v4tvQOyQbCv4+8K7z2CdhspP/ldD/FYtN92Q9HVxLlnCvDfQ2ojT9ewQGfsAnN2ttQi2upoCsQC7rF8cX/+3C4/qLxJy6bm9k5706tVL5YB79A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773858776; c=relaxed/simple;
	bh=HuhgTLNeaKxjxIlJNDT2ePsJQlFEGU5KP/g6MqVULao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+A0AbDpgWgzsJRECA7ZVhMwZfZciFlc3LojM8hyUG2vdhVFzhFoK4/Cwqql+fUEjUg5XukCMhjgSj0osJm1S2GoM7LfzdjWRCLGHotRMTL9F5s6xNigzBZCDyYfwG3Jn4K+eEFvkLR/OSouBfR94O2LKgsWhT7frHGVHT0thr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QW5SFreD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QW5SFreD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8967C19421;
	Wed, 18 Mar 2026 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773858776;
	bh=HuhgTLNeaKxjxIlJNDT2ePsJQlFEGU5KP/g6MqVULao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QW5SFreDMlQ67ekxXodx3GvikbLJMS3H7l2Mm1AJxNFPRdme6a2BUJSVIukhXisJ2
	 RSPOVnZw/GQIILpHH7U7NlnYsYf2yBMtODTl9VqEjXzZPQ/A4Kubv+J4NvK7upwxtm
	 fwu9sGKU2ETw+c0kCa9wwdp+wBGKjRdGhXgVD43VNNwtvFgxETh1Pvq7fFQOxzioYz
	 9AJgRATtn5r1joiQjLjdEXKFsW7fc6eu2vCHyWKxKPJY1o7VLYWdZvGuDOBYu9MncC
	 bo72iyXJW6JORb/TVm5dxM0AQAgG7RF8KCGMAafYpj0ig9EJSEYG2LdAf2cKVA4pHt
	 S09g9AMnHREzg==
Date: Wed, 18 Mar 2026 12:32:53 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many
 segments
Message-ID: <abrv1Zk_L8yoovW4@kbusch-mbp>
References: <20260316150229.1771884-1-kbusch@meta.com>
 <20260316150941.1813568-1-kbusch@meta.com>
 <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com>
 <abraWvuLlTjHF-9q@kbusch-mbp>
 <7cdd50b4-afcf-aa5a-af0b-a00a35b88bdf@redhat.com>
 <abrmlumkhOQEBk-Z@kbusch-mbp>
 <d8cc89c8-be4c-3d62-5855-2c6021d77b56@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8cc89c8-be4c-3d62-5855-2c6021d77b56@redhat.com>

On Wed, Mar 18, 2026 at 07:16:15PM +0100, Mikulas Patocka wrote:
> On Wed, 18 Mar 2026, Keith Busch wrote:
> > On Wed, Mar 18, 2026 at 06:40:52PM +0100, Mikulas Patocka wrote:
> > > On Wed, 18 Mar 2026, Keith Busch wrote:
> > > 
> > > > But even then, the only thing I know of that really wants this has an
> > > > offset that straddles two pages per block, so I never need more than 2
> > > > segments, and the inline scatterlist has four. There's just currently no
> > > > way for the block layer to report a max-segments-per-block limit, so I'm
> > > > including this patch to be consistent with the reportable limits.
> > > 
> > > Can userspace use preadv/pwritev with many small iovecs on a file opened 
> > > for direct I/O?
> > 
> > Yes, I have several patches that were accepted last year to block and
> > iomap that align direct-io memory requirements to the backing device's
> > dma constraints. You can do dword aligned and sized vectored IO to a
> > block device today if the block limits say its okay.
> 
> So, we must support worst-case scenario - "cc->sector_size / 4" segments. 
> 
> sector_size can be up to 4096, so there may be up to 1024 segments. Each 
> segment consumes sizeof(struct scatterlist) bytes - that's 32 bytes. So, 
> we allocate up to 32768 bytes.
> 
> kmalloc with size greater than 32768 is unreliable - so we are just on 
> this limit.

Direct-io hits the BIO_VEC_MAX limit (256) first, so 8k for the
scatterlist (not great, but less terrible). You can have some 4-byte
segments in the user request, but the average segement size would have
to be larger. The important part is that any segment can start at any
memory address dword alignment offset.
