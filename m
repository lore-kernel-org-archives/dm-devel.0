Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209B5143752;
	Tue, 30 Apr 2024 15:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490779; cv=none; b=HNupQ3lwZmmKXWaYJiTNFds0hJT3JYC3euKiliRs9Yb54zsbBafL1+4e9txUkyOCIkNNv3dod6l3VvyoSmnSJS0rTEVmGle97fsui/CTvs0WjwYJNtIsu2OrWlc6n0AKjebydN5q8SV3KgR3/xmW5XT1x8FvmxVzGLZBnjyGqWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490779; c=relaxed/simple;
	bh=Kdkj1F/H5Nmqw6pFz6r75/IMXjIFnqcTnvbpEC7kWlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtNhMTHlt7Xfai0LuH4VKehzxsnOqtJPTvjRPAbbp6N6mjFFoR2DFIJlr2qQ+EUe8S/V2DTzrdo2kRiKT3p1h0BUyAdZ7jdNu80xme1EOrSmE0EnqBWX+lJJNGvzw6y886GDG1dAGlPjFZdRy5WPLi/lFW5+FPfhoSug0ePzlzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xYHfRdF4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xYHfRdF4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kdkj1F/H5Nmqw6pFz6r75/IMXjIFnqcTnvbpEC7kWlU=; b=xYHfRdF4yEePhlIvVCLJHZfVaj
	WAhfN/bcTNGJabXqjn3nt6iAeZ+LCdd09DvBB9+4NaBC82eYmfkQHy69U8KJUeh2raUhq4trnisxA
	+Xxx8ir6pQXPpJD0pUJ3wZctChkAj/hXYeqha/8//o959bAfvY6tpzY4HkuLZB+xkDbDnOwl7gRnW
	/rh4r7tRcdVbxo3rt2LS5FIF94G89N+PnJQYojZZ7vLAKhqQMUeUKxJ2oHwumK0bIiDjyPxIRynzV
	xKigj1BxSqxfQZaFzMqW9hgvu6IC4ULajIY4i8huucmxlT+Y61rBLb3cpudaZ2bQXOqCoTtF5HfR5
	o5+8tQgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pN3-0000000720r-342x;
	Tue, 30 Apr 2024 15:26:17 +0000
Date: Tue, 30 Apr 2024 08:26:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 03/13] block: Fix zone write plug initialization from
 blk_revalidate_zone_cb()
Message-ID: <ZjENmQ6d0tayg_YR@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-4-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I suspect that at some point blk_revalidate_zone_cb should
grow separate helpers for the conventional and sequential required cases
as the amount of code in that switch statement is getting a bit out of
bounds..

