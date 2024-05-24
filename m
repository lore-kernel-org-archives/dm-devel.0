Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFBA9475
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 07:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716536408; cv=none; b=Dbu0GUzENzo+hZVJQF8GLg8JTL9Ye7GkJwRoJZ1ewFnSMLflvfaeSrzDWp4U/7KJ1+uDFHqUIE28RjnZ6SOYQTZu4iAz74cDGBOFgzQdOrQsVvEdsJpbrbMwpVJrtP8BibKFUNNdqaLbtTFeNaS3evGKuMiNgfGoAr1FawgL0C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716536408; c=relaxed/simple;
	bh=d9uYQyhdcHAhJqhLyJS2puAOrgGCGS6DbNQ4um6HGjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gA3JiP6Rcp6ZtNmRJYDfSalLjNKTNmTAasV8PO5UiQ+tHnyh0UZ7O8u4RI3we3K6gkzClRO6WvOMikSDs3TrSBrX+hNffJXp2mr28OZXhchwHiT2i5j701ob+Z+PSwY1ag9Ufpij41M4etLPaTYhTSlk+Dyl4LddLxv8J93eKwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F58368B05; Fri, 24 May 2024 09:39:57 +0200 (CEST)
Date: Fri, 24 May 2024 09:39:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] block: blk_set_stacking_limits() doesn't validate
Message-ID: <20240524073957.GB16336@lst.de>
References: <20240524062119.143788-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524062119.143788-1-hare@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 24, 2024 at 08:21:19AM +0200, Hannes Reinecke wrote:
> blk_validate_zoned_limits() checks whether any of the zoned limits
> are set for non-zoned limits. As blk_set_stacking_limits() sets
> max_zone_append_sectors() it'll fail to validate.

Except that you now broke it for zone devices.  Normally if we are
not building a stacked zoned device there should at least be one
underlying device that has a zero max_zone_append_limit, thus lowering
the stacked device limit to 0.  I guess you have a scenario where that
is not the case, so please explain it so that we can fix it.

