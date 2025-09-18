Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48A214A9E;
	Thu, 18 Sep 2025 20:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758228743; cv=none; b=VAWFc1uu3137BL/4Dx8P4QheON8C+z4d6SgbDMy6yHs7Y/FGGNVnXXn30xEIUHEKAxACyxU/2Tj95JfKpeIdi300UXnX4604q4/WQYK3pKCihB74lOYklYE210foqItgNznnxKJmhXyN27mnJjt8h/hd41ZZODdT+CFmozPetbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758228743; c=relaxed/simple;
	bh=OtpT5m1f6K1kMPx38uQO22JI1+n9ZmR8kcwDSVVAVX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVkG+1G9oA3SdtpMTtRCE7ecEdrsAA+l7OGkTXj2Do0MPyPWPrWG1zQNXRkiEtTCByUz0/LwZA36386wovVs7qh926EmIaRCMYS5jkck6xxKibKn4S8hIDlYaRZznJp428Gfq/47TvAz3v5T/VX2UuMY6WQtnRP9/UG+wB89hyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O159E+xa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O159E+xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E18EC4CEE7;
	Thu, 18 Sep 2025 20:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758228743;
	bh=OtpT5m1f6K1kMPx38uQO22JI1+n9ZmR8kcwDSVVAVX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O159E+xadTyJsYxUds+2wpLfke8K/oq2pihkJAbvIGdZNxWKMs9LFU13egy7TcnEh
	 NLHlIsfmYTqcv+GIUPojsfiiVCip3Qypu6kS2bDF6fjL7E8qrok1Jdp1IAG5quD1tt
	 a7oN0RZVoA6udVPoQbrFJgO5jjbhmq1stPs2BrMAn31RVA+4Zd6851qcpwc3KFlo+c
	 tLXAHSfUnH6J0HyQ97VTBpS3GBuxfAZ9orr5sMClXNmbY3NgTpHc3ddFgcMKz+PM6z
	 AwG2GN6LUITpQR3D8gQP+fM4lsrf2wV/dIGlRrVKyVa6XOFMgGwXxpVJmPDS3rl1tH
	 hkiWXGLcRdDmw==
Date: Thu, 18 Sep 2025 14:52:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	ebiggers@google.com
Subject: Re: [RFC PATCH] dm-crypt: allow unaligned bio_vecs for direct io
Message-ID: <aMxxBWQAL8ws8pGa@kbusch-mbp>
References: <20250918161642.2867886-1-kbusch@meta.com>
 <aMxrIjcFqaT2WztN@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMxrIjcFqaT2WztN@kernel.org>

On Thu, Sep 18, 2025 at 04:27:14PM -0400, Mike Snitzer wrote:
> On Thu, Sep 18, 2025 at 09:16:42AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Most storage devices can handle DMA for data that is not aligned to the
> > sector block size. The block and filesystem layers have introduced
> > updates to allow that kind of memory alignment flexibility when
> > possible.
> 
> I'd love to understand what changes in filesystems you're referring
> to.  Because I know for certain that DIO with memory that isn't
> 'dma_alignment' aligned fails with certainty ontop of XFS.

I only mentioned the "sector block size" alignment, not the hardware dma
alignment. The dma alignment remains the minimum address alignment you
have to use. But xfs has been able to handle dword aligned addresses for
a while now, assuming your block_device can handle dword aligned DMA.
But the old requirement for a buffer to be aligned to a 4k address
offset for a 4k block device isn't necessary anymore.
 
> Pretty certain it balks at DIO that isn't logical_block_size aligned
> ondisk too.

We might be talking about different things. The total length of a
vector must be a multiple of the logical block size, yes. But I'm
talking about the address offset. Right now dm-crypt can't handle a
request if the address offset is not aligned to the logical block size.
But that's a purely software created limitation, there's no hard reason
that needs to be the case.

> > it sends a single scatterlist element for the input ot the encrypt and
> > decrypt algorithms. This forces applications that have unaligned data to
> > copy through a bounce buffer, increasing CPU and memory utilization.
> 
> Even this notion that an application is somehow able to (unwittingly)
> lean on "unaligned data to copy through a bounce buffer" -- has me
> asking: where does Keith get these wonderful toys?

I'm just trying to write data to disk from buffers filled by NICs
subscribed to io_uring zero-copy receive capabilities. I guess they need
fancy features to do that, but it's not that uncommon, is it? Anyway,
the data that needs to be persisted often have offsets that are still
DMA friendly, but unlikely to be perfectly page aligned.
