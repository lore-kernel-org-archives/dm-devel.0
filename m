Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C346B3BB670
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790232; cv=none; b=hmg8xMOtNmq2Ep51uIIaARSLtOoijk+0r3ORAvHpaQldv4hNx47cvroBu7oBJRzAlA5h6vkJhs+cIQZmEoUXRJHjw5NUgyXiEWfsHEZg1OrUtsOo4fDb2+t9imu2ICIM4btMNSgx5TZ84PYZJFR9vd3DKx7r/MKvm7U96N3rV8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790232; c=relaxed/simple;
	bh=XKUehf4X8nwF3CflU///ls6TmM0Kev/2DLg5AaWT2N4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rG4yZ7f+Bczef3snwqHXEUi9U9PDYNp8Bc0v27Fx61PYgxNqJvsOfYd4+MWM0wMm3Unq03gUaueHN9R2Tr+ZgMQ3zoGh5I9YJVcgjJlALMMrJowJ0vzm9o+Ip4U8W5b+ka3506cFIbsxZ/dNMjTHurjY2+jWlK301heWgsiyU1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 033C668BEB; Thu, 18 Jun 2026 15:43:46 +0200 (CEST)
Date: Thu, 18 Jun 2026 15:43:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, axboe@kernel.dk, brauner@kernel.org,
	djwong@kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] block: validate user space vectors during
 extraction
Message-ID: <20260618134346.GA2752@lst.de>
References: <20260617233235.1016063-1-kbusch@meta.com> <20260617233235.1016063-2-kbusch@meta.com> <20260618102627.GA23200@lst.de> <ajPv7yOoYsR5O6kf@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajPv7yOoYsR5O6kf@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 18, 2026 at 07:17:35AM -0600, Keith Busch wrote:
> > >  	if (iov_iter_is_bvec(iter)) {
> > >  		bio_iov_bvec_set(bio, iter);
> > > +
> > > +		if (mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
> > > +							vec_align_mask)
> > > +			return -EINVAL;
> > 
> > Can you add a comment here?  Especially as the bvec iter doesn't actually
> > require all individual bvecs to be aligned and I'm not entirely sure this
> > handles all case - writing down the rules might help a bit with that.
> 
> The rationale is that the only iter_bvec users come from io_uring
> registered buffers, which are virtually contiguous.

There's plenty of iov_iter_bdev users, and even without poking deep I
know that two directly passed on bvecs from block-layer generated bios to
the underlying file system's direct I/O code: loop and zloop.

So we need rules on what can be passed, and preferably some way to
enforce that at least for debug builds.

