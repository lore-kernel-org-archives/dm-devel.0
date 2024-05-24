Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276BC1AACC
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716568904; cv=none; b=EnI+I1YSc1JK8ZF7aZePCplTVVkrrcOc4sU/kqHnXqU4aHCI04Kx3tQBPa9axqJt0sPAs30Sfg5Fa6DQX70BbZDyFvh8Co5t+I3Xv+2gTkELyZsWYQ1i1kNX1pYDK3CLu7hgppfq1QGMa9Fmr+XBnvMIwNV6mIC4fYj8JmYemHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716568904; c=relaxed/simple;
	bh=WdCP+tpQ/PR7E/dXZ6DMDE/eLw9K/L4mA/B4OTugpx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KC85QH7Z60AbP8+/PrXhKeXNedKKGyej0MhwhW9kIJpnctw11Xr5Kcl9DS0qQvYtPcX7nn102VCAvLT5dm4NudNgecq/Ht8fMlpZ7IkQdSFzS8lZOYCTvh1bYW2kK6mj4nVhHVLaMAMCLdc8+/vgti/J2HccG/yqDH0MaGXVIQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2BE2168B05; Fri, 24 May 2024 18:41:39 +0200 (CEST)
Date: Fri, 24 May 2024 18:41:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 3/3] dm: make dm_set_zones_restrictions work on the
 queue limits
Message-ID: <20240524164138.GB21444@lst.de>
References: <20240524142929.817565-1-hch@lst.de> <20240524142929.817565-4-hch@lst.de> <ZlCvAZMBftEgovjJ@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlCvAZMBftEgovjJ@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 24, 2024 at 11:15:13AM -0400, Mike Snitzer wrote:
> > +	if (limits->zoned) {
> > +		r = dm_set_zones_restrictions(t, q, limits);
> > +		if (r) {
> > +			queue_limits_cancel_update(q);
> 
> Not aware of a preceding queue_limits_start_update().

True, that's actually hidden in queue_limits_set for the stacking
case.
