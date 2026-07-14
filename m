Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D330E1E5B64
	for <dm-devel@lists.linux.dev>; Tue, 14 Jul 2026 04:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784003749; cv=none; b=uknUeSyQEKkOQJfH737HB2qJw4y9/hdYV67iiuolH/cacCpc2sm+GwwKgk6HU17rnm/dV6lgyo4WuYsmK1wKT4jvfNaQ0ahzsZSBPmU9YQaSvKP3UtsHIW2iLGXafRC/3RvuD4uBBIvY+6JH9jYeZXTAo2RLtd0wT3DnqV1Z2T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784003749; c=relaxed/simple;
	bh=C0+IdKbVeVdaa81xL7FHb6BNvZUke28lOgmoNt9OxQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBMaHupvIcQM5qBeR3ygDhEawDD7y55VAZCVKVq7SFEYgZEDPrUMjDizJHr66VqYyx/bpF+UqY2g2YkDuvs1Te+dloGUPjMzlBhdTQOjVZdGG0zLuO1kmHQtVjSgXmdmBcUdc+WIeUkmW7Ky2g+O4hKJXlwLtuitJOx7Pb/Vz24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EA3468C4E; Tue, 14 Jul 2026 06:35:43 +0200 (CEST)
Date: Tue, 14 Jul 2026 06:35:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 0/5] block: validate direct I/O memory alignment
Message-ID: <20260714043543.GA30880@lst.de>
References: <20260624170905.3972095-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624170905.3972095-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 10:09:00AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This addresses the misaligned direct-io problem behind various threads:

It looks like this never got merged and is still missing in 7.2-rc3.

