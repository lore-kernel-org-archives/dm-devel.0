Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51BF2FC23;
	Mon, 10 Mar 2025 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741613431; cv=none; b=lGQbBnF4s6udw2oOci5htFGiJ9hns+ssS5zWmTlzzRFj4jdv6CAeCynkp/KjfZovRlk7wCGEeoc8L2LGyJ1lL8X08Use2lPvLBdn8Zk8bmoPqTK6aBQ6ecjGRbsYm4mGsAxZDqdG7HC5FAvKM3e3qCy0Qj6RAA7v9OmGMSpoHT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741613431; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpEzM9okhsCl3d1LeAB+03fvwfhZAJoX1lDLHMuwzDFRX2CXIDHRl5w0JNCIDLeb3zeWvZ5NftJT7XzujpXaAwWVUFG0zI4q+nxG4sgKuCwJdpZx6rBkhfb89Li5qfXC9Gv+iwqtaC2fXJoIkfwSZBKWmI+3ggi//vETK8yyI1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qPK/xp2l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qPK/xp2l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qPK/xp2lWLapk4aZ68CKRHt8wC
	cOmIaWjXJASOFyDXQMPXOZTfeIz/KOz47TWQJmJHFr23D7gNTyBfVSYAt1cK9GcXd6TJPMU2jtaEl
	B04rde18oDIWBdBUtXMYRF+kpBm09t1LxJDRsYZakdQEqEDD3nBW/Jw+C3cHy4VOClpIIo/s108vN
	+NEsFkhsjm8xJ7XTLDL91HTkA3F1vckNoG4SfxpA145z+IKe4lTOCDU/MCryRPFBxbsuzhgPtONBE
	meyp4FsGNx7mRRew4rHo+IHJ5WfJhLhNYUSV3+XvF9zz/XPeyaTqrpolhYeA1N+nCkqbboiy0dYJi
	/mubAe6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1trdDB-00000002nmz-26wU;
	Mon, 10 Mar 2025 13:30:29 +0000
Date: Mon, 10 Mar 2025 06:30:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH V2] block: make sure ->nr_integrity_segments is cloned in
 blk_rq_prep_clone
Message-ID: <Z87pdRKOKozDx4cb@infradead.org>
References: <20250310115453.2271109-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310115453.2271109-1-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

