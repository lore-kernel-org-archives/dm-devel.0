Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0C73BBCC;
	Wed,  1 May 2024 04:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714539453; cv=none; b=pvgJ1ZuXf1ek5/F+swWHdxlkZZp1UWHuTSVnRs/j/Q8jk2lPlC5rtrkMi6CHhZpu1xub/eGWM95qb4Nieek/f/YD2o7pP51h7fubD7QB8gKQVQxC8nrJuEQlH7le3W/JUViUSQnCtGmjk2fd2sViuP6G+u6Ja+mLdwOf1ToUeoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714539453; c=relaxed/simple;
	bh=o0t9bD3XmHwHQ2Ber0ySXANHMszRsi54P1HtMsjWZCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Puq7TN9Y0JfeN6lNMDwddDUgo2oKFf5Et2H7yUQEc7wbNtiQkmFw7HrrnQWUGtlK9D0LJJd32YW2cFdRAdMU9GUmYPlc5QcGRz7FQNfHaEYdSMcgw0YsXKD6NV0enSb29RGFp9MMh+yJJzIY7XBsJLoBoOmLxMtvJp/PaMJO374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hOYoNTWX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hOYoNTWX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8GPE9SW8xhULMy6da8SVZMCcTPEE7DMbEFYgbtz6C8Y=; b=hOYoNTWXb40d/LaLb5dvbl9nh4
	Af/DZxRdsgoS+VOHhrrnQoR9pvkD55yTd+3owQlm+Z2p1psQQ+cURuSEl4lR+f6mDhTk1Hw9qBUwe
	IUarGexulcjRAUxiKIWUe2aV3VmkWiS7Powu3TuPKyQBlqJuNTPCDwQ2IRHfJBodtEklLj5Emjagq
	gFA2UPBgOJnzbz4PvP47zmxwJovSGZCF7NECfoXzSV2rVgAnLvFyUO0JizCSSDlWQa8k/IDKUcYGZ
	j7yo2vKVOyjnCJyr4HQK+vxpl1lP3iUuBU7Rk9DZZIKTXpJGQWtJYj1xa+FAc0uQIoH3xHsZB5jA7
	tDsfQctQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s2225-00000008ZjF-2yT1;
	Wed, 01 May 2024 04:57:29 +0000
Date: Tue, 30 Apr 2024 21:57:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 02/13] block: Exclude conventional zones when faking max
 open limit
Message-ID: <ZjHLubxsEVqq4Qgy@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-3-dlemoal@kernel.org>
 <ZjENF8spyEWrGwws@infradead.org>
 <4c54e3c8-83ed-46dd-b437-2f01ab1cb866@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c54e3c8-83ed-46dd-b437-2f01ab1cb866@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 30, 2024 at 01:04:51PM -0600, Jens Axboe wrote:
> On 4/30/24 9:24 AM, Christoph Hellwig wrote:
> > On Tue, Apr 30, 2024 at 09:51:20PM +0900, Damien Le Moal wrote:
> >> +	/* Resize the zone write plug memory pool if needed. */
> >> +	if (disk->zone_wplugs_pool->min_nr != pool_size)
> >> +		mempool_resize(disk->zone_wplugs_pool, pool_size);
> > 
> > No need for the if here, mempool_resize is a no-op if called for
> > the current value.
> 
> Still cheaper than the function call though, so I think that's
> the right way to do it.

It is only called during device probing and resize.  Try to avoid
the call and spinlock there is the poster definition of premature
micro-optimization..

