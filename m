Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063F23AE715;
	Thu, 30 Jul 2026 12:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415956; cv=none; b=XO26x+RpTpQwDcw4GHZNUJ+Ob+dvN8VS6KMxoTQMljSenl38kYmAx/gwvvKQbNI/Gy4T7A0mOHc8FwQdYD2f9YXP882m9XUPWqi/O2fTkivvmEEk5ewX1v8wvBqtS0TmpRuWVSNy0eyGWNK2JjC+cDHPOhkNLRrRuCEdt6CThvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415956; c=relaxed/simple;
	bh=07lNuD5ptxWBI+AKSt0qjJALzC9Vhu0wMgNXOgZOB7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4y9CriipKg1xbhhQkgL6OFvQTxiXSHtqaP9Se+qzABSmTLy79elOwTR2bXLAvRw/79tavLijTDQMclB6YYBLAA79dYOHTz6uJ9pThNiisfKt6SW7x9XHlN4aa4q+30eHadTVAHCjy+Dx1aVqjp2qqgM+qLIIRcXOWRi10NL23c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5K6VOjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5K6VOjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CC81F00A3D;
	Thu, 30 Jul 2026 12:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785415950;
	bh=wNLqfaailhWRC00dmZqTCn7FJigC0qHjk4FhgDFhBVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f5K6VOjziwdzVIf0zfQ/D3pK3Tn8Qp/A0rG3aDbF/zWVcL3VQtNOOz3qvgfjbBSNn
	 PH2VLeW5rlDN5FAZosashIdwpIZuzT91qT4rWGczTrBobCRHKAmwTi422HtJPpjBKN
	 O1sEXxn3SLQx3ZWGMt+u7UnKoo9kzMZydj4H5Y8MeqQHt8YIHK6cNAVlDkTeKpRIqa
	 uzG66knLe9JRxS469iLnP6dFzZAmPmmvbbkipmlS16DpKpMAA4sU1yDrM0l5sKe94e
	 hDv5uB1r+LhCsqktb5qhMBGqDe9opSRSb40bNLubJlJ5uXMPX6TUhTXeNm2YhENRtQ
	 HkKC+pUlRdgzA==
Date: Thu, 30 Jul 2026 06:52:28 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, regressions@lists.linux.dev,
	torvalds@linux-foundation.org
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
Message-ID: <amtJDCtczVyX1baB@kbusch-mbp>
References: <20260720201057.1862857-1-kbusch@meta.com>
 <ampRQyXDbGgeg49V@kbusch-mbp>
 <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>
 <ampce7mxSmxAwAiu@kbusch-mbp>
 <20260730112626.GA24827@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730112626.GA24827@lst.de>

On Thu, Jul 30, 2026 at 01:26:26PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 29, 2026 at 02:03:07PM -0600, Keith Busch wrote:
> > > > Hi Jens, have you had a chance to look at this one yet? This addresses
> > > > previous issues with certain device mappers under direct io.
> > > 
> > > I they look fine, but at this point we should toss them into 7.3. Yes
> > > I know there are regressions around this, but from 6.1x days. And the
> > > series doesn't apply to the current block-7.2 anyway.
> > 
> > This series is kind of old at this point, but yes, it's not fixing a new
> > regression either. I'm okay if this goes to the next window, and I will
> > handle the stable follow-up.
> 
> Honestly, I think that'a a reall bad idea.  This is a regression in 6.18,
> and while it took a while for people to hit this with their a little
> more complicated lvm/md setups, it has stopped real systems from being
> used.  We need to fix this ASAP.

This should have gone in several weeks ago, IMO. You can most readily
hit a problem running qemu against one of those lvm setups. We're just
so late in this release cycle that I'm not pushing hard for 7.2, but I
would support that choice too.
