Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B92F23
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 06:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720073851; cv=none; b=aIi/wPO1GnkZS9W5lTwiyaQeQDRWlb6coT5Q/f6Yl7/Y6mXgBG0kzDdVoqawAujlVRTszPi9YZq4FLR/zDrX1PWTLWdjTIZanpOCXtLmj3f4vYKT08leSdnvxz9lywX7+m02TE3fFpHgMYuhNNKPDeN20Qy8sX1kEuNRvq4/lMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720073851; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbZN59W8enY/oYxQNumz17zrn5NBjUAtmBTqdWYTVEdsMR2IYGV/BwquBzx5Q2+BRSNHCgVXjYNxNbnAukrUSfZOUSujDjgUNw3ewIUZQD4W4PDz5WQGDpjCZ4mkVYZW6z14eIes9rWHKEGJ7EQeCFZQLL9DJK8zJDfRD1pHBI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z70DkRXF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z70DkRXF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=z70DkRXFJ9pD+WThW4FmmA3cVt
	sSCFBIbhBPxjhq0Q1CwHJ2phw8iDrzvwC37UxZ3WDbKmRAVSb7ZI9aL+xWFVwUWbnctg5D3rMNChQ
	cheR8beluDR5XvrFkzEtygHxab6qaqRuGyDff7Lstmc1Ocz28RCwHEhsaS+2foJTbg55V/SKp6iBp
	pbHIofZpzdlnTqhmGBakUc6zEn/R0s6BNiy/Z1Qx7PvmfJikT9iGUwRenuIygGnT9JVoIQ0smdkZW
	jNSnnYLU69CsGsuHkkUuxxPpK7mRg4iM4xG/lPyBLjzp+ViA2gwOaO0lvaL1l7FwMlYineDOtqjym
	eOIcy7Cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sPFmb-0000000CJ3s-3a3x;
	Thu, 04 Jul 2024 06:17:29 +0000
Date: Wed, 3 Jul 2024 23:17:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm: Remove max_secure_erase_granularity
Message-ID: <ZoY-eZTWiMyehSdT@infradead.org>
References: <20240703221336.503507-1-dlemoal@kernel.org>
 <20240703221336.503507-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703221336.503507-3-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

