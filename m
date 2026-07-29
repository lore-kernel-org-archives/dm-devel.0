Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D262E2F0E;
	Wed, 29 Jul 2026 20:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785355390; cv=none; b=lLIX+jgLeBS3ZSyzQNuUeQpPkfPLINXVK1OSwR3Ay/5sDoz8QE2aVL+pXjNknrY+TnKzq/0ob6uhJgoo87bkibtd2H0umO8zPAuTY1CIFFV/5bpYeQjXfUjrA/w0WvE1rhN6tBEOBjLr8qeWLEO/RPOQ7jmj7FdUWUMtbU7aAdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785355390; c=relaxed/simple;
	bh=p4KQgminFFewplGRKbGvY99DLbBsmXYppsmO7++5T7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ck0F06qYfDuF08lOLayQoMFvqQI1Fut3xkqBzpkQ4nlnTjMnIJXqWCXQ5j8KUsMIWBg1SawxRCZW5zkSQJeGTrrBot5i8PJSe2nUJqmyjBNPEY5BVCAzHbvyAd14v1ygDVqdtWf+oTAL5UlUOxjMP+hYQpMO1CM3Y5XBjHCqgJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjNVoXWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjNVoXWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE9B1F000E9;
	Wed, 29 Jul 2026 20:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785355389;
	bh=jml1C2l2PIIYHTPrel4zGWOzano3z0M7hg3hSJOdhFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NjNVoXWq5M+G2c52xvJAPqSQ8lDAxp9yLtJETJD8EFKATGXlaUi0rNbHHQjCyK+a+
	 kXDauYs2gJ6sm06Q3ZcaY5aOBl1NTyebFTzm+A/93y7HkgSJuO8XbCD5XHAycGYKSZ
	 EQzKJ7MTtlmDD85Lpp+GsWIKosezTzMfAypRd+N6FRJNtVlKfZTR+c+sf280cJmnfN
	 tjad712+CxEnQbE0iRTshSytX8qDhMPvc1oh6zX9Yk37L/SnO2BkEneT7oAy4PItek
	 MaRt29yB0it8JBrsTFF+sibFEBB7kqyakP5W6iOSbLp8wqsF+vyKsNUeXrvJD1ywYa
	 mSQygJefCcjOw==
Date: Wed, 29 Jul 2026 14:03:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, hch@lst.de,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
Message-ID: <ampce7mxSmxAwAiu@kbusch-mbp>
References: <20260720201057.1862857-1-kbusch@meta.com>
 <ampRQyXDbGgeg49V@kbusch-mbp>
 <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>

On Wed, Jul 29, 2026 at 01:18:40PM -0600, Jens Axboe wrote:
> On 7/29/26 1:15 PM, Keith Busch wrote:
> > On Mon, Jul 20, 2026 at 01:10:52PM -0700, Keith Busch wrote:
> >> This addresses the misaligned direct-io problem behind various threads:
> > 
> > Hi Jens, have you had a chance to look at this one yet? This addresses
> > previous issues with certain device mappers under direct io.
> 
> I they look fine, but at this point we should toss them into 7.3. Yes
> I know there are regressions around this, but from 6.1x days. And the
> series doesn't apply to the current block-7.2 anyway.

This series is kind of old at this point, but yes, it's not fixing a new
regression either. I'm okay if this goes to the next window, and I will
handle the stable follow-up.

Are you planning to start the for-7.3/block branch soon? I can rebase
the series if there's a conflict, and would be great to get this exposed
to linux-next.
