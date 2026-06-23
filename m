Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8950D2E717B;
	Tue, 23 Jun 2026 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782231460; cv=none; b=Azxod75hVVpVLgTeh6yxSMmkAs7u/MeqL4HSitOxhDjiAWALgBZM3OTGQhPcns0loax+DBrSGCCeW5PR/ecUF9xvzdzvzJVqEfn53DBv8BL8Ex8shN631rCwtrW5V1/e/2jZHRWNTVtrBdwXAfERs1Acpm34S17MoqZyLnrurWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782231460; c=relaxed/simple;
	bh=JqN+XApthMKw0Xt3sDMOQwY5FP0A1lVTmMZG3shfJRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxVBCmVxkniM0cU5dqTAbq65+RQt/cwUzwowPWpBVOs0q69NU/h358ztO0/f1XAGXVE5HSQ679nqb0e/8u0kEHmk7q3fg1UI16dqHMFrBN3YsIMqGQnmEWw52GWXuaioeNTTk/yk+mKkWHO82IGGpLxkNCJ+7bW9s/x+2g/4rXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qf48XRbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qf48XRbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59AF1F000E9;
	Tue, 23 Jun 2026 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782231459;
	bh=R6/LZhSKXz0DdN/N6n1Mz5Z1IYu0jU7zuRmUKfW8tPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qf48XRbLhRyY97EF12Wmggc9mwgKREcAwmGHUy8EkFz7TBPqvwulrefHFCfex8BHS
	 +OF9EVB5O03UXxED9+yPCFj6YHXs2oju8KLqu/gBiuG8SVuVphY6LuxpeOsGMWInry
	 GbG1kArDA/hoy/BpjuNSJqeheSC6o8C7cMFtV9R4XZ6I3QOEXD0oTGQMJo5iuYgYTQ
	 gLE/uloYOE0QxNWR1lg7LJcmFo30BukdxT6b7/ArrJtdvsn7OkqVGYm4jbFrs1WU2C
	 QCzDOPPQUha7J/y8mqr6OZptJoxV2svQgdKezOm69swumRpsENsKP8my9ek1+XNDTv
	 inQx+xeyWVgdg==
Date: Tue, 23 Jun 2026 10:17:37 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: [PATCHv2 6/6] block: validate user space vectors during
 extraction
Message-ID: <ajqxoeZ0R_RwqEKe@kbusch-mbp>
References: <20260622174241.2299563-1-kbusch@meta.com>
 <20260622174241.2299563-7-kbusch@meta.com>
 <20260623151021.GA14919@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623151021.GA14919@lst.de>

On Tue, Jun 23, 2026 at 05:10:21PM +0200, Christoph Hellwig wrote:
> > +	/*
> > +	 * The vectors are owned and laid out by the caller; we only forward
> > +	 * them. Most callers are already aligned, but io_uring can place a
> > +	 * user chosen offset through a registered buffer, where only the first
> > +	 * vector may be unaligned.
> > +	 */
> > +	return !(mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
> > +							mem_align_mask);
> 
> I don't fully understand the comment.  I guess this is to say ITER_BVEC
> users better don't create any alignment gaps?  Maybe we should also
> clearly document that in uio.h?

Exactly, the in-kernel users of ITER_BVEC that allocate their own
buffers are, as far as I know, aligned already. Fabric storage targets
like nvme allocate their own SGLs on page boundaries so the bio is
aligned at the point it was constructed.

The ones that forward user buffers like loop and zloop are addressed in
the previous two patches. They generally should have been fine for most
hardware without those updates, but they're included in case a backing
device has more restrictive constraints than 512b "sector_t" aligned.

The only other user space provided alignment that I think may trip this
up is the io_uring registered buffer, so that's what I'm trying to call
out here.
