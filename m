Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E394307498;
	Wed, 25 Jun 2025 06:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832294; cv=none; b=lPf+qrfJklRP0H4BSPENqYfUb9WGk0uTh3lJjoI32x66y26V3Spy0ILHx2MGgNuMAqQlkrn27gqUqVvXum5sSFWEFgh2HhmZ2EnUTn4SW0eXwvmTrdjB3okaStHVFNaVMSdwTcVnkBip9bGnZct3jmz/YiIwfaoSqx+9uZzpFvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832294; c=relaxed/simple;
	bh=mlWCt80N2mswh3zRw2yp8sxsDCPCNvuJ0E4ZXu352p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aK31WgoUuB8GvLk8GbLNjzuKnJuP3tRS0qrzCNEyVBnnaYYr4HEwM1dpmYG+W4yH1P74SpR7LGYW4uXqR/jUJH1B7iWvIsK0SuskyMUUm9qzXKWMPd0xDllAxf2KXmd15WI+pqnMKdjW10wBpSGR36qsSfqyb0baQepKfTJNos8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FicnKg+k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FicnKg+k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JoWhCOAVXdzr1ER6ZF50SXK4IRK+D9okETFOKLlE0Ac=; b=FicnKg+kuBt6VuPLcJzdJ8FMRR
	N9oFOw5nNHBq9jJkAhP+fTt8f9L4TE26AXmOXQRsT7PsJi1S5LhSmMfRn1U8oul9rK3yKeKsZPSuY
	zLYHnnCx7QS5WOySPZPzR9V6LSogxB/I1nCtqW8bswL0hj1JhieNF0RD5ojqyLSZR9TG5R1K1wUwA
	Z7UOMv5yRZN8/W52z1BRaQeXqViQC8uu01I75OvlV6FC96uQ6DR6+Sqc2b1OUE0y9G/7mYCTU8jBL
	fZkQol7pxX+aUi8ixZSKVy6oUpK5yT/wYKh9cX9+e4D/YUQN0zTvJ5dN7cweSQ7RXbqOsACihHpd7
	H54tToGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uUJSW-00000007eEd-3pQE;
	Wed, 25 Jun 2025 06:18:12 +0000
Date: Tue, 24 Jun 2025 23:18:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 1/4] block: Introduce bio_needs_zone_write_plugging()
Message-ID: <aFuUpLwmUWWwOmeB@infradead.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
 <20250625055908.456235-2-dlemoal@kernel.org>
 <aFuTYxdeAzG1iSl9@infradead.org>
 <576bb6dd-18b1-4c78-b848-51577d99b124@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576bb6dd-18b1-4c78-b848-51577d99b124@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 25, 2025 at 03:14:51PM +0900, Damien Le Moal wrote:
> On 6/25/25 3:12 PM, Christoph Hellwig wrote:
> > On Wed, Jun 25, 2025 at 02:59:05PM +0900, Damien Le Moal wrote:
> >> +bool bio_needs_zone_write_plugging(struct bio *bio)
> > 
> > Can you use this in blk_zone_plug_bio instead of duplicating the logic?
> 
> I thought about doing that, but we would still need to again do the switch/case
> on the bio op. But the checks before that could go into a common static helper.
> 
> > I also wonder if we should only it it, as despite looking quite complex
> 
> This does not parse...

The "only it" above should be "inline", -ENOTENOUGHCOFFEE

