Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDB92C2ABF;
	Wed, 25 Jun 2025 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750850912; cv=none; b=dm2ilTf/pusUbccaJi8P8TwFPEMUkA3XZdFp0BBACoiDWdqnLYGMruCsLFz5qvzC+ioH0QJn4P3sBBMjx1Uyo07LQ6xopkHkneUiJjCQgEyHcmVPQXU9culUbkRHBYWYTWr9O+8QqtyviNm6MJiXpmYW95yyZNQJ6pjVhFo5pL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750850912; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2wP4nHkb4YJq6OW1nQxsyNhFevsxgqjkrsc5dbfC+hUlPr+NJvbo4EcVLyP7dKA8MyQG67719U96eIuG8Umcuzl21sc4/bBJ2kIt6yzHTrRrWKtRTVK6n0/Ahrox2pjptH4INLkrOEMdEdiqI1ZHGv/k/ZBz0ViFEYNsNeIFYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WPnJ/Hw4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WPnJ/Hw4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WPnJ/Hw4vZo0HTT5OQjd8WduFn
	9itk+pfL3cOFUB+6clTCt7iMxr4fpG2hWLsmKZajCyiz4Wm/j7C9FJJatLjYxZe5y2GEXwvJc8V/f
	KRaz7qLxm3v+ZmL4hH2ikQnOELxu6uKMRFTwQjCDeSzmtPYtudMyVVF4ACDn2cuRziZlCGLXQDYt7
	YmzrlEdpZBhIyypFQzndGP/K/Hh/C2h9XrrjdGPiuo1gKUNOMmQeB4FirJ7QR0SLWKPEhjbV9ey/0
	I/jZc+40AINhur6/G16uGSbdayXnx9mp7hgK0h1iSeUtWtSgnmg2HUyWFpoca6TdPiUecUNdSODmo
	v5x1j3vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uUOIp-00000008TMw-08Ra;
	Wed, 25 Jun 2025 11:28:31 +0000
Date: Wed, 25 Jun 2025 04:28:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 1/5] block: Make REQ_OP_ZONE_FINISH a write operation
Message-ID: <aFvdXxEEBV67wbVm@infradead.org>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625093327.548866-2-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
