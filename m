Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0693242D6C
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 07:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782286747; cv=none; b=iRO6TA0PDw4MxvDSkaB1+fLNWHiSM2tq8rhqUj+jyoDSKZcn+VgA/PBpjwT1883EpJeHy6400NGLXGkc0BdFFuo+kpb20dDhzZgEq+0fU+uRDAQVj3CXQCHWBwej3wLI5iibIYg5baLT8/ERqSp/xuy2z7AFJ7VA5E9FMdaL/TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782286747; c=relaxed/simple;
	bh=Z4vHZNdWfmXhY08NWu9SAVKC9IY+kynM7MA+zCAUIZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOSNl0lS/c9dSqBc879RQFTjqoqOjXIy9liWQytAchmiTG/V8t4/B3R/1q0boOD4LMqzQPs7vjWwBk3B2Y1HJkSawnUrhvBF5+1qReWkop5HGD+2PRMnWDxRFq4ysyjkVv6J4Dc4uPlcQeood/rSBrJ18Vegm8wOISzZTRubJDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 300DA68BEB; Wed, 24 Jun 2026 09:39:02 +0200 (CEST)
Date: Wed, 24 Jun 2026 09:39:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, axboe@kernel.dk, brauner@kernel.org,
	djwong@kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: [PATCHv2 6/6] block: validate user space vectors during
 extraction
Message-ID: <20260624073901.GA12649@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-7-kbusch@meta.com> <20260623151021.GA14919@lst.de> <ajqxoeZ0R_RwqEKe@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajqxoeZ0R_RwqEKe@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 23, 2026 at 10:17:37AM -0600, Keith Busch wrote:
> Exactly, the in-kernel users of ITER_BVEC that allocate their own
> buffers are, as far as I know, aligned already. Fabric storage targets
> like nvme allocate their own SGLs on page boundaries so the bio is
> aligned at the point it was constructed.
> 
> The ones that forward user buffers like loop and zloop are addressed in
> the previous two patches. They generally should have been fine for most
> hardware without those updates, but they're included in case a backing
> device has more restrictive constraints than 512b "sector_t" aligned.
> 
> The only other user space provided alignment that I think may trip this
> up is the io_uring registered buffer, so that's what I'm trying to call
> out here.

Sounds reasonable, but it would be really helpful to have this in
the API documentation somewhere..

Talking about documented APIs and related bits:  do you still plan
to get back to exposing our pre-vector alignment requirements and
add tests to blktests/xfstests based on that?
