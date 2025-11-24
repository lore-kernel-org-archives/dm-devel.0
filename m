Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328F53043D0
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004355; cv=none; b=qXZT6IKdJTHO+iRiNVDiUDl2WpRKyYvLxeDXfWKXC+yL6JJhd6dRI5nYtDvkhEFcoGcdI3nPtesjiXMN3cRp4uErOos+t8cZdwKv87gofn7DjjC0TUB1LEkJUQtmD/03asjypVVplJeTZCDPrdxZSme5MhW8o+z5DYGry5Mqs+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004355; c=relaxed/simple;
	bh=IElTkPtUepoxZWCCFUry0ZzlqgirtvL9ZRknXY7xvzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEjyxRoAtN2aRBh/Sr+wJXfRRO3Z3idwA9aiHVxTEVJtFmfWIiq35yTWKpH//sQGB31nBddhN5Md3rgEI7mukn+CGqZGvVGQGkfQoDiNL7Z3cmk8mgGhxjO8aaYzzlhoITZwxHXVf1Eh9xxPQ6zuhYTANWdFl9BdbDHbetqTo/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B455A68B05; Mon, 24 Nov 2025 18:12:30 +0100 (CET)
Date: Mon, 24 Nov 2025 18:12:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
	ebiggers@kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 1/3] block: remove stacking default dma_alignment
Message-ID: <20251124171230.GA29490@lst.de>
References: <20251124170903.3931792-1-kbusch@meta.com> <20251124170903.3931792-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124170903.3931792-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 24, 2025 at 09:09:01AM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The dma_alignment becomes 511 anyway if the caller doesn't explicitly
> set it. But setting this default prevents the stacked device from
> requesting a lower value even if it can handle lower alignments.

Given how much trouble we had with drivers doing software processing
and unaligned buffers I'd feel more comfortable keeping this default
limitation.  Drivers that want to relax it can still trivially do
that right after calling blk_set_stacking_limits.

