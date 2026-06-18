Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F88F49;
	Thu, 18 Jun 2026 13:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781788658; cv=none; b=PDBz6Bqulq5Rc+6IhBWTU/xqZKd+NQ/SsRQMkZkpCNmNsyQ/sMWitKhhLg5wbO29pGs/EyOa5qGFVg8AYtZcoo6/LD8h6CPMAinOFmM+hMerfm72zK0bNQbO9mtqTotLXzFE8O42I7j8izlj5qxsLhFCYt+JiTsmSNP0MGWhrKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781788658; c=relaxed/simple;
	bh=7lvUVxJQgs9T1NCRLLxwh4ARAP8CzLsEZiKAGOX/lzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=klla90WqQuikTW9q/LxyV6Bd27zoNOcvz8SF7pDDE5Q0R9Enu7kXpLGvB7B8urrqyfQVfuUJJrOFgnb025VLs0n1tg2Da0HmHJo+P5hmnjGOckERPLQegJzwODUKP1AOaUsqA4TJPq6scvwxCvJf6W+BcQPZmQ4tPCL9bUPo4FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lsh9OVVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lsh9OVVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A527A1F000E9;
	Thu, 18 Jun 2026 13:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781788657;
	bh=jpPKPCapCqBNEJwlVjxbOvVvWYzXbHXZeR9b6lZQkF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lsh9OVVwU538PN+8v4cAH5Rts8f9CsCeYUjOjksuOLzFWz3+Om4ASpg6IibKTwQNA
	 8SGTaGbaKFOxEBSSd5uBBmSdVFS+47fH0aWu/bgRESiddQvd0B/NL1PC8EwqX6HxHi
	 vqT6SIlP9IDGsKiaVVBfztU+hHplMlTC/u2WhUQMvxAe/sNq0g6WXf4U12/P/UDhr2
	 vtvkmmQhcCU+IcAxYD1phKAtroB6iyrRc8p2yhjbQpD3n2RpXRWSfvDQVG1gOhd8Uw
	 IIYuRvEC7wqE8O//9QVYl+9qJKZKhgZUX40oveBSHaZ1alkty4p4q0uPZUejXaORgo
	 kgUpdQG9dyj8Q==
Date: Thu, 18 Jun 2026 07:17:35 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] block: validate user space vectors during extraction
Message-ID: <ajPv7yOoYsR5O6kf@kbusch-mbp>
References: <20260617233235.1016063-1-kbusch@meta.com>
 <20260617233235.1016063-2-kbusch@meta.com>
 <20260618102627.GA23200@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618102627.GA23200@lst.de>

On Thu, Jun 18, 2026 at 12:26:27PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 17, 2026 at 04:32:35PM -0700, Keith Busch wrote:
> > @@ -1251,6 +1251,11 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
> >  
> >  	if (iov_iter_is_bvec(iter)) {
> >  		bio_iov_bvec_set(bio, iter);
> > +
> > +		if (mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
> > +							vec_align_mask)
> > +			return -EINVAL;
> 
> Can you add a comment here?  Especially as the bvec iter doesn't actually
> require all individual bvecs to be aligned and I'm not entirely sure this
> handles all case - writing down the rules might help a bit with that.

The rationale is that the only iter_bvec users come from io_uring
registered buffers, which are virtually contiguous. Subsequent IO
referencing it provides only an offset and a length, so the only
possible unlaignment could bne the first offset (we've already verified
the total length earlier). Every subsequent vector must be page aligned
at a minimum, which is the largest possible dma alignment the block
layer allows, so we don't need to check the rest.
 
> >  		ret = iov_iter_extract_bvecs(iter, bio->bi_io_vec,
> >  				BIO_MAX_SIZE - bio->bi_iter.bi_size,
> > -				&bio->bi_vcnt, bio->bi_max_vecs, flags);
> > +				&bio->bi_vcnt, bio->bi_max_vecs,
> > +				vec_align_mask, flags);
> >  		if (ret <= 0) {
> > +			if (ret == -EINVAL) {
> > +				bio_release_pages(bio, false);
> > +				bio_clear_flag(bio, BIO_PAGE_PINNED);
> > +				bio->bi_iter.bi_size = 0;
> > +				bio->bi_vcnt = 0;
> > +				return ret;
> > +			}
> 
> Do we need all this cleanups beyoned the bio_release_pages()?  Most
> callers just free the bio, so should not care about it, and the error
> handling in __blkdev_direct_IO that calls bio_endio looks buggy for
> other reasons..

Yeah, it's exactly for the __blkdev_direct_IO() error handling, though I
think clearing either the PINNED flag or bi_vcnt is sufficient after
bio_release_pages(). The rest is just resetting the bio to the initial
state since I didn't want to return both an error and something that
looks like a partially constructed bio, even if no one currently cares.

But since you mention it, __blkdev_direct_IO's handling does look wrong,
so maybe I can clean that up first.
