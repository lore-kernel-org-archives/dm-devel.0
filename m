Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468BD31E848;
	Thu, 18 Jun 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790664; cv=none; b=J6II0eI1ZRRNvb2/8dZexRMaWp2JabJFgFWeh3wr5OA9TPQ31fCfj7riKjGPcey6Vfic/36Vks9VCTbUpmW/EZh2ZSyq5zcFnQm+f+CHk3vZpRQ31UiZ5u8IqrI601FJsO65WxH4Nijni8avxVDjKkv+rPWBAybJW8j+/pnfw40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790664; c=relaxed/simple;
	bh=pKc6SS8uAML39Ppryw70MR5Sdxt0EKip0fAphJGYqkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rA9yAEdkiJEWY+aZhGVJ4I3d2mvX3AbseZHKfiqjT0KBCs3yRhxfw0vO3oTSfej+AsGoZn/dHO5ubjFeFttJzR6qJb4DpK8MjZVsUUkFeYundUPRbsZx91YmzrxQ90/TS4rlIJ7pxjAVkCGBoeoA0uV+IYBaReUYT/FG7My9f5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMekl4mC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMekl4mC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD321F000E9;
	Thu, 18 Jun 2026 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781790662;
	bh=x2xVP5fN8sggM5zWCK8BYn27nm4LN3XasYt1gta5ioA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MMekl4mCDwd1ZP5MduDsQ+HPBE9bgxpj+rsYWwUijGYCTmCZtQF0JQaavtmjzw0zl
	 hNYSYWMOTfDLD4g4ZTJ9+nxAbPqwtqtHUI9z0wUUtXW9ZiciaQLdZjchkCvwuOfmV6
	 jcKl3h/bLQv7BV0awzjniuDU9EH++GtyV4vve4bRvZQMajZPM7DS/VwPGV5vzJchBp
	 Dopsxzc0XLOdUH9uAWLEjP3ZyFfeSibd3IZCtd5lbCPUfo6xTTy9l8+yy5WVnqpT5+
	 L0PXSfYa2nTYZqmhQmJjFz2B+EUFq7WLaeVEJBGgeka6kcbsZycRbTfozTSBzQPsXu
	 l+6ZJC0YKwSXw==
Date: Thu, 18 Jun 2026 07:51:01 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] block: validate user space vectors during extraction
Message-ID: <ajP3xZOlaMVz3VUr@kbusch-mbp>
References: <20260617233235.1016063-1-kbusch@meta.com>
 <20260617233235.1016063-2-kbusch@meta.com>
 <20260618102627.GA23200@lst.de>
 <ajPv7yOoYsR5O6kf@kbusch-mbp>
 <20260618134346.GA2752@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618134346.GA2752@lst.de>

On Thu, Jun 18, 2026 at 03:43:46PM +0200, Christoph Hellwig wrote:
> On Thu, Jun 18, 2026 at 07:17:35AM -0600, Keith Busch wrote:
> > > >  	if (iov_iter_is_bvec(iter)) {
> > > >  		bio_iov_bvec_set(bio, iter);
> > > > +
> > > > +		if (mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
> > > > +							vec_align_mask)
> > > > +			return -EINVAL;
> > > 
> > > Can you add a comment here?  Especially as the bvec iter doesn't actually
> > > require all individual bvecs to be aligned and I'm not entirely sure this
> > > handles all case - writing down the rules might help a bit with that.
> > 
> > The rationale is that the only iter_bvec users come from io_uring
> > registered buffers, which are virtually contiguous.
> 
> There's plenty of iov_iter_bdev users, and even without poking deep I
> know that two directly passed on bvecs from block-layer generated bios to
> the underlying file system's direct I/O code: loop and zloop.

Oh, I meant only users that go through this direct-io path, but you're
right, I was wrong about that too. The nvme target file backend can also
get here in addition to what you pointed out.
 
> So we need rules on what can be passed, and preferably some way to
> enforce that at least for debug builds.

Yeah.
