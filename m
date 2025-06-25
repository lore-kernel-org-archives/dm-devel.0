Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE62B126C05;
	Wed, 25 Jun 2025 06:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832127; cv=none; b=rm5Ji1hJaJKDHZawKgsrMVVLHzxwvXt7qkKMiBvHPwTlwGKKLDUUtz0OTPB5+vyjlJGZo1Rpd6h1vU1mmkZ6HGQzFJMc9oXZSMRPoh2v1pjlEOZxk0U5+5+qSwsakcXWJxhkhLjQKUJjfiIdDzDG7XCAiDsbz9AhybBh5/9+Yt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832127; c=relaxed/simple;
	bh=BIE5habvDnYBuxXcMIiPWS3liBj1/ZSStI9NL0QDYOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=de5LymsLAIMuBROjVVDbpCPWjateElbZdET9fl/JvYA3XKua4aCjYUkzhI5qX/pL15cc9m6lReo+fhSubUx4oBm3o0jsfGCdSxcvsDGZEWnyD92S15Vn+Q/PKUgxqZqBkH4Mp0z0HbUl6EmXTE4i6bp/9blZWYue/8kZ5rmEqXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Rui+LvFq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rui+LvFq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4SQd2aUv+Aaw6zhjkbR79njX4uAilXoWPMnlUwFSk6k=; b=Rui+LvFqMFgNfHc5yqtx8Z24Sr
	AU9x4V49anmTW5JOyZyMU64L4ps22XCqXAjWJURH1Ka/YqwGNDKSyPd8QXY6j5EqsYqrPC7i77+vG
	hlyLyANwAJ98jc5ZsLUufH3IsgZPE3uzpAWTMenDotNzij3JleZzkuEVYLw2KY/fw0bUwcAsFKpJ9
	vx1/s/eHWA2mIPjvLdPc0UrBnsPZTi/T94/J/HrZcOV2F7Ul6OJtyXtWawmLuwhOwYgKwZDdKMy3a
	Hl00gjBh7vSY++1auO5uXdF+jdQy/3KrCCKSp3NJQdu3rj2aHUZ33chrfyHJ600zUp1evCFgxQ5Be
	KjpfoM7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uUJPp-00000007e0w-15D2;
	Wed, 25 Jun 2025 06:15:25 +0000
Date: Tue, 24 Jun 2025 23:15:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 2/4] dm: Always split write BIOs to zoned device limits
Message-ID: <aFuT_X8GdNwRU9AF@infradead.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
 <20250625055908.456235-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625055908.456235-3-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 25, 2025 at 02:59:06PM +0900, Damien Le Moal wrote:
> Any zoned DM target that requires zone append emulation will use the
> block layer zone write plugging. In such case, DM target drivers must
> not split BIOs using dm_accept_partial_bio() as doing so can potentially
> lead to deadlocks with queue freeze operations. Regular write operations
> used to emulate zone append operations also cannot be split by the
> target driver as that would result in an invalid writen sector value
> return using the BIO sector.
> 
> In order for zoned DM target drivers to avoid such incorrect BIO
> splitting, we must ensure that large BIOs are split before being passed
> to the map() function of the target, thus guaranteeing that the
> limits for the mapped device are not exceeded.
> 
> dm-crypt and dm-flakey are the only target drivers supporting zoned
> devices and using dm_accept_partial_bio().

Is there any good way to catch usage dm_accept_partial_bio on zone
devices so that issues like this don't get reintroduced later?

