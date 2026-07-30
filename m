Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD98D3B0AEF;
	Thu, 30 Jul 2026 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410792; cv=none; b=bLy+NkFqb+39qr/2DePT5qsS5L4OTEl2n3ina0rfqFv34Wu+DrmBjfyY1hMZRKyzJGx/VMDzFSHXXc4yLeWWkOO9DJRr21rbDa6fnFReN4/bgcvOZZ3CnsKu3MfkgkSgQHhsjopO6SMoc297yLGMOPqLRTNab1IA8+IKAhZIZxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410792; c=relaxed/simple;
	bh=R+m8QtR9ceOKDEHgPb+6KIlq1t3NMCX0Q1A58q+CDYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThXzOqGV7JDAq276MJNlXTeFCXMIgtOwmMIKlFMf6TOsV+CF5ASjytEnadRFuAdQ1jXV6EaK5WtsD7cW/qfAqRK0VejHsWM5MjTG9lfhg9QWTxM25GJt9hyfSwOrtIw4WDrggCFN7ZUoNgLt+cmQ3O1MogdgNLCOAQutSLKyaeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD8C168BFE; Thu, 30 Jul 2026 13:26:26 +0200 (CEST)
Date: Thu, 30 Jul 2026 13:26:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, brauner@kernel.org,
	djwong@kernel.org, viro@zeniv.linux.org.uk,
	regressions@lists.linux.dev, torvalds@linux-foundation.org
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
Message-ID: <20260730112626.GA24827@lst.de>
References: <20260720201057.1862857-1-kbusch@meta.com> <ampRQyXDbGgeg49V@kbusch-mbp> <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk> <ampce7mxSmxAwAiu@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ampce7mxSmxAwAiu@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 02:03:07PM -0600, Keith Busch wrote:
> > > Hi Jens, have you had a chance to look at this one yet? This addresses
> > > previous issues with certain device mappers under direct io.
> > 
> > I they look fine, but at this point we should toss them into 7.3. Yes
> > I know there are regressions around this, but from 6.1x days. And the
> > series doesn't apply to the current block-7.2 anyway.
> 
> This series is kind of old at this point, but yes, it's not fixing a new
> regression either. I'm okay if this goes to the next window, and I will
> handle the stable follow-up.

Honestly, I think that'a a reall bad idea.  This is a regression in 6.18,
and while it took a while for people to hit this with their a little
more complicated lvm/md setups, it has stopped real systems from being
used.  We need to fix this ASAP.

